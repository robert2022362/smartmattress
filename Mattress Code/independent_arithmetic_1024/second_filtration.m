function [ new_findpeaks_time_domain_min ] = second_filtration( new_data ,findpeaks_time_domain_min, peaks_count_min )
%SECOND_FILTRATION
    p=1;
    for i=1:peaks_count_min
        if(i==1)                    %判断第一个是否应该留下
            diff_value_right=new_data(findpeaks_time_domain_min(1))/new_data(findpeaks_time_domain_min(2));
            %如果第一个峰点与第二个峰点的比值是小于0.7的话，说明(第一个峰点)就是应该被删除的点了，与此同时间隔也应该要小于60才对
            if((abs(findpeaks_time_domain_min(2)-findpeaks_time_domain_min(1))<60)&&(diff_value_right<0.7))
                continue
            else
                new_findpeaks_time_domain_min(p)=findpeaks_time_domain_min(i);%如果上面两个条件都不满足的话，就保留
                p=p+1;
            end
        elseif(i==peaks_count_min)  %判断最后一个是否应该留下
            diff_value_left=new_data(findpeaks_time_domain_min(i))/new_data(findpeaks_time_domain_min(i-1));
            %如果最后一个峰点与倒数第二个峰点的比值小于0.7的话，说明(最后一个峰点)就应该是被删除的点了，与此同时间隔也应该要小于60才对
            if((abs(findpeaks_time_domain_min(i)-findpeaks_time_domain_min(i-1))<60)&&(diff_value_left<0.7))
                continue
            else
                new_findpeaks_time_domain_min(p)=findpeaks_time_domain_min(i);%如果上面两个条件都不满足的话，就保留
                p=p+1;
            end
        else                        %其它的中间点
            diff_value_left=new_data(findpeaks_time_domain_min(i))/new_data(findpeaks_time_domain_min(i-1));
            diff_value_right=new_data(findpeaks_time_domain_min(i))/new_data(findpeaks_time_domain_min(i+1 ));
            if((abs(findpeaks_time_domain_min(i)-findpeaks_time_domain_min(i-1))<60)&&(diff_value_left<0.7))||((abs(findpeaks_time_domain_min(i)-findpeaks_time_domain_min(i+1))<60)&&(diff_value_right<0.7))
                continue
            else
                new_findpeaks_time_domain_min(p)=findpeaks_time_domain_min(i);%如果上面两个条件都不满足的话，就保留
                p=p+1;
            end
        end
    end


end

