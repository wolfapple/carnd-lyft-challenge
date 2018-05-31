#!/bin/bash
# May need to uncomment and update to find current packages
# apt-get update

# Required for demo script! #
pip install scikit-video

# Add your desired packages for each workspace initialization
#          Add here!          #
apt-get update
apt-get install cuda-9-0
pip install --upgrade tensorflow-gpu