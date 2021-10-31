
clc;clf;clear all

% load('G:\ocamar\最终比较\10月立项前测试\10_20_function_t_and_f_陈躺(_聚氨酯+网格光纤)杨躺杨侧.mat')
% datat=data(520:11543);
%datat=data(12920:21016);



% load('G:\ocamar\前期测试\9_11_heart_rate8—聚氨酯—林(1).mat')
% temp=118*512;
% data_iteration=data(temp-511:temp);



load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧60-20.mat')


temp=1*1;
data_iteration=data(temp:temp+2047);


n=1;
[c,l] = wavedec(data_iteration,n,'db5');
[cd1]=detcoef(c,l,1);
a=max(cd1);
thr=a(1);
cx = wthcoef('t',c,l,1:n,thr,'s');
lx = l;
x = waverec(cx,lx,'db5');

processed_data=data_iteration-x;
plot(cd1)

%%
clc;clear all

% load('G:\ocamar\最终比较\10月立项前测试\10_20_function_t_and_f_陈躺(_聚氨酯+网格光纤)杨躺杨侧.mat')
% datat=data(520:11543);
%datat=data(12920:21016);



% load('G:\ocamar\前期测试\9_11_heart_rate8—聚氨酯—林(1).mat')
%temp=130*512;
%temp=118*512;
% 
% data1=data(temp:temp+2047);

%data_iteration=data(temp-1023:temp);
%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧25-20.mat')
%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧27-20.mat')
%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧30-20.mat')    %a_all为17最大 a_middle为8最大  a_low为3最大
%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧白海绵30-20(3).mat')

%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧40-20.mat')    %a_all为14最大 a_middle为9最大  a_low无最大
%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧45-20.mat')   %a_all为27最大 a_middle为27最大  a_low无最大
%下面开始a_all都大于20
%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧50-20.mat')
%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧55-20.mat')
%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧60-20.mat')
%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧80-20.mat')
%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧100-20.mat')
%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧120-20.mat')
%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧180-20.mat')
%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧230-20.mat')
%load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧250-20.mat')
%load('G:\ocamar\BCG模拟器数据\加卡座\2.5-40-200弹簧+卡座30-20.mat')
%load('G:\ocamar\BCG模拟器数据\无note power\2.5-40-200弹簧30-20.mat')

%load('G:\ocamar\成品采集数据\陈 数据采集2.mat')

%load('G:\ocamar\研发采集数据12-15起\1-26新数据\composite_t_and_f_2s5s10s_陈正躺_侧.mat')
%load('G:\ocamar\研发采集数据12-15起\1-26新数据\composite_t_and_f_2s5s10s_陈跑.mat')
%load('G:\ocamar\研发采集数据12-15起\1-26新数据\composite_t_and_f_2s5s10s_陈正躺.mat')
%load('G:\ocamar\研发采集数据12-15起\1-26新数据\马辉(1).mat')
%load('G:\ocamar\研发采集数据12-15起\1-26新数据\王校长(1).mat')
%load('G:\ocamar\研发采集数据12-15起\1-26新数据\赵南南(1).mat')
% data=data(6688:end);


%load('G:\ocamar\成品采集数据\陈 数据采集7-21.mat')
load('G:\ocamar\成品采集数据\陈 数据采集7-22(1).mat')


for f=1:length(data)/512
% for f=26:26
clf;
% disp(f);
temp=f*512;
data1=data(temp:temp+2047);

%{
figure(1)
%环境设置2
F=100;          %采样率
N=2048;         %采样点数
n =0:N-1;       %采样序列
f=n*F/N;        %真实的频率

%得到fft数据
y=fft(data1,N);
Mag=abs(y)*2/N;

stem(f(1:end),Mag(1:end));
axis([0 23 0 0.002]);
xticks(0:100);
title('幅频响应');xlabel('频率/Hz');ylabel('幅度');
hold on
%}


figure(1);
set(gcf,'Position',[100,200,500,500]);
plot(data1)

figure(2);
set(gcf,'Position',[700,200,500,500]);




threshold=0.04; %判断阈值%0.2的话还是有些小峰的，所以改到0.1，根据效果，更好是0.04或0.02
 data2=data1;
%3个元素的窗口
for i=2:(length(data2)-1)%第二个到最后倒数第二个
    a=abs(data2(i)-data2(i-1));
    b=abs(data2(i)-data2(i+1));
     if((a>=threshold)&&(b>=threshold))
         data2(i)=mean(data2(i-1)+data2(i+1))/2;
     end
