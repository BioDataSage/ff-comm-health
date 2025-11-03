# Community Health Evaluation: From Prediction to Explanation

## 📋 Overview

This repository presents a dual-analysis of community health outcomes, moving beyond simple prediction to deep, actionable explanation. It combines two complementary analyses: - A Supervised Machine Learning pipeline to predict Quality of Life (QoL) and identify its key drivers. - An Unsupervised Clustering analysis to explain patient satisfaction by identifying hidden biomechanical profiles and the service gaps they face.

The result is a complete, data-driven story that moves from "What" is happening (Prediction) to "Why" it's happening and "How" to fix it (Explanation).

## 🎯 Objectives

-   **Predict Quality of Life scores** using patient demographics, biomechanical measures, and service utilization patterns
-   **Discover hidden patient profiles** ("Slow," "Steady," and "Fast Walkers") using unsupervised k-Means clustering.
-   **Identify key determinants** of patient satisfaction and health outcomes
-   **Explain the "Frustration Gap** we found in Patient Satisfaction for the "Steady Walker" profile.
-   **Explain Identify a critical "Rehab Gap** as the root cause of this frustration.
-   **Compare machine learning models** (Linear Regression vs Random Forest) for predictive accuracy
-   **Provide interactive tools** for healthcare professionals to explore patient data and generate predictions
-   **Generate evidence-based recommendations** for intervention strategies and program optimization

------------------------------------------------------------------------

## 📊 Dataset Description

### Source

