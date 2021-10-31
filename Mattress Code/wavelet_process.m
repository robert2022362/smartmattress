function [ new_data ] = wavelet_process( data , t ,para)
%WAVELET_PROCESS 小波通用预处理函数
%   此处显示详细说明
    o=lower(para);
	n=9;%level 9
    [c,l] = wavedec(data,n,o);
    [cd1,cd2,cd3,cd4,cd5,cd6,cd7,cd8,cd9]=detcoef(c,l,[1 2 3 4 5 6 7 8 9]);
    a=[max(cd1) max(cd2) max(cd3) max(cd4) max(cd5) max(cd6) max(cd7) max(cd8) max(cd9)];%得到每组系数的最多大值，也就是波峰作为最大阈值
    if t==1
        thr2=[a(1) a(2) a(3) a(4) a(5) a(6) 0.000 0.000 0.00];%出体动
    else
        thr2=[a(1) a(2) a(3) a(4) a(5) 0.00 0.000 0.000 0.00];%出体动
    end
    cxc = wthcoef('t',c,l,1:n,thr2,'s');%N and T must be the same length
    lxc = l;
    xc = waverec(cxc,lxc,o);% Wavelet reconstruction of xd.
    new_data=data-xc;
end

