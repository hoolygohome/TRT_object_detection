## nVidia containers !!!
```
https://ngc.nvidia.com/catalog/containers/nvidia:l4t-tensorflow
docker pull nvcr.io/nvidia/l4t-tensorflow:r32.4.4-tf2.3-py3

# docker commands:
docker login
docker ps
docker commit <container_hash> <repo_name/subname>:<tag>
docker images

# * some example
docker commit 4b6f804b5667 hoolygohome/jetson-tf-trt:v1
docker images

docker build -t hoolygohome/jetson-tf-trt:v1-build .
docker push hoolygohome/jetson-tf-trt:v1-build
```
## Also u can install Visual Studio Code from
https://code.visualstudio.com/docs/supporting/faq#_previous-release-versions
https://update.code.visualstudio.com/1.50.1/linux-deb-arm64/stable

===========================================
TensorRT Python Sample for Object Detection
===========================================

Performance includes memcpy and inference.
</br>

| Model | Input Size | TRT Nano |
|:------|:----------:|-----------:|
| ssd_inception_v2_coco(2017) | 300x300 | 49ms |
| ssd_mobilenet_v1_coco | 300x300 | 36ms |
| ssd_mobilenet_v2_coco | 300x300 | 46ms |

Since the optimization of preprocessing is not ready yet, we don't include image read/write time here.
</br>
</br>

## May need to:
```
# install 
pip install --upgrade virtualenv

# create
virtualenv -p python3 <env-name>

# activate
source <env-name>/bin/activate
```

## Install dependencies

```C
# Tensorflow installation on Jetson NANO
https://docs.nvidia.com/deeplearning/frameworks/install-tf-jetson-platform/index.html

$ sudo apt-get install python3-pip libhdf5-serial-dev hdf5-tools
$ pip3 install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v42 tensorflow-gpu==1.13.1+nv19.5 --user
$ pip3 install numpy pycuda --user
```

</br>
</br>

## Download model

Please download the object detection model from <a href=https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/tf2_detection_zoo.md>TensorFlow model zoo</a>.
</br>

```C
$ git clone https://github.com/AastaNV/TRT_object_detection.git
$ cd TRT_object_detection
$ mkdir model
$ cp [model].tar.gz model/
$ tar zxvf model/[model].tar.gz -C model/
```

##### Supported models:

- ssd_inception_v2_coco_2017_11_17
- ssd_mobilenet_v1_coco
- ssd_mobilenet_v2_coco

We will keep adding new model into our supported list.

</br>
</br>

## Update graphsurgeon converter

Edit /usr/lib/python3.6/dist-packages/graphsurgeon/node_manipulation.py

```C
diff --git a/node_manipulation.py b/node_manipulation.py
index d2d012a..1ef30a0 100644
--- a/node_manipulation.py
+++ b/node_manipulation.py
@@ -30,6 +30,7 @@ def create_node(name, op=None, _do_suffix=False, **kwargs):
     node = NodeDef()
     node.name = name
     node.op = op if op else name
+    node.attr["dtype"].type = 1
     for key, val in kwargs.items():
         if key == "dtype":
             node.attr["dtype"].type = val.as_datatype_enum
```
</br>
</br>

## RUN

**1. Maximize the Nano performance**
```C
$ sudo nvpmodel -m 0
$ sudo jetson_clocks
```
</br>

**2. Update main.py based on the model you used**
```C
from config import model_ssd_inception_v2_coco_2017_11_17 as model
from config import model_ssd_mobilenet_v1_coco_2018_01_28 as model
from config import model_ssd_mobilenet_v2_coco_2018_03_29 as model
```
</br>

**3. Execute**
```C
$ python3 main.py [image]
```

It takes some time to compile a TensorRT model when the first launching.
</br>
After that, TensorRT engine can be created directly with the serialized .bin file
</br>
</br>
@ To get more memory, it's recommended to turn-off X-server.
</br>
</br>
</br>
</br>
</br>

## Docker CE (arm64) & docker-compose
```
#!/bin/bash
sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose
sudo usermod -aG docker $USER
```

# Before the installation pycuda
```
export CPATH=$CPATH:/usr/local/cuda-10.2/targets/aarch64-linux/include
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda-10.2/targets/aarch64-linux/lib

export CPATH=$CPATH:/usr/local/cuda-10.0/targets/aarch64-linux/include
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda-10.0/targets/aarch64-linux/lib 

```


