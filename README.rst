################################
pl-tensorflowapp-sample
################################


Abstract
********

| Sample Tensorflow application plugin for ChRIS Project.
| The application is a digit-identification application based on MNIST data.
| The intent is to make it easy for future users to take this sample and use it as the starting point to build your own plugin.

Build
*****

.. note::
  Make sure you have 's2i' installed where you are building.

On a Fedora system the command would be:

.. code-block:: bash

  sudo dnf install s2i

***Build the base container:***

From the root directory of the git repository, run the following command to build the container:

.. code-block:: bash

    make build

The default image built will be named:

``pl-tensorflowapp-sample-centos-python3``

This default container image is a CentOS image that includes Python3


.. note::
  See 'Makefile' if you'd like to use a different IMAGE_NAME



***S2I Build & Training***

Run the s2i command below to train the model and build the sample application plugin

``s2i build <source-location> <builder-image-name> <output-image-name>``

Example Command:

.. code-block:: bash

  s2i build . pl-tensorflowapp-sample-centos-python3 tensorflowapp-sample-centos

If you'd like see additional information when building, append the --loglevel

.. code-block:: bash

  s2i build . pl-tensorflowapp-sample-centos-python3 tensorflowapp-sample-centos --loglevel 5


Run
***

Make sure you have all the pre-requisites installed
Need to use the '--user' option to install ChrisApp
.. code-block:: bash

pip3 install -r requirements.txt --default-timeout=100 --user

.. code-block:: bash

usage: tensorflowapp.py [-h] [--json] [--savejson DIR] [--inputmeta INPUTMETA]
                        [--saveinputmeta] [--saveoutputmeta] [--prefix PREFIX]
                        [--inference_path imagedir] inputdir outputdir

Runs the tensorflow application.

positional arguments:
  inputdir              directory containing the input files
  outputdir             directory containing the output files/folders
  inference_path        directory containing the test digit images

optional arguments:
  -h, --help            show this help message and exit
  --json                show json representation of app and exit
  --savejson DIR        save json representation file to DIR and exit
  --inputmeta INPUTMETA
                        meta data file containing the arguments passed to this
                        app
  --saveinputmeta       save arguments to a JSON file
  --saveoutputmeta      save output meta data to a JSON file
  --prefix PREFIX       prefix for file names


Build the container
===================

.. code-block:: bash

    docker build --rm -t billrainford/pl-tensorflowapp .



Using ``docker run``
====================

Start Docker Service

.. code-block:: bash

    sudo systemctl start docker


Start Docker daemon at boot (Optional)

.. code-block:: bash

    sudo systemctl enable docker


Make sure your user is in the docker group if you want to run the docker command as a non-root user

.. code-block:: bash

    sudo groupadd docker && sudo gpasswd -a ${USER} docker && sudo systemctl restart docker
    newgrp docker


Assign an "input" directory to ``/incoming`` and an output directory to ``/outgoing``.
The input is prepopulated with mnist data.

.. code-block:: bash

    mkdir -p input && mkdir -p output


**To train the mnist model**.
Below command will train a mnist model and output the accuracy to a file in ``$(pwd)/output`` folder.

.. code-block:: bash

    docker run --rm -v $(pwd)/input:/incoming -v $(pwd)/output:/outgoing   \
            billrainford/pl-tensorflowapp tensorflowapp.py            \
            --prefix mnist-                                     \
            /incoming /outgoing


**Note: If you are running with SELinux enabled** make sure to tell docker to label the volume with the correct SELinux context prior to performing the 'bind mount' the levels are updated to allow the container process to access the volume
This is done by appending the ':Z' to your '-v' 'volume bind mount' entries

.. code-block:: bash

    docker run --rm -v $(pwd)/input:/incoming:Z -v $(pwd)/output:/outgoing:Z \
            billrainford/pl-tensorflowapp tensorflowapp.py \
            --prefix mnist- \
            /incoming /outgoing

**To train the mnist model & also run inference**.
Below command will train a mnist model also run inference on the test image against the mnist model.

.. code-block:: bash

    docker run --rm -v $(pwd)/input:/incoming -v $(pwd)/output:/outgoing   \
            billrainford/pl-tensorflowapp tensorflowapp.py            \
            --prefix mnist-                                     \
            --inference_path /incoming/test/test.png            \
            /incoming /outgoing

**Note:** If you are running with SELinux enabled make sure to see the note above on appending ':Z' to your 'volume bind mount' entries

.. code-block:: bash

    docker run --rm -v $(pwd)/input:/incoming:Z -v $(pwd)/output:/outgoing:Z \
            billrainford/pl-tensorflowapp tensorflowapp.py \
            --prefix mnist- \
            --inference_path /incoming/test/test.png \
            /incoming /outgoing

**Note:** Make sure that the host ``$(pwd)/output`` directory is world writable!
