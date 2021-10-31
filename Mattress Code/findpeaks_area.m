function [ findpeaks_time_domain_max_min ] = findpeaks_area( new_data)
%FINDPEAKS6 此处显示有关此函数的摘要
    p=1;
    for i=10:200
        if(((new_data(i)>=new_data(i-1))&&(new_data(i)>=new_data(i-2))&&(new_data(i)>new_data(i-3))&&(new_data(i)>new_data(i-4))&&(new_data(i)>new_data(i-5))&&(new_data(i)>new_data(i-6))&&(new_data(i)>new_data(i-7))&&(new_data(i)>new_data(i-8))&&(new_data(i)>new_data(i-9)))&&...
            ((new_data(i)>=new_data(i+1))&&(new_data(i)>=new_data(i+2))&&(new_data(i)>new_data(i+3))&&(new_data(i)>new_data(i+4))&&(new_data(i)>new_data(i+5))&&(new_data(i)>new_data(i+6))&&(new_data(i)>new_data(i+7))&&(new_data(i)>new_data(i+8))&&(new_data(i)>new_data(i+9))))
             findpeaks_time_domain_max_min(1,p)=i;
             p=p+1;
        end
    end
end


