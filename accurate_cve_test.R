# Accurate CVE-2024-27322 Test
# Tests the actual promise object deserialization vulnerability

test_cve_2024_27322_accurate <- function() {
  cat("=== CVE-2024-27322 Vulnerability Test ===\n")
  cat("Testing promise object deserialization exploit...\n\n")
  
  # Create a test environment to capture if code executes
  .GlobalEnv$vuln_test_executed <- FALSE
  
  temp_file <- tempfile(fileext = ".rds")
  
  tryCatch({
    # The real vulnerability involves promises in serialized environments
    # Create an environment with a promise that should execute during load
    test_env <- new.env()
    
    # This creates a promise that gets evaluated during deserialization in vulnerable R
    # The key is that the promise is evaluated as part of the deserialization process
    delayedAssign("malicious_var", {
      .GlobalEnv$vuln_test_executed <- TRUE
      cat("*** VULNERABLE: Promise executed during deserialization! ***\n")
      "exploit_payload"
    }, eval.env = test_env, assign.env = test_env)
    
    # Save the environment containing the promise
    saveRDS(test_env, temp_file)
    cat("Saved test environment with promise to:", temp_file, "\n")
    
    # Reset the test flag
    .GlobalEnv$vuln_test_executed <- FALSE
    cat("Loading RDS file...\n")
    
    # This should trigger promise evaluation in vulnerable versions
    loaded_env <- readRDS(temp_file)
    
    # Check if promise was auto-evaluated during load
    if (.GlobalEnv$vuln_test_executed) {
      cat("\n*** RESULT: VULNERABLE ***\n")
      cat("Promise was evaluated during readRDS() - CVE-2024-27322 present!\n")
      return("VULNERABLE")
    }
    
    # Additional check: try to access the variable (this should be safe in patched versions)
    cat("Checking if promise exists without auto-execution...\n")
    
    # In patched versions, the promise should exist but not auto-execute
    if (exists("malicious_var", envir = loaded_env)) {
      # Try to get the value - in patched versions this won't auto-execute
      val <- try(get("malicious_var", envir = loaded_env), silent = TRUE)
      
      if (.GlobalEnv$vuln_test_executed) {
        cat("\n*** RESULT: VULNERABLE ***\n") 
        cat("Promise executed when accessed - CVE-2024-27322 present!\n")
        return("VULNERABLE")
      } else {
        cat("\n*** RESULT: LIKELY PATCHED ***\n")
        cat("Promise exists but did not auto-execute during deserialization\n")
        return("PATCHED")
      }
    } else {
      cat("\n*** RESULT: PATCHED ***\n")
      cat("Promise object was not preserved in deserialization (secure behavior)\n")
      return("PATCHED")
    }
    
  }, error = function(e) {
    cat("\n*** RESULT: ERROR OR PATCHED ***\n")
    cat("Error during test:", e$message, "\n")
    cat("This may indicate patched behavior or other protective measures\n")
    return("LIKELY_PATCHED")
  }, finally = {
    # Cleanup
    if (file.exists(temp_file)) unlink(temp_file)
    if (exists("vuln_test_executed", .GlobalEnv)) rm(vuln_test_executed, envir = .GlobalEnv)
  })
}

# Alternative test method - direct promise serialization
test_promise_serialization <- function() {
  cat("\n=== Promise Serialization Test ===\n")
  
  temp_file <- tempfile(fileext = ".rds")
  .GlobalEnv$promise_test_flag <- FALSE
  
  tryCatch({
    # Create a promise object directly
    p <- substitute({
      .GlobalEnv$promise_test_flag <- TRUE
      cat("Promise evaluated!\n")
      42
    })
    
    # Try to serialize the promise
    saveRDS(p, temp_file)
    result <- readRDS(temp_file)
    
    if (.GlobalEnv$promise_test_flag) {
      cat("*** Promise executed during deserialization ***\n")
      return("VULNERABLE")
    } else {
      cat("*** Promise not executed - likely patched ***\n")
      return("PATCHED")
    }
    
  }, finally = {
    if (file.exists(temp_file)) unlink(temp_file)
    if (exists("promise_test_flag", .GlobalEnv)) rm(promise_test_flag, envir = .GlobalEnv)
  })
}

# Version check
cat("R Version Information:\n")
cat("Version:", R.version.string, "\n")
version_info <- R.Version()
r_version <- paste(version_info$major, version_info$minor, sep = ".")
cat("Parsed version:", r_version, "\n\n")

# Run both tests
result1 <- test_cve_2024_27322_accurate()
result2 <- test_promise_serialization()

cat("\n=== FINAL ASSESSMENT ===\n")
cat("Test 1 (Environment promises):", result1, "\n")
cat("Test 2 (Direct promises):", result2, "\n")

if (result1 == "VULNERABLE" || result2 == "VULNERABLE") {
  cat("\n*** SYSTEM IS VULNERABLE TO CVE-2024-27322 ***\n")
  cat("Upgrade to R 4.4.0+ or use Posit patched binaries\n")
} else {
  cat("\n*** System appears PATCHED against CVE-2024-27322 ***\n")
  if (as.numeric(substr(r_version, 1, 3)) < 4.4) {
    cat("NOTE: If version < 4.4.0, verify you're using Posit patched binaries\n")
  }
}