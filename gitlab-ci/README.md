# maap-workspaces
Repository dedicated to building maap workspaces. 

## CI/CD setup
If using gitlab, create a blank project and copy the gitlab ci file to it. 
Set up a webhook from this repository to trigger pipelines builds on the gitlab project. 

### CI Variables

`FORCE_REF_BUILD`: variable used to force build a specific branch or commit hash.

`BUILD_ALL_BASE_IMAGES`: Builds all images listed under the [base_images](/base_images) dir.

`BUILD_SPECIFIC_BASE_IMAGES`: Comma separated list of base images to build. Names should match dir names under 
[base_images](/base_images) dir 


### Working of CI

Use the above variables to control the execution of a CI pipline when manually triggering a pipline.
By default, when the CI receives a webhook, it will get the latest commit on the repo and list the files that have changed. 

If files changed match `base_images/*/*` it will trigger a build of those images. 
Any other files changed currently does not trigger image builds. 

TODO: On files changed under jupyterlab dir, build all images. 

## Devfile publication

To be listed in the ADE stack directory, the devfile and its metadata must be included in the [devfiles](/devfiles) directory. 