The dataset is publicly available on kaggle: [Link to dataset](https://www.kaggle.com/datasets/ziya07/community-health-evaluation-dataset?resource=download)

### Dataset Characteristics

| Characteristic | Details |
|---------------------------------------------|---------------------------|
| **Sample Size** | 347 participants |
| **Age Range** | 18-69 years |
| **Variables** | 12 features (demographics, clinical, biomechanical, outcomes) |
| **Study Type** | Cross-sectional community health evaluation |
| **Data Format** | CSV (community_health_evaluation_dataset.csv) |

### Variables

**Demographics:** - Age (years) - Gender (Male/Female) - Socioeconomic Status (SES: 1-4 scale)

**Service Utilization:** - Service Type (Consultation, Preventive, Rehabilitation) - Visit Frequency (Yearly, Monthly, Weekly)

**Biomechanical Measures:** - Step Frequency (steps/min) - Stride Length (meters) - Joint Angle (degrees) - EMG Activity Level (Low, Moderate, High)

**Outcome Measures:** - Quality of Life Score (0-100) - Patient Satisfaction (1-10 scale)

------------------------------------------------------------------------

## 🔬 Methodology

Our project uses a two-part analytical approach to tell the full story.

### Part 1 (Supervised): Predicting Quality of Life (The "What")

This analysis builds a predictive model to understand the key drivers of QoL. - **Models:** Linear Regression, Random Forest. - **Process:** 80/20 train-test split with 5-fold cross-validation. - **Finding:** The Random Forest model was superior (R² = 0.489), and it identified Patient Satisfaction and Service Type as the two most important predictors of Quality of Life. - **The Problem:** This gave us a puzzle. To improve QoL, we have to "improve satisfaction." This isn't an answer; it's a new question.

### Part 2 (Unsupervised): Explaining Patient Satisfaction (The "Why")

This analysis was designed to solve the puzzle from Part 1. We investigated Patient Satisfaction to find its root cause. - **Model:** Unsupervised k-Means Clustering. - **Process:** 1. **Clustering:** We clustered patients on their 4 biomechanical variables. 2. **Find k:** An Elbow Plot showed k=3 was the optimal number of clusters. 3. **Profile:** We profiled the clusters by their Step Frequency and named them: "Slow Walkers," "Steady Walkers," and "Fast Walkers." 4. **Connect**: We cross-referenced these clusters with our key outcome (Patient Satisfaction) and the key driver (Service Type).

------------------------------------------------------------------------

## 📂 Repository Structure

This structure is designed for clear, reproducible analysis.

```         
.
├── data/
    └── RData.rds                            # Dataset
├── scripts/
    └── predictive_analysis.qmd                # Script for Part 1 (RF Model)
    └── clustering_analysis.Rmd                # Script for Part 2 (k-Means Model)
├── app/
    └── app.R                                # Interactive Shiny dashboard
├── presentations/
    └── final_presentation.pdf               # Presentation file
    └── report.Rmd                           # Script for online report
├── README.md                                # This file
├── LICENSE                                  # MIT License
└── figures/                                 # Generated plots and visualizations
```

------------------------------------------------------------------------

## 🚀 Getting Started (Reproducibility)

### Prerequisites

``` r
# Install required packages
install.packages(c(
  "shiny", "tidyverse", "plotly", "DT", "randomForest", 
  "caret", "quarto", "corrplot", "patchwork"
))
```

**How to Reproduce Our Analysis** The project is split into two logical, numbered scripts.

1.  Run the Predictive Analysis (Part 1):

``` r
# This script builds the Random Forest model and finds the key QoL predictors.
source("scripts/predictive_analysis.qmd")

```

2.  Run the Clustering Analysis (Part 2):

``` r
# This script runs the k-Means clustering, finds the "Frustration Gap,"
# and identifies the "Rehab Gap."
source("scripts/clustering_analysis.rmd")
```

3.  Launching our Dashboard

``` r
# Launch the Shiny application
shiny::runApp("app.R")
```

The dashboard provides: - **Real-time QoL predictions** based on patient parameters - **Interactive data exploration** with filtering and visualization - **Model performance comparison** with diagnostic plots - **Clinical interpretation** with actionable recommendations

### Generating the Analysis Report

``` r
# Render the Quarto presentation
render("presentations/report.rmd")
```

## 📈 Key Findings

### Model Performance

| Model             | RMSE  | MAE   | R²    |
|-------------------|-------|-------|-------|
| Linear Regression | 13.45 | 10.82 | 0.342 |
| Random Forest     | 11.23 | 8.97  | 0.489 |

**Random Forest outperforms Linear Regression** across all metrics, capturing non-linear relationships and interactions between predictors.

### Top Predictors of Quality of Life - Random Forest Model

1.  **Patient Satisfaction** (most important)
2.  **Service Type**
3.  **Visit Frequency**
4.  **EMG Activity Level**
5.  **Age**

**Finding 1 (Prediction)**: Patient Satisfaction and Service Type are the most important predictors of Quality of Life.

**Finding 2 (Clustering)**: We found 3 patient profiles: "Slow," "Steady," and "Fast Walkers."

**Finding 3 (The "Frustration Gap")**: The "Steady Walkers" (Cluster 2) are the least satisfied patient group.

**Finding 4 (The "Rehab Gap")**: This "frustrated" group also receives the least "Rehab" (26.7%), while the most satisfied group (Cluster 3) receives the most (37.1%).

**Finding 5 (The Solution)**: The "one-size-fits-all" rehab model is failing. Our EMG plot shows a clear triage solution: - **"Slow Walkers"** (40% "Low EMG") need Strength Training. - **"Steady Walkers"** ("Mod/High EMG") need Physical Therapy for pain/balance.

## 🎨 Dashboard Features

### 1. Overview Tab

-   Summary statistics and key performance indicators
-   Demographic distribution visualizations
-   Service utilization patterns

### 2. Predict QoL Tab

-   Interactive input controls for patient parameters
-   Real-time predictions from both models
-   Clinical interpretation with color-coded risk levels
-   Feature importance visualization
-   Confidence intervals based on similar patients

### 3. Model Performance Tab

-   Side-by-side model comparison
-   Actual vs Predicted scatter plots
-   Residual diagnostics
-   Subgroup performance analysis

### 4. Data Explorer Tab

-   Interactive filtering by demographics and service type
-   Custom scatter plots and distributions
-   Exportable data tables

## 📊 Use Cases

### For Healthcare Professionals

-   **Risk Stratification:** Identify patients at risk for poor QoL outcomes
-   **Intervention Planning:** Prioritize resources based on predicted outcomes
-   **Service Optimization:** Compare effectiveness of different service types
-   **Patient Counseling:** Set realistic expectations based on similar cases

### For Researchers

-   **Hypothesis Testing:** Explore relationships between variables
-   **Model Benchmarking:** Compare with alternative approaches
-   **Feature Selection:** Identify most impactful predictors
-   **Subgroup Analysis:** Examine disparities across populations

### For Healthcare Administrators

-   **Program Evaluation:** Assess effectiveness of interventions
-   **Resource Allocation:** Optimize service delivery models
-   **Quality Improvement:** Monitor outcomes over time
-   **Evidence-Based Decision Making:** Data-driven policy development

## 🔄 Reproducibility

All analyses are fully reproducible. The code includes: - Fixed random seeds for model training - Explicit package version requirements - Clear documentation of preprocessing steps - Detailed comments throughout

------------------------------------------------------------------------

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes:

1.  Fork the repository
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📧 Contact

-   **Authors:** "[Derrick Nyarko](github.com/nyarderr), [Daniel Adediran](github.com/dexwel), [Alejandra Ramirez](github.com/Alejandra1599),[Julie Cha](github.com/jcha-hub), [Jiro Claveria](github.com/aljon-claveria)
-   **Project Link:** <https://github.com/BioDataSage/ff-comm-health>

------------------------------------------------------------------------
