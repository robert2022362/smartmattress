%综合程序，有独立频域，时域+频域
%这部分只是调用频域或时域算法，和做必要的plot，
%


%准备环境
clf;clc;clear all;
load('G:\ocamar\研发采集数据12-15起\analog switch test\通道4_10M_正躺+侧躺_正躺_侧躺2.mat')
datat=data(1584:14766);
%datat=data(15963:23882);
%datat=data(24876:29660);

figure(1)
start=1*512;
data2=datat(start:start+511);



%第一步是使用AM_FREQ_512子函数
%传入的是原始数据，512个point
%传出的是一个标志，代表着是否有合适的结果，以及实际结果

%[间隔可能的标志，频率心率值，原间隔，峰点有效标志，时域值和频域值的比较次数，待比较数组]=AM_FREQ_512(原始数据，小波名称，a(6)置零与否标志)
[ statistics_array_2D_freq,possible_interval_flag,F_interval_continuity_HR ,F_interval_continuity_value,peak_valid_flag,comparing_times,freq_HR_array] = AM_FREQ_512( data2,'coif5',0); %a(6)置0
%[ flag2,heartrate_freq2,max_flag_value_freq2,findpeaks2] = AM_FREQ_512( data2,'sym5',0); %a(6)置0
%[ flag3,heartrate_freq3,max_flag_value_freq3,findpeaks3] = AM_FREQ_512( data2,'db5',0); %a(6)置0

%如果，possible_interval_flag=为0或者1的话，就有必要执行下面的了，并利用下上面为4的间隔——max_flag_value_freq

%第二步是使用AM_TIME_512子函数
%传入的是原始数据，512个point
%传出的是一个标志，代表是否有合适的结果，等级是多大的，以及实际的结果
%这里需要和freq里面的值进行对比

%[标志，时域心率值]
[ interval_successrate_flag,T_interval_continuity_HR] = AM_TIME_512(data2,'coif5');
% [ flag_time2,heartrate_optimal2] = AM_TIME_512(data2,'sym5')
% [ flag_time3,heartrate_optimal3] = AM_TIME_512(data2,'db5')



%第三步
%时域有合适的点的话
if interval_successrate_flag>=1 %如果为1、2、3，只要不为0的话
    T_F_adiff=[];
    for i=1:comparing_times
        T_F_adiff(i)=abs(T_interval_continuity_HR-freq_HR_array(i));
    end
    [a_min_indicate,b_min_indicate]=min(T_F_adiff); %找最小的差值
    
    %通过时域推出的间隔 和 频域推出的峰点心率值
    if a_min_indicate<10
        T_F_success_rate=1;
        T_interval_continuity_HR
    else
        T_F_success_rate=0;
    end
end

T_F_success_rate











