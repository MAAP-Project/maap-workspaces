# maap-workspaces
Repository dedicated to building maap workspaces. 

## CI/CD setup
If using gitlab, create a blank project and copy the gitlab ci file to it. 
Set up a webhook from this repository to trigger pipelines builds on the gitlab project. 

### CI Variables
By default all images are built upon trigger. 
Order of build is
- Base images
- Jupyterlab image using those base images 

To skip building all base images use the `SKIP_BASE_IMAGE_BUILD` flag and set it to `1`

When using the above option, the defulat base image used for the jupyterlb build is the miniconda3 images. 
To use a custom base image set the `BASE_IMAGE_NAME` to the image url you'd wish to use.  
