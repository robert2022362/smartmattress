function [ breath_value ] = function_breathprocess( data )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明


threshold=0.04; %判断阈值%0.2的话还是有些小峰的，所以改到0.1，根据效果，更好是0.04或0.02
data2=data;
%3个元素的窗口
for i=2:(length(data)-1)%第二个到最后倒数第二个
    a=abs(data2(i)-data2(i-1));
    b=abs(data2(i)-data2(i+1));
     if((a>=threshold)&&(b>=threshold))
         data2(i)=mean(data2(i-1)+data2(i+1))/2;
     end
end
%data2是异常点去除的新数据
data_iteration=data2;

%==========================开始计算数据

%---------------------------中值滤波---------------------------
% figure(1);
median_value=medfilt1(data_iteration,100);%noise suppression,keep useful information,150的时候呼吸峰上就已经没有心率了
% subplot(4,1,1)
% plot(data_iteration);xlabel("original");
% subplot(4,1,2)
% plot(median_value);xlabel("median filter");

%------------------------------提取基线漂移---------------------------
[b,a]=butter(1,0.5/100,'low');
data_filted=filter(b,a,data_iteration);
% removebase=median_value-data_filted;%去除这一段通过lowfilter的信号，得到去基线漂移的信号

% subplot(4,1,3)
% plot(data_filted);xlabel("removebase");

%%------------------------------求平均值并二值化---------------------------
n=length(data_iteration);
data_compare=zeros(1,n);
data_meaned=mean(data_filted(300:end));%求平均值
for i=1:n
    if(data_filted(i)>data_meaned)
        data_compare(i)=1;
    else
        data_compare(i)=0;
    end
end
% subplot(4,1,4)
% plot(data_compare);xlabel("binaryzation");    
% ylim([-2 2])
%---------------------------计算呼吸滤---------------------------
global k;
k=0;%记录上升沿个数
indicate_for_k=[];
t=1;
for j=1:n-1 %这里只是找上升沿，主要是因为下降沿会包含滤波的时延
   if(data_compare(j)==0)&&(data_compare(j+1)==1)
        k=k+1;
        indicate_for_k(t)=j;t=t+1;
   end
end
%最后的k值可能还要减1
%disp(k)
%fprintf('The respiratory rate value is %d per minute.\n',k)
% toc


%==============更加准确的二次处理=======2021年4月27日=========
if(k>=2)
    distance=indicate_for_k(end)-indicate_for_k(1);
    breath_value=60/((distance/(k-1))*0.010);
    %disp(['The breath rate value is ',num2str(breath_value)]);
else
    breath_value=0;
end

%===========================================================



end

