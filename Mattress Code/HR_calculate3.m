function [original_interval] = HR_calculate3( new_findpeaks_time_domain_max_min )
%HR_calculate 此处显示有关此函数的摘要
    %-------------------------计算后一个点与前一个点的原始间隔--------------------
    peaks_count=length(new_findpeaks_time_domain_max_min);
    original_interval=[];
    for i=1:(peaks_count-1) %n个峰值的话，只要做n-1次减计算就可以了
        original_interval(1,i)=(new_findpeaks_time_domain_max_min(1,i+1)-new_findpeaks_time_domain_max_min(1,i))-1;%这里减1是为了得到峰之间的间隔
    end
end

