#!/bin/bash

R_SITE_ENV=$(R RHOME)/etc/Renviron.site

# Variables we want to add to Renviron
VARS=("AWS_ROLE_ARN" "AWS_WEB_IDENTITY_TOKEN_FILE" "AWS_DEFAULT_REGION" "MAAP_PGT")

echo "--- Updating R Site Environment Variables ---"

# Loop through the variables and append them if they exist in the current shell
for var_name in "${VARS[@]}"; do
    # Use indirect expansion to get the value of the variable name
    var_value="${!var_name}"

    if [ -n "$var_value" ]; then
        echo "Adding $var_name to $R_SITE_ENV"
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

# File ends with a newline 
echo "" >> "$R_SITE_ENV"

# Needed to run awsv2 and aws 
awscliv2 --install
CONDA_BIN=$(dirname $(which python))
ln -sf $(which awsv2) "$CONDA_BIN/aws"

# Hand control to the base image's /srv/start which handles all initialization
exec /srv/start "$@"