import csv
import os
import numpy as np
import random
import matplotlib.pyplot as plt
from scipy import signal
import pandas as pd 

def preprocessing(path):
    ecgpath=path[0]
    mattresspath=path[1]
    fiber_data=[]
    ecg_data=[]
    fiber_dict={}
    ecg_dict={}
    for filename in os.listdir(ecgpath):
        if filename.endswith('.xls'):
            ecgsheet=pd.read_excel(ecgpath+filename,sheet_name='TrendTable',header=1)
            ecgdata=ecgsheet[["TIME","HR","RR"]]
            for index, row in ecgdata.iterrows():
                datetime=row['TIME']
                HR=row['HR']
                RR=row['RR']
                if RR!='---' and int(RR)!=0:
                    datetime=datetime.split(" ")
                    hour=datetime[1].split(":")[0]
                    minute=datetime[1].split(":")[1]
                    date=datetime[0].split("-")
                    time=str(date[0])+str(int(date[1]))+str(int(date[2]))+str(int(hour))+str(int(minute))
                    ecg_dict[time]=[int(HR),int(RR)]
                    
    for filename in os.listdir(mattresspath):
        if filename.startswith("fiber_data"):
            date=filename[11:23].split("-")
            with open(mattresspath+filename) as csv_file:
                csv_reader=csv.reader(csv_file)
                for row_num, row in enumerate(csv_reader):
                    if row_num==0:
                        hour=row
                    elif row_num==1:
                        minute=row
                    elif row_num==3:
                        data=row
                for itr, datum in enumerate(data):
                    time=date[0]+date[1]+date[2]+str(hour[itr])+str(minute[itr])
                    if time not in fiber_dict:
                        fiber_dict[time]=[]
                    if len(fiber_dict[time])<6000:
                        fiber_dict[time].append(float(datum))
    
    print(fiber_dict)
    
    for key, value in ecg_dict.items():
        if key in fiber_dict:
            while len(fiber_dict[key])<6000:
                fiber_dict[key].append(0)
            fiber_data.append(fiber_dict[key])
            ecg_data.append(value)
            
    num_examples=len(fiber_data)
    index=list(range(num_examples))
    random.shuffle(index)
    
    fiber_data_processed=np.array([compute_spectrogram(np.array(fiber_data[i])) for i in index],dtype="double")
    fiber_data=np.array(fiber_data,dtype="double")
    ecg_data=np.array([ecg_data[i] for i in index],dtype="int")
    
#     print(fiber_data.shape)
#     print(ecg_data.shape)
    
#     Split data into training, dev, and test set
    training_split=int(0.8*num_examples)
    dev_split=int(0.9*num_examples)
    
    training_slice=slice(training_split)
    dev_slice=slice(training_split,dev_split)
    test_slice=slice(dev_split,num_examples)
    
    training_set={
        "fiber_data_processed":fiber_data_processed[training_slice],
        "fiber_data_unprocessed":fiber_data[training_slice],
        "ecg_data":ecg_data[training_slice],
    }
    dev_set={
        "fiber_data_processed":fiber_data_processed[dev_slice],
        "fiber_data_unprocessed":fiber_data[dev_slice],
        "ecg_data":ecg_data[dev_slice],
    }
    test_set={
        "fiber_data_processed":fiber_data_processed[test_slice],
        "fiber_data_unprocessed":fiber_data[test_slice],
        "ecg_data":ecg_data[test_slice],
    }
    return training_set, dev_set, test_set

# def preprocessing_v1(path):
#     fiber_data=[]
#     heart_rate_data=[]
#     respiration_rate_data=[]
#     for filename in os.listdir(path):
#         if filename.startswith("fiber_data"):
#             with open(path+filename) as csv_file:
#                 csv_reader=csv.reader(csv_file)
#                 for row in csv_reader:
#                     col_num=0
#                     for col in row:
#                         col_num=col_num+1;
#                         if col_num%2048==0:
#                             fiber_data.append(np.asarray(row[col_num-2048:col_num-48]).reshape(-1,100))
#         elif filename.startswith("heart_rate_data"):
#             with open(path+filename) as csv_file:
#                 csv_reader=csv.reader(csv_file)
#                 for row_num, row in enumerate(csv_reader):
#                     if row_num==3:
#                         heart_rate_data.append(np.asarray(row).reshape(-1,1))
#         elif filename.startswith("respiration_rate_data"):
#             with open(path+filename) as csv_file:
#                 csv_reader=csv.reader(csv_file)
#                 for row_num, row in enumerate(csv_reader):
#                     if row_num==3:
#                         respiration_rate_data.append(np.asarray(row).reshape(-1,1))
                        
#     # Randomly shuffle data
#     num_examples=len(fiber_data)
#     index=list(range(num_examples))
#     random.shuffle(index)
    
#     fiber_data=np.asarray([fiber_data[i] for i in index],dtype='double')
#     heart_rate_data=[[example for batch in heart_rate_data for example in batch][i] for i in index]
#     respiration_rate_data=[[example for batch in respiration_rate_data for example in batch][i] for i in index]
    
#     heart_rate_data=np.asarray(heart_rate_data,dtype='int')
#     respiration_rate_data=np.asarray(respiration_rate_data,dtype='int')
#     heart_rate_data=heart_rate_data.reshape(num_examples,1)
#     respiration_rate_data=respiration_rate_data.reshape(num_examples,1)
    
#     # Split data into training, dev, and test set
#     training_split=int(0.9*num_examples)
#     dev_split=int(0.95*num_examples)
    
#     training_slice=slice(training_split)
#     dev_slice=slice(training_split,dev_split)
#     test_slice=slice(dev_split,num_examples)
    
#     fiber_data=np.asarray(compute_spectrogram(fiber_data),dtype='double')
    
#     training_set={
#         "fiber_data":fiber_data[training_slice],
#         "heart_rate_data":heart_rate_data[training_slice],
#         "respiration_rate_data":respiration_rate_data[training_slice]
#     }
#     dev_set={
#         "fiber_data":fiber_data[dev_slice],
#         "heart_rate_data":heart_rate_data[dev_slice],
#         "respiration_rate_data":respiration_rate_data[dev_slice]
#     }
#     test_set={
#         "fiber_data":fiber_data[test_slice],
#         "heart_rate_data":heart_rate_data[test_slice],
#         "respiration_rate_data":respiration_rate_data[test_slice]
#     }
#     return training_set, dev_set, test_set

def compute_spectrogram(fiber_data):
    nperseg = 6000
    fs = 100 # Sampling frequency
    freqs, times, spec = signal.spectrogram(fiber_data, nperseg=nperseg, fs=fs)
#     plt.plot(freqs,spec)
#     print(freqs.shape)
#     print(spec.shape)
    return spec.reshape(-1)

if __name__ == "__main__":
    path=["/Users/RobertYangSun/Desktop/Dr. Mani Research/ExportData/","/Users/RobertYangSun/Desktop/Dr. Mani Research/Data/"]
    data=preprocessing(path)
#     print(data)