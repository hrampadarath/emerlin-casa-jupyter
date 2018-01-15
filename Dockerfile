FROM penngwyn/jupytercasa

USER root
RUN echo "c.NotebookApp.token = ''" >> /home/jupyter/.jupyter/jupyter_notebook_config.py

ENV DISPLAY :102
# COPY all necesary files 

COPY eMERLIN_Basic_Calibration_Tutorial.ipynb /home/jupyter
COPY all_avg.ms.tar /home/jupyter
COPY 3C286_C.clean.model.tt0.tgz /home/jupyter
COPY all_avg_1.flags /home/jupyter
COPY Answer* /home/jupyter/
RUN chmod a+w *

USER jupyter
RUN tar xf all_avg.ms.tar
RUN tar xzf 3C286_C.clean.model.tt0.tgz
