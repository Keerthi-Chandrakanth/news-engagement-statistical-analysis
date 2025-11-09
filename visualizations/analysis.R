#Download the data from https://archive.ics.uci.edu/dataset/432/news+popularity+in+multiple+social+media+platforms
#"News Popularity in Multiple Social Media Platforms"
# ----------------------------
# 0. Setup
# ----------------------------

# Install required packages if missing
required_packages <- c("tidyverse", "readr", "skimr", "psych", "FactoMineR", "factoextra", "CCA", "CCP")
installed_packages <- rownames(installed.packages())
for (pkg in required_packages) {
  if (!(pkg %in% installed_packages)) {
    install.packages(pkg)
  }
}

# Load libraries
library(tidyverse)
library(skimr)
library(psych)
library(FactoMineR)
library(factoextra)
library(CCA)
library(CCP)

# ----------------------------
# 1. Load Data and Inspect
# ----------------------------
#Load dataset (ensure 'News_Final.csv' is in your working directory)
data <- read_csv("News_Final.csv")
#View structure, summary, and skim overview of the dataset
glimpse(data)
skim(data)
summary(data)

# ----------------------------
# 2. Descriptive Statistics
# ----------------------------

# Engagement variable summary
#Select engagement variables
library(dplyr)

# Define engagement variables
engagement_vars <- c("Facebook", "GooglePlus", "LinkedIn")

data %>%
  dplyr::select(all_of(engagement_vars)) %>%
  summary()
# Histogram of engagements for each platform
data %>%
  pivot_longer(cols = all_of(engagement_vars), names_to = "Platform", values_to = "Engagement") %>%
  ggplot(aes(x = Engagement, fill = Platform)) +
  geom_histogram(bins = 40, alpha = 0.6, position = "identity") +
  facet_wrap(~Platform, scales = "free_x") +
  scale_fill_manual(values = c("Facebook" = "#1877F2", "GooglePlus" = "#DB4437", "LinkedIn" = "#0077B5")) +  # custom platform colors
  labs(title = "Distribution of Engagement Across Platforms", x = "Engagement Count", y = "Frequency") +
  theme_minimal()

# ----------------------------
# 3. Inferential Statistics
# ----------------------------

##T-Test: Compare Facebook engagement between Economy and Microsoft topics
topic_data <- data %>%
  filter(Topic %in% c("economy", "microsoft")) %>%
  mutate(TopicGroup = ifelse(Topic == "economy", "Economy", "Microsoft"))

t_test_fb <- t.test(Facebook ~ TopicGroup, data = topic_data)
print(t_test_fb)

#Boxplot to visualize comparison
ggplot(topic_data, aes(x = TopicGroup, y = Facebook)) +
  geom_boxplot(fill = "light Green") +
  scale_y_log10() +
  labs(title = "Facebook Engagement: Economy vs. Microsoft (Log Scale)", 
       x = "Topic", y = "Facebook Shares (log10)") +
  theme_minimal()

## Chi-Square Test: Topic vs High Engagement
threshold <- quantile(data$Facebook[data$Facebook >= 0], 0.75)
data <- data %>%
  mutate(HighEngagement = ifelse(Facebook >= threshold, "High", "Low"))

top_topics <- c("economy", "microsoft", "obama", "palestine", "tech")
engagement_chi <- data %>%
  filter(Topic %in% top_topics)

table_chi <- table(engagement_chi$Topic, engagement_chi$HighEngagement)
chi_test_result <- chisq.test(table_chi)
print(chi_test_result)

#Bar chart
ggplot(engagement_chi, aes(x = Topic, fill = HighEngagement)) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = c("Low" = "#E74C3C", "High" = "#27AE60")) + 
  labs(title = "High vs Low Facebook Engagement by Topic", x = "Topic", y = "Count") +
  theme_minimal()

# ----------------------------
# 4. Multivariate Analysis
# ----------------------------

# Load packages
library(FactoMineR)
library(factoextra)
library(dplyr)

# Prepare numeric variables (selecting key features)
#PCA: Principal Component Analysis
pca_vars <- data %>%
  dplyr::select(Facebook, GooglePlus, LinkedIn, SentimentTitle, SentimentHeadline) %>%
  filter(Facebook >= 0 & GooglePlus >= 0 & LinkedIn >= 0)


# Scale and run PCA
pca_scaled <- scale(pca_vars)

# Run PCA
pca_result <- PCA(pca_scaled, graph = FALSE)

# Visualize variable contribution to PCs
fviz_pca_var(pca_result,
             col.var = "contrib",
             gradient.cols = c("lightblue", "orange", "red"),
             repel = TRUE)
fviz_eig(pca_result, 
         addlabels = TRUE, 
         barfill = "skyblue", 
         barcolor = "black",
         main = "Scree Plot: Variance Explained by PCA Components")

##Correspondence Analysis (CA)
selected_topics <- c("economy", "microsoft", "obama", "palestine")

