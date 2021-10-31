
clc;
close all;
clear all;
%删除所有已经打开的串口，这条很重要，防止之前运行没有关闭串口
delete(instrfindall);

s=serial('com5');
%s=serial('com12');
set(s,'BaudRate',115200,'DataBits',8,'StopBits',1,'Parity','none','FlowControl','none');
s.ReadAsyncMode = 'continuous';
s.InputBufferSize =1000;%Byte  550022Byte
% s.BytesAvailableFcnMode='byte';%中断触发事件为‘bytes-available Event’g
% s.BytesAvailableFcnCount=66;%接收缓冲区每收到33个字节时，触发回调函数
% s.BytesAvailableFcn={@instrcallback};%得到回调函数句柄

%s.BytesAvailableFcn={@EveBytesAvailableFcn,handles};%回调函数的指定
fopen(s);
fig = figure(1);


AxisMax =  1.8;    %坐标轴最大值
AxisMin = -1.8;    %坐标轴最小值


% AxisMax =  2;    %坐标轴最大值
% AxisMin = -1;    %坐标轴最小值
window_width = 8000;  %窗口宽度

data_512 = 0;        %512代求数组   满512点稳定点后计算心率
%data_1024 = 0;       %1024代求数组  满1024稳定点后计算呼吸率
data_512_status = 0; %data_512数组状态 0为空 1为一半 2为满  满后用于心率的计算
%data_1024_status = 0; %用于呼吸率的数组
heart_value =0;      %心率实际值
breath_value=0;      %呼吸率实际值
aftermath=0;        %上一次为体动标志

g_Count =0;          %接收到的数据计数
SOF = 0;             %同步帧标志

AxisValue = 1;       %坐标值
RecDataDisp = zeros(1,100000,'double'); %开辟100000个数据单元，用于存储接收到的数据。
RecData = zeros(1,100,'double');        %开辟100个数据单元，用于数据处理。
Axis = zeros(1,100000);                 %开辟100000个数据单元，用于X轴。
heartrate_meter=zeros(1,1000,'double'); %用于存储心跳表格plot(RecDataDisp(1:52000))
heartrate_count = 1;                    %用来记录心跳个数
count_512_flag=0;
                                                              

count_256 = 0;%用来记录256/512数据的个数

window = window_width * (-0.9); %窗口X轴起始坐标
axis([window, window + window_width, AxisMin, AxisMax]); %设置窗口坐标范围

%float是4个字节，Windows系统里面，每行结尾是“<回车><换行>”，即“ \r\n”
while ishandle(fig)
    %设置同步信号标志， = 1表示接收到下位机发送的同步帧
    SOF = 0; 

    if(s.BytesAvailable>=176)
        for i=1:16
            RecData(1,i)=str2double(fscanf(s));
        end
    %RecData=fscanf(s,'%f',[1,66]);%从设备对象s中读入10*100个数据填充到数组A[10,100]中，并以整型数据格式存放。这个语句是没用的！！！！
    %RecData=fread(s,6,'double');%这个方法其实是算可以的，但是前期第一次会报错。而且转换得到的数据并不正确，要搭配 if(s.BytesAvailable>=66)使用
        SOF =1;
    end
    
    %更新接收到的数据波形
