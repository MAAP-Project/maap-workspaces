#!/usr/bin/env Rscript

# Script to print all R packages defined in install_cran_packages_r.sh
# along with their current versions

cat("R Package Versions\n")
cat("==================\n\n")

# Read the install script
script_path <- "/scripts/install_cran_packages_r.sh"
if (!file.exists(script_path)) {
  # If running locally, try the relative path
  script_path <- "install_cran_packages_r.sh"
}

# Read the script content
script_lines <- readLines(script_path)

# Extract package names from Rscript install2.r lines
packages <- c()

for (line in script_lines) {
  # Match lines with install2.r and extract package name (last quoted argument)
  if (grepl("install2\\.r.*\"[^\"]+\"\\s*$", line)) {
    # Extract the last quoted string
    match <- regmatches(line, regexpr("\"([^\"]+)\"\\s*$", line))
    if (length(match) > 0) {
      package_name <- gsub("\"", "", match)
      packages <- c(packages, package_name)
    }
  }

  # Also match Bioconductor packages from BiocManager::install
  if (grepl("BiocManager::install\\('([^']+)'", line)) {
    match <- regmatches(line, regexpr("'([^']+)'", line))
    if (length(match) > 0) {
      package_name <- gsub("'", "", match)
      packages <- c(packages, package_name)
    }
  }
}

# Get versions for each package
cat(sprintf("Found %d packages\n\n", length(packages)))

for (pkg in packages) {
  tryCatch({
    version <- as.character(packageVersion(pkg))
    cat(sprintf("%-20s %s\n", pkg, version))
  }, error = function(e) {
    cat(sprintf("%-20s NOT INSTALLED\n", pkg))
  })
}

cat("\n")