# First define HighEngagement, then filter
ca_data <- data %>%
  mutate(
    HighEngagement = ifelse(Facebook >= quantile(Facebook[Facebook >= 0], 0.75), "High", "Low"),
    Topic = factor(Topic, levels = selected_topics),
    HighEngagement = factor(HighEngagement, levels = c("Low", "High"))
  ) %>%
  filter(Topic %in% selected_topics & !is.na(HighEngagement)) %>%
  count(Topic, HighEngagement) %>%
  pivot_wider(names_from = HighEngagement, values_from = n, values_fill = 0)

ca_matrix <- as.matrix(ca_data[, -1])
rownames(ca_matrix) <- ca_data$Topic
ca_table <- as.table(ca_matrix)

ca_result <- CA(ca_table, graph = FALSE)

#CA Visualization
topic_coords <- data.frame(
  Topic = names(ca_result$row$coord),
  Dim1 = ca_result$row$coord
)

engagement_coords <- data.frame(
  Engagement = rownames(ca_result$col$coord),
  Dim1 = ca_result$col$coord[, 1]
)

ggplot(topic_coords, aes(x = Topic, y = Dim1)) +
  geom_point(color = "steelblue", size = 4) +
  geom_text(aes(label = Topic), vjust = -0.8) +
  labs(title = "Correspondence Analysis - Topic Positions (Dim 1 Only)",
       y = "Dimension 1", x = "") +
  theme_minimal()

ggplot(engagement_coords, aes(x = Engagement, y = Dim1)) +
  geom_point(color = "darkgreen", size = 4) +
  geom_text(aes(label = Engagement), vjust = -0.8) +
  labs(title = "Correspondence Analysis - Engagement Levels (Dim 1 Only)",
       y = "Dimension 1", x = "") +
  theme_minimal()

## MANOVA: Multivariate ANOVA
library(dplyr)

# Define selected topics
selected_topics <- c("economy", "microsoft", "obama", "palestine")

# Prepare MANOVA data safely
manova_data <- data %>%
  filter(Topic %in% selected_topics) %>%
  filter(Facebook >= 0 & GooglePlus >= 0 & LinkedIn >= 0) %>%
  dplyr::select(Topic, Facebook, GooglePlus, LinkedIn)
manova_model <- manova(cbind(Facebook, GooglePlus, LinkedIn) ~ Topic, data = manova_data)
summary(manova_model)
summary(manova_model, test = "Wilks")

ggplot(manova_data, aes(x = Topic, y = Facebook)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Facebook Engagement by Topic", y = "Facebook", x = "Topic") +
  theme_minimal()

## Canonical Correlation Analysis (CCA)
library(dplyr)

cca_data <- data %>%
  dplyr::select(SentimentTitle, SentimentHeadline, Facebook, GooglePlus, LinkedIn) %>%
  filter(Facebook >= 0, GooglePlus >= 0, LinkedIn >= 0)

X <- scale(cca_data %>% dplyr::select(SentimentTitle, SentimentHeadline))
Y <- scale(cca_data %>% dplyr::select(Facebook, GooglePlus, LinkedIn))

cca_result <- cancor(X, Y)
print(cca_result$cor)
cca_test <- p.asym(rho = cca_result$cor, 
                   N = nrow(X), 
                   p = ncol(X), 
                   q = ncol(Y), 
                   tstat = "Wilks")


# ----------------------------
# 5. Regression Modeling
# ----------------------------

## Multiple Linear Regression
reg_data <- data %>%
  filter(Facebook >= 0) %>%
  dplyr::select(Facebook, SentimentTitle, SentimentHeadline)

lm_model <- lm(Facebook ~ SentimentTitle + SentimentHeadline, data = reg_data)
summary(lm_model)
plot(lm_model)

## Logistic Regression
library(dplyr)

# Step 1: Calculate threshold for high engagement (top 25%)
threshold <- quantile(data$Facebook[data$Facebook >= 0], 0.75)

# Step 2: Prepare data for logistic regression
logit_data <- data %>%
  filter(Facebook >= 0) %>%
  mutate(HighEngagement = ifelse(Facebook >= threshold, 1, 0)) %>%
  dplyr::select(HighEngagement, SentimentTitle, SentimentHeadline)

# Step 3: Fit the logistic regression model
logit_model <- glm(HighEngagement ~ SentimentTitle + SentimentHeadline, 
                   data = logit_data, 
                   family = binomial())

# Step 4: View model summary
summary(logit_model)

# Step 5: Predict probabilities from the model
logit_data$predicted <- predict(logit_model, type = "response")

# Step 6: Plot predicted probabilities by actual engagement (0 or 1)
library(ggplot2)

ggplot(logit_data, aes(x = predicted, fill = factor(HighEngagement))) +
  geom_histogram(position = "identity", bins = 40, alpha = 0.6) +
  scale_fill_manual(values = c("0" = "steelblue", "1" = "firebrick")) +
  labs(title = "Predicted Probability of High Engagement",
       x = "Predicted Probability", 
       fill = "Actual Engagement\n(0 = Low, 1 = High)") +
  theme_minimal()