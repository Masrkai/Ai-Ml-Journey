# Project 02: Iris Dataset Analysis & Classification Pipeline

## Overview
This project implements a rigorous exploratory data analysis, statistical validation, and baseline classification pipeline for the classic **Iris Dataset** in Julia. Following the architectural patterns established in Project 01, this project demonstrates data ingestion from the repository-wide Single Source of Truth (`datasets/iris.csv`), descriptive statistics, feature separability analysis, normality / variance tests, PCA dimensionality reduction, and a custom k-NN / distance-based classification model.

## Dataset
We utilize the **Iris Dataset** stored in the repository root SSOT folder (`datasets/iris.csv`). The dataset contains 150 samples of iris flowers with four numeric features:
1. `sepal_length` (cm)
2. `sepal_width` (cm)
3. `petal_length` (cm)
4. `petal_width` (cm)
And one target categorical feature:
5. `species` (`setosa`, `versicolor`, `virginica`).

## Key Objectives
1. **Data Ingestion & Validation**: Load `datasets/iris.csv`, verify schema, inspect missing values and data integrity.
2. **Descriptive & Groupby Statistics**: Compute mean, median, standard deviation, and IQR grouped by species.
3. **Statistical Inference & Separability**: Perform correlation analysis and feature variance checks across species.
4. **Dimensionality Reduction & Clustering**: Execute Principal Component Analysis (PCA) to visualize class separability in 2D space.
5. **Baseline Classification**: Implement and evaluate a distance-based nearest neighbor classification engine.
6. **Automated Reporting & Visualization**: Generate distribution plots, correlation heatmaps, PCA biplots, and summary reports.

## How to Run

### Command Line Execution
Run the pipeline script from the repository root:
```bash
julia --project=projects/02-iris-dataset projects/02-iris-dataset/src/iris_pipeline.jl datasets/iris.csv species
```

### Running via Julia REPL
1. Enter the Julia REPL in the project directory:
   ```julia
   julia --project=projects/02-iris-dataset
   ```
2. Run the pipeline:
   ```julia
   include("src/iris_pipeline.jl")
   ```

## Chronological Source Code Architecture
```text
src/
├── iris_pipeline.jl              # Master Pipeline Orchestrator Driver
└── pipeline/
    ├── 01_ingest.jl              # 1. Dataset Ingestion & Validation
    ├── 02_statistics.jl          # 2. Groupby Statistics & Correlations
    ├── 03_modeling.jl            # 3. Distance-based Baseline Classification
    └── 04_visualization.jl       # 4. Plots Generation & Summary Report
```
