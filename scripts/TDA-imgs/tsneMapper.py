from ImgMapper import *
from sklearn.decomposition import PCA
import pandas as pd
from PIL import Image
from pylab import *

features_path = "../features/hogs_feat.pkl"

hog_features = pd.read_pickle(features_path)


# Create images for a custom tooltip array
from io import BytesIO
from scipy.misc import imsave, toimage
import base64
tooltip_s = []
image_paths  = list(hog_features["image_paths"])

for image_path in image_paths:
  output = BytesIO()
  #img = toimage(image_data.reshape((28,28))) # Data was a flat row of 64 "pixels".
  img = Image.open(image_path).resize((100,100))
  img.save(output, format="PNG")
  contents = "<img src='data:image/png;base64,"+base64.encodestring(output.getvalue()).decode()+"'>"
  tooltip_s.append( contents )
  output.close()
  
tooltip_s = np.array(tooltip_s) # need to make sure to feed it as a NumPy array, not a list



# # Setup data feature

image_features = array(list(hog_features["hogs"]))
image_features.shape


# # Reduce dimensions and apply clustering

pca = PCA(n_components=50)
data = pca.fit_transform(array(image_features))

# Initialize to use t-SNE with 2 components (reduces data to 2 dimensions). Also note high overlap_percentage.
mapper = KeplerMapper(cluster_algorithm=cluster.DBSCAN(eps=0.2, min_samples=5), 
             reducer = manifold.TSNE(), nr_cubes=30, overlap_perc=0.9, 
             link_local=False, verbose=1)

# Fit and transform data
data = mapper.fit_transform(data)

# Create the graph
complex = mapper.map(data, dimension_index=[0,1], dimension_name="t-SNE(2) 2D")

# Create the visualizations (increased the graph_gravity for a tighter graph-look.)

# Tooltips with image data for every cluster member
mapper.visualize(complex, "results.html", "t-SNE on first 4k images", graph_charge=-50, graph_gravity=0.15, custom_tooltips=tooltip_s)
  