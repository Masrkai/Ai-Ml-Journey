# Project 04: Titanic Survival Prediction - Findings & Insights

## 1. Demographic & Socioeconomic Survival Factors
- **Gender Disparity**: Female passengers (`female`) exhibited a significantly higher survival rate (~74%) compared to male passengers (`male`) (~18%), reflecting the "women and children first" maritime evacuation protocol.
- **Ticket Class (`Pclass`)**: First-class passengers (`Pclass = 1`) experienced markedly higher survival rates than third-class passengers (`Pclass = 3`), highlighting socioeconomic priority during rescue operations.

## 2. Feature Engineering Impact
- **Family Size (`FamilySize = SibSp + Parch + 1`)**: Passengers travelling alone or in very large families (`FamilySize > 4`) had lower survival probabilities compared to small families (size 2-4), who benefited from mutual support.

## 3. Model Performance
- **Classification Baseline**: A robust classification model achieves $\approx 79.5\%$ test accuracy with well-balanced precision and recall scores on passenger survival prediction.
- **Feature Importance**: Gender and ticket class emerge as the primary predictive drivers of passenger survival.
