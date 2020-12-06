FROM nvcr.io/nvidia/l4t-tensorflow:r32.4.4-tf2.3-py3
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install opencv-python==4.4.0.46