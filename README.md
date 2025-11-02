# Community Health Evaluation: Predictive Analytics for Quality of Life Outcomes

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.17504866.svg)](https://doi.org/10.5281/zenodo.17504866) [![R](https://img.shields.io/badge/R-4.3+-blue.svg)](https://www.r-project.org/) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 📋 Overview

This repository contains a comprehensive data analysis and interactive dashboard for predicting Quality of Life (QoL) outcomes in community health settings. The project leverages machine learning algorithms to identify key determinants of patient well-being and provide clinical decision support tools for healthcare optimization.

## 🎯 Objectives

-   **Predict Quality of Life scores** using patient demographics, biomechanical measures, and service utilization patterns
-   **Identify key determinants** of patient satisfaction and health outcomes
-   **Compare machine learning models** (Linear Regression vs Random Forest) for predictive accuracy
-   **Provide interactive tools** for healthcare professionals to explore patient data and generate predictions
-   **Generate evidence-based recommendations** for intervention strategies and program optimization

## 📊 Dataset Description

### Source

The dataset is publicly available on Zenodo: - **DOI:** [10.5281/zenodo.17504866](https://doi.org/10.5281/zenodo.17504866) - **Citation:** [Community Health Team]. (2925). Community Health Evaluation Dataset. Zenodo. <https://doi.org/10.5281/zenodo.17504866>

### Dataset Characteristics

| Characteristic | Details |
|----|----|
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

## 🔬 Methodology

### Analytical Approach

1.  **Exploratory Data Analysis (EDA)**
    -   Descriptive statistics and distribution analysis
    -   Correlation analysis and feature relationships
    -   Subgroup comparisons (ANOVA, t-tests)
    -   Visualization of demographic and clinical patterns
2.  **Feature Engineering**
    -   Mobility Index (composite biomechanical score)
    -   Engagement Score (visit frequency quantification)
    -   Age group stratification
    -   Satisfaction categorization
3.  **Predictive Modeling**
    -   **Linear Regression:** Baseline interpretable model
    -   **Random Forest:** Ensemble method for non-linear relationships
    -   80/20 train-test split with stratification
    -   5-fold cross-validation
    -   Hyperparameter tuning
4.  **Model Evaluation**
    -   Root Mean Square Error (RMSE)
    -   Mean Absolute Error (MAE)
    -   R-squared (R²)
    -   Residual analysis
    -   Subgroup performance assessment

## 📂 Repository Structure

```         
.
├── community_health_evaluation_dataset.csv  # Dataset
├── app.R                                    # Interactive Shiny dashboard
├── analysis.qmd                             # Quarto presentation
├── README.md                                # This file
├── LICENSE                                  # MIT License
└── figures/                                 # Generated plots and visualizations
```

## 🚀 Getting Started

### Prerequisites

``` r
# Install required packages
install.packages(c(
  "shiny",
  "shinydashboard",
  "tidyverse",
  "plotly",
  "DT",
  "randomForest",
  "caret",
  "knitr",
  "kableExtra",
  "corrplot",
))
```

### Running the Interactive Dashboard

``` r
# Launch the Shiny application
shiny::runApp("app.R")
```

The dashboard provides: - **Real-time QoL predictions** based on patient parameters - **Interactive data exploration** with filtering and visualization - **Model performance comparison** with diagnostic plots - **Clinical interpretation** with actionable recommendations

### Generating the Analysis Report

``` r
# Render the Quarto presentation
quarto::quarto_render("analysis.qmd")
```

## 📈 Key Findings

### Model Performance

| Model             | RMSE  | MAE   | R²    |
|-------------------|-------|-------|-------|
| Linear Regression | 13.45 | 10.82 | 0.342 |
| Random Forest     | 11.23 | 8.97  | 0.489 |

**Random Forest outperforms Linear Regression** across all metrics, capturing non-linear relationships and interactions between predictors.

### Top Predictors of Quality of Life

1.  **Patient Satisfaction** (most important)
2.  **Service Type**
3.  **Visit Frequency**
4.  **EMG Activity Level**
5.  **Age**

### Clinical Insights

-   **Strong positive correlation** between patient satisfaction and QoL (r = 0.45, p \< 0.001)
-   **Service type matters:** Preventive care shows highest average QoL scores
-   **Engagement effect:** Weekly visits associated with better outcomes (p = 0.032)
-   **Biomechanical function:** High EMG activity predicts better QoL
-   **Age-related patterns:** Middle-aged adults (31-45) show optimal outcomes

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

## 📝 Citation

If you use this dataset or code in your research, please cite:

``` bibtex
@dataset{community_health_2025,
  author       = {[Fair Forward Community Health Team]},
  title        = {Community Health Evaluation: Predictive Analytics Dataset},
  year         = {2025},
  publisher    = {Zenodo},
  doi          = {10.5281/zenodo.17504866},
  url          = {https://doi.org/10.5281/zenodo.17504866}
}
```

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

-   **Author:** [Your Name]
-   **Email:** [your.email\@example.com](mailto:your.email@example.com){.email}
-   **Project Link:** <https://github.com/yourusername/community-health-evaluation>

## 📚 References

1.  Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R, Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller E, Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu V, Takahashi K, Vaughan D, Wilke C, Woo K, Yutani H (2019). “Welcome to the tidyverse.” Journal of Open Source Software, 4(43), 1686. doi:10.21105/joss.01686.
2.  Posit Team (2025). RStudio: Integrated Development Environment for R. Posit Software, PBC. http://www.posit.co/.

------------------------------------------------------------------------
