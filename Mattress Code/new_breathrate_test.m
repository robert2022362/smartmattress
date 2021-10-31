
%准备环境
clf;clc;clear all;
%load('G:\ocamar\研发采集数据12-15起\analog switch test\通道4_10M_正躺+侧躺_正躺_侧躺2.mat')
%datat=data(1584:14766);
%datat=data(15963:23882);
%datat=data(24876:29660);

% load('G:\ocamar\研发采集数据12-15起\1-26新数据\赵南南(1).mat')
% %datat=data(937:14267);
% datat=data(16026:33028);
% %datat=data(35246:39678);

load('G:\ocamar\研发采集数据12-15起\1-26新数据\composite_t_and_f_2s5s10s_陈正躺_侧.mat')
datat=data(1083:7771);
% datat=data(8456:18826);
% datat=data(20828:28169);


start=1;
% data2=datat(start:start+1023);%10s
data2=datat(start:start+1535);%15s
% data2=datat(start:start+2047);%20s
% data2=datat(start:start+2559);%20s
% data2=datat(start:start+3071);%20s

%只设定10s数据，15s数据，20s数据，30s数据

l=data2(2:2:end);%取奇数 10s数据压缩到512个点(50Hz,20ms)
m=l(2:2:end);%取偶数  512个点压缩到256个点(25Hz,40ms)
n=m(2:2:end);

o=data2(8:8:end);

[b,a]=butter(4,1/12.5,'low');
new_data=filter(b,a,o);
plot(n)
hold on
plot(new_data)%前45个点得去掉
hold on
%removebase=median_value-data_filted;%去除这一段通过lowfilter的信号，得到去基线漂移的信号


%正常人心率是 12~20次/分，对应分辨率20ms的间隔250~150
%这里我用最小间隔是80来找峰点，如果真有80的间隔的呼吸峰的话，这个人的呼吸是37.5次/分

%正常人心率是 12~20次/分，对应分辨率40ms的间隔125~75
%这里我用最小间隔是40来找峰点，如果真有40的间隔的呼吸峰的话，这个人的呼吸是37.5次/分

%正常人心率是 12~20次/分，对应分辨率80ms(采样率是12.5Hz)的间隔62.5~37.5
%这里我用最小间隔是20来找峰点，如果真有20的间隔的呼吸峰的话，这个人的呼吸是37.5次/分

