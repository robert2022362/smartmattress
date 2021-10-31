function [freq_interval_result,statistics_array_2D_freq_2 ] = AM_FREQ_1024_2( data )

%本程序，送进来的值，是已经经历过一次的间隔分类和间隔连续性比较的，所以肯定是不用再进行连续性比较的，只需要直接分类就可以了，

data2=data;%复制出来，避免元素被0替换后无法正常使用原数组
freq_count=length(data);
statistics_array_freq=zeros(1,freq_count);%长度是adiff_count
statistics_array_2D_freq_2=[];
for t_freq=1:freq_count
    for h_freq=1:freq_count  %由于每个数都包含一次自身，所以实际结果要减1，但是单纯找最大数的话是没必要的
        if(data2(1,h_freq)==0)%如果已经被归为0的话，就说明已经被比较过且被取走了
           continue 
        elseif(abs(data2(1,t_freq)-data2(1,h_freq))<2)
            statistics_array_freq(1,t_freq)=statistics_array_freq(1,t_freq)+1;%相近数统计值加1
            statistics_array_2D_freq_2(t_freq,h_freq)=data2(1,h_freq);
            %这里需要加一个二维数组，长度还是adiff_count,列的元素是相差为10内的数据
            if(t_freq~=h_freq)
                data2(1,h_freq)=0;%标注原数组adiff中已经被统计过(即小于本次10)的值
            end
        else
            %disp('no elements')
        end
    end
end
[row,column]=size(statistics_array_2D_freq_2);





%这部分是为了得到分类后每行的平均值
statistics_array_2D_freq_sum=sum(statistics_array_2D_freq_2,2);%对矩阵行元素求和，中间的0也加起来，后面只除统计数
statistics_array_2D_freq_num=sum(statistics_array_2D_freq_2~=0,2);%返回列向量，代表矩阵中行非零元素的个数
for i=1:row
    statistics_array_2D_freq_num_average(1,i)=statistics_array_2D_freq_sum(i)/statistics_array_2D_freq_num(i);
end

 
[~,b]=max(statistics_array_freq); %得到数量最多的那行
freq_interval_result=statistics_array_2D_freq_num_average(b);


end



