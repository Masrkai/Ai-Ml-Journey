# Findings & Decisions: Roadmap Projects 5 to 22

## Requirements
- **Master Roadmap SSOT**: Follow `docs/roadmap.md` exactly for project ordering, nomenclature, and scope (Projects 5 through 22).
- **Dataset SSOT**: All datasets must reside in and be loaded from root `datasets/` folder. No local dataset duplicates.
- **Julia Stack**: Pure Julia utilizing `DataFrames.jl`, `CSV.jl`, `Plots.jl`, `Statistics.jl`, and `LinearAlgebra`.
- **Pipeline Structure**: Modular pipeline stages (`01_ingest.jl`, `02_preprocess.jl`, `03_modeling.jl`, `04_visualization.jl`) driven by a master script, accompanied by tests (`test/runtests.jl`), summaries (`output/summary_report.txt`), visualizations (`output/*.png`), and findings (`docs/findings.md`).

## Research Findings: Detailed Project Architecture (Projects 5 to 22)

### Phase 2: Classical Machine Learning & Predictive Modeling (Projects 5–9)
1. **Project 05: Housing Price Predictor (`projects/05-housing-price-predictor`)**
   - *Dataset*: `datasets/housing.csv` (or generated synthetic housing dataset conforming to SSOT).
   - *Pipeline*: Ingestion -> Feature engineering (log-transforms, missing imputation, interaction terms) -> Regularized Ridge/Lasso Regression (closed-form / gradient descent) -> Evaluation (RMSE, MAE, $R^2$) -> Visualization (residual plots, regression fit, feature coefficients).
2. **Project 06: Image Classification System (`projects/06-image-classification`)**
   - *Dataset*: Low-resolution numerical image CSVs or flattened arrays in `datasets/`.
   - *Pipeline*: Ingestion -> Flattening & normalization -> Multi-class Softmax Regression with Cross-Entropy Loss -> Evaluation (Accuracy, Precision, Recall, Confusion Matrix) -> Visualization (confusion matrix heatmap, sample predictions grid, loss curve).
3. **Project 07: Sentiment Analysis System (`projects/07-sentiment-analysis`)**
   - *Dataset*: Text review corpus CSV in `datasets/`.
   - *Pipeline*: Ingestion -> Tokenization & TF-IDF vocabulary matrix construction -> L2-regularized Binary Logistic Regression -> Evaluation (F1-score, ROC-AUC) -> Visualization (top predictive words bar chart, ROC curve).
4. **Project 08: Customer Churn Predictor (`projects/08-customer-churn`)**
   - *Dataset*: Customer telecommunications / financial attributes CSV in `datasets/`.
   - *Pipeline*: Ingestion -> Categorical one-hot encoding & scaling -> Weighted loss logistic regression / decision tree addressing class imbalance -> Evaluation (Precision-Recall AUC, F1) -> Visualization (PR curve, feature importance ranking).
5. **Project 09: Stock Price Predictor (`projects/09-stock-price-predictor`)**
   - *Dataset*: Historical financial time-series CSV in `datasets/`.
   - *Pipeline*: Ingestion -> Technical indicator feature engineering (SMA, EMA, rolling returns, volatility) -> Time-series rolling-origin cross-validation -> Autoregressive regression forecasting -> Visualization (actual vs predicted time-series price trajectory plot).

### Phase 3: Deep Learning Foundations & Advanced AI Systems (Projects 10–14)
6. **Project 10: Build your own Neural Network (`projects/10-neural-network`)**
   - *Dataset*: Synthetic non-linear classification data (concentric circles / spirals).
   - *Pipeline*: Data generation -> Neural network multi-layer perceptron (MLP) architecture (Dense layers, ReLU, Sigmoid, Softmax) -> Backpropagation engine & mini-batch gradient descent -> Evaluation (accuracy, loss convergence) -> Visualization (decision boundary plot, epoch loss/accuracy curves).
