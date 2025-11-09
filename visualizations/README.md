# 📊 News Engagement Statistical Analysis

A comprehensive statistical analysis of 93,000+ news articles examining engagement patterns across Facebook, Google+, and LinkedIn using advanced multivariate techniques in R.

![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white)
![Statistical Analysis](https://img.shields.io/badge/Statistics-Analysis-blue)
![Data Science](https://img.shields.io/badge/Data-Science-green)

---

## Project Overview

This project analyzes how content topics and sentiment influence social media engagement across multiple platforms. Using the **News Popularity in Multiple Social Media Platforms** dataset from UCI Machine Learning Repository (93,000+ articles from Nov 2015 - July 2016), I applied 8+ statistical techniques to uncover patterns in viral content.

**Key Finding:** Content topic and sentiment significantly influence engagement patterns, with sentiment predicting viral success likelihood more effectively than exact engagement counts.

---

## 📈 Key Results

- **Facebook** showed the highest engagement variance, making it the most informative platform for analysis
- **Topics like "Obama"** consistently received 2-3x higher engagement than business topics
- **Sentiment in headlines** increased high-engagement probability by 13.9% (p < 0.05)
- **PCA revealed** that 56.4% of engagement variance stems from platform choice and sentiment
- **MANOVA confirmed** statistically significant differences in engagement patterns across topics (p < 2.2e-16)

---

## 🛠️ Statistical Techniques Applied

### Descriptive Statistics
- Summary statistics and distribution analysis
- Multi-platform engagement comparison
- Outlier detection and data cleaning

### Inferential Statistics
- **T-Tests** - Comparing engagement between topic pairs
- **Chi-Square Tests** - Topic vs. high/low engagement association (X² = 12,397, p < 2.2e-16)

### Multivariate Analysis
- **PCA (Principal Component Analysis)** - Dimensionality reduction and variance explanation
- **Correspondence Analysis (CA)** - Topic-engagement relationship mapping
- **MANOVA** - Multi-platform engagement differences by topic
- **CCA (Canonical Correlation Analysis)** - Sentiment-engagement relationships

### Regression Modeling
- **Multiple Linear Regression** - Predicting exact engagement from sentiment
- **Logistic Regression** - Predicting high-engagement probability (AIC: 91,984)

---

##  Visualizations

### Sample Results

![Engagement Distribution](visualizations/engagement_histogram.png)
*Distribution of engagement across platforms showing heavy right skew*

![PCA Analysis](visualizations/pca_screeplot.png)
*Principal components explaining 56.4% of variance*

![Topic Engagement](visualizations/chi_square_barplot.png)
*High vs Low engagement by topic*

*View all visualizations in the [visualizations/](./visualizations/) folder*

---

##  Technical Stack

**Language:** R  
**Libraries:** 
- `tidyverse`, `dplyr` - Data manipulation
- `ggplot2` - Data visualization
- `FactoMineR`, `factoextra` - Multivariate analysis (PCA, CA)
- `stats` - Statistical tests and regression
- `CCA`, `CCP` - Canonical correlation analysis
- `psych`, `skimr` - Descriptive statistics

---

## 📂 Project Structure
```
news-engagement-statistical-analysis/
├── README.md                    # Project overview (this file)
├── analysis.R                   # Complete R analysis script
├── REPORT.pdf                   # Detailed methodology and findings
├── visualizations/              # All generated plots and charts
│   ├── engagement_histogram.png
│   ├── pca_screeplot.png
│   ├── pca_biplot.png
│   └── ... (additional plots)
└── data/
    └── README.md               # Dataset information and download link
```

---

## How to Run

### Prerequisites
```r
install.packages(c("tidyverse", "readr", "ggplot2", "dplyr", 
                   "skimr", "psych", "stats", "FactoMineR", 
                   "factoextra", "CCA", "CCP"))
```

### Steps
1. **Download the dataset** from [UCI ML Repository](https://archive.ics.uci.edu/dataset/432/news+popularity+in+multiple+social+media+platforms)
2. **Place `News_Final.csv`** in the project root directory
3. **Run the analysis:**
```r
   source("analysis.R")
```
4. **View results** - Plots will be generated and statistical outputs printed to console

---

## Key Insights

### What Drives Viral Content?

1. **Topic Matters Most**
   - Political topics (Obama) achieved 40-60% higher engagement
   - Business topics (Microsoft, economy) showed lower interaction rates

2. **Sentiment's Dual Role**
   - Positive headlines → ↑ viral probability
   - Positive titles → ↓ viral probability (contrarian finding!)

3. **Platform Differences**
   - Facebook: Highest engagement, most variance
   - Google+: Minimal engagement, limited variance
   - LinkedIn: Professional content performs better

4. **Statistical Validation**
   - All major findings significant at p < 0.05 level
   - Large sample size (93K+ articles) ensures robust conclusions

---

## Methodology Highlights

- **Missing Data Handling:** Removed -1 values (missing data indicators)
- **High Engagement Definition:** Top 25% threshold (75th percentile)
- **Scaling:** Standardized variables for PCA/CCA
- **Multiple Testing:** Applied appropriate corrections for family-wise error rate
- **Visualization Strategy:** Log-scale transformations for skewed distributions

---

## Context

Academic project demonstrating proficiency in:
- Exploratory Data Analysis (EDA)
- Statistical hypothesis testing
- Multivariate statistical methods
- Data visualization and communication
- R programming and reproducible research

---

## Full Report

For detailed methodology, complete results, and in-depth discussion, see **[REPORT.pdf](./REPORT.pdf)**

---

## Future Enhancements

- [ ] Time series analysis of engagement trends over publication dates
- [ ] Network analysis of topic co-occurrence patterns
- [ ] Machine learning models (Random Forest, XGBoost) for engagement prediction
- [ ] Sentiment analysis using NLP instead of pre-labeled scores
- [ ] Interactive Shiny dashboard for exploratory visualization

---

## Dataset Information

### Source
**News Popularity in Multiple Social Media Platforms** dataset from UCI Machine Learning Repository.

**Download:** https://archive.ics.uci.edu/dataset/432/news+popularity+in+multiple+social+media+platforms

### Details
- **Size:** ~93,000 news articles
- **Time Period:** November 2015 - July 2016
- **Platforms:** Facebook, Google+, LinkedIn
- **Variables:** Topic, sentiment scores, engagement metrics, publication metadata

**Note:** The raw dataset is not included in this repository due to size. Download it from UCI and place `News_Final.csv` in the root directory.

