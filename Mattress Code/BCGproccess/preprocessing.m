clc;clear all;
load('G:\ocamar\BCG模拟器\BCG模拟器MATLAB数据\data1.mat')
subplot(2,1,1)
plot(data)
ylim([-1.65 1.65])
data2=data;
threshold=0.04; %判断阈值%0.2的话还是有些小峰的，所以改到0.1

%3个元素的窗口
for i=2:(length(data)-1)%第二个到最后倒数第二个
    a=abs(data2(i)-data2(i-1));
    b=abs(data2(i)-data2(i+1));
     if((a>=threshold)&&(b>=threshold))
         data2(i)=mean(data2(i-1)+data2(i+1))/2;
     end
end

subplot(2,1,2)
plot(data2)
ylim([-1.65 1.65])

