# Exploratory Data Analysis (EDA) Technical Case Study

## 1. Executive Summary
This document presents the rigorous exploratory data analysis (EDA) findings for Project 01 of the Julia AI & ML Journey. Using the benchmark Iris dataset, we performed a comprehensive data quality audit, missingness scan, Shannon entropy class distribution check, distribution moments (skewness & excess kurtosis), Pearson and Spearman rank correlation analyses, One-Way ANOVA group separability hypothesis tests, Mahalanobis multivariate outlier detection, PCA dimensionality reduction via SVD, and advanced visual diagnostics.

---

## 2. Key Statistical Insights

### A. Data Quality & Missingness
- **Completeness**: 0% missing values across all 150 records and 5 features.
- **Data Integrity**: 1 duplicate row detected.
- **Class Balance & Entropy**: Uniform distribution across 3 species classes (`setosa`, `versicolor`, `virginica`) yielding a Shannon Entropy of 1.585 bits.

### B. Distributional Characteristics & Moments
- **Sepal Length**: Mean = 5.84 cm, Std = 0.83 cm, Skewness = 0.315, Excess Kurtosis = -0.552 (mild right-skew).
- **Sepal Width**: Mean = 3.06 cm, Std = 0.44 cm, Skewness = 0.319, Excess Kurtosis = 0.228, with 4 univariate outliers flagged via IQR bounds ($[2.05, 4.05]$).
- **Petal Length & Width**: Petal Length (Skewness = -0.275, Kurtosis = -1.402) and Petal Width (Skewness = -0.103, Kurtosis = -1.341) exhibit platykurtic distributions reflecting multi-modal clustering across species groups.

### C. Correlation & Multicollinearity Analysis
- **Pearson & Spearman Matrices**: Both Pearson ($r = 0.963$) and Spearman ($\rho = 0.938$) confirm exceptionally high positive correlation between `petal_length` and `petal_width`, indicating severe multicollinearity.
- **Multivariate Outliers**: Mahalanobis distance analysis ($p < 0.01$ threshold $\chi^2_4 = 13.277$) flagged 0 multivariate outliers in joint feature space, confirming that univariate outliers in sepal width are well-integrated within normal multivariate dispersion.

### D. Inferential Group Separability (One-Way ANOVA)
- **Petal Length**: $F = 1180.16$ ($p \ll 0.001$), confirming dominant discriminative power across species.
- **Petal Width**: $F = 960.01$ ($p \ll 0.001$).
- **Sepal Length**: $F = 119.26$ ($p \ll 0.001$).
- **Sepal Width**: $F = 49.16$ ($p \ll 0.001$).

### E. Exploratory Dimensionality Reduction (PCA via SVD)
- **PC1**: Captures **72.96%** of total variance.
- **PC2**: Captures **22.85%** of variance.
- **Cumulative Variance (PC1 + PC2)**: **95.81%** of total information is retained in 2 dimensions, validating that 2D PCA projections capture nearly full data separability.

### F. Advanced Statistical Diagnostics (Non-Parametric & Homoscedasticity)
- **Kruskal-Wallis H Tests**: Confirm robust non-parametric group separability across species for Petal Length ($H = 130.13$), Petal Width ($H = 129.91$), Sepal Length ($H = 96.76$), and Sepal Width ($H = 63.03$).
- **Levene’s Homoscedasticity Test**: Evaluates variance homogeneity across species. Petal length and width exhibit significant variance heterogeneity ($W = 19.48$ and $19.89$), indicating varying dispersion across classes.
- **Cluster Separation Score**: Mean silhouette separation score in PC1-PC2 space is **0.401**, confirming distinct cluster boundaries between species groups.

### H. ML Workflow Optimization Diagnostics (Supervised vs. Unsupervised)
- **Supervised Mode Diagnostics**:
  - **Classification Imbalance**: Evaluates class distribution balance ratios. For the Iris benchmark, the class balance ratio is **1.0** (perfect balance across 3 classes).
  - **Target Leakage**: Scans feature-to-target correlations in regression tasks, flagging absolute correlation coefficients exceeding $0.95$.
- **Unsupervised Mode Diagnostics**:
  - **Hopkins Statistic**: Quantifies cluster tendency. For Iris in unsupervised mode, the Hopkins statistic is **0.84**, confirming robust spatial clustering suitability ($H > 0.65$).
  - **Feature Redundancy Analysis**: Identifies highly collinear feature pairs ($|r| > 0.85$), recommending dimensionality reduction (PCA) or feature pruning prior to distance-based clustering.

---

## 3. Downstream Machine Learning Handoff

1. **Feature Selection & Regularization**: High multicollinearity between petal dimensions requires regularization (Ridge/Lasso) or PCA projection to prevent coefficient instability in linear models.
2. **Dimensionality Reduction**: Projecting features onto the first 2 principal components retains 95.81% of variance, offering an efficient feature space for downstream clustering (Project 03) and classification (Project 02/04).
3. **Scaling & Transformation**: Distance-based algorithms (KNN, SVM) require Z-score standardization, while Yeo-Johnson power transformations can be applied to further stabilize variance if needed.
