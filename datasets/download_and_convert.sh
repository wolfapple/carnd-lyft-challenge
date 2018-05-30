set -e

CURRENT_DIR=$(pwd)
WORK_DIR="./lyft"
mkdir -p "${WORK_DIR}"
cd "${WORK_DIR}"

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
BASE_URL="https://s3-us-west-1.amazonaws.com/udacity-selfdrivingcar/Lyft_Challenge/Training+Data"
FILENAME="lyft_training_data.tar.gz"

download_and_uncompress "${BASE_URL}" "${FILENAME}"

rm "${FILENAME}"

cd "${CURRENT_DIR}"

# Root path for lyft dataset.
LYFT_ROOT="${WORK_DIR}/Train"

# Build TFRecords of the dataset.
# First, create output directory for storing TFRecords.
OUTPUT_DIR="${WORK_DIR}/tfrecord"
mkdir -p "${OUTPUT_DIR}"

echo "Converting lyft dataset..."
python ./build_lyft_data.py  \
  --train_image_folder="${LYFT_ROOT}/CameraRGB/" \
  --train_image_label_folder="${LYFT_ROOT}/CameraSeg/" \
  --output_dir="${OUTPUT_DIR}"