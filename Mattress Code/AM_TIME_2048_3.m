function [processed_data,black_and_red,black_and_red_low] = AM_TIME_2048_3(data,a,wavename)
%输入是原始数据

    %coif5、sym5、db5的a(6)置零
    [processed_data] = wavelet_process(data,a,lower(wavename));%返回得到的是已经去掉基线的BCG，a(6)为1是置保留，为0是置零
    
    %-----------30间隔--------black------------------
    [findpeaks_time_domain_max] = findpeaks_1536_2048(processed_data,1,2025);%找到black峰点  2017改2025
    peaks_count_max=length(findpeaks_time_domain_max);%找到的峰值个数
    %-----------二次处理------black-------------------
    %对找到的峰点进行过滤—black
    [new_findpeaks_time_domain_max] = second_filtration(processed_data ,findpeaks_time_domain_max, peaks_count_max);
    [original_interval_black] = HR_calculate3( new_findpeaks_time_domain_max );
    %==========================================================================================================
    %------------30间隔----------red------------------
    [findpeaks_time_domain_min] = findpeaks_1536_2048(processed_data,0,2025);%找到red峰点  2017改2025
    peaks_count_min=length(findpeaks_time_domain_min);%找到的峰值个数，值可以为p-1
    %------------二次处理-----------red------------
    %对找到的峰点进行过滤—red
    [new_findpeaks_time_domain_min] = second_filtration(processed_data ,findpeaks_time_domain_min, peaks_count_min);
    [original_interval_red] = HR_calculate3( new_findpeaks_time_domain_min );
    %=======================================arithmetic2======================================================
   
    black_and_red=[];
    black_and_red=[original_interval_black,original_interval_red];
    
    
    
    %100的间隔
    [findpeaks_time_domain_max] = findpeaks_100(processed_data,1,1947);%找到black峰点  2017改2025
    peaks_count_max=length(findpeaks_time_domain_max);%找到的峰值个数
    %-----------二次处理------black-------------------
    %对找到的峰点进行过滤—black
    [new_findpeaks_time_domain_max] = second_filtration(processed_data ,findpeaks_time_domain_max, peaks_count_max);
    [original_interval_black_low] = HR_calculate3( new_findpeaks_time_domain_max );
    %===========================================================================
    [findpeaks_time_domain_min] = findpeaks_100(processed_data,0,1947);%找到red峰点  2017改2025
    peaks_count_min=length(findpeaks_time_domain_min);%找到的峰值个数，值可以为p-1
    %------------二次处理-----------red------------
    %对找到的峰点进行过滤—red
    [new_findpeaks_time_domain_min] = second_filtration(processed_data ,findpeaks_time_domain_min, peaks_count_min);
    [original_interval_red_low] = HR_calculate3( new_findpeaks_time_domain_min );
    
    black_and_red_low=[];
    black_and_red_low=[original_interval_black_low,original_interval_red_low];
    
    
end

