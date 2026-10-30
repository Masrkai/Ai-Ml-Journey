# Project 04: Titanic Survival Prediction

## Overview
This project implements an end-to-end data cleaning, feature engineering, and predictive modeling pipeline for the classic **Titanic Survival Dataset** in Julia. Following repository governance and dataset SSOT standards, datasets are loaded from the root `datasets/` folder (managed by `datasets/download_datasets.jl`).

## Dataset
We utilize `datasets/titanic.csv`. Key features include:
- `Survived`: Target variable (0 = No, 1 = Yes)
- `Pclass`: Ticket class (1 = 1st, 2 = 2nd, 3 = 3rd)
- `Sex`: Gender (`male`, `female`)
- `Age`: Age in years
- `SibSp`: Number of siblings / spouses aboard
- `Parch`: Number of parents / children aboard
- `Fare`: Passenger fare
- `Embarked`: Port of embarkation (C, Q, S)

## Key Objectives
1. **Data Ingestion & SSOT Integration**: Load `datasets/titanic.csv` using central dataset paths.
2. **Missing Value Imputation & Feature Engineering**: Impute missing ages (using median) and fares, encode categorical variables, and engineer features (`FamilySize = SibSp + Parch + 1`).
3. **Predictive Modeling**: Train a robust baseline classification model (e.g., Logistic Regression / distance classifier) predicting passenger survival.
4. **Evaluation Metrics**: Compute Accuracy, Precision, Recall, F1-Score, and Confusion Matrix.
5. **Visualization & Reporting**: Generate feature distribution plots, survival rate by class/gender charts, and summary reports.

## How to Run

### Command Line Execution
```bash
julia --project=projects/04-titanic-survival projects/04-titanic-survival/src/titanic_pipeline.jl
```

### Running via Julia REPL
```julia
julia --project=projects/04-titanic-survival
include("src/titanic_pipeline.jl")
```

## Chronological Source Code Architecture
```text
src/
├── titanic_pipeline.jl           # Master Pipeline Orchestrator Driver
└── pipeline/
    ├── 01_ingest.jl              # 1. Dataset Ingestion via SSOT
    ├── 02_preprocess.jl          # 2. Missing Value Imputation & Feature Engineering
    ├── 03_modeling.jl            # 3. Baseline Classification & Evaluation
    └── 04_visualization.jl       # 4. Plots Generation & Summary Report
```
