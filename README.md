# Player Market Value Prediction

## Overview

This project investigates the factors that influence professional football (soccer) player market value and develops machine learning models to predict player valuation. Using FIFA player datasets from 2016–2022, we analyze player attributes, position-specific characteristics, and market pricing efficiency to understand how player performance metrics translate into monetary value.

The project combines statistical modeling and supervised machine learning techniques to predict player market value and explore whether football clubs efficiently price players based on measurable attributes.

## Authors

- Joshua Nghe
- Carter Nault
- James Ho

**Course:** STAT 472 — Statistical Machine Learning  
**Institution:** Colorado State University  
**Date:** May 12, 2026

---

# Research Questions

This project focuses on the following questions:

1. Which player attributes are most important in determining football player market value?
2. Can machine learning models accurately predict player market value?
3. How does player valuation differ across positions?
4. Are some clubs or leagues overvaluing or undervaluing players compared to model predictions?
5. Does pricing efficiency relate to team performance?

---

# Dataset

The primary dataset consists of FIFA player statistics collected from 2016–2022.

The dataset contains information about:

- Player physical attributes
- Technical skills
- Defensive and attacking abilities
- Mental attributes
- International reputation
- Position-related statistics
- Player market value

Examples of important features include:

- Overall rating
- Potential
- Age
- Pace
- Shooting
- Passing
- Dribbling
- Defending
- Physical attributes
- Skill moves
- International reputation

The response variable used in modeling is:

\[
\log(\text{market value})
\]

The logarithmic transformation was applied due to the highly skewed distribution of player market values.

---

# Data Processing

The following preprocessing steps were performed:

1. Removed irrelevant variables and identifiers.
2. Converted categorical variables into numerical representations.
3. Removed missing values.
4. Applied logarithmic transformation to player market value.
5. Split data into training and testing sets.
6. Standardized predictors when required by machine learning models.

---

# Exploratory Data Analysis

Initial analysis examined:

- Distribution of player market values
- Relationship between player attributes and market value
- Differences between player positions
- Correlation between performance metrics and valuation

Players were also grouped into major positions:

- Attackers
- Midfielders
- Defenders

to investigate position-specific differences in valuation.

---

# Models

## Linear Regression

A baseline regression model was developed to identify relationships between player attributes and market value.

The model helped determine:

- Which attributes had the strongest relationship with player valuation
- How traditional statistical modeling compares with machine learning approaches

---

## LASSO Regression

LASSO regression was used for feature selection and regularization.

Benefits:

- Reduces overfitting
- Identifies the most important player attributes
- Removes less informative variables through coefficient shrinkage

Results:

- Best lambda: 100
- Training R²: 0.812

Important features were visualized using non-zero model coefficients.

---

## Elastic Net Regression

Elastic Net regression combines:

- L1 regularization from LASSO
- L2 regularization from Ridge regression

This approach improves model stability when predictors are highly correlated.

The model was used to compare feature selection performance against LASSO.

---

## Support Vector Machine (SVM)

A Support Vector Regression model was developed to capture nonlinear relationships between player attributes and market value.

Model performance:

- RMSE: 0.2604
- MAE: 0.1882

Additional evaluation included:

- Predicted vs. actual market value plots
- Residual analysis
- QQ plots
- Feature importance analysis

---

# Model Evaluation

Models were evaluated using:

### R²

Measures the proportion of variance explained by the model.

### RMSE

Measures average prediction error while penalizing larger errors.

### MAE

Measures average absolute prediction error.

Performance comparisons were made between:

- Linear Regression
- LASSO
- Elastic Net
- Support Vector Regression

---

# Market Efficiency Analysis

After predicting player market values, residual analysis was used to investigate pricing efficiency.

Residual:

\[
\text{Residual} = \text{Actual Value} - \text{Predicted Value}
\]

Interpretation:

- Positive residual → Player may be undervalued
- Negative residual → Player may be overvalued

Residuals were analyzed by:

- Club
- League
- Position

Team-level analysis compared valuation efficiency with team performance metrics.

---

# Key Findings

The analysis showed that:

- Player potential and overall ability are among the strongest predictors of market value.
- Technical attributes such as passing, shooting, and dribbling significantly contribute to valuation.
- Machine learning models capture nonlinear relationships between player characteristics and market prices.
- Some teams consistently purchase players above or below expected market value.
- Player valuation efficiency may relate to team success.

---

# Repository Structure

```
Player-Market-Prediction/
│
├── Data/
│   ├── filtered_timeseries_fifa_players.csv
│   ├── variables.csv
│   └── defenders.csv
│
├── Code/
│   ├── Linear_Regression.R
│   ├── LASSO_Model.R
│   ├── Elastic_Net_Model.R
│   └── SVM_Model.R
│
├── Figures/
│   ├── coefficient_plots/
│   ├── residual_plots/
│   └── model_comparisons/
│
├── Report/
│   └── Player_Market_Prediction.pdf
│
└── README.md
```

---

# Technologies Used

## Programming Languages

- R

## Libraries

- glmnet
- e1071
- caret
- dplyr
- ggplot2
- doParallel

## Statistical Methods

- Linear Regression
- LASSO Regression
- Elastic Net Regression
- Support Vector Regression
- Residual Analysis
- Feature Selection

---

# Future Improvements

Potential extensions include:

- Incorporating real transfer market data
- Adding team financial information
- Including player injury history
- Using advanced models such as:
  - Random Forest
  - Gradient Boosting
  - Neural Networks
- Developing a live player valuation prediction tool

---

# Conclusion

This project demonstrates how statistical modeling and machine learning can be used to analyze football player valuation. By combining FIFA player statistics with predictive modeling techniques, we identify important valuation factors and investigate whether market prices accurately reflect player performance.

The results highlight the potential of data-driven approaches in sports analytics, scouting, and decision-making.