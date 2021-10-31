

%------用来播放不同小波，查找black和red的效果，并且同时展示查找到的black和red对比-------

clc;clf;clear all



%============================旧数据=======================================================

% load('G:\ocamar\最终比较\10月立项前测试\10_20_function_t_and_f_陈躺(_聚氨酯+网格光纤)杨躺杨侧.mat')
% datat=data(520:11543);
%datat=data(12920:21016);


% load('G:\ocamar\研发采集数据12-15起\1-26新数据\王校长(1).mat')
% datat=data(1:10880);


%load('G:\ocamar\研发采集数据12-15起\1-26新数据\赵南南(1).mat')
%datat=data(937:14267);
%datat=data(16026:33028);
%datat=data(35246:39678);

%load('G:\ocamar\研发采集数据12-15起\1-26新数据\马辉(1).mat')
%datat=data(21050:28117);
%datat=data(29061:39221);
%datat=data(39872:51145);

load('G:\ocamar\研发采集数据12-15起\1-26新数据\陈跑(1).mat')
datat=data(13320:23542);

%========================================================================================================


%load('G:\ocamar\前期测试\9_11_heart_rate8—聚氨酯—林(1).mat')%测试数据1
%datat=data(48120:71800);%侧躺
%datat=data(10847:42338);%正躺

% load('G:\ocamar\研发采集数据12-15起\2M+RADC12_16刘躺+刘侧(1).mat')
% datat=data(1750:16541);
%datat=data(17298:24200);

% load('G:\ocamar\研发采集数据12-15起\2M+RADC12_17马躺+马侧(2).mat')
%datat=data(2163:18683);
% datat=data(33093:55280);

% load('G:\ocamar\研发采集数据12-15起\5M+RADC12_19陈躺(1).mat')
% datat=data(3899:13345);


%load('G:\ocamar\研发采集数据12-15起\5M+RADC12_19陈躺(2).mat')
%datat=data(1400:13842);
%datat=data(14942:21130);
%datat=data(22125:30992);

%load('G:\ocamar\研发采集数据12-15起\测试数据二.mat')
%datat=data(1300:6437);
%datat=data(7843:17774);
%datat=data(19914:25535);
%datat=data(27000:35535);

% load('G:\ocamar\研发采集数据12-15起\analog switch test\通道4_10M_正躺+侧躺_正躺_侧躺2.mat')
% datat=data(1584:14766);
%datat=data(15963:23882);
%datat=data(24876:29660);


%采集库专用FFT
Fs=100;     %采样率
N=1024;     %采样点数
nt =0:N-1;   %采样序列
f=nt*Fs/N;   %真实的频率
% figure(2);



a_max_flag=[];
max_flag_value=[];
result=[];
fig = figure(1);



% while ishandle(fig)
       for t=1:fix(length(datat)/512)
        t
        start=t*512;
        data_iteration=datat(start:start+511);
        
        
        %--------------------------------------------------------------
        %-----------------arithmetic1----该程序，只分解一层-------------
        %--------------------------------------------------------------
        %     nt=1;
        %     [ct,lt] = wavedec(data_iteration,nt,'db5');
        %     [cd1t]=detcoef(ct,lt,1);
        %     at=max(cd1t);
        %     thr2t=at(1);
        %     cxt = wthcoef('t',ct,lt,1:nt,thr2t,'s');
        %     lxt = lt;
        %     xt = waverec(cxt,lxt,'db5');
        %    
        %     new_data2=data_iteration-xt;
        %     subplot(2,1,1);
        %     plot(new_data2)
        %     hold on
        %------------------------------------------------------------
        %------------------------arithmetic1-------------------------
        %------------------------------------------------------------





        %==========================arithmetic2----coif5、sym5、db5的a(6)置零==========================================
        [new_data2] = wavelet_process(data_iteration,0,'coif5');%返回得到的是已经去掉基线的BCG，且此处a(6)是置零
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
        %直接扩展 
        expend_data1=flip(new_data2);
        new_data1=[new_data2,expend_data1];%要全部转置成一维数组
        y1=fft(new_data1,N);
        Mag1=abs(y1)*2/N;
        