if(SOF == 1)
    %更新数据
    RecDataDisp(AxisValue) =  RecData(1);
    RecDataDisp(AxisValue + 1) =  RecData(2);
    RecDataDisp(AxisValue + 2) =  RecData(3);
    RecDataDisp(AxisValue + 3) =  RecData(4);
    RecDataDisp(AxisValue + 4) =  RecData(5);
    RecDataDisp(AxisValue + 5) =  RecData(6);
    RecDataDisp(AxisValue + 6) =  RecData(7);
    RecDataDisp(AxisValue + 7) =  RecData(8);
    RecDataDisp(AxisValue + 8) =  RecData(9);
    RecDataDisp(AxisValue + 9) =  RecData(10);
    RecDataDisp(AxisValue + 10) =  RecData(11);
    RecDataDisp(AxisValue + 11) =  RecData(12);
    RecDataDisp(AxisValue + 12) =  RecData(13);
    RecDataDisp(AxisValue + 13) =  RecData(14);
    RecDataDisp(AxisValue + 14) =  RecData(15);
    RecDataDisp(AxisValue + 15) =  RecData(16);


    %更新X轴
    Axis(AxisValue) = AxisValue;
    Axis(AxisValue + 1) = AxisValue + 1;
    Axis(AxisValue + 2) = AxisValue + 2;
    Axis(AxisValue + 3) = AxisValue + 3;
    Axis(AxisValue + 4) = AxisValue + 4;
    Axis(AxisValue + 5) = AxisValue + 5;
    Axis(AxisValue + 6) = AxisValue + 6;
    Axis(AxisValue + 7) = AxisValue + 7;
    Axis(AxisValue + 8) = AxisValue + 8;
    Axis(AxisValue + 9) = AxisValue + 9;
    Axis(AxisValue + 10) = AxisValue + 10;
    Axis(AxisValue + 11) = AxisValue + 11;
    Axis(AxisValue + 12) = AxisValue + 12;
    Axis(AxisValue + 13) = AxisValue + 13;
    Axis(AxisValue + 14) = AxisValue + 14;
    Axis(AxisValue + 15) = AxisValue + 15;

    %更新变量
    AxisValue = AxisValue + 16;
    g_Count = g_Count + 16;

    %绘制波形

    plot(Axis(1:AxisValue-1),  RecDataDisp(1:AxisValue-1), 'r');
    window = window + 16;
    axis([window, window + window_width, AxisMin, AxisMax]);
    grid on;
    drawnow
    %disp([num2str(AxisValue),'.',num2str(g_Count),'.',num2str(length(nonzeros(RecDataDisp)))]);
    %disp(s.InputBufferSize);
end

%-----------------------------------------------------------------------
%------------------------------------计算-------------------------------
%-----------------------------------------------------------------------
%说明：一共是三个部分，体动/离床/数据分析、只有连续四次进入else，才会有一次呼吸率计算
%也就是数，凡是进入if或者elseif，都会中段呼吸数据的记录
if(g_Count==256)
    %data=[];
    data=RecDataDisp(AxisValue-256:AxisValue-1);%得到data_256数据
    %-------------------离床判断--------------------%
    average_data = mean(data);%该组数的平均值
    max_differencee = max(data)-min(data);%该组数的最大差值
    if(average_data>=1.5)
        disp('离床');
        if(data_512_status == 1)%data_512前半段有数据，但是未填的后半段是离床
            data_512(1:256)=[];
            data_512_status = 0;%那么data_512就要清除前半段，并把状态清零
        end
    elseif(max_differencee>0.2000)%如果电压最大差值大于~的话，就判定为体动
        disp('体动');
        if(data_512_status == 1)%data_512前半段有数据，但是未填的后半段是体动
            data_512(1:256)=[];
            data_512_status = 0;%那么data_512就要清除前半段，并把状态清零
        end
    else
        %既不是体动又不是离床的话
        switch data_512_status
            case 0
                data_512(1:256)=data;%为0的话，就存入data_512数组前半段
                data_512_status=1;
            case 1
                data_512(257:512)=data;%存入data_512数组后半段
                [ flag,heartrate_value ] = function_synthesize_arithmetic_B( data_512 );
                %data_512_status = 0;%这里1是需要对这个buffer进行清除，2是需要存到data_1024数组
                if flag~=0
                        disp(['心率 ',num2str(heartrate_value),'      ',num2str(flag)])
                else
                    disp('NG ');
                end
                
                %把本次的(257:512)数据重新作为下一个5s的前半部分数据保存下来
                data_512(1:256)=data;
                data_512_status=1;
            otherwise
                disp('other value');
        end
    end
    g_Count=0;
end
end


fclose(s);%关闭串口设备对象                                                        
delete(s);%删除内存中串口设备对象
clear s;%清除工作空间中串口设备对象


