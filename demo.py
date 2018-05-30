import sys, skvideo.io, json, base64
import numpy as np
import tensorflow as tf
from PIL import Image
from io import BytesIO, StringIO

file = sys.argv[-1]

if file == 'demo.py':
  print ("Error loading video")
  quit

# Define model class
class DeeplabModel(object):
  INPUT_TENSOR_NAME = 'ImageTensor:0'
  OUTPUT_TENSOR_NAME = 'SemanticPredictions:0'
  IMAGE_SHAPE = (600, 800)
  
  def __init__(self):
      self.graph = tf.Graph()
      pb_file = open('frozen_inference_graph.pb', 'rb')
      graph_def = tf.GraphDef.FromString(pb_file.read())
      pb_file.close()
      
      with self.graph.as_default():
        tf.import_graph_def(graph_def, name='')
      
      self.sess = tf.Session(graph=self.graph)
      
  def predict(self, image):
      width = image.shape[0]
      height = image.shape[1]
      batch_seg_map = self.sess.run(
          self.OUTPUT_TENSOR_NAME,
          feed_dict={self.INPUT_TENSOR_NAME: [np.asarray(image)]})
      seg_map = batch_seg_map[0]
      return seg_map

# Define encoder function
def encode(array):
  pil_img = Image.fromarray(array)
  buff = BytesIO()
  pil_img.save(buff, format="PNG")
  return base64.b64encode(buff.getvalue()).decode("utf-8")

video = skvideo.io.vread(file)

answer_key = {}

# Frame numbering starts at 1
frame = 1

# model instance
model = DeeplabModel()

for rgb_frame in video:
  # Grab segmentation map
  seg_map = model.predict(rgb_frame)
  # Look for cars :)
  binary_car_result = np.where(seg_map==2,1,0).astype('uint8')
  # Look for road :)
  binary_road_result = np.where(seg_map==1,1,0).astype('uint8')
  answer_key[frame] = [encode(binary_car_result), encode(binary_road_result)]
  # Increment frame
  frame+=1

# Print output in proper json format
print (json.dumps(answer_key))