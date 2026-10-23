CSV trajectory data is stored in "Dataset.7z", extract after downloading/cloning the repository.
To run the simulator by script, run "Main_phoenix_simulator_GRR.m" and "Main_phoenix_simulator_OLH.m".
The goal of the script simulator is to debug and visualize. I sustain the latest bug-free version on the script version. After making sure it works, I copy the contents to "Main_phoenix_simulator_probMatrix_preprocess_V2_fcn.m" and "Main_phoenix_simulator_hashing_preprocess_V2_fcn.m".

"Main_phoenix_simulator_probMatrix_preprocess_V2_fcn.m" and "Main_phoenix_simulator_hashing_preprocess_V2_fcn.m" contain the simulator as a function so that it can be called by outside script with purpose of running bulk simulations.

"run_fest_OLH_phoenixV2.m" and "run_fest_GRR_phoenixV2.m" are the scripts for bulk running the simulations.
