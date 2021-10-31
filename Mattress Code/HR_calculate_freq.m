% function [statistics_array_2D_freq,flag_2D,a_max_flag,max_flag_value] = HR_calculate_freq( Mag )
% %UNTITLED 此处显示有关此函数的摘要
clc;clear all;clf;

%1Hz区间10个点，(实际点12~21)可为1倍、2倍频
freq_1Hz=[11 12 13 14 15 16 17 18 19 20;5.5 6 6.5 7 7.5 8 8.5 9 9.5 10];
%2Hz区间10个点，(实际点22~31)可为1倍、2倍、3倍频
freq_2Hz=[21 22 23 24 25 26 27 28 29 30;10.5 11 11.5 12 12.5 13 13.5 14 14.5 15;7 7.3 7.7 8 8.3 8.7 9 9.3 9.7 10];
%3Hz区间10个点，(实际点32~41)可为2倍、3倍、4倍频
freq_3Hz=[15.5 16 16.5 17 17.5 18 18.5 19 19.5 20;10.3 10.7 11 11.3 11.7 12 12.3 12.7 13 13.3;7.75 8 8.25 8.5 8.75 9 9.25 9.5 9.75 10];
%4Hz区间11个点，(实际点42~52)可为2倍、3倍、4倍、5倍频
freq_4Hz=[20.5 21 21.5 22 22.5 23 23.5 24 24.5 25 25.5;13.7 14 14.3 14.7 15 15.3 15.7 16 16.3 16.7 17;10.25 10.5 10.75 11 11.25 11.5 11.75 12 12.25 12.5 12.75;8.2 8.4 8.6 8.8 9 9.2 9.4 9.6 9.8 10 10.2];
%5Hz区间10个点，(实际点53~62)可为2倍、3倍、4倍、5倍、6倍频
freq_5Hz=[26 26.5 27 27.5 28 28.5 29 29.5 30 30.5;17.3 17.7 18 18.3 18.7 19 19.3 19.7 20 20.3;13 13.25 13.5 13.75 14 14.25 14.5 14.75 15 15.25;10.4 10.6 10.8 11 11.2 11.4 11.6 11.8 12 12.2;8.7 8.8 9.0 9.2 9.3 9.5 9.7 9.8 10 10.2];
%6Hz区间10个点，(实际点63~72)可为3倍、4倍、5倍、6倍频
freq_6Hz=[20.7 21 21.3 21.7 22 22.3 22.7 23 23.3 23.7;15.5 15.8 16 16.3 16.5 16.8 17 17.3 17.5 17.8;12.4 12.6 12.8 13 13.2 13.4 13.6 13.8 14 14.2;10.3 10.5 10.7 10.8 11 11.2 11.3 11.5 11.7 11.8];



load('G:\ocamar\研发采集数据12-15起\analog switch test\通道4_10M_正躺+侧躺_正躺_侧躺2.mat')
datat=data(1584:14766);
%datat=data(15963:23882);
%datat=data(24876:29660);

start=1*512;
data2=datat(start:start+511);

figure(1)


%采集库专用FFT
Fs=100;         %采样率
N=1024;         %采样点数
nt =0:N-1;      %采样序列
f=nt*Fs/N;      %真实的频率




expend_data1=flip(new_data2);
new_data1=[new_data2,expend_data1];     %要全部转置成一维数组
y1=fft(new_data1,N);
Mag=abs(y1)*2/N;



stem(f(1:end),Mag(1:end));
axis([0 23 0 0.002]);
xticks(0:100);
title('幅频响应');xlabel('频率/Hz');ylabel('幅度');
hold on



findpeaks=[];
    p=1;
    for i=22:250
                if(((Mag(i)>Mag(i-1))&&(Mag(i)>Mag(i-2))&&(Mag(i)>Mag(i-3))&&(Mag(i)>Mag(i-4))&&(Mag(i)>Mag(i-5))&&(Mag(i)>Mag(i-6))&&(Mag(i)>Mag(i-7))&&(Mag(i)>Mag(i-8)))&&...
                    ((Mag(i)>Mag(i+1))&&(Mag(i)>Mag(i+2))&&(Mag(i)>Mag(i+3))&&(Mag(i)>Mag(i+4))&&(Mag(i)>Mag(i+5))&&(Mag(i)>Mag(i+6))&&(Mag(i)>Mag(i+7))&&(Mag(i)>Mag(i+8))))
                     findpeaks(1,p)=i;                          %findpeaks用来存放峰值的位置
                     plot(f(i),Mag(i),'ok');hold on             %对找到的峰值画圈圈
                     p=p+1;
                end
    end
    peaks_count=length(findpeaks);%找到的峰值个数，值可以为p-1


