# Auto-activate renv if present
if (file.exists("renv/activate.R")) {
  source("renv/activate.R")
}

# Ensure packages are installed and loaded
source("R/packages.R")
setup_packages()

# Run the main analysis (creates data, outputs, logs)
source("analysis/main.R")

# Optionally render the R Markdown report when --render is passed
args <- commandArgs(trailingOnly = TRUE)
if ("--render" %in% args) {
  rmarkdown::render("analysis/ai_carbon_analysis.Rmd", output_format = "html_document")
}
