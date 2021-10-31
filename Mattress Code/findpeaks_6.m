function [ findpeaks_time_domain_max_min ] = findpeaks_6( new_data)
%FINDPEAKS6 此处显示有关此函数的摘要

p=1;
for i=7:203%正常取31，高通后取66    
    if(((new_data(i)>new_data(i-1))&&(new_data(i)>new_data(i-2))&&(new_data(i)>new_data(i-3))&&(new_data(i)>new_data(i-4))&&(new_data(i)>new_data(i-5))&&(new_data(i)>new_data(i-6)))&&...
        ((new_data(i)>new_data(i+1))&&(new_data(i)>new_data(i+2))&&(new_data(i)>new_data(i+3))&&(new_data(i)>new_data(i+4))&&(new_data(i)>new_data(i+5))&&(new_data(i)>new_data(i+6))))
%     if(new_data(i)>30)
        %plot(f(i),Mag(i),'ok');hold on             %对找到的峰值画圈圈 
        findpeaks_time_domain_max_min(1,p)=i;
         p=p+1;
    end
end
if p==1
    findpeaks_time_domain_max_min(1,1)=1;
end
end

