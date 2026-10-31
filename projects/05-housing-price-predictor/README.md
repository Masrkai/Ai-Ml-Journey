# Project 05: Housing Price Predictor

## Overview
This project implements an end-to-end regression pipeline in pure Julia to predict housing prices using the centralized SSOT dataset (`datasets/housing.csv`).

## Pipeline Architecture
- `01_ingest.jl`: Load dataset from root SSOT.
- `02_preprocess.jl`: Data cleaning, log transformation, feature scaling, train/test split.
- `03_modeling.jl`: Ridge Regression implementation using analytical closed-form solution (`LinearAlgebra`).
- `04_visualization.jl`: Residual analysis, regression fit plots, and summary report generation.

## How to Run
```bash
julia --project=projects/05-housing-price-predictor projects/05-housing-price-predictor/src/housing_pipeline.jl
```
