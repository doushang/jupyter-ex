# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/datascience-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

# ffmpeg for matplotlib anim & dvipng+cm-super for latex labels
RUN apt-get update && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# install font simhei
Run 
    mv simhei.ttf /opt/conda/lib/python3.8/site-packages/matplotlib/mpl-data/fonts/tt && \
    sed -i 's/#font.family/font.family: /g' /opt/conda/lib/python3.8/site-packages/matplotlib/mpl-data/matplotlibrc && \
    sed -i 's/#axes.unicode_minus: True/axes.unicode_minus: False /g' /opt/conda/lib/python3.8/site-packages/matplotlib/mpl-data/matplotlibrc && \
    sed -i "s/#font.sans-serif:/font.sans-serif: /g" /opt/conda/lib/python3.8/site-packages/matplotlib/mpl-data/matplotlibrc && \
    sed -i "/^font.sans-serif: .*$/s//&, SimHei/g" /opt/conda/lib/python3.8/site-packages/matplotlib/mpl-data/matplotlibrc && \
    rm -rf /home/jovyan/.cache/matplotlib/*

# Install Python 3 packages
RUN conda install --quiet --yes \
    'openpyxl=3.0.6' \
    && \
    conda clean --all -f -y && \
    npm cache clean --force && \
    rm -rf "/home/${NB_USER}/.cache/yarn" && \
    rm -rf "/home/${NB_USER}/.node-gyp" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

WORKDIR $HOME