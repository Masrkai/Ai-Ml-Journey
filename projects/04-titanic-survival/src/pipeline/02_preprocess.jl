# =====================================================================
# Stage 2: Missing Value Imputation & Feature Engineering
# =====================================================================

println("\n[2] Preprocessing & Feature Engineering...")

# Select relevant features
relevant_cols = ["Survived", "Pclass", "Sex", "Age", "SibSp", "Parch", "Fare", "Embarked"]
df_clean = select(df, intersect(relevant_cols, names(df)))

# Impute missing Age with median
median_age = median(skipmissing(df_clean.Age))
replace!(df_clean.Age, missing => median_age)

# Impute missing Fare with median
median_fare = median(skipmissing(df_clean.Fare))
replace!(df_clean.Fare, missing => median_fare)

# Impute missing Embarked with mode ('S')
replace!(df_clean.Embarked, missing => "S")

# Feature Engineering: FamilySize
df_clean.FamilySize = df_clean.SibSp .+ df_clean.Parch .+ 1

# Encode Sex: female -> 1, male -> 0
df_clean.IsFemale = [ismissing(s) ? 0 : (lowercase(string(s)) == "female" ? 1 : 0) for s in df_clean.Sex]

# Drop rows with any remaining missing target
dropmissing!(df_clean, [:Survived])

println("Preprocessing completed successfully. Clean dataset rows: $(size(df_clean, 1))")
push!(summary_lines, "Clean Dataset Rows after preprocessing: $(size(df_clean, 1))")