% for i=41:215
%     if(((new_data(i)>new_data(i-1))&&(new_data(i)>new_data(i-2))&&(new_data(i)>new_data(i-3))&&(new_data(i)>new_data(i-4))&&(new_data(i)>new_data(i-5))&&(new_data(i)>new_data(i-6))&&(new_data(i)>new_data(i-7))&&(new_data(i)>new_data(i-8))&&(new_data(i)>new_data(i-9))&&(new_data(i)>new_data(i-10))&&(new_data(i)>new_data(i-11))&&(new_data(i)>new_data(i-12))&&(new_data(i)>new_data(i-13))&&(new_data(i)>new_data(i-14))&&(new_data(i)>new_data(i-15))&&(new_data(i)>new_data(i-16))&&(new_data(i)>new_data(i-17))&&(new_data(i)>new_data(i-18))&&(new_data(i)>new_data(i-19))&&(new_data(i)>new_data(i-20))&&(new_data(i)>new_data(i-21))&&(new_data(i)>new_data(i-22))&&(new_data(i)>new_data(i-23))&&(new_data(i)>new_data(i-24))&&(new_data(i)>new_data(i-25))&&(new_data(i)>new_data(i-26))&&(new_data(i)>new_data(i-27))&&(new_data(i)>new_data(i-28))&&(new_data(i)>new_data(i-29))&&(new_data(i)>new_data(i-30))&&(new_data(i)>new_data(i-31))&&(new_data(i)>new_data(i-32))&&(new_data(i)>new_data(i-33))&&(new_data(i)>new_data(i-34))&&(new_data(i)>new_data(i-35))&&(new_data(i)>new_data(i-36))&&(new_data(i)>new_data(i-37))&&(new_data(i)>new_data(i-38))&&(new_data(i)>new_data(i-39))&&(new_data(i)>new_data(i-40)))&&...
%         ((new_data(i)>new_data(i+1))&&(new_data(i)>new_data(i+2))&&(new_data(i)>new_data(i+3))&&(new_data(i)>new_data(i+4))&&(new_data(i)>new_data(i+5))&&(new_data(i)>new_data(i+6))&&(new_data(i)>new_data(i+7))&&(new_data(i)>new_data(i+8))&&(new_data(i)>new_data(i+9))&&(new_data(i)>new_data(i+10))&&(new_data(i)>new_data(i+11))&&(new_data(i)>new_data(i+12))&&(new_data(i)>new_data(i+13))&&(new_data(i)>new_data(i+14))&&(new_data(i)>new_data(i+15))&&(new_data(i)>new_data(i+16))&&(new_data(i)>new_data(i+17))&&(new_data(i)>new_data(i+18))&&(new_data(i)>new_data(i+19))&&(new_data(i)>new_data(i+20))&&(new_data(i)>new_data(i+21))&&(new_data(i)>new_data(i+22))&&(new_data(i)>new_data(i+23))&&(new_data(i)>new_data(i+24))&&(new_data(i)>new_data(i+25))&&(new_data(i)>new_data(i+26))&&(new_data(i)>new_data(i+27))&&(new_data(i)>new_data(i+28))&&(new_data(i)>new_data(i+29))&&(new_data(i)>new_data(i+30))&&(new_data(i)>new_data(i+31))&&(new_data(i)>new_data(i+32))&&(new_data(i)>new_data(i+33))&&(new_data(i)>new_data(i+34))&&(new_data(i)>new_data(i+35))&&(new_data(i)>new_data(i+36))&&(new_data(i)>new_data(i+37))&&(new_data(i)>new_data(i+38))&&(new_data(i)>new_data(i+39))&&(new_data(i)>new_data(i+40))))
% for i=31:235 
%       if(((new_data(i)>new_data(i-1))&&(new_data(i)>new_data(i-2))&&(new_data(i)>new_data(i-3))&&(new_data(i)>new_data(i-4))&&(new_data(i)>new_data(i-5))&&(new_data(i)>new_data(i-6))&&(new_data(i)>new_data(i-7))&&(new_data(i)>new_data(i-8))&&(new_data(i)>new_data(i-9))&&(new_data(i)>new_data(i-10))&&(new_data(i)>new_data(i-11))&&(new_data(i)>new_data(i-12))&&(new_data(i)>new_data(i-13))&&(new_data(i)>new_data(i-14))&&(new_data(i)>new_data(i-15))&&(new_data(i)>new_data(i-16))&&(new_data(i)>new_data(i-17))&&(new_data(i)>new_data(i-18))&&(new_data(i)>new_data(i-19))&&(new_data(i)>new_data(i-20))&&(new_data(i)>new_data(i-21))&&(new_data(i)>new_data(i-22))&&(new_data(i)>new_data(i-23))&&(new_data(i)>new_data(i-24))&&(new_data(i)>new_data(i-25))&&(new_data(i)>new_data(i-26))&&(new_data(i)>new_data(i-27))&&(new_data(i)>new_data(i-28))&&(new_data(i)>new_data(i-29))&&(new_data(i)>new_data(i-30)))&&...
%           ((new_data(i)>new_data(i+1))&&(new_data(i)>new_data(i+2))&&(new_data(i)>new_data(i+3))&&(new_data(i)>new_data(i+4))&&(new_data(i)>new_data(i+5))&&(new_data(i)>new_data(i+6))&&(new_data(i)>new_data(i+7))&&(new_data(i)>new_data(i+8))&&(new_data(i)>new_data(i+9))&&(new_data(i)>new_data(i+10))&&(new_data(i)>new_data(i+11))&&(new_data(i)>new_data(i+12))&&(new_data(i)>new_data(i+13))&&(new_data(i)>new_data(i+14))&&(new_data(i)>new_data(i+15))&&(new_data(i)>new_data(i+16))&&(new_data(i)>new_data(i+17))&&(new_data(i)>new_data(i+18))&&(new_data(i)>new_data(i+19))&&(new_data(i)>new_data(i+20))&&(new_data(i)>new_data(i+21))&&(new_data(i)>new_data(i+22))&&(new_data(i)>new_data(i+23))&&(new_data(i)>new_data(i+24))&&(new_data(i)>new_data(i+25))&&(new_data(i)>new_data(i+26))&&(new_data(i)>new_data(i+27))&&(new_data(i)>new_data(i+28))&&(new_data(i)>new_data(i+29))&&(new_data(i)>new_data(i+30))))

