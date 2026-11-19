#!/bin/bash

REGION="${AWS_DEFAULT_REGION:-us-west-2}"

rclone config create maap-s3 s3 provider=AWS env_auth=true region="$REGION" no_check_bucket true

exec /srv/start "$@"