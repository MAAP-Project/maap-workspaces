# Correct CVE-2024-27322 Test
# Tests for unbound promise deserialization vulnerability
# Based on HiddenLayer's research and R Core Team's statement

test_cve_2024_27322_correct <- function() {
  cat("=== CVE-2024-27322 Vulnerability Test ===\n")
  cat("Testing for unbound promise deserialization exploit...\n\n")
  
  # The vulnerability requires creating an unbound promise through deserialization
  # Normal R code cannot create unbound promises - only hacked RDS files can
  
  temp_file <- tempfile(fileext = ".rds")
  .GlobalEnv$cve_test_executed <- FALSE
  
  tryCatch({
    # Test 1: Try to create what would be an exploitable structure
    # In vulnerable versions, this could create an unbound promise
    test_env <- new.env()
    
    # Create a normal promise (this should be bound in all R versions)
    delayedAssign("test_var", {
      .GlobalEnv$cve_test_executed <- TRUE
      cat("Code executed!\n")
      "executed"
    }, eval.env = test_env, assign.env = test_env)
    
    # Save and reload
    saveRDS(test_env, temp_file)
    loaded_env <- readRDS(temp_file)
    
    # Check if the loaded environment behaves normally
    if (exists("test_var", envir = loaded_env)) {
      # In vulnerable versions with unbound promises, accessing might trigger execution
      # In patched versions, this should work normally without unexpected execution
      val <- try(get("test_var", envir = loaded_env), silent = TRUE)
      
      # The key is that unbound promises would execute at unexpected times
      # This test is limited because we can't create actual unbound promises in R
      cat("Promise exists and can be accessed normally\n")
      return("CANNOT_DETERMINE")
    }
    
  }, error = function(e) {
    cat("Error during test:", e$message, "\n")
    return("ERROR")
  }, finally = {
    if (file.exists(temp_file)) unlink(temp_file)
    if (exists("cve_test_executed", .GlobalEnv)) rm(cve_test_executed, envir = .GlobalEnv)
  })
}

# More reliable test: Check R version and known vulnerability status
test_version_check <- function() {
  cat("=== Version-based Vulnerability Check ===\n")
  
  version_info <- R.Version()
  major <- as.numeric(version_info$major)
  minor_full <- version_info$minor
  
  # Parse minor version (e.g., "4.0" from "4.4.0")
  minor <- as.numeric(strsplit(minor_full, "\\.")[[1]][1])
  patch <- as.numeric(strsplit(minor_full, "\\.")[[1]][2])
  
  cat("R Version:", version_info$version.string, "\n")
  cat("Parsed: Major =", major, "Minor =", minor, "Patch =", patch, "\n\n")
  
  # CVE-2024-27322 was fixed in R 4.4.0
  if (major > 4 || (major == 4 && minor >= 4)) {
    cat("*** RESULT: PATCHED ***\n")
    cat("R >= 4.4.0 includes the official CVE-2024-27322 fix\n")
    return("PATCHED")
  } else if (major == 4 && minor >= 0) {
    cat("*** RESULT: LIKELY VULNERABLE ***\n")
    cat("R 4.0.0-4.3.x are vulnerable unless using Posit patched binaries\n")
    
    # Check if this might be a Posit patched version
    build_info <- try(capture.output(R.version), silent = TRUE)
    if (any(grepl("posit", build_info, ignore.case = TRUE))) {
      cat("Detected Posit in build info - may be patched\n")
      return("POSIT_PATCHED")
    }
    return("VULNERABLE")
  } else {
    cat("*** RESULT: VULNERABLE ***\n")
    cat("R < 4.0.0 is vulnerable to CVE-2024-27322\n")
    return("VULNERABLE")
  }
}

# Simple serialization safety test
test_serialization_safety <- function() {
  cat("\n=== Serialization Safety Test ===\n")
  
  # This tests if R properly handles promise serialization
  # The vulnerability involved unbound promises that shouldn't exist in normal R
  
  temp_file <- tempfile(fileext = ".rds")
  
  tryCatch({
    # Create a complex nested structure that might expose issues
    complex_obj <- list(
      normal_value = 42,
      quoted_expr = quote(cat("This should not execute\n")),
      function_obj = function() cat("Function called\n")
    )
    
    # Save and load
    saveRDS(complex_obj, temp_file)
    loaded_obj <- readRDS(temp_file)
    
    # Verify structure integrity
    if (identical(names(complex_obj), names(loaded_obj)) && 
        is.call(loaded_obj$quoted_expr) && 
        is.function(loaded_obj$function_obj)) {
      cat("Serialization preserves object structure correctly\n")
      return("NORMAL_BEHAVIOR")
    } else {
      cat("Unexpected serialization behavior detected\n")
      return("ABNORMAL_BEHAVIOR")
    }
    
  }, error = function(e) {
    cat("Error in serialization test:", e$message, "\n")
    return("ERROR")
  }, finally = {
    if (file.exists(temp_file)) unlink(temp_file)
  })
}

cat("CVE-2024-27322 Vulnerability Assessment\n")
cat("========================================\n\n")

# Run tests
result1 <- test_version_check()
result2 <- test_serialization_safety()

cat("\n=== FINAL ASSESSMENT ===\n")
cat("Version check:", result1, "\n")
cat("Serialization test:", result2, "\n\n")

if (result1 == "VULNERABLE") {
  cat("*** SYSTEM IS VULNERABLE TO CVE-2024-27322 ***\n")
  cat("RECOMMENDATION: Upgrade to R 4.4.0+ or use Posit patched binaries\n")
  cat("CRITICAL: Do not load .rds, .rdb, or .rdx files from untrusted sources\n")
} else if (result1 == "PATCHED") {
  cat("*** SYSTEM IS PATCHED AGAINST CVE-2024-27322 ***\n")
  cat("R 4.4.0+ includes the official fix for this vulnerability\n")
} else if (result1 == "POSIT_PATCHED") {
  cat("*** SYSTEM MAY BE PATCHED (Posit binaries) ***\n")
  cat("Verify you are using Posit's patched R binaries\n")
} else {
  cat("*** VULNERABILITY STATUS UNCERTAIN ***\n")
  cat("Manual verification recommended\n")
}

cat("\nNOTE: This vulnerability requires loading malicious .rds files\n")
cat("Always verify the source of R data files before loading\n")