function [statistics_array_2D,statistics_array] = HR_calculate5( original_interval )

    %----------------------原始间隔分类--------二维数组-----------
    original_interval2=original_interval;
    statistics_array=zeros(1,length(original_interval));%长度
    statistics_array_2D=[];
    for i=1:length(original_interval)-1
        for j=1:length(original_interval)-1  %由于每个数都包含一次自身，所以实际结果要减1，但是单纯找最大数的话是没必要的
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
    
    
  %{

    statistics_array_2D_num_average=[];
    statistics_array_2D_sum=sum(statistics_array_2D,2);%对矩阵行元素求和，中间的0也加起来，后面只除统计数
    statistics_array_2D_num=sum(statistics_array_2D~=0,2);%返回列向量，代表矩阵中行非零元素的个数
    for i=1:row_n1
        statistics_array_2D_num_average(1,i)=statistics_array_2D_sum(i)/statistics_array_2D_num(i);
    end
    %至此就得到了statistics_array_2D的每行的平均值，可以直接用该间隔计算心率

    %----------------------原始间隔连续性--------二维数组-----------
    flag_2D=zeros(row_n1,column_n1);
    for i=1:row_n1
        t=1;
        for j=1:column_n1
             if (statistics_array_2D(i,j)>0) %大于0才开始判断
                   flag_2D(i,t)=flag_2D(i,t)+1;%连续的所以要加1
             end
             if (j>1)&&(statistics_array_2D(i,j-1)>0)&&(statistics_array_2D(i,j)==0)
                 t=t+1;
             end
        end
    end
    %all(flag_black==0,1);%返回一个行向量，用1表示是否为全零列
    flag2_2D=flag_2D;
    flag2_2D(:,all(flag2_2D==0,1))=[];%删除全零列


    max_flag2=[];
    for i=1:row_n1
       max_flag2(i)=max(flag2_2D(i,:)); %得到每行自己的最大值，比如2，2这种连续又分段的情况下
    end
    %比较每行的最大值，得到最大值
    for i=1:length(max_flag2)
        [a_max_flag,b_max_flag]=max(max_flag2);
    end
    %然后是通过索引找到对应的间隔行
    max_flag_value=statistics_array_2D_num_average(b_max_flag);

    
    %}
    
    
end

