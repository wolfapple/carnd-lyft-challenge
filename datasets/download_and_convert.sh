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

download_and_unzip() {
  local BASE_URL=${1}
  local FILENAME=${2}

  if [ ! -f "${FILENAME}" ]; then
    echo "Downloading ${FILENAME} to ${WORK_DIR}"
    wget -nd -c "${BASE_URL}/${FILENAME}"
  fi
  echo "Unzip ${FILENAME}"
  unzip "${FILENAME}"
}

# Download the images.
BASE_URL="https://s3-us-west-1.amazonaws.com/udacity-selfdrivingcar/Lyft_Challenge/Training+Data"
FILENAME="lyft_training_data.tar.gz"
BASE_URL2="https://github.com/ongchinkiat/LyftPerceptionChallenge/releases/download/v0.1"
FILENAME2="carla-capture-20181305.zip"
BASE_URL3="https://github.com/ongchinkiat/LyftPerceptionChallenge/releases/download/v0.1"
FILENAME3="carla-capture-20180513A.zip"

download_and_uncompress "${BASE_URL}" "${FILENAME}"
download_and_unzip "${BASE_URL2}" "${FILENAME2}"
download_and_unzip "${BASE_URL3}" "${FILENAME3}"

mv CameraRGB/* Train/CameraRGB
mv CameraSeg/* Train/CameraSeg

rm "${FILENAME}"
rm "${FILENAME2}"
rm "${FILENAME3}"
rm -rf CameraRGB
rm -rf CameraSeg

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