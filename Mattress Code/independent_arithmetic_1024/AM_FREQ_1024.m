function [ statistics_array_2D_freq,flag,F_interval_continuity_HR ,F_interval_continuity_value,peak_valid,comparing_times,freq_value] = AM_FREQ_1024( data ,wavename,a6)
%AM_FREQ_512
%   输入是512个原始数据
%   输出是标志位，以及实际的结果



%=========================================间隔========================================


%环境设置2
F=100;          %采样率
N=2048;         %采样点数
n =0:N-1;       %采样序列
f=n*F/N;        %真实的频率

%先进行小波处理
o=lower(wavename);
[processed_data] = wavelet_process(data,a6,o);%返回得到的是已经去掉基线的BCG，且0的话a(6)是置零，1的话a(6)是置1

%扩展                                                                         
expend_data=flip(processed_data);         %512扩展为1024点
new_data=[processed_data,expend_data];    %要全部转置成一维数组

%得到fft数据
y=fft(new_data,N);
Mag=abs(y)*2/N;

%绘图
% stem(f(1:end),Mag(1:end));
% axis([0 23 0 0.002]);
% xticks(0:100);
% title('幅频响应');xlabel('频率/Hz');ylabel('幅度');
% hold on

findpeaks=[];
p=1;
for i=32:500
    if(((Mag(i)>Mag(i-1))&&(Mag(i)>Mag(i-2))&&(Mag(i)>Mag(i-3))&&(Mag(i)>Mag(i-4))&&(Mag(i)>Mag(i-5))&&(Mag(i)>Mag(i-6))&&(Mag(i)>Mag(i-7))&&(Mag(i)>Mag(i-8))&&(Mag(i)>Mag(i-9))&&(Mag(i)>Mag(i-10))&&(Mag(i)>Mag(i-11))&&(Mag(i)>Mag(i-12))&&(Mag(i)>Mag(i-13))&&(Mag(i)>Mag(i-14))&&(Mag(i)>Mag(i-15))&&(Mag(i)>Mag(i-16)))&&...
        ((Mag(i)>Mag(i+1))&&(Mag(i)>Mag(i+2))&&(Mag(i)>Mag(i+3))&&(Mag(i)>Mag(i+4))&&(Mag(i)>Mag(i+5))&&(Mag(i)>Mag(i+6))&&(Mag(i)>Mag(i+7))&&(Mag(i)>Mag(i+8))&&(Mag(i)>Mag(i+9))&&(Mag(i)>Mag(i+10))&&(Mag(i)>Mag(i+11))&&(Mag(i)>Mag(i+12))&&(Mag(i)>Mag(i+13))&&(Mag(i)>Mag(i+14))&&(Mag(i)>Mag(i+15))&&(Mag(i)>Mag(i+16))))
         findpeaks(1,p)=i;                          %findpeaks用来存放峰值的位置
         %plot(f(i),Mag(i),'ok');hold on             %对找到的峰值画圈圈
         findpeaks_true_Mag(1,p)=Mag(i);
         p=p+1;
    end
end
peaks_count=length(findpeaks);%找到的峰值个数，值可以为p-1



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


%这部分是为了得到平均值
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
F_interval_continuity_value=statistics_array_2D_freq_num_average(b_max_flag_freq);




if a_max_flag_freq>=6       %单独的成功率为90%
    %得到间隔连续性最大的那组数的索引，并取出统计表中那行的数据
    second_process_array=statistics_array_2D_freq(b_max_flag_freq,:);
    %然后对数据重新进行间隔分类
    [freq_interval_result,statistics_array_2D_freq_2 ] = AM_FREQ_1024_2( second_process_array );
    %直接用平均的间隔值计算心率，不再映射到峰点上去
    F_interval_continuity_HR=freq_interval_result*(100/2048)*60;
    flag=1;
elseif a_max_flag_freq>=4   %单独成功率仅为60%
    F_interval_continuity_HR=F_interval_continuity_value*(100/2048)*60;
    flag=2;
else %如果没有连续的四个数，表明没有找到
    F_interval_continuity_HR=0;
    flag=0;
    F_interval_continuity_value=0;
end


%=============================================峰点======================================

%找幅值最大的点，用来时频比较用的
[~,b_peaks_max]=max(findpeaks_true_Mag);%找到幅值最大的峰点，此刻最好小波中的a(6)是置零的，否则肯定会有体动存在
freq_max=(findpeaks(b_peaks_max)-1)*100/2048;
evaluated=freq_max*60;%计算待除数
%------------------------------取得最大幅度点的区间位置---------------------------
firstpeak_region=fix(freq_max);%向零取整(截尾取整)
firstpeak_region_first=findpeaks(b_peaks_max);%findpeaks第一个峰点的indicate
%确定可能的除数集合，这里与以前不同的是，我不需要标准间隔，我只需要可能值
freq_value=[];
peak_valid=0;   %初始化，只有首点为1Hz、2Hz、3Hz、4Hz、5Hz、6Hz才有效
comparing_times=0;
switch firstpeak_region
    case 1	%1Hz区间10个点，可为1倍、2倍频(实际点12~21)
        peak_valid=1;
        comparing_times=2;
        freq_value=[evaluated,evaluated/2];%div=1:2;
    case 2  %2Hz区间10个点，(实际点22~31)可为1倍、2倍、3倍频
        peak_valid=1;
        comparing_times=3;
        freq_value=[evaluated,evaluated/2,evaluated/3];%div=1:3;
    case 3  %3Hz区间10个点，(实际点32~41)可为2倍、3倍、4倍频
        peak_valid=1;
        comparing_times=3;
        freq_value=[evaluated/2,evaluated/3,evaluated/4];% div=2:4;
    case 4  %4Hz区间11个点，(实际点42~52)可为2倍、3倍、4倍、5倍频
        peak_valid=1;
        comparing_times=4;
        freq_value=[evaluated/2,evaluated/3,evaluated/4,evaluated/5];%div=2:5;
    case 5  %5Hz区间10个点，(实际点53~62)可为2倍、3倍、4倍、5倍、6倍频
        peak_valid=1;
        comparing_times=5;
        freq_value=[evaluated/2,evaluated/3,evaluated/4,evaluated/5,evaluated/6];%div=2:6;%有五个除数，2-3-4-5-6
    case 6  %6Hz区间10个点，(实际点63~72)可为3倍、4倍、5倍、6倍频
        peak_valid=1;
        comparing_times=4;
        freq_value=[evaluated/3,evaluated/4,evaluated/5,evaluated/6];%div=3:6;
    case 7
        peak_valid=0;
        div=3:6;
    case 8
        peak_valid=0;
        div=3:6;
    case 9
        peak_valid=0;
        div=4:6;     
    case 10
        peak_valid=0;
        div=4:6; 
    case 11
        peak_valid=0;
        div=4:6;
    case 12
        peak_valid=0;
        div=5:6;
end







end