% enddata=107;
% enddata=172;
enddata=236;
p=1;
for i=21:enddata      
      if(((new_data(i)>new_data(i-1))&&(new_data(i)>new_data(i-2))&&(new_data(i)>new_data(i-3))&&(new_data(i)>new_data(i-4))&&(new_data(i)>new_data(i-5))&&(new_data(i)>new_data(i-6))&&(new_data(i)>new_data(i-7))&&(new_data(i)>new_data(i-8))&&(new_data(i)>new_data(i-9))&&(new_data(i)>new_data(i-10))&&(new_data(i)>new_data(i-11))&&(new_data(i)>new_data(i-12))&&(new_data(i)>new_data(i-13))&&(new_data(i)>new_data(i-14))&&(new_data(i)>new_data(i-15))&&(new_data(i)>new_data(i-16))&&(new_data(i)>new_data(i-17))&&(new_data(i)>new_data(i-18))&&(new_data(i)>new_data(i-19))&&(new_data(i)>new_data(i-20)))&&...
          ((new_data(i)>new_data(i+1))&&(new_data(i)>new_data(i+2))&&(new_data(i)>new_data(i+3))&&(new_data(i)>new_data(i+4))&&(new_data(i)>new_data(i+5))&&(new_data(i)>new_data(i+6))&&(new_data(i)>new_data(i+7))&&(new_data(i)>new_data(i+8))&&(new_data(i)>new_data(i+9))&&(new_data(i)>new_data(i+10))&&(new_data(i)>new_data(i+11))&&(new_data(i)>new_data(i+12))&&(new_data(i)>new_data(i+13))&&(new_data(i)>new_data(i+14))&&(new_data(i)>new_data(i+15))&&(new_data(i)>new_data(i+16))&&(new_data(i)>new_data(i+17))&&(new_data(i)>new_data(i+18))&&(new_data(i)>new_data(i+19))&&(new_data(i)>new_data(i+20))))
         findpeaks_time_domain_max_min(1,p)=i;
         plot(i,new_data(i),'ok');hold on %对找到的峰值画圈圈
         p=p+1;
      end
end


%-------------------------计算后一个点与前一个点的原始间隔--------------------
    peaks_count=length(findpeaks_time_domain_max_min);
    original_interval=[];
    for i=1:(peaks_count-1) %n个峰值的话，只要做n-1次减计算就可以了
        original_interval(1,i)=(findpeaks_time_domain_max_min(1,i+1)-findpeaks_time_domain_max_min(1,i))-1;%这里减1是为了得到峰之间的间隔
    end
    %----------------------原始间隔分类--------二维数组-----------
    original_interval2=original_interval;
    statistics_array=zeros(1,peaks_count);%长度
    statistics_array_2D=[];
    for i=1:peaks_count-1
        for j=1:peaks_count-1  %由于每个数都包含一次自身，所以实际结果要减1，但是单纯找最大数的话是没必要的
            if(original_interval2(1,j)==0)%如果已经被归为0的话，就说明已经被比较过且被取走了
               continue 
            elseif(abs(original_interval2(1,i)-original_interval2(1,j))<12)
                statistics_array(1,i)=statistics_array(1,i)+1;%相近数统计值加1
                statistics_array_2D(i,j)=original_interval2(1,j);
                %这里需要加一个二维数组，长度还是adiff_count,列的元素是相差为10内的数据
                if(i~=j)
                    original_interval2(1,j)=0;%标注原数组adiff中已经被统计过(即小于本次10)的值
                end
            else
                %disp('no elements')
            end
        end
    end
    [row_n1,column_n1]=size(statistics_array_2D);
    

    statistics_array_2D_num_average=[];
    statistics_array_2D_sum=sum(statistics_array_2D,2);%对矩阵行元素求和，中间的0也加起来，后面只除统计数
    statistics_array_2D_num=sum(statistics_array_2D~=0,2);%返回列向量，代表矩阵中行非零元素的个数
    for i=1:row_n1
        statistics_array_2D_num_average(1,i)=statistics_array_2D_sum(i)/statistics_array_2D_num(i);
    end
    %至此就得到了statistics_array_2D的每行的平均值，可以直接用该间隔计算心率


    
    [a_max_flag,b_max_flag]=max(statistics_array);
    %然后是通过索引找到对应的间隔行
    max_flag_value=statistics_array_2D_num_average(b_max_flag);
    
    breath_value=750/max_flag_value
    
    

%%

%准备环境
clf;clc;clear all;
%load('G:\ocamar\研发采集数据12-15起\analog switch test\通道4_10M_正躺+侧躺_正躺_侧躺2.mat')
%datat=data(1584:14766);
%datat=data(15963:23882);
%datat=data(24876:29660);

