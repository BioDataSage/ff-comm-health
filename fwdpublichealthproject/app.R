# ============================================================================
# Community Health Evaluation - Interactive Predictive Dashboard
# ============================================================================

# Required Libraries
library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(DT)
library(randomForest)
library(caret)

# ============================================================================
# Data Loading & Model Training
# ============================================================================

# Load data
data <- readRDS("C:/Users/Hp/Desktop/ff-comm-health/data/Rdata.rds")

# Data preprocessing
data_processed <- data %>%
  mutate(
    Gender = factor(Gender, levels = c("M", "F"), labels = c("Male", "Female")),
    SES = factor(SES, levels = 1:4, labels = c("Low", "Medium-Low", "Medium-High", "High"), ordered = TRUE),
    Service.Type = factor(Service.Type),
    Visit.Frequency = factor(Visit.Frequency, levels = c("Yearly", "Monthly", "Weekly"), ordered = TRUE),
    EMG.Activity = factor(EMG.Activity, levels = c("Low", "Moderate", "High"), ordered = TRUE),
    Mobility_Index = scale(Step.Frequency..steps.min.) + 
      scale(Stride.Length..m.) - 
      scale(Joint.Angle....),
    Engagement_Score = case_when(
      Visit.Frequency == "Weekly" ~ 3,
      Visit.Frequency == "Monthly" ~ 2,
      Visit.Frequency == "Yearly" ~ 1
    )
  )

# Train models
set.seed(42)
trainIndex <- createDataPartition(data_processed$Quality.of.Life.Score, p = 0.80, list = FALSE)
train_data <- data_processed[trainIndex, ]
test_data <- data_processed[-trainIndex, ]

# Linear Regression Model
lm_model <- lm(Quality.of.Life.Score ~ Age + Gender + SES + Service.Type + 
                 Visit.Frequency + Step.Frequency..steps.min. + 
                 Stride.Length..m. + Joint.Angle.... + EMG.Activity + 
                 Patient.Satisfaction..1.10. + Mobility_Index + 
                 Engagement_Score, 
               data = train_data)

# Random Forest Model
rf_model <- randomForest(Quality.of.Life.Score ~ Age + Gender + SES + Service.Type + 
                           Visit.Frequency + Step.Frequency..steps.min. + 
                           Stride.Length..m. + Joint.Angle.... + EMG.Activity + 
                           Patient.Satisfaction..1.10. + Mobility_Index + 
                           Engagement_Score,
                         data = train_data, 
                         ntree = 500, 
                         importance = TRUE)

# Calculate model metrics
lm_pred <- predict(lm_model, newdata = test_data)
rf_pred <- predict(rf_model, newdata = test_data)

model_metrics <- data.frame(
  Model = c("Linear Regression", "Random Forest"),
  RMSE = c(
    sqrt(mean((test_data$Quality.of.Life.Score - lm_pred)^2)),
    sqrt(mean((test_data$Quality.of.Life.Score - rf_pred)^2))
  ),
  MAE = c(
    mean(abs(test_data$Quality.of.Life.Score - lm_pred)),
    mean(abs(test_data$Quality.of.Life.Score - rf_pred))
  ),
  R_Squared = c(
    cor(test_data$Quality.of.Life.Score, lm_pred)^2,
    cor(test_data$Quality.of.Life.Score, rf_pred)^2
  )
)

# ============================================================================
# UI Definition
# ============================================================================

