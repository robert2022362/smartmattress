This repo contains the code and data used in my smart mattress project.
The raw data is recorded from an 100Hz fiber-optic sensor connected to a layer of fiber-optics in the mattress. The ground truth is a set of heart and respiration rate pairs recorded on a per minute basis from an electrocardiogram. Timestamps are saved to match the raw data and the ground truth. The raw data isn't normalized because its mean and variance are close to 1.
DNNs, CNNs, and LSTMs were tested. DNNs have the highest accuracy of +-4bpm.
The code uses python 3.8 and tensorflow 2.
