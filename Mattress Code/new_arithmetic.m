                                                                                  
clc;clf;clear all


%------------------------------------------------------------------------------
%----------------------------------表1---标准间隔-------------------------------
%------------------------------------------------------------------------------

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

figure(1)
start=1*512;
data2=datat(start:start+511);

a_max_flag=[];
max_flag_value=[];
t=1;




% expend_data=flip(data2);
% o_data=[data2,expend_data];%要全部转置成一维数组

%==========================arithmetic2----coif5、sym5、db5的a(6)置零==========================================
[new_data2] = wavelet_process(data2,0,'coif5');%返回得到的是已经去掉基线的BCG，且此处a(6)是置零
subplot(3,1,1);
plot(new_data2)
hold on
%-----------30间隔--------black------------------
[findpeaks_time_domain_max] = findpeaks(new_data2,1);%找到black峰点
peaks_count_max=length(findpeaks_time_domain_max);%找到的峰值个数
for i=1:peaks_count_max
    subplot(3,1,1);
    plot(findpeaks_time_domain_max(i),new_data2(findpeaks_time_domain_max(i)),'ok');hold on             %对找到的峰值画圈圈
end
%-----------二次处理------black-------------------
%对找到的峰点进行过滤—black
[new_findpeaks_time_domain_max] = second_filtration(new_data2 ,findpeaks_time_domain_max, peaks_count_max);
for i=1:length(new_findpeaks_time_domain_max)
    plot(new_findpeaks_time_domain_max(i),new_data2(new_findpeaks_time_domain_max(i)),'*k');hold on             %对找到的峰值画圈圈
end
[statistics_array_2D,flag_2D,a_max_flag(t,1),max_flag_value(t,1)] = HR_calculate( new_findpeaks_time_domain_max );

%==========================================================================================================
%------------30间隔----------red------------------
[findpeaks_time_domain_min] = findpeaks(new_data2,0);%找到red峰点
peaks_count_min=length(findpeaks_time_domain_min);%找到的峰值个数，值可以为p-1
for i=1:peaks_count_min
    subplot(3,1,1);
    plot(findpeaks_time_domain_min(i),new_data2(findpeaks_time_domain_min(i)),'or');hold on             %对找到的峰值画圈圈
end
%------------二次处理-----------red------------
%对找到的峰点进行过滤—red
[new_findpeaks_time_domain_min] = second_filtration(new_data2 ,findpeaks_time_domain_min, peaks_count_min);
for i=1:length(new_findpeaks_time_domain_min)
    plot(new_findpeaks_time_domain_min(i),new_data2(new_findpeaks_time_domain_min(i)),'*r');hold on             %对找到的峰值画圈圈
end
[statistics_array_2D2,flag_2D2,a_max_flag(t,2),max_flag_value(t,2)] = HR_calculate( new_findpeaks_time_domain_min );
hold off
%=======================================arithmetic2======================================================





figure(2)
%-------------傅里叶变换----------------
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
                     findpeaks_true_Mag(1,p)=Mag(i);
                     plot(f(i),Mag(i),'ok');hold on             %对找到的峰值画圈圈
                     p=p+1;
                end
    end
    peaks_count=length(findpeaks);%找到的峰值个数，值可以为p-1

%找幅值最大的点，用来时频比较用
[a_peaks_max,b_peaks_max]=max(findpeaks_true_Mag);%找到幅值最大的峰点，此刻最好小波中的a(6)是置零的，否则肯定会有体动存在
freq_max=(findpeaks(b_peaks_max)-1)*100/1024;

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


statistics_array_2D_freq_sum=sum(statistics_array_2D_freq,2);%对矩阵行元素求和，中间的0也加起来，后面只除统计数
statistics_array_2D_freq_num=sum(statistics_array_2D_freq~=0,2);%返回列向量，代表矩阵中行非零元素的个数
for i=1:row
    statistics_array_2D_freq_num_average(1,i)=statistics_array_2D_freq_sum(i)/statistics_array_2D_freq_num(i);
end




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
%flag_freq2=flag_freq;

flag_freq(:,all(flag_freq==0,1))=[];%删除全零列


max_flag_freq=[];
for i=1:row
    max_flag_freq(i)=max(flag_freq(i,:)); %得到每行自己的最大值，比如2，2这种连续又分段的情况下
