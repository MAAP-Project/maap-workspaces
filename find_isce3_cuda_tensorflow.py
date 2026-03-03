import requests
import subprocess
import re
import os
import sys

# Constants for the Quay repository
REGISTRY = "quay.io"
REPO = "pangeo/ml-notebook"
# Base API URL for tags
BASE_API_URL = f"https://quay.io/api/v1/repository/{REPO}/tag/"

def get_filtered_quay_tags():
    """Fetches ALL tags using Quay.io pagination and filters them."""
    print(f"🔍 Fetching ALL tags from {REGISTRY}/{REPO} (this may take a moment)...")
    all_tags = []
    page = 1
    has_additional = True
    
    # Filtering parameters
    cutoff_date = "2026.10.20"
    date_pattern = re.compile(r'^\d{4}\.\d{2}\.\d{2}$')
    
    try:
        while has_additional:
            # Quay API uses a 'page' parameter for pagination
            response = requests.get(f"{BASE_API_URL}?page={page}")
            if response.status_code != 200:
                print(f"❌ Failed to fetch page {page}: {response.status_code}")
                break
            
            data = response.json()
            tags_in_page = data.get('tags', [])
            
            for tag_obj in tags_in_page:
                tag_name = tag_obj.get('name', '')
                if date_pattern.match(tag_name):
                    if tag_name < cutoff_date:
                        all_tags.append(tag_name)
            
            # Check if there are more pages to fetch
            has_additional = data.get('has_additional', False)
            page += 1
            
            if page % 5 == 0:
                print(f"   ...collected {len(all_tags)} date tags so far...")

    except Exception as e:
        print(f"❌ Error during API request: {e}")
        
    # Sort newest tags first to find the most modern working base image
    all_tags.sort(reverse=True)
    return all_tags

def run_isce3_cuda_test(tag):
    """Attempts to build a Docker image for amd64 and install isce3-cuda."""
    image_name = f"{REGISTRY}/{REPO}:{tag}"
    isce3_version = "0.25.7"
    platform = "linux/amd64"

    # Dockerfile logic with the critical CUDA override
    dockerfile_content = f"""
FROM --platform={platform} {image_name}
USER root
ENV CONDA_OVERRIDE_CUDA="12.0"
SHELL ["/bin/bash", "-c"]
USER ${{NB_USER}}

RUN conda update -y -n base conda && \\
    conda install -y -n notebook -c conda-forge isce3-cuda={isce3_version} && \\
    conda run -n notebook python -c "import isce3; print('ISCE3_CUDA_LOADED_SUCCESSFULLY')"
"""
    
    with open("TempCudaTestTensorflow.Dockerfile", "w") as f:
        f.write(dockerfile_content)

    print(f"\n--- 🧪 Testing Tag: {tag} (isce3-cuda {isce3_version}) ---")
    
    try:
        # check=False ensures the script doesn't crash on build failure
        result = subprocess.run([
            "docker", "build", 
            "--platform", platform,
            "-f", "TempCudaTestTensorflow.Dockerfile", 
            "--no-cache",
            "-t", "isce3_cuda_probe", 
            "."
        ], capture_output=False) 

        return result.returncode == 0
            
    finally:
        if os.path.exists("TempCudaTestTensorflow.Dockerfile"):
            os.remove("TempCudaTestTensorflow.Dockerfile")
        subprocess.run(["docker", "rmi", "isce3_cuda_probe"], capture_output=True)
        # Pulling amd64 images takes a lot of space; cleanup the base image after test
        subprocess.run(["docker", "rmi", image_name], capture_output=True)

if __name__ == "__main__":
    tags_to_test = get_filtered_quay_tags()
    
    if not tags_to_test:
        print("❌ No valid candidate tags found older than 2025.01.24.")
    else:
        print(f"✅ Found {len(tags_to_test)} candidate images. Starting sequence...")
        for tag in tags_to_test:
            if run_isce3_cuda_test(tag):
                print("\n" + "="*60)
                print(f"🏁 COMPATIBLE BASE IMAGE FOUND: {tag}")
                print(f"Update your Dockerfile to: FROM {REGISTRY}/{REPO}:{tag}")
                print("="*60)
                sys.exit(0)
            else:
                print(f"❌ Tag {tag} failed. Trying next oldest tag...")
