FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04 AS builder

ARG WEBUI_VERSION=v1.3.2
ARG DREAMBOOTH_VERSION=1.0.14

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND noninteractive\
    SHELL=/bin/bash

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu
ENV PATH="/workspace/venv/bin:$PATH"
ENV TORCH_COMMAND="pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu117"
WORKDIR /workspace

COPY cache-sd-model.py .
COPY install-automatic.py .
COPY assets/models /sd-models/
COPY assets/embeddings /sd-embeddings/
COPY assets/controlnet /cn-models/
#COPY requirements_dreambooth.txt /requirements_dreambooth.txt

COPY requirements.txt /requirements.txt
COPY requirements_versions.txt /requirements_versions.txt

RUN apt update --yes && \
apt upgrade --yes && \
apt install --yes --no-install-recommends \
git \
openssh-server \
libglib2.0-0 \
libsm6 \
libgl1 \
libxrender1 \
libxext6 \
ffmpeg \
wget \
curl \
psmisc \
rsync \
vim \
pkg-config \
libffi-dev \
libcairo2 \
libcairo2-dev \
libgoogle-perftools4 \
libtcmalloc-minimal4 \
apt-transport-https \
software-properties-common \
ca-certificates && \
update-ca-certificates && \
add-apt-repository ppa:deadsnakes/ppa && \
apt install python3.10-dev python3.10-venv -y --no-install-recommends && \
ln -s /usr/bin/python3.10 /usr/bin/python && \
rm /usr/bin/python3 && \
ln -s /usr/bin/python3.10 /usr/bin/python3 && \
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \python get-pip.py && \ 
pip install -U --no-cache-dir pip && \
python -m venv /workspace/venv && \
export PATH="/workspace/venv/bin:$PATH" && \
pip install -U --no-cache-dir jupyterlab jupyterlab_widgets ipykernel ipywidgets && \
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git && \
cd stable-diffusion-webui && \
git checkout tags/v1.3.2 && \
mv /workspace/install-automatic.py /workspace/stable-diffusion-webui/ && \
mv /requirements.txt ./requirements.txt && \
mv /requirements_versions.txt ./requirements_versions.txt && \
python -m install-automatic --skip-torch-cuda-test && \
  cd /workspace/stable-diffusion-webui && \
  git clone https://github.com/deforum-art/sd-webui-deforum extensions/deforum && \
  cd extensions/deforum && \
  pip install -r requirements.txt && \
cd /workspace/stable-diffusion-webui && \
  git clone https://github.com/Mikubill/sd-webui-controlnet.git extensions/sd-webui-controlnet && \
  cd extensions/sd-webui-controlnet && \
  pip install -r requirements.txt && \
cd /workspace/stable-diffusion-webui && \
  git clone https://github.com/AlUlkesh/stable-diffusion-webui-images-browser/ extensions/stable-diffusion-webui-images-browser && \
  git clone https://github.com/kohya-ss/sd-webui-additional-networks.git extensions/sd-webui-additional-networks && \
  git clone https://github.com/Bing-su/adetailer.git extensions/adetailer && \
#cd /workspace/stable-diffusion-webui && \
#git clone https://github.com/d8ahazard/sd_dreambooth_extension.git extensions/sd_dreambooth_extension && \
#cd extensions/sd_dreambooth_extension && \
#git checkout dev && \
#  git reset ${DREAMBOOTH_VERSION} --hard && \
#  mv /requirements_dreambooth.txt ./requirements.txt && pip install -r requirements.txt && \
cd /workspace/stable-diffusion-webui/ && \
mv /workspace/cache-sd-model.py /workspace/stable-diffusion-webui/ && \
python cache-sd-model.py --use-cpu=all --ckpt /sd-models/AnythingV5_v5PrtRE.safetensors && \
pip cache purge && \
apt clean && \
mv /workspace/venv /venv && \
mv /workspace/stable-diffusion-webui /stable-diffusion-webui

COPY pre_start.sh /pre_start.sh
COPY relauncher.py webui-user.sh /stable-diffusion-webui/
COPY start.sh /start.sh
RUN chmod a+x /start.sh && chmod a+x /pre_start.sh

SHELL ["/bin/bash", "--login", "-c"]
CMD [ "/start.sh" ]