end
%比较每行的最大值，得到最大值，
for i=1:length(max_flag_freq)
    [a_max_flag_freq,b_max_flag_freq]=max(max_flag_freq);
end
%然后是通过索引找到对应的间隔行
max_flag_value_freq=statistics_array_2D_freq_num_average(b_max_flag_freq);










%------------------------------取得第一个区间位置---------------------------
firstpeak_region=fix((findpeaks(1,1)-1)*100/1024);%向零取整(截尾取整)
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




if a_max_flag_freq>6
    %得到间隔连续性最大的那组数的索引，并取出统计表中那行的数据
    second_process_array=statistics_array_2D_freq(b_max_flag_freq,:);
    %然后对数据重新进行间隔分类，和连续性计算
    
    [freq_interval_result,statistics_array_2D_freq_2 ] = AM_FREQ_512_2( second_process_array );
   
elseif a_max_flag_freq>=4   %如果间隔有连续的四个，那就认为频域找到了可以用作验证的间隔
    for i=1:length(div)
        freq_xHz_diff(i)=abs(max_flag_value_freq-freq_xHz(i));%确定是倍频里的哪一个
    end
    [a_min_freq_xHz_diff,b_min_freq_xHz_diff]=min(freq_xHz_diff);%主要是为了确定倍频，而不是倍频对应的间隔
    firstpoint_freq_multi=div(b_min_freq_xHz_diff);%第一个点的倍频
    heartrate_optimal_freq=(((findpeaks(1,1)-1)*100/2048)*60)/firstpoint_freq_multi;
else %如果没有连续的四个数，那就啥都不用做了
    heartrate_optimal_freq=0;
end








%%
%采集库专用FFT
Fs=100;     %采样率
N=1024;     %采样点数
nt =0:N-1;   %采样序列
f=nt*Fs/N;   %真实的频率
figure(2)

%直接扩展 
expend_data2=flip(new_data2);
new_data=[new_data2,expend_data2];%要全部转置成一维数组
%------------单独傅里叶变换----

y=fft(new_data,N);
Mag=abs(y)*2/N;

% stem(f(1:end),Mag(1:end));
plot(f(1:end),Mag(1:end));
axis([0 23 0 0.002]);
xticks(0:100);
title('幅频响应');xlabel('频率/Hz');ylabel('幅度');
hold on








%-------------30点间隔查找------black----------------
original_interval_black=[];
for i=1:(peaks_count_max-1) %n个峰值的话，只要做n-1次减计算就可以了
    original_interval_black(1,i)=(findpeaks_time_domain_max(1,i+1)-findpeaks_time_domain_max(1,i))-1;%这里减1是为了得到峰之间的间隔
end


%-----------------------------原始间隔的连续情况--------------------
original_interval_black2=original_interval_black;
statistics_array_black=zeros(1,peaks_count_max);%长度
statistics_array_2D_black=[];
for t_black=1:peaks_count_max-1
    for h_black=1:peaks_count_max-1  %由于每个数都包含一次自身，所以实际结果要减1，但是单纯找最大数的话是没必要的
        if(original_interval_black2(1,h_black)==0)%如果已经被归为0的话，就说明已经被比较过且被取走了
           continue 
        elseif(abs(original_interval_black2(1,t_black)-original_interval_black2(1,h_black))<10)
            statistics_array_black(1,t_black)=statistics_array_black(1,t_black)+1;%相近数统计值加1
            statistics_array_2D_black(t_black,h_black)=original_interval_black2(1,h_black);
            %这里需要加一个二维数组，长度还是adiff_count,列的元素是相差为10内的数据
            if(t_black~=h_black)
                original_interval_black2(1,h_black)=0;%标注原数组adiff中已经被统计过(即小于本次10)的值
            end
        else
            %disp('no elements')
        end
    end
end
[row_n1,column_n1]=size(statistics_array_2D_black);



statistics_array_2D_black_sum=sum(statistics_array_2D_black,2);%对矩阵行元素求和，中间的0也加起来，后面只除统计数
statistics_array_2D_black_num=sum(statistics_array_2D_black~=0,2);%返回列向量，代表矩阵中行非零元素的个数
for i=1:row_n1
    statistics_array_2D_black_num_average(1,i)=statistics_array_2D_black_sum(i)/statistics_array_2D_black_num(i);
