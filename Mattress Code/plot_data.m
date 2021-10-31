close all;
clear all;
delete(instrfindall);

path = "/Users/RobertYangSun/Desktop/Dr. Mani Research/Old Data/";
filename = path+"fiber_data_2021-7-23-3.csv";
data = table2array(readtable(filename,'FileType','text'));
plot(data);