7. **Project 11: Face Recognition System (`projects/11-face-recognition`)**
   - *Dataset*: Face image matrices in `datasets/`.
   - *Pipeline*: Ingestion -> Principal Component Analysis (Eigenfaces via covariance matrix and eigenvalue decomposition `eigen` from `LinearAlgebra`) -> Projection into low-dimensional space -> KNN / Euclidean distance classification -> Visualization (Eigenfaces visualization grid, recognition accuracy report).
8. **Project 12: Recommendation System (`projects/12-recommendation-system`)**
   - *Dataset*: User-item rating matrices in `datasets/`.
   - *Pipeline*: Ingestion -> Sparse matrix representation -> Singular Value Decomposition (SVD) / Alternating Least Squares (ALS) matrix factorization -> Evaluation (RMSE on held-out test ratings) -> Visualization (latent factor embedding scatter plot, error distribution).
9. **Project 13: Automated ML Pipeline (`projects/13-automl-pipeline`)**
   - *Dataset*: Arbitrary tabular datasets in `datasets/`.
   - *Pipeline*: Automated schema audit (`01_audit.jl`) -> Automated imputation & normalization (`02_preprocess.jl`) -> Multi-model training and benchmarking (`03_benchmark.jl`) -> Leaderboard reporting (`04_report.jl`).
10. **Project 14: Language Model from scratch (`projects/14-language-model`)**
    - *Dataset*: Text corpus in `datasets/`.
    - *Pipeline*: Corpus ingestion -> Character/word tokenization & transition probability modeling / lightweight RNN -> Temperature-controlled text generation -> Evaluation (validation perplexity) -> Visualization & output (`output/generated_text.txt`, perplexity curve).

### Phase 4: Production Systems, Frameworks & Scaling (Projects 15–22)
11. **Project 15: A/B Testing Framework (`projects/15-ab-testing`)**
    - Statistical hypothesis testing suite (Z-test, T-test, Chi-square, power analysis, confidence intervals, conversion comparison plots).
12. **Project 16: Image Generation System (`projects/16-image-generation`)**
    - Generative pattern/cellular automaton or VAE/GAN principles in pure Julia to synthesize patterned image grids.
13. **Project 17: Multi-language NLP Pipeline (`projects/17-multilingual-nlp`)**
    - Multi-lingual tokenization, vocabulary alignment, language identification, and cross-lingual text classification.
14. **Project 18: Reinforcement Learning AI Game (`projects/18-rl-game`)**
    - Q-Learning / Policy Gradient reinforcement learning solving gridworld or bandit environments from scratch.
15. **Project 19: Real Time Fraud Detection System (`projects/19-fraud-detection`)**
    - Streaming / batch anomaly detection using isolation forest or statistical z-score thresholds on transaction datasets.
16. **Project 20: Build Your own AutoML (`projects/20-custom-automl`)**
    - End-to-end automated ML library with feature selection, random hyperparameter search, and ensembling.
17. **Project 21: MLOps Pipeline (`projects/21-mlops-pipeline`)**
    - Model versioning, experiment tracking registry, artifact logging (JSON/JLD2), and automated threshold validation.
18. **Project 22: Distributed ML System (`projects/22-distributed-ml`)**
    - Distributed data processing and parallel model training leveraging `Distributed.jl` and `Threads.@threads`.

## Technical Decisions
| Decision | Rationale |
|----------|-----------|
| Standardized Pipeline Structure | Ensures consistency, testability, and adherence to repository conventions across all 22 roadmap items. |
| Deterministic SSOT Fallbacks | Guarantees self-contained reproducibility even when external datasets require offline setup. |

## Issues Encountered
| Issue | Resolution |
|-------|------------|
| None so far | Planning phase progressing cleanly. |

## Resources
- `docs/roadmap.md`
- `CONTRIBUTING.md`
- `AGENTS.md`

