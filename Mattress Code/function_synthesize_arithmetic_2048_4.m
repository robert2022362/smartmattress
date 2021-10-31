function [heart_value] = function_synthesize_arithmetic_2048_4( data )

    %figure(2);
    threshold=0.04; %判断阈值%0.2的话还是有些小峰的，所以改到0.1，根据效果，更好是0.04或0.02
     data2=data;
    %3个元素的窗口
    for i=2:(length(data)-1)%第二个到最后倒数第二个
        a=abs(data2(i)-data2(i-1));
        b=abs(data2(i)-data2(i+1));
         if((a>=threshold)&&(b>=threshold))
             data2(i)=mean(data2(i-1)+data2(i+1))/2;
         end
    end
    %data2是异常点去除的新数据

        

[ black_and_red_array1,black_and_red_array1_low] = AM_TIME_2048_3(data2,1,'coif5');%a(6)置1
[ black_and_red_array2,black_and_red_array2_low] = AM_TIME_2048_3(data2,0,'coif5');%a(6)置0
%[ black_and_red_array3,black_and_red_array3_low] = AM_TIME_2048_3_2(data2,'coif5');
black_and_red_array3=[];
black_and_red_array3_low=[];

%[ ~,possible_interval_flag2,F_interval_continuity_HR2 ,~,~,comparing_times2,freq_HR_array2] = AM_FREQ_1024( data2,'sym5',0); %a(6)置0
[ black_and_red_array4,black_and_red_array4_low] = AM_TIME_2048_3(data2,1,'sym5');%a(6)置1
[ black_and_red_array5,black_and_red_array5_low] = AM_TIME_2048_3(data2,0,'sym5');%a(6)置0
%[ black_and_red_array6,black_and_red_array6_low] = AM_TIME_2048_3_2(data2,'sym5');
black_and_red_array6=[];
black_and_red_array6_low=[];

%[ ~,possible_interval_flag3,F_interval_continuity_HR3 ,~,~,comparing_times3,freq_HR_array3] = AM_FREQ_1024( data2,'sym5',0); %a(6)置0
[ black_and_red_array7,black_and_red_array7_low] = AM_TIME_2048_3(data2,1,'db5');%a(6)置1
[ black_and_red_array8,black_and_red_array8_low] = AM_TIME_2048_3(data2,0,'db5');%a(6)置0
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

%stem(range_statistics_30_double)


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
% subplot(2,1,2)
% stem(range_statistics_30_250_double);hold on

[a_low,b_low]=max(range_statistics_30_double);%a是值，c是坐标  从40心率到30心率这样
[a_all,b_all]=max(range_statistics_30_250_double);
[a_all_detial,b_all_detial]=max(range_statistics_30_250);


% if(a_low>=30)&&(a_all<120)
%     heart_value=round(6000/(b_low+22));disp('1');
% elseif(a_all>100)&&(a_all<=400)
%     heart_value=round(6000/(b_all+22));disp('2');
% elseif(a_all>400)
%     heart_value=round(6000/(b_all_detial+22));disp('3');
% else
%     heart_value=0;
% end

%{

[max1_a,max1_b]=max(range_statistics_30_250_double(30:100));%a是数量， b是坐标
[max2_a,max2_b]=max(range_statistics_30_250_double(50:100));%a是数量， b是坐标
%plot(max1_b+29,max1_a,'ok');
%plot(max2_b+49,max2_a,'or');

if(((b_all<=10)&&(a_all>200))||((b_all>10)&&(b_all<=20)&&(a_all>150))||((b_all>20)&&(b_all<30)&&(a_all>110))||((b_all>=30)&&(b_all<40)&&(a_all>100))||((b_all>=40)&&(b_all<50)&&(a_all>90))||((b_all>=50)&&(b_all<60)&&(a_all>80))||((b_all>=60)&&(b_all<70)&&(a_all>70)))
    heart_value=round(6000/(b_all+22));
elseif((b_all<50)&&(a_all<200)&&(max2_a>40))%50~100有大于40的存在的话
    heart_value=round(6000/(max2_b+49+22));
elseif((b_all<50)&&(a_all<200)&&(max1_a>40))%30~100有大于40的存在的话
    heart_value=round(6000/(max1_b+29+22));
elseif(a_low<30)&&(a_all>40)
    heart_value=round(6000/(b_all+22));
else
    heart_value=0;
end
%}
disp(['    b_all  ',num2str(b_all),'    a_all  ',num2str(a_all)])
%     figure(2);
%     hist(large_array)
    
    
    
 end

