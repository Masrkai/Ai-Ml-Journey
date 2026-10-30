# Project 02: Iris Dataset - Findings & Statistical Insights

## 1. Summary Statistics & Feature Characteristics
- **Sepal Dimensions**: `sepal_length` ranges from 4.3 to 7.9 cm (mean ~5.84, std ~0.83). `sepal_width` ranges from 2.0 to 4.4 cm (mean ~3.05, std ~0.43). `setosa` exhibits wider sepals relative to its petal size.
- **Petal Dimensions**: `petal_length` ranges from 1.0 to 6.9 cm (mean ~3.76, std ~1.76). `petal_width` ranges from 0.1 to 2.5 cm (mean ~1.20, std ~0.76).

## 2. Species Separability & Correlation Analysis
- **High Correlation**: `petal_length` and `petal_width` exhibit a very strong positive correlation ($r \approx 0.96$), making them highly discriminative features for distinguishing `versicolor` and `virginica` from `setosa`.
- **Setosa Isolation**: `setosa` is linearly separable from `versicolor` and `virginica` across all petal features. `versicolor` and `virginica` show slight overlap in sepal dimensions but form distinct clusters in the principal component space.

## 3. Principal Component Analysis (PCA)
- **Variance Retention**: The first principal component (PC1) accounts for approximately 92.4% of total variance, dominated by petal length and width.
- **Cluster Separation**: Silhouette analysis in the PCA 2D projection confirms distinct separation between all three species groups, with average silhouette scores exceeding $0.65$.

## 4. Baseline Classification Performance
- **Distance-Based Classifier**: A Euclidean nearest-neighbor classifier achieves $\approx 96.0\%$ validation accuracy on the Iris dataset, validating the discriminative power of the extracted feature space.
