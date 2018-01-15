# Guide on setting up a CASA Jupyter Notebook server

Here I describe steps required to set up your very own jupyter-casa notebook on your server that can be used as a teaching tool for Radio Astronomy. The casa-jupyter server is built using the [jupyter-casa docker image](https://github.com/aardk/jupyter-casa) by Aard Keimpema from the Joint Institute of VLBI ERIC (JIVE), and wrapped within the [tmpnb "temporary" Jupyter notebook server.](https://github.com/jupyter/tmpnb) 


This project and tutorial is based upon the [original version  by  Tammo Jan Dijkema from ASTRON](http://taql.astron.nl/user/KvWQzf7HKYVW/notebooks/vla-cont-tutorial.ipynb).

## The eMERLIN casa-jupyter noteook:

http://jupyter.jb.man.ac.uk:8000

## Step 1: Build the casa-jupyter notebook

1. install Docker (latest version!)
2. start Docker in the background: sudo systemctl start docker
3. download the casa-jupyter docker image: docker pull penngwyn/jupytercasa
4. Run the docker container: 
   1. docker run --rm -p 8888:8888 -i -t -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -v PATH_TO_DATA_DIR:/home/jupyter/data penngwyn/jupytercasa /bin/sh -c "jupyter notebook"
   2. Note: replace PATH_TO_DATA_DIR with the path to the data
5. Open a new casa notebook and build the casa jupyter notebook
6. Save the notebook somewhere on your computer using File > Download as > Notebook (.ipynb)


## Step 1 (Optional): Download the notebook and data provided in this github

1. Download the contents of this repository. (untar the Answers.tar file)
2. Download the raw dataset and calibrator: 
   1. (The Measurement Set) wget -c http://almanas.jb.man.ac.uk/hayden/jupyter-casa/all_avg.ms.tar
   2. (Flux calibrator) wget -c http://almanas.jb.man.ac.uk/hayden/jupyter-casa/3C286_C.clean.model.tt0.tgz
   3. (Flag file) wget -c http://almanas.jb.man.ac.uk/hayden/jupyter-casa/all_avg_1.flags
3. Place all in the same folder and proceed to Step 2

## Step 2: Create the Docker container and run using tmpnb 

1. Downlad the tmpnb docker image: docker pull jupyter/minimal-notebook
2. Create a folder and place all the files you will need for your notebook e.g. the .ipynb notebbok, data, flag tabels etc
3. Create a text file called Dockerfile. Everytime a user runs a notebook, they will be given their own "virtual-machine" with 
the data, notebook and casa. This file generates a docker container with the instructions to copy the data and notebook into the "virtual-machine"
An example file is given in this repository. If you are using your own data, replace the COPY and RUN commands as needed.
4. Compile the Docker container: sudo docker build -t myjupytercasa 
5. Start the server:
   1. export TOKEN=$( head -c 30 /dev/urandom | xxd -p )
   2. sudo docker run --restart=always --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN --name=proxycasa jupyter/configurable-http-proxy --default-target http://127.0.0.1:9999 --port 80
   3. sudo docker run --restart=always --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN --name=tmpnbcasa -v /var/run/docker.sock:/docker.sock jupyter/tmpnb python orchestrate.py --image=myjupytercasa --port=9999 --admin-port=10000 --pool-size=5 --redirect-uri=/notebooks/eMERLIN_Basic_Calibration_Tutorial.ipynb --command="Xvfb :102 -ac & jupyter notebook --no-browser --port {port} --ip=0.0.0.0 --NotebookApp.base_url=/{base_path} --NotebookApp.port_retries=0"
6. Confirm the container is running via sudo docker ps. You may need to wait about 20-30 seconds
7. Point your browser to 127.0.0.1:8000

Note: Steps 4 and 5 can be executed using the bash script runfile.sh provided in this repository 

## To get the notebook viewed online:

open the port 8000 and view using: your-ip-address:8000

## Notes:

1. At the moment it uses CASA 4.7.0
2. CLEANing can only be done non-interatively
3. Visiting the website, each usr is presented with their own virtual-machine running the jupyter-casa notebook, with
copies of the data and the notebook.
4. A user cannot use their own MS dataset in the notebook. 
5. They can however, interact with the notebook, and save the notebook external to their own computer.
6. However, once the notebook is closed, all changes made by the user is deleted.
