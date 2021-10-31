function [ T_interval_continuity_HR ] = function_heartrate_30( data4,datalength)
%此处显示有关此函数的摘要
%   此处显示详细说
%本函数是用来计算30-60之间较低的心率的(争对BCG模拟器)
    threshold=0.04; %判断阈值%0.2的话还是有些小峰的，所以改到0.1，根据效果，更好是0.04或0.02
     data2=data4;
    %3个元素的窗口
    for i=2:(length(data2)-1)%第二个到最后倒数第二个
        a=abs(data2(i)-data2(i-1));
        b=abs(data2(i)-data2(i+1));
         if((a>=threshold)&&(b>=threshold))
             data2(i)=mean(data2(i-1)+data2(i+1))/2;
         end
    end
%data2是异常点去除的新数据


    if(datalength==1536)
        max_limit=1435;
    elseif(datalength==2048)
        max_limit=1947;
    else
        error(message('Input parameter wrong'));
    end
    
    %AM_TIME_1024(data2,1,'coif5');%a(6)置1
    
    [processed_data] = wavelet_process(data2,1,'coif5');%返回得到的是已经去掉基线的BCG，a(6)为1是置保留，为0是置零
    %/////////////////////
%     stem(processed_data)
%     hold on
    %/////////////////////
    %-----------30间隔--------black------------------
    [findpeaks_time_domain_max] = findpeaks_100(processed_data,1,max_limit);%找到black峰点  1435是1536的数据长度 1947是2048的数据长度
    peaks_count_max=length(findpeaks_time_domain_max);%找到的峰值个数
    %/////////////////////
%     for i=1:peaks_count_max
%         %subplot(3,1,2);
%         plot(findpeaks_time_domain_max(i),processed_data(findpeaks_time_domain_max(i)),'ok');hold on             %对找到的峰值画圈圈
%     end
    %/////////////////////
    %-----------二次处理------black-------------------
    %对找到的峰点进行过滤—black
    [new_findpeaks_time_domain_max] = second_filtration(processed_data ,findpeaks_time_domain_max, peaks_count_max);
    %////////////////////
%     for i=1:length(new_findpeaks_time_domain_max)
%         plot(new_findpeaks_time_domain_max(i),processed_data(new_findpeaks_time_domain_max(i)),'*k');hold on             %对找到的峰值画圈圈
%     end
    %////////////////////
    [original_interval_black , statistics_array_2D_black , statistics_array_black  , max_statistics_red , flag_2D_black , a_max_flag(1) , max_flag_value(1) , row_n11 , column_n11] = HR_calculate( new_findpeaks_time_domain_max );
    
    %==========================================================================================================
    %------------30间隔----------red------------------
    [findpeaks_time_domain_min] = findpeaks_100(processed_data,0,max_limit);%找到red峰点
    peaks_count_min=length(findpeaks_time_domain_min);%找到的峰值个数，值可以为p-1
    %//////////////////////
%     for i=1:peaks_count_min
%         %subplot(3,1,3);
%         plot(findpeaks_time_domain_min(i),processed_data(findpeaks_time_domain_min(i)),'or');hold on             %对找到的峰值画圈圈
%     end
    %//////////////////////
    %------------二次处理-----------red------------
    %对找到的峰点进行过滤—red
    [new_findpeaks_time_domain_min] = second_filtration(processed_data ,findpeaks_time_domain_min, peaks_count_min);
%     for i=1:length(new_findpeaks_time_domain_min)
%         plot(new_findpeaks_time_domain_min(i),processed_data(new_findpeaks_time_domain_min(i)),'*r');hold on             %对找到的峰值画圈圈
%     end
    [original_interval_red , statistics_array_2D_red , statistics_array_red  , max_statistics_black , flag_2D_red , a_max_flag(2) , max_flag_value(2) , row_n12 , column_n12] = HR_calculate( new_findpeaks_time_domain_min );
    %=======================================arithmetic2======================================================
   
    
    
    
    %------心率筛选----第一层----
    %-----计算匹配度-------

    %=====================针对30心率=================
    
%     if(a_max_flag(1)>=5)
%        
%         heartrate_level_flag=1;
%         heartrate_time_domain_interval=round(max_flag_value(1));
%     elseif(a_max_flag(2)>=5)
%         
%         heartrate_level_flag=1;
%         heartrate_time_domain_interval=round(max_flag_value(2));
    middelvalue=abs(max_flag_value(1)-max_flag_value(2));
    if(a_max_flag(1)>=5)&&(a_max_flag(2)>=5)&&(middelvalue<=10)
        heartrate_level_flag=1;
        heartrate_time_domain_interval=round(max_flag_value(1));     
    else
        %没有找到的话               
        heartrate_time_domain_interval=0;   
        heartrate_level_flag=0;             
    end

    %======================这第一部分主要是看单个小波的单个(black或redd)

    
    if heartrate_level_flag==1
        %T_interval_continuity_HR=roundn(60/(heartrate_time_domain_interval*0.010),-2);%这里除数不可能为0.即不可能会是无效值
        %T_interval_continuity_HR=60/(heartrate_time_domain_interval*0.010);%这里除数不可能为0.即不可能会是无效值
        T_interval_continuity_HR=round(60/(heartrate_time_domain_interval*0.010));%这里除数不可能为0.即不可能会是无效值

    else
        T_interval_continuity_HR=0;
    end

end

