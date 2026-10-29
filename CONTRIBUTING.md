# Contributing to AI, Machine Learning & Data Science Journey in Julia

Thank you for your interest in contributing to this repository! 

---

## 1. Single Source of Truth (SSOT) Protocol

- **Global Roadmap SSOT**: The master curriculum defined in [`docs/roadmap.md`](docs/roadmap.md) is the **Single Source of Truth** for all projects, scope, ordering, and nomenclature.
- **Project Boundaries**: Each project under `projects/` corresponds strictly to its numbered entry in the roadmap.
- **No Drift**: Any modifications, expansions, or additions to projects must align with the global roadmap. Under no circumstances should local implementation diverge from or contradict roadmap definitions.

---

## 2. Semantic Ambiguity Prevention Check

Whenever an update, refactor, or documentation change is made anywhere in the repository:
1. **Ambiguity Audit**: Review all modified files (code, comments, documentation, READMEs) to verify that terminology, variable names, metric definitions, and instructions are precise and unambiguous.
2. **Post-Change Verification**: Confirm that a reader or automated agent interpreting the change cannot arrive at multiple conflicting interpretations.
3. **Traceability**: Ensure every added feature, dataset, or metric clearly maps back to standard data science principles and roadmap requirements.

---

## 3. Contribution Workflow

1. Choose a project from `docs/roadmap.md`.
2. Ensure environment reproducibility using Julia (`Project.toml`, `Manifest.toml`).
3. Validate code execution and outputs.
4. Ensure governance rules and semantic ambiguity checks are strictly followed.