end
%data2是异常点去除的新数据
flag_process=0;
%     for i=1:4
%        data_process=data2(i*512-511:i*512);
       average_data = mean(data2);%该组数的平均值
       max_differencee = max(data2)-min(data2);%该组数的最大差值
       if(average_data>=1.5)
            flag_process=1;
       elseif(max_differencee>=0.6)
            flag_process=2;
       end
%     end

    if flag_process==1
        disp('离床');continue;
    elseif flag_process==2
        disp('体动');continue;
    end
%[ ~,possible_interval_flag,F_interval_continuity_HR ,~,~,comparing_times,freq_HR_array] = AM_FREQ_1024( data2,'coif5',0); %a(6)置0
[ processed_data1,black_and_red_array1,black_and_red_array1_low] = AM_TIME_2048_3(data2,1,'coif5');%a(6)置1
[ processed_data2,black_and_red_array2,black_and_red_array2_low] = AM_TIME_2048_3(data2,0,'coif5');%a(6)置0
%[ black_and_red_array3,black_and_red_array3_low] = AM_TIME_2048_3_2(data2,'coif5');
black_and_red_array3=[];
black_and_red_array3_low=[];

%[ ~,possible_interval_flag2,F_interval_continuity_HR2 ,~,~,comparing_times2,freq_HR_array2] = AM_FREQ_1024( data2,'sym5',0); %a(6)置0
[ processed_data3,black_and_red_array4,black_and_red_array4_low] = AM_TIME_2048_3(data2,1,'sym5');%a(6)置1
[ processed_data4,black_and_red_array5,black_and_red_array5_low] = AM_TIME_2048_3(data2,0,'sym5');%a(6)置0
%[ black_and_red_array6,black_and_red_array6_low] = AM_TIME_2048_3_2(data2,'sym5');
black_and_red_array6=[];
black_and_red_array6_low=[];

%[ ~,possible_interval_flag3,F_interval_continuity_HR3 ,~,~,comparing_times3,freq_HR_array3] = AM_FREQ_1024( data2,'sym5',0); %a(6)置0
[ processed_data5,black_and_red_array7,black_and_red_array7_low] = AM_TIME_2048_3(data2,1,'db5');%a(6)置1
[ processed_data6,black_and_red_array8,black_and_red_array8_low] = AM_TIME_2048_3(data2,0,'db5');%a(6)置0
%[ black_and_red_array9,black_and_red_array9_low] = AM_TIME_2048_3_2(data2,'db5');
black_and_red_array9=[];
black_and_red_array9_low=[];

large_array=[];
large_array=[black_and_red_array1,black_and_red_array2,black_and_red_array3,black_and_red_array4,black_and_red_array5,black_and_red_array6,black_and_red_array7,black_and_red_array8,black_and_red_array9];

large_array_low=[];
large_array_low=[black_and_red_array1_low,black_and_red_array2_low,black_and_red_array3_low,black_and_red_array4_low,black_and_red_array5_low,black_and_red_array6_low,black_and_red_array7_low,black_and_red_array8_low,black_and_red_array9_low];






range_statistics_30=zeros(1,209);
 for i=1:length(large_array_low)
     for j=22:230
         if(j==large_array_low(i))
             range_statistics_30(j-21)=range_statistics_30(j-21)+1;
         end
     end
 end
 

 range_statistics_30_double=zeros(1,209);%22~230间隔即272~26心率
 for i=1:209
     if i<5
        range_statistics_30_double(i)=sum(range_statistics_30(1:4));
     elseif i>205
        range_statistics_30_double(i)=sum(range_statistics_30(206:209));
     else
         for j=i-4:i+4
           range_statistics_30_double(i)=range_statistics_30_double(i)+range_statistics_30(j);
         end
     end
 end
subplot(2,1,1)
stem(range_statistics_30_double)




%自己写的function hist部分  新  
range_statistics_30_250=zeros(1,209);
 for i=1:length(large_array)
     for j=22:230
         if(j==large_array(i))
             range_statistics_30_250(j-21)=range_statistics_30_250(j-21)+1;
         end
     end
 end
 
 range_statistics_30_250_double=zeros(1,209);%22~230间隔即272~26心率
 for i=1:209
     if i<5
        range_statistics_30_250_double(i)=sum(range_statistics_30_250(1:4));
     elseif i>205
        range_statistics_30_250_double(i)=sum(range_statistics_30_250(206:209));
     else
         for j=i-4:i+4
           range_statistics_30_250_double(i)=range_statistics_30_250_double(i)+range_statistics_30_250(j);
         end
     end
 end
subplot(2,1,2)
stem(range_statistics_30_250_double);hold on

[a_low,b_low]=max(range_statistics_30_double);%a是值，c是坐标  从40心率到30心率这样
[a_all,b_all]=max(range_statistics_30_250_double);
[a_all_detial,b_all_detial]=max(range_statistics_30_250);

