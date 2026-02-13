#!/bin/bash

# 1. Locate the R site configuration file
R_SITE_ENV=$(R RHOME)/etc/Renviron.site

# 2. Define the variables you want to "pass through" to R
VARS=("AWS_ROLE_ARN" "AWS_WEB_IDENTITY_TOKEN_FILE" "AWS_DEFAULT_REGION" "MAAP_PGT")

echo "--- Updating R Site Environment Variables ---"

# 3. Loop through the names and append them if they exist in the current shell
for var_name in "${VARS[@]}"; do
    # Use indirect expansion to get the value of the variable name
    var_value="${!var_name}"

    if [ -n "$var_value" ]; then
        echo "Adding $var_name to $R_SITE_ENV"
        # Use sudo if your user doesn't have write permissions to /usr/lib/R/etc/
        # Check if the line already exists to avoid duplicates
        if ! grep -q "^$var_name=" "$R_SITE_ENV"; then
            echo "$var_name=$var_value" >> "$R_SITE_ENV"
        else
            # Update existing line if it changed
            sed -i "s|^$var_name=.*|$var_name=$var_value|" "$R_SITE_ENV"
        fi
    else
        echo "Skipping $var_name: Not set in shell environment."
    fi
done

# 4. Ensure the file ends with a newline (R requires this)
echo "" >> "$R_SITE_ENV"

# Hand control to the base image's /srv/start which handles all initialization
exec /srv/start "$@"