end
%至此就得到了statistics_array_2D_black的每行的平均值，可以直接用该间隔计算心率




flag_black=zeros(row_n1,column_n1);
for i=1:row_n1
    t=1;
    for j=1:column_n1
         if (statistics_array_2D_black(i,j)>0) %大于0才开始判断
               flag_black(i,t)=flag_black(i,t)+1;%连续的所以要加1
         end
         if (j>1)&&(statistics_array_2D_black(i,j-1)>0)&&(statistics_array_2D_black(i,j)==0)
             t=t+1;
         end
    end
end
%all(flag_black==0,1);%返回一个行向量，用1表示是否为全零列
flag_black2=flag_black;
flag_black2(:,all(flag_black2==0,1))=[];%删除全零列

dd=1;
%----------心率处理1-----对flag_black2进行处理--------------
max_flag_black2=[];
for i=1:row_n1
   max_flag_black2(i)=max(flag_black2(i,:)); %得到每行自己的最大值，比如2，2这种连续又分段的情况下
end
%比较每行的最大值，得到最大值，
for i=1:length(max_flag_black2)
    [a_max_flag_black,b_max_flag_black]=max(max_flag_black2);
end
%然后是通过索引找到对应的间隔行
max_flag_value_black=statistics_array_2D_black_num_average(b_max_flag_black);


%----------心率处理2-----对statistics_array_2D_black_num和statistics_array_2D_black_num_average进行处理--------------
%statistics_array_2D_black_num_average并没有连续的意思在里面
%flag_black2是有连续的意思在的
finally_interval_black=0;
finally_interval_black_flag=0;
for i=1:row_n1
    %挑选出是连续两次，或两次以上的60间隔，小于60的可能就没有这样讨论的意义了
    if (statistics_array_2D_black_num_average(i)>=60)
        for j=1:length(flag_black2(i,:))%比较次数
            if flag_black2(i,j)>=2  %像2，2或者2，3这种间隔性的也没有问题，反正平均值都是一样的
                %记录这个满足条件的平均值
                finally_interval_black=statistics_array_2D_black_num_average(i);
                finally_interval_black_flag=1;%说明预处理找到了
            end
        end
    end
end







%////////////////////////////////////////////////////////////////////////////////////////////
%------------------------------------red点的查找-------开始-------------------------------
findpeaks_time_domain_min=[];
p3=1;
for j=31:480%%正常取31，高通后取66
            if(((data_differenced(j)<data_differenced(j-1))&&(data_differenced(j)<data_differenced(j-2))&&(data_differenced(j)<data_differenced(j-3))&&(data_differenced(j)<data_differenced(j-4))&&(data_differenced(j)<data_differenced(j-5))&&(data_differenced(j)<data_differenced(j-6))&&(data_differenced(j)<data_differenced(j-7))&&(data_differenced(j)<data_differenced(j-8))&&(data_differenced(j)<data_differenced(j-9))&&(data_differenced(j)<data_differenced(j-10))&&(data_differenced(j)<data_differenced(j-11))&&(data_differenced(j)<data_differenced(j-12))&&(data_differenced(j)<data_differenced(j-13))&&(data_differenced(j)<data_differenced(j-14))&&(data_differenced(j)<data_differenced(j-15))&&(data_differenced(j)<data_differenced(j-16))&&(data_differenced(j)<data_differenced(j-17))&&(data_differenced(j)<data_differenced(j-18))&&(data_differenced(j)<data_differenced(j-19))&&(data_differenced(j)<data_differenced(j-20))&&(data_differenced(j)<data_differenced(j-21))&&(data_differenced(j)<data_differenced(j-22))&&(data_differenced(j)<data_differenced(j-23))&&(data_differenced(j)<data_differenced(j-24))&&(data_differenced(j)<data_differenced(j-25))&&(data_differenced(j)<data_differenced(j-26))&&(data_differenced(j)<data_differenced(j-27))&&(data_differenced(j)<data_differenced(j-28))&&(data_differenced(j)<data_differenced(j-29))&&(data_differenced(j)<data_differenced(j-30)))&&...
                ((data_differenced(j)<data_differenced(j+1))&&(data_differenced(j)<data_differenced(j+2))&&(data_differenced(j)<data_differenced(j+3))&&(data_differenced(j)<data_differenced(j+4))&&(data_differenced(j)<data_differenced(j+5))&&(data_differenced(j)<data_differenced(j+6))&&(data_differenced(j)<data_differenced(j+7))&&(data_differenced(j)<data_differenced(j+8))&&(data_differenced(j)<data_differenced(j+9))&&(data_differenced(j)<data_differenced(j+10))&&(data_differenced(j)<data_differenced(j+11))&&(data_differenced(j)<data_differenced(j+12))&&(data_differenced(j)<data_differenced(j+13))&&(data_differenced(j)<data_differenced(j+14))&&(data_differenced(j)<data_differenced(j+15))&&(data_differenced(j)<data_differenced(j+16))&&(data_differenced(j)<data_differenced(j+17))&&(data_differenced(j)<data_differenced(j+18))&&(data_differenced(j)<data_differenced(j+19))&&(data_differenced(j)<data_differenced(j+20))&&(data_differenced(j)<data_differenced(j+21))&&(data_differenced(j)<data_differenced(j+22))&&(data_differenced(j)<data_differenced(j+23))&&(data_differenced(j)<data_differenced(j+24))&&(data_differenced(j)<data_differenced(j+25))&&(data_differenced(j)<data_differenced(j+26))&&(data_differenced(j)<data_differenced(j+27))&&(data_differenced(j)<data_differenced(j+28))&&(data_differenced(j)<data_differenced(j+29))&&(data_differenced(j)<data_differenced(j+30))))
                 findpeaks_time_domain_min(1,p3)=j;                  
                 %findpeaks用来存放峰值的位置
                 plot(j,data_differenced(j),'or');hold on             %对找到的峰值画圈圈
                 p3=p3+1;
            end
