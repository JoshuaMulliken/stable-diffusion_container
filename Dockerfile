FROM continuumio/miniconda3

RUN apt-get update && apt-get upgrade -y
RUN conda update -y conda
RUN conda install -n base -c pytorch \
    pytorch torchvision torchaudio cudatoolkit=11.3
RUN conda install -n base -c conda-forge \
    jupyterlab jupyterlab-git 

RUN echo "source activate base" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH