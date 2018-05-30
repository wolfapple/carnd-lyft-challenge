set -e

CURRENT_DIR=$(pwd)
WORK_DIR="./pretrained_model"
mkdir -p "${WORK_DIR}"

# Helper function to download and unpack lyft dataset.
download_and_uncompress() {
  local BASE_URL=${1}
  local FILENAME=${2}

  if [ ! -f "${FILENAME}" ]; then
    echo "Downloading ${FILENAME} to ${WORK_DIR}"
    wget -nd -c "${BASE_URL}/${FILENAME}"
  fi
  echo "Uncompressing ${FILENAME}"
  tar xvfz "${FILENAME}"
}

# Download the images.
BASE_URL="http://download.tensorflow.org/models"
FILENAME="deeplabv3_cityscapes_train_2018_02_06.tar.gz"

download_and_uncompress "${BASE_URL}" "${FILENAME}"
rm "${FILENAME}"
mv deeplabv3_cityscapes_train pretrained_model