load('G:\ocamar\研发采集数据12-15起\1-26新数据\赵南南(1).mat')
%datat=data(937:14267);
datat=data(16026:33028);
%datat=data(35246:39678);

start=1*512;
data2=datat(start:start+1023);

%只设定10s数据，15s数据，20s数据，30s数据

% l=data2(2:2:end);%取奇数 10s数据压缩到512个点(50Hz,20ms)
% m=l(2:2:end);%取偶数  512个点压缩到256个点(25Hz,40ms)
% n=m(2:2:end);
% 
% o=data2(8:8:end);

%[b,a]=butter(1,1/12.5,'low');
[b,a]=butter(1,1/100,'low');
new_data=filter(b,a,data2);
plot(data2)
hold on
plot(new_data)%前45个点得去掉
hold on









%%

%15s
%准备环境
clf;clc;clear all;
%load('G:\ocamar\研发采集数据12-15起\analog switch test\通道4_10M_正躺+侧躺_正躺_侧躺2.mat')
%datat=data(1584:14766);
%datat=data(15963:23882);
%datat=data(24876:29660);

load('G:\ocamar\研发采集数据12-15起\1-26新数据\赵南南(1).mat')
%datat=data(937:14267);
datat=data(16026:33028);
%datat=data(35246:39678);

start=1*512;

data4=datat(start:start+1536);

n=data4(8:8:end);

[b,a]=butter(1,1/12.5,'low');
new_data=filter(b,a,n);
plot(n)
hold on
plot(new_data)%前45个点得去掉
hold on



p=1;
for i=21:171      
      if(((new_data(i)>new_data(i-1))&&(new_data(i)>new_data(i-2))&&(new_data(i)>new_data(i-3))&&(new_data(i)>new_data(i-4))&&(new_data(i)>new_data(i-5))&&(new_data(i)>new_data(i-6))&&(new_data(i)>new_data(i-7))&&(new_data(i)>new_data(i-8))&&(new_data(i)>new_data(i-9))&&(new_data(i)>new_data(i-10))&&(new_data(i)>new_data(i-11))&&(new_data(i)>new_data(i-12))&&(new_data(i)>new_data(i-13))&&(new_data(i)>new_data(i-14))&&(new_data(i)>new_data(i-15))&&(new_data(i)>new_data(i-16))&&(new_data(i)>new_data(i-17))&&(new_data(i)>new_data(i-18))&&(new_data(i)>new_data(i-19))&&(new_data(i)>new_data(i-20)))&&...
          ((new_data(i)>new_data(i+1))&&(new_data(i)>new_data(i+2))&&(new_data(i)>new_data(i+3))&&(new_data(i)>new_data(i+4))&&(new_data(i)>new_data(i+5))&&(new_data(i)>new_data(i+6))&&(new_data(i)>new_data(i+7))&&(new_data(i)>new_data(i+8))&&(new_data(i)>new_data(i+9))&&(new_data(i)>new_data(i+10))&&(new_data(i)>new_data(i+11))&&(new_data(i)>new_data(i+12))&&(new_data(i)>new_data(i+13))&&(new_data(i)>new_data(i+14))&&(new_data(i)>new_data(i+15))&&(new_data(i)>new_data(i+16))&&(new_data(i)>new_data(i+17))&&(new_data(i)>new_data(i+18))&&(new_data(i)>new_data(i+19))&&(new_data(i)>new_data(i+20))))
         findpeaks_time_domain_max_min(1,p)=i;
         plot(i,new_data(i),'ok');hold on %对找到的峰值画圈圈
         p=p+1;
      end%%

%20s
%准备环境
clf;clc;clear all;
%load('G:\ocamar\研发采集数据12-15起\analog switch test\通道4_10M_正躺+侧躺_正躺_侧躺2.mat')
%datat=data(1584:14766);
%datat=data(15963:23882);
%datat=data(24876:29660);

load('G:\ocamar\研发采集数据12-15起\1-26新数据\赵南南(1).mat')
%datat=data(937:14267);
datat=data(16026:33028);
%datat=data(35246:39678);

start=1*512;

data3=datat(start:start+2048);

n=data3(8:8:end);

[b,a]=butter(1,1/12.5,'low');
new_data=filter(b,a,n);
plot(n)
hold on
plot(new_data)%前45个点得去掉
hold on