%------------------------------取得第一个区间位置---------------------------
firstpeak_region=fix((findpeaks2(1,1)-1)*100/1024);%向零取整(截尾取整)
firstpeak_region_first=findpeaks(1,1);%findpeaks第一个峰点的indicate
%确定可能的除数集合
switch firstpeak_region
    case 1	%1Hz区间10个点，可为1倍、2倍频(实际点12~21)
        div=1:2;
        freq_xHz=[freq_1Hz(1,firstpeak_region_first-11),freq_1Hz(2,firstpeak_region_first-11)];
    case 2  %2Hz区间10个点，(实际点22~31)可为1倍、2倍、3倍频
        div=1:3;
        freq_xHz=[freq_2Hz(1,firstpeak_region_first-21),freq_2Hz(2,firstpeak_region_first-21),freq_2Hz(3,firstpeak_region_first-21)];
    case 3  %3Hz区间10个点，(实际点32~41)可为2倍、3倍、4倍频
        div=2:4;
        freq_xHz=[freq_3Hz(1,firstpeak_region_first-31),freq_3Hz(2,firstpeak_region_first-31),freq_3Hz(3,firstpeak_region_first-31)];
    case 4  %4Hz区间11个点，(实际点42~52)可为2倍、3倍、4倍、5倍频
        div=2:5;
        freq_xHz=[freq_4Hz(1,firstpeak_region_first-41),freq_4Hz(2,firstpeak_region_first-41),freq_4Hz(3,firstpeak_region_first-41),freq_4Hz(4,firstpeak_region_first-41)];
    case 5  %5Hz区间10个点，(实际点53~62)可为2倍、3倍、4倍、5倍、6倍频
        div=2:6;%有五个除数，2-3-4-5-6
        freq_xHz=[freq_5Hz(1,firstpeak_region_first-52),freq_5Hz(2,firstpeak_region_first-52),freq_5Hz(3,firstpeak_region_first-52),freq_5Hz(4,firstpeak_region_first-52),freq_5Hz(5,firstpeak_region_first-52)];
    case 6  %6Hz区间10个点，(实际点63~72)可为3倍、4倍、5倍、6倍频
        div=3:6;
        freq_xHz=[freq_6Hz(1,firstpeak_region_first-62),freq_6Hz(2,firstpeak_region_first-62),freq_6Hz(3,firstpeak_region_first-62),freq_6Hz(4,firstpeak_region_first-62)];
    case 7
        div=3:6;
    case 8
        div=3:6;
    case 9
        div=4:6;     
    case 10
        div=4:6; 
    case 11
        div=4:6;
    case 12
        div=5:6;
end


%-------------------------计算后一个点与前一个点的原始间隔----------------------
original_interval=[];
p=1;
for i=1:(peaks_count-1) %n个峰值的话，只要做n-1次减计算就可以了
    original_interval(1,p)=(findpeaks(1,i+1)-findpeaks(1,i))-1;%这里减1是为了得到峰之间的间隔
    p=p+1;%长度为n-1个
end
original_interval2=original_interval;%复制出来，避免元素被0替换后无法正常使用原数组
freq_count=length(original_interval);
statistics_array_freq=zeros(1,freq_count);%长度是adiff_count
statistics_array_2D_freq=[];
for t_freq=1:freq_count
    for h_freq=1:freq_count  %由于每个数都包含一次自身，所以实际结果要减1，但是单纯找最大数的话是没必要的
        if(original_interval2(1,h_freq)==0)%如果已经被归为0的话，就说明已经被比较过且被取走了
           continue 
        elseif(abs(original_interval2(1,t_freq)-original_interval2(1,h_freq))<5)
            statistics_array_freq(1,t_freq)=statistics_array_freq(1,t_freq)+1;%相近数统计值加1
            statistics_array_2D_freq(t_freq,h_freq)=original_interval2(1,h_freq);
            %这里需要加一个二维数组，长度还是adiff_count,列的元素是相差为10内的数据
            if(t_freq~=h_freq)
                original_interval2(1,h_freq)=0;%标注原数组adiff中已经被统计过(即小于本次10)的值
            end
        else
            %disp('no elements')
        end
    end
end
[row,column]=size(statistics_array_2D_freq);


flag_freq=zeros(row,column);
for i=1:row
    t=1;
    for j=1:column
         if (statistics_array_2D_freq(i,j)>0) %大于0才开始判断
               flag_freq(i,t)=flag_freq(i,t)+1;%连续的所以要加1
         end
         if (j>1)&&(statistics_array_2D_freq(i,j-1)>0)&&(statistics_array_2D_freq(i,j)==0)
             t=t+1;
         end
    end
end

%all(flag_black==0,1);%返回一个行向量，用1表示是否为全零列
flag_freq2=flag_freq;
flag_freq2(:,all(flag_freq2==0,1))=[];%删除全零列


%----------心率处理1-----对flag_black2进行处理--------------
max_flag_freq2=[];
for i=1:row
   max_flag_freq2(i)=max(flag_freq2(i,:)); %得到每行自己的最大值，比如2，2这种连续又分段的情况下
end
%比较每行的最大值，得到最大值，
for i=1:length(max_flag_freq2)
    [a_max_flag_freq,b_max_flag_freq]=max(max_flag_freq2);
end
%然后是通过索引找到对应的间隔行
max_flag_value_freq=statistics_array_2D_freq_num_average(b_max_flag_freq);


% end

