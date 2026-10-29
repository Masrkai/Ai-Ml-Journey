

### 1. Data-Related Issues

* **Not Cleaning Your Data Properly:**
* *Talking Point:* Feeding raw, messy data straight into a model guarantees poor performance.
* *Expansion:* Garbage in means garbage out. Beginners often overlook noisy elements like formatting inconsistencies, special characters, white spaces, and irrelevant text strings. Proper data hygiene involves inspecting data distributions and filtering out corruption before any modeling begins.


* **Forgetting to Normalize / Standardize:**
* *Talking Point:* Leaving features on vastly different scales distorts how models learn.
* *Expansion:* If one feature ranges from 0 to 1 (like ratios) and another from 0 to 100,000 (like annual income), gradient-based algorithms (like linear regression, logistic regression, and neural networks) will disproportionately weight the larger-scale feature. Techniques like Min-Max scaling or Z-score standardization bring everything to a uniform scale.


* **Data Leakage:**
* *Talking Point:* Unintentionally allowing information from the future or from the test set to leak into the training process.
* *Expansion:* This is one of the most dangerous traps because it results in unrealistically high training/validation scores that completely collapse in production. A common mistake is performing data preprocessing (like normalization or imputing missing values) over the *entire* dataset before splitting it into train and test sets, rather than fitting the transformer exclusively on the training data.


* **Class Imbalance Issues:**
* *Talking Point:* Training a model on a dataset where one target class vastly outnumbers the others.
* *Expansion:* If 99% of your fraud detection dataset consists of legitimate transactions and only 1% is fraud, a naive model can achieve 99% accuracy by simply predicting "not fraud" every time. Beginners need to handle this using resampling techniques (like SMOTE or undersampling), specialized loss functions, or alternative evaluation metrics.


* **Not Handling Missing Values Correctly:**
* *Talking Point:* Dropping rows blindly or filling gaps with arbitrary defaults.
* *Expansion:* Simply deleting every row with a missing value can throw away critical information or bias your dataset. Conversely, filling missing numbers with a hardcoded constant like `0` can inject false signals. Better strategies include imputation using the column median/mean, or letting advanced algorithms handle missingness natively.



---

### 2. Model Training & Evaluation

* **Using Wrong Metrics:**
* *Talking Point:* Relying exclusively on standard accuracy for evaluating model success.
* *Expansion:* As noted in the class imbalance scenario, accuracy is deeply misleading for skewed datasets. Beginners should expand their toolkit to include precision, recall, F1-score, ROC-AUC, or mean squared error (MSE) depending on whether the task is classification or regression and what the business cost of a false positive/negative is.


* **Overfitting and Underfitting:**
* *Talking Point:* Striking the wrong balance between model complexity and generalization.
* *Expansion:* Underfitting happens when a model is too simple to capture the underlying patterns (high bias). Overfitting happens when a model memorizes the training data—including its noise and outliers—and fails to generalize to unseen data (high variance). Beginners learn to combat this via proper train/val/test splits, cross-validation, regularization (L1/L2), and early stopping.