%         stem(f(1:end),Mag(1:end));
%         plot(f(1:end),Mag(1:end));
%         axis([0 23 0 0.002]);
%         xticks(0:100);
%         title('幅频响应');xlabel('频率/Hz');ylabel('幅度');
        
        
        
        
        
        
        
        
        
        
        
        
        
        


        %============================arithmetic2.1==========coif5、sym5、db5的a(6)置零============================
%         [new_data2] = wavelet_process(data_iteration,1,'coif5');%返回得到的是已经去掉基线的BCG，且此处a(6)是置1
%         subplot(3,1,1);
%         plot(new_data2)
%         hold on
%         %-----------30间隔--------black-------
%         [findpeaks_time_domain_max] = findpeaks(new_data2,1);%找到black峰点
%         peaks_count_max=length(findpeaks_time_domain_max);%找到的峰值个数
%         for i=1:peaks_count_max
%             subplot(3,1,1);
%             plot(findpeaks_time_domain_max(i),new_data2(findpeaks_time_domain_max(i)),'ok');hold on             %对找到的峰值画圈圈
%         end
%          %-----------二次处理------black-------------------
%         %对找到的峰点进行过滤—black
%         [new_findpeaks_time_domain_max] = second_filtration(new_data2 ,findpeaks_time_domain_max, peaks_count_max);
%         for i=1:length(new_findpeaks_time_domain_max)
%             plot(new_findpeaks_time_domain_max(i),new_data2(new_findpeaks_time_domain_max(i)),'*k');hold on             %对找到的峰值画圈圈
%         end
% 
%         %------------30间隔----------red------------------
%         [findpeaks_time_domain_min] = findpeaks(new_data2,0);%找到red峰点
%         peaks_count_min=length(findpeaks_time_domain_min);%找到的峰值个数，值可以为p-1
%         for i=1:peaks_count_min
%             subplot(3,1,1);
%             plot(findpeaks_time_domain_min(i),new_data2(findpeaks_time_domain_min(i)),'or');hold on             %对找到的峰值画圈圈
%         end
%         %------------二次处理-----------red------------
%         %对找到的峰点进行过滤—red
%         [new_findpeaks_time_domain_min] = second_filtration(new_data2 ,findpeaks_time_domain_min, peaks_count_min);
%         for i=1:length(new_findpeaks_time_domain_min)
%             plot(new_findpeaks_time_domain_min(i),new_data2(new_findpeaks_time_domain_min(i)),'*r');hold on             %对找到的峰值画圈圈
%         end
%         hold off
    	%-------------------------------------------------------------------------------------------------------
        %----------------------arithmetic2.1--------------------------------------------------------------------
        %-------------------------------------------------------------------------------------------------------

        
        
        


















        %disp("===============interval================")




 




        %------------------------------------------------------
        %-------arithmetic3----coif5、sym5、db5的a(6)置零-------
        %------------------------------------------------------
        [data_differenced] = wavelet_process(data_iteration,0,'sym5');%返回得到的是已经去掉基线的BCG，且此处a(6)是置零
        subplot(3,1,2);
        plot(data_differenced)
        hold on

        %------------------------------------------------------
        %------------------arithmetic3-------------------------
        %------------------------------------------------------

        %     data_differenced=diff(new_data2,1);%一阶差分(去基线差分)
        %     subplot(2,1,2);
        %     plot(data_differenced)

        %-----------30间隔--------black------------------
        [findpeaks_time_domain_max] = findpeaks(data_differenced,1);%找到black峰点
        peaks_count_max=length(findpeaks_time_domain_max);%找到的峰值个数
        for i=1:peaks_count_max
            %subplot(3,1,2);
            plot(findpeaks_time_domain_max(i),data_differenced(findpeaks_time_domain_max(i)),'ok');hold on             %对找到的峰值画圈圈
        end
        %-----------二次处理------black-------------------
        %对找到的峰点进行过滤—black
        [new_findpeaks_time_domain_max] = second_filtration(data_differenced ,findpeaks_time_domain_max, peaks_count_max);
        for i=1:length(new_findpeaks_time_domain_max)
            plot(new_findpeaks_time_domain_max(i),data_differenced(new_findpeaks_time_domain_max(i)),'*k');hold on             %对找到的峰值画圈圈
        end
        [statistics_array_2D3,flag_2D3,a_max_flag(t,3),max_flag_value(t,3)] = HR_calculate( new_findpeaks_time_domain_max );
        %==========================================================================================================
        %------------30间隔----------red------------------
        [findpeaks_time_domain_min] = findpeaks(data_differenced,0);%找到red峰点
        peaks_count_min=length(findpeaks_time_domain_min);%找到的峰值个数，值可以为p-1
        for i=1:peaks_count_min
            %subplot(3,1,2);
            plot(findpeaks_time_domain_min(i),data_differenced(findpeaks_time_domain_min(i)),'or');hold on             %对找到的峰值画圈圈
        end
        %------------二次处理-----------red------------
        %对找到的峰点进行过滤—red
        [new_findpeaks_time_domain_min] = second_filtration(data_differenced ,findpeaks_time_domain_min, peaks_count_min);
        for i=1:length(new_findpeaks_time_domain_min)
            plot(new_findpeaks_time_domain_min(i),data_differenced(new_findpeaks_time_domain_min(i)),'*r');hold on             %对找到的峰值画圈圈
        end
        [statistics_array_2D4,flag_2D4,a_max_flag(t,4),max_flag_value(t,4)] = HR_calculate( new_findpeaks_time_domain_min );
        hold off





       %disp("===============interval================")




        %----------------------------------------------------------------------------------------------------------------
        %-------arithmetic4----coif5、sym5、db5的a(6)置零-----------------------------------------------------------------
        %----------------------------------------------------------------------------------------------------------------
        [data_differenced] = wavelet_process(data_iteration,0,'db5');%返回得到的是已经去掉基线的BCG，且此处a(6)是置零
        subplot(3,1,3);
        plot(data_differenced)
        hold on
        %-----------30间隔--------black------------------
        [findpeaks_time_domain_max] = findpeaks(data_differenced,1);%找到black峰点
        peaks_count_max=length(findpeaks_time_domain_max);%找到的峰值个数
        for i=1:peaks_count_max
            %subplot(3,1,3);
            plot(findpeaks_time_domain_max(i),data_differenced(findpeaks_time_domain_max(i)),'ok');hold on             %对找到的峰值画圈圈
        end
        %-----------二次处理------black-------------------
        %对找到的峰点进行过滤—black
        [new_findpeaks_time_domain_max] = second_filtration(data_differenced ,findpeaks_time_domain_max, peaks_count_max);
        for i=1:length(new_findpeaks_time_domain_max)
            plot(new_findpeaks_time_domain_max(i),data_differenced(new_findpeaks_time_domain_max(i)),'*k');hold on             %对找到的峰值画圈圈
        end
        [statistics_array_2D5,flag_2D5,a_max_flag(t,5),max_flag_value(t,5)] = HR_calculate( new_findpeaks_time_domain_max );
        %==========================================================================================================
        %------------30间隔----------red------------------
        [findpeaks_time_domain_min] = findpeaks(data_differenced,0);%找到red峰点
        peaks_count_min=length(findpeaks_time_domain_min);%找到的峰值个数，值可以为p-1
        for i=1:peaks_count_min
            %subplot(3,1,3);
            plot(findpeaks_time_domain_min(i),data_differenced(findpeaks_time_domain_min(i)),'or');hold on             %对找到的峰值画圈圈
        end
        %------------二次处理-----------red------------
        %对找到的峰点进行过滤—red
        [new_findpeaks_time_domain_min] = second_filtration(data_differenced ,findpeaks_time_domain_min, peaks_count_min);
        for i=1:length(new_findpeaks_time_domain_min)
            plot(new_findpeaks_time_domain_min(i),data_differenced(new_findpeaks_time_domain_min(i)),'*r');hold on             %对找到的峰值画圈圈
        end
        [statistics_array_2D6,flag_2D6,a_max_flag(t,6),max_flag_value(t,6)] = HR_calculate( new_findpeaks_time_domain_min );
        hold off
        %------------------------------------------------------
        %------------------arithmetic4-------------------------
        %------------------------------------------------------
        
        
        
        %单独数组分析 max_flag_value和a_max_flag
        %特别情况1 六个都差不多的话(不管个数是多少)
        min_adiff=max(max_flag_value(t,:))-min(max_flag_value(t,:));
        %特别情况2 去掉为1的数后，剩下的值一样的话就输出
        temp_array=[];
        p=1;
        for z=1:6
            if a_max_flag(t,z)>1
                temp_array(p)=max_flag_value(t,z);
                p=p+1;
            end
        end
        min_adiff2=max(temp_array)-min(temp_array);%剩下的都一样的话
        
        
        %------心率筛选----第一层----
        %-----计算匹配度-------
        matching_degree=[];
        %heartrate_level=0;                  %初始化准确率等级
        %heartrate_time_domain_interval=0;   %初始化时域间隔
        %heartrate_level_0_flag=0;           %初始化间隔找到标志
        for i=1:6
            matching_degree(i)=a_max_flag(t,i)*max_flag_value(t,i);
        end
        [a_matching_degree_max,b_matching_degree_max]=max(matching_degree);
        if a_matching_degree_max>406.8 %------90%-------
            heartrate_level=1;              %标注准确率等级
            heartrate_level_flag=1;       %初始化间隔
            heartrate_time_domain_interval=max_flag_value(t,b_matching_degree_max);
        elseif a_matching_degree_max>361.6 %------80%-------
            heartrate_level=2;              %标注准确率等级
            heartrate_level_flag=1;       %初始化间隔
            heartrate_time_domain_interval=max_flag_value(t,b_matching_degree_max);
        elseif a_matching_degree_max>316.4 %------70%-------
            heartrate_level=3;              %标注准确率等级
            heartrate_level_flag=1;       %初始化间隔
            heartrate_time_domain_interval=max_flag_value(t,b_matching_degree_max);
        elseif a_matching_degree_max>271.2 %------60%-------
            heartrate_level=4;              %标注准确率等级
            heartrate_level_flag=1;       %初始化间隔
            heartrate_time_domain_interval=max_flag_value(t,b_matching_degree_max);
            %--------------60%的话，准确率太低了，所以就算了------需要以第二阶段的方式推出
        elseif min_adiff<6          %说明六个值差不多
            heartrate_level=5;
            heartrate_level_flag=1;
            heartrate_time_domain_interval=mean(max_flag_value(t,:));
        elseif min_adiff2<6          %说明六个值差不多
            heartrate_level=6;
            heartrate_level_flag=1;
            heartrate_time_domain_interval=mean(temp_array);
        else
            heartrate_level=0;                  %初始化准确率等级
            heartrate_time_domain_interval=0;   %初始化时域间隔
            heartrate_level_flag=0;           %初始化间隔找到标志
        end
        
        
        
        
        
        %======================这第一部分主要是看单个小波的单个(black或redd)
        %如果确实在coif5、sym5、db5中有一个和当前波形匹配度较高90%以上的匹配度的话,一是要用来输出，二是要要作为后面至少20秒内，用来输出的心率
        %那至少有70%以上的吧
        heartrate_optimal=0;
        
        if heartrate_level_flag==1
            heartrate_optimal=60/(heartrate_time_domain_interval*0.010)
            result(t)=heartrate_optimal;
            heartrate_level
        else
            result(t)=0;
        end
        
        
        
        
        
        pause(2);

       end
    
 
% end

