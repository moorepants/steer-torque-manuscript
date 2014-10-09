Introduction
============

These are the instructions for reproducing the figures in the paper from raw
data.

Get the source
==============

Change into a working directory (``/path/to`` should be customized to your
environment)::

   $ cd /path/to

Clone the source code with Git::

   $ git clone https://github.com/moorepants/steer-torque-manuscript.git

or download a zip file::

   $ https://github.com/moorepants/steer-torque-manuscript/archive/master.zip
   $ unzip steer-torque-manuscript-master.zip
   $ mv steer-torque-manuscript-master steer-torque-manuscript

Get the data
============

Create a directory to contain all of the data::

   $ mkdir /path/to/instrumented-bicycle-data

The raw trial data can downloaded as so::

   $ wget -O raw-trial-data.zip http://downloads.figshare.com/article/public/1164632
   $ unzip -d raw-trial-data raw-trial-data.zip
   $ rm raw-trial-data.zip

The raw calibration files::

   $ wget -O raw-calibration-data.zip http://downloads.figshare.com/article/public/1164630
   $ unzip -d raw-calibration-data raw-calibration-data.zip
   $ rm raw-calibration-data.zip

The additional corrupt trial file::

   $ wget -O data-corruption.csv http://files.figshare.com/1696860/data_corruption.csv

The bicycle parameter data::

   $ wget http://files.figshare.com/1710525/bicycle_parameters.tar.gz
   $ tar -zxvf bicycle_parameters.tar.gz
   $ rm bicycle_parameters.tar.gz

Put the torque wrench experiment data in the ``data`` directory::

   $ cd /path/to/steer-torque-manuscript/data
   $ wget -O troque-wrench-data.txt http://files.figshare.com/1672045/data.txt

Now change into ``src``::

   $ cd /path/to/steer-torque-manuscript/src

Edit the ``bdp-defaults.cfg`` file to point to the data directories you created::

   [data]
   pathToDatabase = /path/to/steer-torque-manuscript/data/instrumented-bicycle-data.h5
   pathToCorruption  = /path/to/instrumented-bicycle-data/data-corruption.csv
   pathToRunMat = /path/to/instrumented-bicycle-data/raw-trial-data
   pathToCalibMat = /path/to/instrumented-bicycle-data/raw-calibration-data
   pathToParameters = /path/to/instrumented-bicycle-data/bicycle-parameters

Setup an environment
====================

Now create a conda environment with the needed dependencies::

   $ conda create -n steer-torque-paper numpy scipy matplotlib sympy pandas pyyaml "pytables<3.0"
   $ source activate steer-torque-paper

These need to be installed with pip::

   (steer-torque-paper)$ pip install uncertainties "dynamicisttoolkit>=0.3.5"
   (steer-torque-paper)$ pip install "yeadon>=1.1.1" "BicycleParameters>=0.2.0"
   (steer-torque-paper)$ pip install git+https://github.com/moorepants/BicycleDataProcessor.git

TODO : Create a release of the BicycleDataProcessor and change this install
directive.

Your ``conda list`` for the environment should look somthing like::

Run the scripts
===============

First you must build the database from the all the data you downloaded. This
will take a few minutes, but once it is built you can keep it around for future
computations with ``BicycleDataProcessor``::

   (steer-torque-paper)$ python build_data_base.py

The following script derives the compensation equation for steer torque and
displays the result::

   (steer-torque-paper)$ python steer_torque_equations.py

To generate the the example plot of the steer torque components in trial 700
run::

   (steer-torque-paper)$ python steer_torque_components.py

To generate the statistics from all of the valid trials, execute the following
(this will take a while on the first pass, but will be much faster on
subsequent runs.)::

   (steer-torque-paper)$ python steer_torque_statistics.py

There is one R script that should run on about any version of R with ggplot2
installed.

::

   (steer-torque-paper)$ R torque-wrench.R

You will find all of the results in the ``data`` and ``figures`` directory.
