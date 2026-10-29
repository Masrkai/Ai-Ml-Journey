# Agent Guidelines for Project 01: Exploratory Data Analysis (EDA) Portfolio

This document governs the behavior, operational protocols, and constraint validations for any AI agent or automated assistant operating within `projects/01-eda-portfolio/`.

---

## 1. Single Source of Truth (SSOT) Enforcement

- **Master Reference**: The root document `docs/roadmap.md` is the immutable **Single Source of Truth** for project identification and scope. Project 01 corresponds strictly to item no. 1: "EDA Portfolio".
- **Strict Compliance**: Agents must not alter project identifiers, scope boundaries, or structural placement without verifying synchronization against `docs/roadmap.md`.

---

## 2. Semantic Ambiguity Prevention Protocol

When updating code, documentation, configuration, or outputs in this project, agents must execute the following protocol:
1. **Pre-Update Assessment**: Identify the exact objective and ensure no conflicting definitions exist in codebase comments or README files.
2. **Post-Update Semantic Check**: Upon making any change, evaluate the diff to ensure:
   - Terminology is fully defined.
   - No vague phrasing, contradictory instructions, or undefined variables are introduced.
   - All statistical and data science operations (e.g., summary metrics, correlation matrices, outlier thresholds) are explicitly named and documented.
3. **Failure Action**: If any semantic ambiguity is detected during post-update review, the agent must immediately refine the text or code until ambiguity is eliminated.

---

## 3. Operational Standards for Project 01

- **Language & Stack**: Pure Julia (`DataFrames.jl`, `CSV.jl`, `Plots.jl`, `Statistics.jl`).
- **Reproducibility**: Ensure data loading handles caching gracefully (local dataset in `datasets/`) and falls back cleanly if network resources are unavailable.
- **Verification**: Run tests or execute the main script (`src/eda_portfolio.jl`) to validate execution integrity before completing any task.
