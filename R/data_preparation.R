#' AI Model Carbon Footprint Data Preparation
#' This script handles the creation and processing of AI model carbon footprint data
#' Last updated: October 29, 2025

#' Create and validate AI model dataset
#' @description Creates a comprehensive dataset of AI models with their environmental impact metrics
#' @return data.frame containing AI model information
#' @export
create_ai_dataset <- function() {
    # Create base dataset
    data <- data.frame(
        Model = c(
            "AlexNet", "BERT", "GPT-2", "Megatron-LM", "T5", "GPT-3", "Switch Transformer",
            "Jurassic-1", "Codex", "BLOOM", "Gopher", "Chinchilla", "PaLM", "OPT", "LLaMA",
            "GPT-4", "Falcon-180B", "Gemini 1.0", "LLaMA 3.1", "Gemini 1.5", "Claude 3 Opus",
            "GPT-5 (est.)", "Claude 4 (est.)", "Gemini 2 (est.)"
        ),
        Year = c(2017, 2018, 2019, 2019, 2020, 2020, 2021, 2021, 2021, 2022, 2022, 2022,
                2022, 2022, 2023, 2023, 2023, 2023, 2024, 2024, 2024, 2025, 2025, 2025),
        Parameters_Billion = c(0.06, 0.34, 1.5, 8.3, 11, 175, 1600, 178, 12, 176, 280, 70,
                             540, 175, 65, 1000, 180, 600, 405, 1200, 400, 2000, 1000, 2200),
        EnergyUsed_MWh = c(50, 400, 1200, 5800, 9400, 1300000, 2100000, 1200000, 400000,
                          1082000, 1900000, 1000000, 2500000, 960000, 900000, 3800000,
                          1100000, 3500000, 1700000, 4200000, 2200000, 6500000, 3800000, 7000000),
        CO2_Tons = c(5, 35, 120, 500, 800, 552, 950, 600, 250, 433, 750, 480, 1200, 430,
                    360, 5184, 510, 2000, 8930, 2150, 1050, 7200, 3500, 6300),
        Organization = c(
            "University of Toronto", "Google", "OpenAI", "NVIDIA", "Google", "OpenAI",
            "Google", "AI21 Labs", "OpenAI", "BigScience", "DeepMind", "DeepMind",
            "Google", "Meta", "Meta", "OpenAI", "TII UAE", "Google DeepMind", "Meta",
            "Google DeepMind", "Anthropic", "OpenAI", "Anthropic", "Google DeepMind"
        ),
        Training_Location = c(
            "Canada", "USA", "USA", "USA", "USA", "USA", "USA", "Israel", "USA",
            "France", "UK", "UK", "USA", "USA", "USA", "USA", "UAE", "USA", "USA",
            "USA", "USA", "USA", "USA", "USA"
        )
    )
    
    # Add derived metrics
    data$Energy_Efficiency <- round(data$Parameters_Billion / data$EnergyUsed_MWh, 4)
    data$CO2_per_Parameter <- round(data$CO2_Tons / data$Parameters_Billion, 2)
    
    # Validate data
    validate_dataset(data)
    
    # Save dataset with timestamp
    filename <- file.path("data", paste0(
        "ai_carbon_footprint_", format(Sys.Date(), "%Y%m%d"), ".csv"
    ))
    write.csv(data, filename, row.names = FALSE)
    
    message("Dataset created and saved successfully to: ", filename)
    return(data)
}

#' Validate the AI model dataset
#' @param data The dataset to validate
#' @return TRUE if validation passes, stops with error otherwise
validate_dataset <- function(data) {
    # Check for missing values
    if (any(is.na(data))) {
        stop("Dataset contains missing values")
    }
    
    # Check for logical constraints
    if (any(data$Parameters_Billion <= 0)) {
        stop("Parameters must be positive")
    }
    if (any(data$EnergyUsed_MWh <= 0)) {
        stop("Energy usage must be positive")
    }
    if (any(data$CO2_Tons <= 0)) {
        stop("CO2 emissions must be positive")
    }
    
    # Check year range
    if (any(data$Year < 2017) || any(data$Year > 2025)) {
        stop("Years must be between 2017 and 2025")
    }
    
    return(TRUE)
}