end
peaks_count_min=length(findpeaks_time_domain_min);%找到的峰值个数，值可以为p-1

%-------------------------计算后一个点与前一个点的原始间隔------black----------------
original_interval_red=[];
for i=1:(peaks_count_min-1) %n个峰值的话，只要做n-1次减计算就可以了
    original_interval_red(1,i)=(findpeaks_time_domain_min(1,i+1)-findpeaks_time_domain_min(1,i))-1;%这里减1是为了得到峰之间的间隔
end

%-----------------------------原始间隔的连续情况--------------------
original_interval_red2=original_interval_red;
statistics_array_red=zeros(1,peaks_count);%长度
statistics_array_2D_red=[];
for t_black=1:peaks_count_min-1
    for h_black=1:peaks_count_min-1  %由于每个数都包含一次自身，所以实际结果要减1，但是单纯找最大数的话是没必要的
        if(original_interval_red2(1,h_black)==0)%如果已经被归为0的话，就说明已经被比较过且被取走了
           continue 
        elseif(abs(original_interval_red2(1,t_black)-original_interval_red2(1,h_black))<10)
            statistics_array_red(1,t_black)=statistics_array_red(1,t_black)+1;%相近数统计值加1
            statistics_array_2D_red(t_black,h_black)=original_interval_red2(1,h_black);
            %这里需要加一个二维数组，长度还是adiff_count,列的元素是相差为10内的数据
            if(t_black~=h_black)
                original_interval_red2(1,h_black)=0;%标注原数组adiff中已经被统计过(即小于本次10)的值
            end
        else
            %disp('no elements')
        end
    end
end
[row_n2,column_n2]=size(statistics_array_2D_red);

statistics_array_2D_red_sum=sum(statistics_array_2D_red,2);%对矩阵行元素求和，中间的0也加起来，后面只除统计数
statistics_array_2D_red_num=sum(statistics_array_2D_red~=0,2);%返回列向量，代表矩阵中行非零元素的个数
for i=1:row_n2
    statistics_array_2D_red_num_average(1,i)=statistics_array_2D_red_sum(i)/statistics_array_2D_red_num(i);
end
%至此就得到了statistics_array_2D_black的每行的平均值，可以直接用该间隔计算心率




