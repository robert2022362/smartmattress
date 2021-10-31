function [ interval_successrate_flag_cd1,T_interval_continuity_HR_cd1] = AM_TIME_1536_2(data,wavename)
%输入是原始数据

    %coif5、sym5、db5的a(6)置零
    %[processed_data] = wavelet_process(data,0,lower(wavename));%返回得到的是已经去掉基线的BCG，且此处a(6)是置零
    
        %--------------------------------------------------------------
        %-----------------arithmetic1----该程序，只分解一层-------------
        %--------------------------------------------------------------
        nt=1;
        [ct,lt] = wavedec(data,nt,wavename);
        [cd1t]=detcoef(ct,lt,1);
        at=max(cd1t);
        thr2t=at(1);
        cxt = wthcoef('t',ct,lt,1:nt,thr2t,'s');
        lxt = lt;
        xt = waverec(cxt,lxt,wavename);

        processed_data=data-xt;

        %------------------------------------------------------------
        %------------------------arithmetic1-------------------------
        %------------------------------------------------------------
    
    
    
    
    %-----------30间隔--------black------------------
    [findpeaks_time_domain_max] = findpeaks_1536_2048(processed_data,1,2017);%找到black峰点
    peaks_count_max=length(findpeaks_time_domain_max);%找到的峰值个数
    %-----------二次处理------black-------------------
    %对找到的峰点进行过滤—black
    [new_findpeaks_time_domain_max] = second_filtration(processed_data ,findpeaks_time_domain_max, peaks_count_max);
    [statistics_array_black,flag_2D_black,a_max_flag(1),max_flag_value(1)] = HR_calculate2( new_findpeaks_time_domain_max );
    %==========================================================================================================
    %------------30间隔----------red------------------
    [findpeaks_time_domain_min] = findpeaks_1536_2048(processed_data,0,2017);%找到red峰点
    peaks_count_min=length(findpeaks_time_domain_min);%找到的峰值个数，值可以为p-1
    %------------二次处理-----------red------------
    %对找到的峰点进行过滤—red
    [new_findpeaks_time_domain_min] = second_filtration(processed_data ,findpeaks_time_domain_min, peaks_count_min);
    [statistics_array_2D_red,flag_2D_red,a_max_flag(2),max_flag_value(2)] = HR_calculate2( new_findpeaks_time_domain_min );
    %=======================================arithmetic2======================================================
    

    %------心率筛选----第一层----
    %-----计算匹配度-------
    matching_degree=[];
    %heartrate_level=0;                  %初始化准确率等级
    %heartrate_time_domain_interval=0;   %初始化时域间隔
    %heartrate_level_0_flag=0;           %初始化间隔找到标志
    for i=1:2
        matching_degree(i)=a_max_flag(i)*max_flag_value(i);%计算两个值
    end
    [a_matching_degree_max,b_matching_degree_max]=max(matching_degree);
    if (a_matching_degree_max>=1700)&&(a_matching_degree_max<2048)      %------90%↑-------
       interval_successrate_flag_cd1=1;                          %标注准确率等级
        heartrate_level_flag=1;         %找到的标志
        heartrate_time_domain_interval=max_flag_value(b_matching_degree_max);
    elseif (a_matching_degree_max>=1466)&&(a_matching_degree_max<2048)	%------80%↑-------
        interval_successrate_flag_cd1=1;                         %标注准确率等级
        heartrate_level_flag=1;         %找到的标志
        heartrate_time_domain_interval=max_flag_value(b_matching_degree_max);
    elseif (a_matching_degree_max>=1300)&&(a_matching_degree_max<2048)  %------70%↑-------
         interval_successrate_flag_cd1=1;                        %标注准确率等级
        heartrate_level_flag=1;         %找到的标志
        heartrate_time_domain_interval=max_flag_value(b_matching_degree_max);
        %--------------60%的话，准确率太低了，所以就算了------需要以第二阶段的方式推出
    else
        %没有找到70%的点的话
        interval_successrate_flag_cd1=0;                             
        heartrate_time_domain_interval=0;   
        heartrate_level_flag=0;             
    end


    %======================这第一部分主要是看单个小波的单个(black或redd)
    %如果确实在coif5、sym5、db5中有一个和当前波形匹配度较高90%以上的匹配度的话,一是要用来输出，二是要要作为后面至少20秒内，用来输出的心率
    %那至少有70%以上的吧
    
    if heartrate_level_flag==1
        T_interval_continuity_HR_cd1=60/(heartrate_time_domain_interval*0.010);
    else
        T_interval_continuity_HR_cd1=0;
    end
    
    
end