ui <- dashboardPage(
  skin = "blue",
  
  dashboardHeader(title = "Community Health Dashboard", titleWidth = 350),
  
  dashboardSidebar(
    width = 250,
    sidebarMenu(
      id = "tabs",
      menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
      menuItem("Predict QoL", tabName = "predict", icon = icon("calculator")),
      menuItem("Model Performance", tabName = "performance", icon = icon("chart-line")),
      menuItem("Data Explorer", tabName = "explorer", icon = icon("database")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .prediction-result { 
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: white;
          padding: 30px;
          border-radius: 10px;
          text-align: center;
          font-size: 28px;
          font-weight: bold;
          margin: 10px;
        }
      "))
    ),
    
    tabItems(
      # OVERVIEW TAB
      tabItem(
        tabName = "overview",
        
        h2("Community Health Evaluation Dashboard"),
        
        fluidRow(
          valueBox(nrow(data_processed), "Total Participants", icon = icon("users"), color = "aqua", width = 3),
          valueBox(round(mean(data_processed$Quality.of.Life.Score), 1), "Avg QoL Score", icon = icon("heart"), color = "green", width = 3),
          valueBox(round(mean(data_processed$Patient.Satisfaction..1.10.), 1), "Avg Satisfaction", icon = icon("smile"), color = "yellow", width = 3),
          valueBox(paste0(round(max(model_metrics$R_Squared) * 100, 1), "%"), "Best Model R²", icon = icon("chart-line"), color = "purple", width = 3)
        ),
        
        fluidRow(
          box(title = "Age Distribution", width = 6, status = "info", plotlyOutput("overview_age", height = 300)),
          box(title = "Service Utilization", width = 6, status = "info", plotlyOutput("overview_services", height = 300))
        ),
        
        fluidRow(
          box(title = "Quality of Life Distribution", width = 6, status = "success", plotlyOutput("overview_qol", height = 300)),
          box(title = "Key Statistics", width = 6, status = "warning", tableOutput("overview_stats"))
        )
      ),
      
      # PREDICT TAB
      tabItem(
        tabName = "predict",
        
        h2("Predict Quality of Life Score"),
        
        fluidRow(
          box(
            title = "Patient Parameters", width = 4, status = "primary", solidHeader = TRUE,
            
            sliderInput("pred_age", "Age:", min = 18, max = 70, value = 45, step = 1),
            selectInput("pred_gender", "Gender:", choices = c("Male", "Female"), selected = "Male"),
            selectInput("pred_ses", "SES:", choices = c("Low", "Medium-Low", "Medium-High", "High"), selected = "Medium-High"),
            selectInput("pred_service", "Service Type:", choices = c("Consultation", "Preventive", "Rehab"), selected = "Preventive"),
            selectInput("pred_frequency", "Visit Frequency:", choices = c("Yearly", "Monthly", "Weekly"), selected = "Monthly"),
            sliderInput("pred_satisfaction", "Satisfaction (1-10):", min = 1, max = 10, value = 7, step = 0.5),
            
            hr(),
            h5("Biomechanical Parameters"),
            sliderInput("pred_step_freq", "Step Frequency (steps/min):", min = 60, max = 100, value = 80, step = 1),
            sliderInput("pred_stride", "Stride Length (m):", min = 0.5, max = 1.0, value = 0.75, step = 0.01),
            sliderInput("pred_joint", "Joint Angle (°):", min = 10, max = 30, value = 20, step = 0.5),
            selectInput("pred_emg", "EMG Activity:", choices = c("Low", "Moderate", "High"), selected = "Moderate"),
            
            hr(),
            actionButton("predict_btn", "Predict QoL", icon = icon("calculator"), class = "btn-primary btn-lg btn-block")
          ),
          
          box(
            title = "Prediction Results", width = 8, status = "success", solidHeader = TRUE,
            
            conditionalPanel(
              condition = "input.predict_btn == 0",
              div(style = "text-align: center; padding: 50px;",
                  icon("arrow-left", style = "font-size: 48px; color: #999;"),
                  h3("Enter parameters and click Predict")
              )
            ),
            
            conditionalPanel(
              condition = "input.predict_btn > 0",
              fluidRow(
                column(6, div(class = "prediction-result", "Linear Regression", br(), textOutput("pred_lm"))),
                column(6, div(class = "prediction-result", style = "background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);", "Random Forest", br(), textOutput("pred_rf")))
              ),
              br(),
              box(width = 12, title = "Clinical Interpretation", status = "info", htmlOutput("pred_interpretation")),
              br(),
              box(width = 12, title = "Feature Importance", status = "warning", plotlyOutput("pred_importance", height = 400))
            )
          )
        )
      ),
      
      # PERFORMANCE TAB
      tabItem(
        tabName = "performance",
        
        h2("Model Performance Analysis"),
        
        fluidRow(
          box(title = "Model Metrics", width = 12, status = "primary", solidHeader = TRUE, DTOutput("perf_metrics"))
        ),
        
        fluidRow(
          box(title = "Linear Regression: Actual vs Predicted", width = 6, status = "info", plotlyOutput("perf_lm_scatter", height = 400)),
          box(title = "Random Forest: Actual vs Predicted", width = 6, status = "success", plotlyOutput("perf_rf_scatter", height = 400))
        ),
        
        fluidRow(
          box(title = "Residual Analysis", width = 6, status = "warning", plotlyOutput("perf_residuals", height = 400)),
          box(title = "Feature Importance (RF)", width = 6, status = "info", plotlyOutput("perf_importance", height = 400))
        )
      ),
      
      # EXPLORER TAB
      tabItem(
        tabName = "explorer",
        
        h2("Data Explorer"),
        
        fluidRow(
          box(
            title = "Filters", width = 3, status = "primary",
            checkboxGroupInput("filter_gender", "Gender:", choices = c("Male", "Female"), selected = c("Male", "Female")),
            checkboxGroupInput("filter_service", "Service:", choices = c("Consultation", "Preventive", "Rehab"), selected = c("Consultation", "Preventive", "Rehab")),
            sliderInput("filter_age", "Age:", min = 18, max = 70, value = c(18, 70)),
            actionButton("apply_filter", "Apply Filters", class = "btn-primary btn-block")
          ),
          box(title = "Data Table", width = 9, status = "info", DTOutput("explorer_table"))
        ),
        
        fluidRow(
          box(
            title = "Variable Relationships", width = 6, status = "success",
            selectInput("explorer_x", "X-axis:", choices = c("Age", "Patient.Satisfaction..1.10.", "Quality.of.Life.Score"), selected = "Patient.Satisfaction..1.10."),
            selectInput("explorer_y", "Y-axis:", choices = c("Age", "Patient.Satisfaction..1.10.", "Quality.of.Life.Score"), selected = "Quality.of.Life.Score"),
            selectInput("explorer_color", "Color:", choices = c("Gender", "Service.Type"), selected = "Service.Type"),
            plotlyOutput("explorer_scatter", height = 400)
          ),
          box(
            title = "Distribution", width = 6, status = "warning",
            selectInput("explorer_var", "Variable:", choices = c("Age", "Quality.of.Life.Score", "Patient.Satisfaction..1.10."), selected = "Quality.of.Life.Score"),
            selectInput("explorer_group", "Group by:", choices = c("Gender", "Service.Type"), selected = "Service.Type"),
            plotlyOutput("explorer_dist", height = 400)
          )
        )
      ),
      
      # ABOUT TAB
      tabItem(
        tabName = "about",
        h2("About This Dashboard"),
        box(
          width = 12, status = "primary",
          h4("Community Health Evaluation - Predictive Analytics Platform"),
          p("This dashboard uses machine learning to predict Quality of Life outcomes."),
          h4("Models"),
          tags$ul(
            tags$li("Linear Regression - R²:", round(model_metrics$R_Squared[1], 3)),
            tags$li("Random Forest - R²:", round(model_metrics$R_Squared[2], 3))
          ),
          h4("Dataset"),
          p("347 participants with demographics, biomechanical measures, and health outcomes.")
        )
      )
    )
  )
)

# ============================================================================
# SERVER
# ============================================================================

server <- function(input, output, session) {
  
  # OVERVIEW
  output$overview_age <- renderPlotly({
    plot_ly(data_processed, x = ~Age, color = ~Gender, type = "histogram", colors = c("#3498db", "#e74c3c")) %>%
      layout(barmode = "overlay", xaxis = list(title = "Age"), yaxis = list(title = "Count"))
  })
  
  output$overview_services <- renderPlotly({
    service_counts <- data_processed %>% group_by(Service.Type) %>% summarise(Count = n())
    plot_ly(service_counts, x = ~Service.Type, y = ~Count, type = "bar", marker = list(color = c("#3498db", "#2ecc71", "#f39c12")))
  })
  
  output$overview_qol <- renderPlotly({
    plot_ly(data_processed, x = ~Quality.of.Life.Score, type = "histogram", marker = list(color = "#2ecc71"))
  })
  
  output$overview_stats <- renderTable({
    data.frame(
      Metric = c("Mean QoL", "Median QoL", "SD QoL", "Mean Satisfaction"),
      Value = c(round(mean(data_processed$Quality.of.Life.Score), 2),
                round(median(data_processed$Quality.of.Life.Score), 2),
                round(sd(data_processed$Quality.of.Life.Score), 2),
                round(mean(data_processed$Patient.Satisfaction..1.10.), 2))
    )
  })
  
  # PREDICT
  predictions <- eventReactive(input$predict_btn, {
    mobility_idx <- (input$pred_step_freq - mean(train_data$Step.Frequency..steps.min.)) / sd(train_data$Step.Frequency..steps.min.) +
      (input$pred_stride - mean(train_data$Stride.Length..m.)) / sd(train_data$Stride.Length..m.) -
      (input$pred_joint - mean(train_data$Joint.Angle....)) / sd(train_data$Joint.Angle....)
    
    engagement <- ifelse(input$pred_frequency == "Weekly", 3, ifelse(input$pred_frequency == "Monthly", 2, 1))
    
    new_data <- data.frame(
      Age = input$pred_age,
      Gender = factor(input$pred_gender, levels = c("Male", "Female")),
      SES = factor(input$pred_ses, levels = c("Low", "Medium-Low", "Medium-High", "High"), ordered = TRUE),
      Service.Type = factor(input$pred_service, levels = levels(train_data$Service.Type)),
      Visit.Frequency = factor(input$pred_frequency, levels = c("Yearly", "Monthly", "Weekly"), ordered = TRUE),
      Step.Frequency..steps.min. = input$pred_step_freq,
      Stride.Length..m. = input$pred_stride,
      Joint.Angle..... = input$pred_joint,
      EMG.Activity = factor(input$pred_emg, levels = c("Low", "Moderate", "High"), ordered = TRUE),
      Patient.Satisfaction..1.10. = input$pred_satisfaction,
      Mobility_Index = mobility_idx,
      Engagement_Score = engagement
    )
    
    list(lm = round(predict(lm_model, newdata = new_data), 1), rf = round(predict(rf_model, newdata = new_data), 1))
  })
  
  output$pred_lm <- renderText({ paste(predictions()$lm, "/ 100") })
  output$pred_rf <- renderText({ paste(predictions()$rf, "/ 100") })
  
  output$pred_interpretation <- renderUI({
    pred <- predictions()$rf
    
    if(pred >= 85) {
      status <- list(color = "#27ae60", icon = "check-circle", text = "Excellent", desc = "Optimal health outcomes. Continue current care.")
    } else if(pred >= 70) {
      status <- list(color = "#f39c12", icon = "exclamation-triangle", text = "Good", desc = "Positive outcomes. Consider optimization opportunities.")
    } else if(pred >= 55) {
      status <- list(color = "#e67e22", icon = "exclamation-circle", text = "Fair", desc = "May benefit from targeted interventions.")
    } else {
      status <- list(color = "#e74c3c", icon = "times-circle", text = "Poor", desc = "Immediate intervention recommended.")
    }
    
    HTML(paste0('<div style="border-left: 5px solid ', status$color, '; padding: 15px;">',
                '<h4 style="color: ', status$color, ';"><i class="fa fa-', status$icon, '"></i> Status: ', status$text, '</h4>',
                '<p>', status$desc, '</p></div>'))
  })
  
  output$pred_importance <- renderPlotly({
    imp <- importance(rf_model) %>% as.data.frame() %>% rownames_to_column("Feature") %>% arrange(desc(`%IncMSE`)) %>% head(10)
    plot_ly(imp, x = ~`%IncMSE`, y = ~reorder(Feature, `%IncMSE`), type = "bar", orientation = "h", marker = list(color = "#3498db"))
  })
  
  # PERFORMANCE
  output$perf_metrics <- renderDT({
    datatable(model_metrics, options = list(dom = 't'), rownames = FALSE) %>%
      formatRound(columns = c("RMSE", "MAE", "R_Squared"), digits = 4)
  })
  
  output$perf_lm_scatter <- renderPlotly({
    df <- data.frame(Actual = test_data$Quality.of.Life.Score, Predicted = lm_pred)
    plot_ly(df, x = ~Actual, y = ~Predicted, type = "scatter", mode = "markers", marker = list(color = "#3498db")) %>%
      add_trace(x = c(50, 100), y = c(50, 100), type = "scatter", mode = "lines", line = list(color = "red", dash = "dash"), showlegend = FALSE)
  })
  
  output$perf_rf_scatter <- renderPlotly({
    df <- data.frame(Actual = test_data$Quality.of.Life.Score, Predicted = rf_pred)
    plot_ly(df, x = ~Actual, y = ~Predicted, type = "scatter", mode = "markers", marker = list(color = "#2ecc71")) %>%
      add_trace(x = c(50, 100), y = c(50, 100), type = "scatter", mode = "lines", line = list(color = "red", dash = "dash"), showlegend = FALSE)
  })
  
  output$perf_residuals <- renderPlotly({
    df <- data.frame(Model = rep(c("LM", "RF"), each = length(lm_pred)),
                     Residual = c(test_data$Quality.of.Life.Score - lm_pred, test_data$Quality.of.Life.Score - rf_pred))
    plot_ly(df, x = ~Residual, color = ~Model, type = "histogram", colors = c("#3498db", "#2ecc71"))
  })
  
  output$perf_importance <- renderPlotly({
    imp <- importance(rf_model) %>% as.data.frame() %>% rownames_to_column("Feature") %>% arrange(desc(`%IncMSE`)) %>% head(10)
    plot_ly(imp, x = ~`%IncMSE`, y = ~reorder(Feature, `%IncMSE`), type = "bar", orientation = "h", marker = list(color = "#2ecc71"))
  })
  
  # EXPLORER
  filtered_data <- eventReactive(input$apply_filter, {
    data_processed %>% filter(Gender %in% input$filter_gender, Service.Type %in% input$filter_service,
                              Age >= input$filter_age[1], Age <= input$filter_age[2])
  }, ignoreNULL = FALSE)
  
  output$explorer_table <- renderDT({
    datatable(filtered_data() %>% select(-Mobility_Index, -Engagement_Score), options = list(pageLength = 10))
  })
  
  output$explorer_scatter <- renderPlotly({
    plot_ly(filtered_data(), x = ~get(input$explorer_x), y = ~get(input$explorer_y), color = ~get(input$explorer_color),
            type = "scatter", mode = "markers") %>% layout(xaxis = list(title = input$explorer_x), yaxis = list(title = input$explorer_y))
  })
  
  output$explorer_dist <- renderPlotly({
    plot_ly(filtered_data(), x = ~get(input$explorer_var), color = ~get(input$explorer_group), type = "histogram") %>%
      layout(barmode = "overlay", xaxis = list(title = input$explorer_var))
  })
}

shinyApp(ui = ui, server = server)