flag_red=zeros(row_n2,column_n2);
for i=1:row_n2
    t=1;
    for j=1:column_n2
         if (statistics_array_2D_red(i,j)>0) %大于0才开始判断
               flag_red(i,t)=flag_red(i,t)+1;%连续的所以要加1
         end
         if (j>1)&&(statistics_array_2D_red(i,j-1)>0)&&(statistics_array_2D_red(i,j)==0)
             t=t+1;
         end
    end
end
%all(flag_red==0,1);%返回一个行向量，用1表示是否为全零列
flag_red2=flag_red;
flag_red2(:,all(flag_red2==0,1))=[];%删除全零列
dd=2;
%----------心率处理-----对flag_black2进行处理--------------
max_flag_red2=[];
for i=1:row_n2
   max_flag_red2(i)=max(flag_red2(i,:)); %得到每行自己的最大值，比如2，2这种连续又分段的情况下
end
%比较每行的最大值，得到最大值，
for i=1:length(max_flag_red2)
    [a_max_flag_red,b_max_flag_red]=max(max_flag_red2);
end
%然后是通过索引找到对应的间隔行
max_flag_value_red=statistics_array_2D_red_num_average(b_max_flag_red);


%----------心率处理2-----对statistics_array_2D_red_num和statistics_array_2D_red_num_average进行处理--------------
%statistics_array_2D_black_num_average并没有连续的意思在里面
%flag_black2是有连续的意思在的
finally_interval_red=0;
finally_interval_red_flag=0;
for i=1:row_n2
    %挑选出是连续两次，或两次以上的60间隔，小于60的可能就没有这样讨论的意义了
    if (statistics_array_2D_red_num_average(i)>=60)
        for j=1:length(flag_red2(i,:))%比较次数
            if flag_red2(i,j)>=2  %像2，2或者2，3这种间隔性的也没有问题，反正平均值都是一样的
                %记录这个满足条件的平均值
                finally_interval_red=statistics_array_2D_red_num_average(i);
                finally_interval_red_flag=1;%说明预处理找到了
            end
        end
    end
end



%//////////////////////////////
%flag_black2  ,  a_max_flag_black  ,  b_max_flag_black  ,  max_flag_value_black
%//////////////////////////////
%flag_red2   ,  a_max_flag_red  ,   b_max_flag_red   ,   max_flag_value_red
%第一种情况 单黑点或单红点判断
heartrate_optimal=0;finally_interval=0;optimal_flag=0;%如果输出为0，就说明没有优选
%先进行单点判断
if ((max_flag_value_black<=40)&&(a_max_flag_black>=7))||... %小于50的话，那就是指30的间隔  %应该不会遇到
   ((max_flag_value_black>40)&&(max_flag_value_black<=50)&&(a_max_flag_black>=7))||... %小于50的话，那就是指40的间隔
   ((max_flag_value_black>50)&&(max_flag_value_black<=60)&&(a_max_flag_black>=5))||... %小于60的话，就是指50的间隔
   ((max_flag_value_black>60)&&(max_flag_value_black<70)&&(a_max_flag_black>=4))||... %小于70的话，就是指60的间隔
   ((max_flag_value_black>=70)&&(a_max_flag_black>=3))      %然后，70往上的话，三个就都够了，二个就可能不严谨了

    finally_interval=max_flag_value_black;optimal_flag=1;
%单点判断
elseif ((max_flag_value_red<=40)&&(a_max_flag_red>=7))||... %同上
       ((max_flag_value_red>40)&&(max_flag_value_red<=50)&&(a_max_flag_red>=6))||... %同上
       ((max_flag_value_red>50)&&(max_flag_value_red<=60)&&(a_max_flag_red>=5))||... %同上
       ((max_flag_value_red>60)&&(max_flag_value_red<70)&&(a_max_flag_red>=4))||...  %同上
       ((max_flag_value_red>=70)&&(a_max_flag_red>=3))      %同上

    finally_interval=max_flag_value_red;optimal_flag=2;

%双点判断
elseif (finally_interval_black_flag==1)&&(finally_interval_red_flag==1)%说明黑点红点都有间隔60且2个或以上的
        if abs(finally_interval_black-finally_interval_red)<10 %说明黑点和红点的间隔是一样的
            finally_interval=(finally_interval_black+finally_interval_red)/2;
            optimal_flag=3;
        end
end

finally_interval
heartrate_optimal=60/(finally_interval*0.010)
optimal_flag

flag_black2
flag_red2




