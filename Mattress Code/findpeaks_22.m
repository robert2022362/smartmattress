function [ findpeaks_time_domain_max_min ] = findpeaks_22( new_data,para,max_limit)
%FINDPEAKS6 此处显示有关此函数的摘要

    if para==1
        
        p=1;
        for i=23:max_limit%正常取31，高通后取66
            if(((new_data(i)>new_data(i-1))&&(new_data(i)>new_data(i-2))&&(new_data(i)>new_data(i-3))&&(new_data(i)>new_data(i-4))&&(new_data(i)>new_data(i-5))&&(new_data(i)>new_data(i-6))&&(new_data(i)>new_data(i-7))&&(new_data(i)>new_data(i-8))&&(new_data(i)>new_data(i-9))&&(new_data(i)>new_data(i-10))&&(new_data(i)>new_data(i-11))&&(new_data(i)>new_data(i-12))&&(new_data(i)>new_data(i-13))&&(new_data(i)>new_data(i-14))&&(new_data(i)>new_data(i-15))&&(new_data(i)>new_data(i-16))&&(new_data(i)>new_data(i-17))&&(new_data(i)>new_data(i-18))&&(new_data(i)>new_data(i-19))&&(new_data(i)>new_data(i-20))&&(new_data(i)>new_data(i-21))&&(new_data(i)>new_data(i-22)))&&...
                ((new_data(i)>new_data(i+1))&&(new_data(i)>new_data(i+2))&&(new_data(i)>new_data(i+3))&&(new_data(i)>new_data(i+4))&&(new_data(i)>new_data(i+5))&&(new_data(i)>new_data(i+6))&&(new_data(i)>new_data(i+7))&&(new_data(i)>new_data(i+8))&&(new_data(i)>new_data(i+9))&&(new_data(i)>new_data(i+10))&&(new_data(i)>new_data(i+11))&&(new_data(i)>new_data(i+12))&&(new_data(i)>new_data(i+13))&&(new_data(i)>new_data(i+14))&&(new_data(i)>new_data(i+15))&&(new_data(i)>new_data(i+16))&&(new_data(i)>new_data(i+17))&&(new_data(i)>new_data(i+18))&&(new_data(i)>new_data(i+19))&&(new_data(i)>new_data(i+20))&&(new_data(i)>new_data(i+21))&&(new_data(i)>new_data(i+22))))
                 findpeaks_time_domain_max_min(1,p)=i;
                 p=p+1;
            end
        end
    elseif para==0
        
        p=1;
        for j=23:max_limit%正常取31，高通后取66
            if(((new_data(j)<new_data(j-1))&&(new_data(j)<new_data(j-2))&&(new_data(j)<new_data(j-3))&&(new_data(j)<new_data(j-4))&&(new_data(j)<new_data(j-5))&&(new_data(j)<new_data(j-6))&&(new_data(j)<new_data(j-7))&&(new_data(j)<new_data(j-8))&&(new_data(j)<new_data(j-9))&&(new_data(j)<new_data(j-10))&&(new_data(j)<new_data(j-11))&&(new_data(j)<new_data(j-12))&&(new_data(j)<new_data(j-13))&&(new_data(j)<new_data(j-14))&&(new_data(j)<new_data(j-15))&&(new_data(j)<new_data(j-16))&&(new_data(j)<new_data(j-17))&&(new_data(j)<new_data(j-18))&&(new_data(j)<new_data(j-19))&&(new_data(j)<new_data(j-20))&&(new_data(j)<new_data(j-21))&&(new_data(j)<new_data(j-22)))&&...
                ((new_data(j)<new_data(j+1))&&(new_data(j)<new_data(j+2))&&(new_data(j)<new_data(j+3))&&(new_data(j)<new_data(j+4))&&(new_data(j)<new_data(j+5))&&(new_data(j)<new_data(j+6))&&(new_data(j)<new_data(j+7))&&(new_data(j)<new_data(j+8))&&(new_data(j)<new_data(j+9))&&(new_data(j)<new_data(j+10))&&(new_data(j)<new_data(j+11))&&(new_data(j)<new_data(j+12))&&(new_data(j)<new_data(j+13))&&(new_data(j)<new_data(j+14))&&(new_data(j)<new_data(j+15))&&(new_data(j)<new_data(j+16))&&(new_data(j)<new_data(j+17))&&(new_data(j)<new_data(j+18))&&(new_data(j)<new_data(j+19))&&(new_data(j)<new_data(j+20))&&(new_data(j)<new_data(j+21))&&(new_data(j)<new_data(j+22))))
                 findpeaks_time_domain_max_min(1,p)=j;  
                 p=p+1;
            end
        end
    else
        
    end
end

