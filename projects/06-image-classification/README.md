# Project 06: Image Classification System

## Overview
Implements an end-to-end multi-class image classification pipeline using Softmax Regression on numerical pixel features (`datasets/digits.csv`).

## Pipeline Architecture
- `01_ingest.jl`: Load digits/image dataset from SSOT.
- `02_preprocess.jl`: Normalize pixel values and split train/test sets.
- `03_modeling.jl`: Train Multi-class Softmax classifier using gradient descent.
- `04_visualization.jl`: Confusion matrix heatmap and training loss curves.

## How to Run
```bash
julia projects/06-image-classification/src/image_classification_pipeline.jl
```