p=1;
for i=21:235      
      if(((new_data(i)>new_data(i-1))&&(new_data(i)>new_data(i-2))&&(new_data(i)>new_data(i-3))&&(new_data(i)>new_data(i-4))&&(new_data(i)>new_data(i-5))&&(new_data(i)>new_data(i-6))&&(new_data(i)>new_data(i-7))&&(new_data(i)>new_data(i-8))&&(new_data(i)>new_data(i-9))&&(new_data(i)>new_data(i-10))&&(new_data(i)>new_data(i-11))&&(new_data(i)>new_data(i-12))&&(new_data(i)>new_data(i-13))&&(new_data(i)>new_data(i-14))&&(new_data(i)>new_data(i-15))&&(new_data(i)>new_data(i-16))&&(new_data(i)>new_data(i-17))&&(new_data(i)>new_data(i-18))&&(new_data(i)>new_data(i-19))&&(new_data(i)>new_data(i-20)))&&...
          ((new_data(i)>new_data(i+1))&&(new_data(i)>new_data(i+2))&&(new_data(i)>new_data(i+3))&&(new_data(i)>new_data(i+4))&&(new_data(i)>new_data(i+5))&&(new_data(i)>new_data(i+6))&&(new_data(i)>new_data(i+7))&&(new_data(i)>new_data(i+8))&&(new_data(i)>new_data(i+9))&&(new_data(i)>new_data(i+10))&&(new_data(i)>new_data(i+11))&&(new_data(i)>new_data(i+12))&&(new_data(i)>new_data(i+13))&&(new_data(i)>new_data(i+14))&&(new_data(i)>new_data(i+15))&&(new_data(i)>new_data(i+16))&&(new_data(i)>new_data(i+17))&&(new_data(i)>new_data(i+18))&&(new_data(i)>new_data(i+19))&&(new_data(i)>new_data(i+20))))
         findpeaks_time_domain_max_min(1,p)=i;
         plot(i,new_data(i),'ok');hold on %对找到的峰值画圈圈
         p=p+1;
      end
end
end

%%

%20s
%准备环境
clf;clc;clear all;
%load('G:\ocamar\研发采集数据12-15起\analog switch test\通道4_10M_正躺+侧躺_正躺_侧躺2.mat')
%datat=data(1584:14766);
%datat=data(15963:23882);
%datat=data(24876:29660);

load('G:\ocamar\研发采集数据12-15起\1-26新数据\赵南南(1).mat')
%datat=data(937:14267);
datat=data(16026:33028);
%datat=data(35246:39678);

start=1*512;

data3=datat(start:start+2048);

n=data3(8:8:end);

[b,a]=butter(1,1/12.5,'low');
new_data=filter(b,a,n);
plot(n)
hold on
plot(new_data)%前45个点得去掉
hold on



p=1;
for i=21:235      
      if(((new_data(i)>new_data(i-1))&&(new_data(i)>new_data(i-2))&&(new_data(i)>new_data(i-3))&&(new_data(i)>new_data(i-4))&&(new_data(i)>new_data(i-5))&&(new_data(i)>new_data(i-6))&&(new_data(i)>new_data(i-7))&&(new_data(i)>new_data(i-8))&&(new_data(i)>new_data(i-9))&&(new_data(i)>new_data(i-10))&&(new_data(i)>new_data(i-11))&&(new_data(i)>new_data(i-12))&&(new_data(i)>new_data(i-13))&&(new_data(i)>new_data(i-14))&&(new_data(i)>new_data(i-15))&&(new_data(i)>new_data(i-16))&&(new_data(i)>new_data(i-17))&&(new_data(i)>new_data(i-18))&&(new_data(i)>new_data(i-19))&&(new_data(i)>new_data(i-20)))&&...
          ((new_data(i)>new_data(i+1))&&(new_data(i)>new_data(i+2))&&(new_data(i)>new_data(i+3))&&(new_data(i)>new_data(i+4))&&(new_data(i)>new_data(i+5))&&(new_data(i)>new_data(i+6))&&(new_data(i)>new_data(i+7))&&(new_data(i)>new_data(i+8))&&(new_data(i)>new_data(i+9))&&(new_data(i)>new_data(i+10))&&(new_data(i)>new_data(i+11))&&(new_data(i)>new_data(i+12))&&(new_data(i)>new_data(i+13))&&(new_data(i)>new_data(i+14))&&(new_data(i)>new_data(i+15))&&(new_data(i)>new_data(i+16))&&(new_data(i)>new_data(i+17))&&(new_data(i)>new_data(i+18))&&(new_data(i)>new_data(i+19))&&(new_data(i)>new_data(i+20))))
         findpeaks_time_domain_max_min(1,p)=i;
         plot(i,new_data(i),'ok');hold on %对找到的峰值画圈圈
         p=p+1;
      end
end