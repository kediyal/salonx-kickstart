#!/bin/bash

# Update the server's package lists
echo ""
echo "Updating package lists..."
sudo apt update
sudo apt upgrade

# Update the packages lists
echo ""
echo "Updating the packages"
sudo apt list --upgradable

# Install essential packages
echo ""
echo "Installing essential packages..."
sudo apt install -y git nginx python3-pip python3-dev python3-venv nodejs npm

# Check if GDAL is already installed
echo ""
echo "Checking for GDAL installation..."
if command -v gdal-config > /dev/null 2>&1; then
    echo "GDAL is already installed."
else
    echo "Downloading and then building GDAL from source."
    echo "Please follow the instructions on screen. This may take a while."
    sudo apt install -y build-essential cmake python3-dev python3-pip
    sudo apt install -y libproj-dev libgeos-dev libcurl4-gnutls-dev
    wget https://github.com/OSGeo/gdal/releases/download/v3.8.5/gdal-3.8.5.tar.gz
    tar -xvf gdal-3.8.5.tar.gz
    cd gdal-3.8.5
    mkdir build
    cd build
    cmake ..
    make -j$(nproc)
    sudo make install

    # Set the environment variables
    echo ""
    echo "Setting path variables for GDAL..."
    export PATH=/usr/local/bin:$PATH
    export GDAL_CONFIG=/usr/local/bin/gdal-config

    # Verify the installation
    gdal-config --version

    # Check GDAL availability
    which gdal-config

    # Once installed, remove the build directories
    rm -rf ~/salonx/gdal-3.8.5/build
    ls ~/salonx/gdal-3.8.5
fi

# Set variables for all the repositories
DJANGO_PROJECT_DIR="backend/"
REACT_PROJECT_DIR="frontend/"
DJANGO_REPO_URL="https://github.com/Harmeek-19/Hair-Salon-Marketplace"
REACT_REPO_URL=""

# Ensure the parent directory exists
PARENT_DIR=$(dirname "$DJANGO_PROJECT_DIR")
if [ ! -d "$PARENT_DIR" ]; then
    echo "Creating parent directory $PARENT_DIR..."
    mkdir -p "$PARENT_DIR"
fi

# Clone the Django project repository
echo ""
echo "Cloning Django repository..."
if [ ! -d "$DJANGO_PROJECT_DIR" ]; then
    git clone $DJANGO_REPO_URL $DJANGO_PROJECT_DIR || { echo "Failed to clone Django repository"; exit 1; }
else
    echo "Directory $DJANGO_PROJECT_DIR already exists, skipping clone."
fi

# Navigate to the Django project directory
echo ""
echo "Navigating to the backend directory..."
cd $DJANGO_PROJECT_DIR

# Set up a Python virtual environment
echo ""
echo "Setting up Python virtual environment..."
python3 -m venv venv

# Verify venv directory
echo ""
echo "Checking if venv directory was created..."
ls -l

# Activate Python virtual environment
echo ""
echo "Activating Python virtual environment..."
source venv/bin/activate

# Verify activation
echo ""
echo "Verifying virtual environment activation..."
which python
which pip

# Install Python dependencies
echo ""
echo "Installing Django dependencies..."
source venv/bin/activate
pip install -r requirements.txt

# Make migrations
echo ""
echo "Make Django database migrations"
# python manage.py makemigrations
# python manage.py migrate

# Static files
mkdir /home/azureuser/salonx/backend/staticfiles
mkdir /home/azureuser/salonx/backend/static
# sudo chown -R azureuser:azureuser /home/azureuser/salonx/backend/staticfiles
# sudo chmod -R 755 /home/azureuser/salonx/backend/staticfiles
# python manage.py collectstatic --clear --noinput