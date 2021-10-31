function [ flag,heartrate_value ] = function_synthesize_arithmetic( data2 )

%频域心率值，和固定的峰点被除数
[ statistics_array_2D_freq,possible_interval_flag,F_interval_continuity_HR ,F_interval_continuity_value,peak_valid_flag,comparing_times,freq_HR_array] = AM_FREQ_512( data2,'coif5',0); %a(6)置0
%[ interval_successrate_flag,T_interval_continuity_HR] = AM_TIME_512(data2,'coif5');
[ interval_successrate_flag_cd1,T_interval_continuity_HR_cd1] = AM_TIME_512_2(data2,'coif5');

[ ~,possible_interval_flag2,F_interval_continuity_HR2 ,~,~,comparing_times2,freq_HR_array2] = AM_FREQ_512( data2,'sym5',0); %a(6)置0
%[ interval_successrate_flag2,T_interval_continuity_HR2] = AM_TIME_512(data2,'sym5');
[ interval_successrate_flag_cd1_2,T_interval_continuity_HR_cd1_2] = AM_TIME_512_2(data2,'sym5');

[ ~,possible_interval_flag3,F_interval_continuity_HR3 ,~,~,comparing_times3,freq_HR_array3] = AM_FREQ_512( data2,'sym5',0); %a(6)置0
%[ interval_successrate_flag3,T_interval_continuity_HR3] = AM_TIME_512(data2,'db5');
[ interval_successrate_flag_cd1_3,T_interval_continuity_HR_cd1_3] = AM_TIME_512_2(data2,'db5');

flag=0;
heartrate_value=0;
T_F_adiff=[];

if possible_interval_flag==1    %优选一，独立频域的值
    for i=1:comparing_times
        T_F_adiff(i)=abs(F_interval_continuity_HR-freq_HR_array(i));
    end
    [a_min_indicate,~]=min(T_F_adiff); %找最小的差值
    if a_min_indicate<10
        flag=1;
        heartrate_value=F_interval_continuity_HR;
    end
elseif possible_interval_flag2==1
    for i=1:comparing_times
        T_F_adiff(i)=abs(F_interval_continuity_HR-freq_HR_array(i));
    end
    [a_min_indicate,~]=min(T_F_adiff); %找最小的差值
    if a_min_indicate<10
        flag=1;
        heartrate_value=F_interval_continuity_HR2;
    end
elseif possible_interval_flag3==1
    for i=1:comparing_times
        T_F_adiff(i)=abs(F_interval_continuity_HR-freq_HR_array(i));
    end
    [a_min_indicate,~]=min(T_F_adiff); %找最小的差值
    if a_min_indicate<10
        flag=1;
        heartrate_value=F_interval_continuity_HR3;
    end
    
    
    
elseif interval_successrate_flag>=1     %优选二，时域推送的间隔和频域除数比较
    %如果为1、2、3，只要不为0的话
    for i=1:comparing_times
        T_F_adiff(i)=abs(T_interval_continuity_HR-freq_HR_array(i));
    end
    [a_min_indicate,~]=min(T_F_adiff); %找最小的差值
    %时域和频域差值比较小的话
    if a_min_indicate<10
        flag=2;
        heartrate_value=T_interval_continuity_HR;
    end
elseif interval_successrate_flag2>=1
    for i=1:comparing_times2
        T_F_adiff(i)=abs(T_interval_continuity_HR2-freq_HR_array2(i));
    end
    [a_min_indicate,~]=min(T_F_adiff); %找最小的差值
    if a_min_indicate<10
        flag=2;
        heartrate_value=T_interval_continuity_HR2;
    end
elseif interval_successrate_flag3>=1
    for i=1:comparing_times3
        T_F_adiff(i)=abs(T_interval_continuity_HR3-freq_HR_array3(i));
    end
    [a_min_indicate,~]=min(T_F_adiff); %找最小的差值
    if a_min_indicate<10
        flag=2;
        heartrate_value=T_interval_continuity_HR3;
    end
    
    
    
    
    
    
elseif interval_successrate_flag_cd1>=1
    for i=1:comparing_times3
        T_F_adiff(i)=abs(T_interval_continuity_HR_cd1-freq_HR_array3(i));
    end
    [a_min_indicate,~]=min(T_F_adiff); %找最小的差值
    if a_min_indicate<10
        flag=3;
        heartrate_value=T_interval_continuity_HR_cd1;
    end
elseif interval_successrate_flag_cd1_2>=1
    for i=1:comparing_times3
        T_F_adiff(i)=abs(T_interval_continuity_HR_cd1_2-freq_HR_array3(i));
    end
    [a_min_indicate,~]=min(T_F_adiff); %找最小的差值
    if a_min_indicate<10
        flag=3;
        heartrate_value=T_interval_continuity_HR_cd1_2;
    end
elseif interval_successrate_flag_cd1_3>=1
    for i=1:comparing_times3
        T_F_adiff(i)=abs(T_interval_continuity_HR_cd1_3-freq_HR_array3(i));
    end
    [a_min_indicate,~]=min(T_F_adiff); %找最小的差值
    if a_min_indicate<10
        flag=3;
        heartrate_value=T_interval_continuity_HR_cd1_3;
    end
    
    
    
    
    
else
    flag=0;
    heartrate_value=0;
end



end

