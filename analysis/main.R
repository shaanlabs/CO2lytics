#' AI Carbon Footprint Analysis Main Script
#' This script orchestrates the complete analysis of AI model environmental impact
#' Last updated: October 29, 2025

# Set up error handling and logging
log_file <- file.path("analysis", "logs", format(Sys.time(), "analysis_%Y%m%d_%H%M%S.log"))
dir.create(dirname(log_file), recursive = TRUE, showWarnings = FALSE)

# Start logging
cat(sprintf("\nAnalysis started at %s\n", Sys.time()), file = log_file)

tryCatch({
    # Source required files
    source("R/packages.R")
    source("R/data_preparation.R")
    source("R/visualization.R")
    
    # Create and load the dataset
    cat("\nCreating dataset...\n", file = log_file, append = TRUE)
    data <- create_ai_dataset()
    
    # Basic summary statistics
    summary_stats <- data %>%
        summarise(
            Total_Models = n(),
            Total_CO2 = sum(CO2_Tons),
            Avg_CO2_per_Model = mean(CO2_Tons),
            Total_Energy = sum(EnergyUsed_MWh),
            Avg_Energy_per_Model = mean(EnergyUsed_MWh),
            Total_Parameters = sum(Parameters_Billion),
            Latest_Year = max(Year)
        )
    
    # Save summary statistics
    cat("\nSummary Statistics:\n", file = log_file, append = TRUE)
    capture.output(summary_stats, file = log_file, append = TRUE)
    
    # Create visualization directory
    viz_dir <- file.path("analysis", "outputs", format(Sys.Date(), "%Y%m%d"))
    dir.create(viz_dir, recursive = TRUE, showWarnings = FALSE)
    
    # Generate and save visualizations
    cat("\nGenerating visualizations...\n", file = log_file, append = TRUE)
    
    # Carbon Footprint Plot
    p1 <- create_carbon_footprint_plot(data)
    ggsave(file.path(viz_dir, "carbon_footprint.png"), p1, width = 12, height = 8)
    
    # Model Size vs Energy Plot
    p2 <- create_model_size_energy_plot(data)
    htmlwidgets::saveWidget(p2, file.path(viz_dir, "model_size_energy.html"))
    
    # Emissions Trend Plot
    p3 <- create_emissions_trend_plot(data)
    ggsave(file.path(viz_dir, "emissions_trend.png"), p3, width = 10, height = 6)
    
    # Efficiency Analysis Plot
    p4 <- create_efficiency_plot(data)
    ggsave(file.path(viz_dir, "efficiency_analysis.png"), p4, width = 12, height = 8)
    
    # Generate organization-specific analysis
    org_summary <- data %>%
        group_by(Organization) %>%
        summarise(
            Models_Count = n(),
            Total_CO2 = sum(CO2_Tons),
            Avg_CO2_per_Model = mean(CO2_Tons),
            Total_Energy = sum(EnergyUsed_MWh),
            .groups = "drop"
        ) %>%
        arrange(desc(Total_CO2))
    
    # Save organization summary
    write.csv(org_summary, 
              file.path(viz_dir, "organization_summary.csv"), 
              row.names = FALSE)
    
    cat("\nAnalysis completed successfully!\n", file = log_file, append = TRUE)
    
}, error = function(e) {
    cat(sprintf("\nError occurred: %s\n", e$message), file = log_file, append = TRUE)
    stop(e)
}, finally = {
    cat(sprintf("\nAnalysis finished at %s\n", Sys.time()), file = log_file, append = TRUE)
})

# Display completion message
message("Analysis completed. Results saved in: ", viz_dir)
message("Log file saved as: ", log_file)