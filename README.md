# maap-workspaces
Repository dedicated to building maap workspaces. 

## CI/CD setup
If using gitlab, create a blank project and copy the gitlab ci file to it. 
Set up a webhook from this repository to trigger pipelines builds on the gitlab project. 

### CI Variables
By default only the miniconda3 jupyterlab image is built upon trigger.
When using this option, the default base image used for the jupyterlb build is the continuumio/miniconda3:4.10.3p1 image. 
To use a custom base image set the `BASE_IMAGE_NAME` to the image url you'd wish to use.

To build all base images use the `BASE_IMAGE_BUILD` flag and set it to `1`
Order of build is
- Base images
- Jupyterlab image using those base images 