plot(b_all,a_all,'*r');


[max1_a,max1_b]=max(range_statistics_30_250_double(30:100));%a是数量， b是坐标
[max2_a,max2_b]=max(range_statistics_30_250_double(50:100));%a是数量， b是坐标
plot(max1_b+29,max1_a,'ok');
plot(max2_b+49,max2_a,'or');
% [ findpeaks_time_domain_max_min ] = findpeaks_6( range_statistics_30_250_double);
% for i=1:length(findpeaks_time_domain_max_min)
%     plot(findpeaks_time_domain_max_min(i),range_statistics_30_250_double(findpeaks_time_domain_max_min(i)),'or');hold on
% end
%findpeaks_time_domain_max_min=diff(range_statistics_30_250_double,1);

% if(a_low<25)&&(a_all<90)
%     value=1;disp('0');

%{
if(a_low>=30)&&(a_all<120)
    heart_value=round(6000/(b_low+22));method=1;
elseif(a_all>100)&&(a_all<=400)
    heart_value=round(6000/(b_all+22));method=2;
elseif(a_all>400)
    heart_value=round(6000/(b_all_detial+22));method=3;
else
    heart_value=0;method=0;
end
%}

%{
if((b_all<50)&&(a_all<200)&&(max2_a>40))%50~100有大于40的存在的话
    value=round(6000/(max2_b+49+22));method=1;
elseif((b_all<50)&&(a_all<200)&&(max1_a>40))%30~100有大于40的存在的话
    value=round(6000/(max1_b+29+22));method=2;
elseif(a_low<30)&&(a_all>40)
    value=round(6000/(b_all+22));method=3;
elseif(a_all>100)&&(a_all<=400)
    value=round(6000/(b_all+22));method=4;
elseif(a_all>400)
    value=round(6000/(b_all_detial+22));method=5;
else
    value=0;
end
%}

if(((b_all<=10)&&(a_all>200))||((b_all>10)&&(b_all<=20)&&(a_all>150))||((b_all>20)&&(b_all<30)&&(a_all>110))||((b_all>=30)&&(b_all<40)&&(a_all>100))||((b_all>=40)&&(b_all<50)&&(a_all>90))||((b_all>=50)&&(b_all<60)&&(a_all>80))||((b_all>=60)&&(b_all<70)&&(a_all>70)))
    value=round(6000/(b_all+22));method=1;
elseif((b_all<50)&&(a_all<200)&&(max2_a>40))%50~100有大于40的存在的话
    value=round(6000/(max2_b+49+22));method=1;
elseif((b_all<50)&&(a_all<200)&&(max1_a>40))%30~100有大于40的存在的话
    value=round(6000/(max1_b+29+22));method=2;
elseif(a_low<30)&&(a_all>40)
    value=round(6000/(b_all+22));method=3;
else
    value=0;method=0;
end

%disp([num2str(f),'    心率 ',num2str(heart_value),'    a_low  ',num2str(a_low),'    a_all  ',num2str(a_all),'       ',num2str(method)])
disp([num2str(f),'    心率 ',num2str(value),'    a_low  ',num2str(a_low),'    a_all  ',num2str(a_all),'       ',num2str(method)])

% figure(3)
% plot(findpeaks_time_domain_max_min)
pause(2);

end


%%
figure(4)
subplot(2,1,1)
plot(range_statistics_30_250_double)

[b,a]=butter(2,2/100,'high');
data_filted=filter(b,a,range_statistics_30_250_double);
subplot(2,1,2)
plot(data_filted)














%%
%关于呼吸的解析
clc;clf;clear all;

load('G:\ocamar\BCG模拟器数据\2.5-40-200弹簧呼吸60-40.mat')
temp=1*2048;
data1=data(temp:temp+2047);


threshold=0.04; %判断阈值%0.2的话还是有些小峰的，所以改到0.1，根据效果，更好是0.04或0.02
data2=data1;
%3个元素的窗口
for i=2:(length(data2)-1)%第二个到最后倒数第二个
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
subplot(4,1,1)
plot(data_iteration);xlabel("original");
subplot(4,1,2)
plot(median_value);xlabel("median filter");

%------------------------------提取基线漂移---------------------------
[b,a]=butter(1,0.25/100,'low');
data_filted=filter(b,a,data_iteration);
% removebase=median_value-data_filted;%去除这一段通过lowfilter的信号，得到去基线漂移的信号

subplot(4,1,3)
plot(data_filted);xlabel("removebase");

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
subplot(4,1,4)
plot(data_compare);xlabel("binaryzation");    
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
