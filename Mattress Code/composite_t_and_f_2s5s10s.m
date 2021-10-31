% Close graphics handles and clear
% variables from previous sessions
close all;
clear all;
delete(instrfindall);

% Test USB serial ports
% Note** Use "serialportlist" command to find list of available
% serial ports when testing on different devices
try
    % Note** Transmitting and receiving devices require the
    % same configurations
    % TODO** "serial" function will be deprecated in
    % future versions of MATLAB, use "serialport" function 
    % instead
    s=serial('/dev/tty.usbserial-1120','BaudRate',115200,'DataBits',8,'StopBits',1,'Parity','none','FlowControl','none');
    s.ReadAsyncMode="continuous";
    s.InputBufferSize=1024;
    fopen(s);
catch
    try
        s=serial('/dev/tty.usbserial-130','BaudRate',115200,'DataBits',8,'StopBits',1,'Parity','none','FlowControl','none');
        s.ReadAsyncMode="continuous";
        s.InputBufferSize=1024;
        fopen(s);
    catch
        try
            s=serial('/dev/tty.usbserial-120','BaudRate',115200,'DataBits',8,'StopBits',1,'Parity','none','FlowControl','none');
            s.ReadAsyncMode="continuous";
            s.InputBufferSize=1024;
            fopen(s);
        catch
            warning("Neither USB ports are connected.");
            return
        end
    end
end

lowerBound=-3999;
upperBound=4000;

% Initialize plots
fig1=figure("OuterPosition",[500,200,1200,800]);
ax1=subplot(1,2,1,"NextPlot","replacechildren","XGrid","on","YGrid","on","XLim",[lowerBound,upperBound],"YLim",[-1.8,1.8]);
title(ax1,"Light Intensity vs Timestep");
xlabel(ax1,"Timestep");
ylabel(ax1,"Light Intensity");
% ax2=subplot(1,2,2,"NextPlot","replacechildren","XGrid","on","YGrid","on","XLim",[lowerBound,upperBound],"YLim",[20,270]);
% title(ax2,"Heart and Respiration Rate vs Timestep");
% xlabel(ax2,"Timestep");
% ylabel(ax2,"Heart and Respiration Rate");

data = [];

% heartRate = 0;
% respirationRate = 0;

byteCount = 0;
batchCount = 0;
batchNum=0;
batchSize = 300;
bytes=128;
interval=2048;

timeStep = 1;
fiberData = zeros(4,batchSize*interval,"double");
% mask = zeros(4,batchSize*interval,"double");
% heartRateData = zeros(4,batchSize);
% respirationRateData = zeros(4,batchSize);
Axis=zeros(1,batchSize*interval);

path="/Users/RobertYangSun/Desktop/Dr. Mani Research/Data/";

% Main loop
while ishandle(fig1)
    
    % Write data to file
    if batchCount==batchSize
        c=clock;
        time="";
        for i=1:3
            time=time+c(i)+"-";
        end
        time=time+c(4);
        writematrix(fiberData,path+"fiber_data_"+time+".csv");
%         writematrix(mask,path+"mask_data_"+time+".csv");
%         writematrix(heartRateData,path+"heart_rate_data_"+time+".csv");
%         writematrix(respirationRateData,path+"respiration_rate_data_"+time+".csv");
        
        timeStep = 1;
        lowerBound=-3999;
        upperBound=4000;
        batchCount = 0;
        fiberData = zeros(4,batchSize*interval,"double");
%         mask = zeros(4,batchSize*interval,"double");
%         heartRateData = zeros(4,batchSize,"double");
%         respirationRateData = zeros(4,batchSize,"double");
        Axis=zeros(1,batchSize*interval,"double");
    end
    
    if(s.BytesAvailable>=176)
        for i=1:bytes
            c=fix(clock);
            fiberData(4,timeStep+i-1)=str2double(fscanf(s));
            fiberData(1:3,timeStep+i-1)=c(4:6);
%             mask(1:3,timeStep+i-1)=c(4:6);
            Axis(timeStep+i-1)=timeStep+i-1;
        end
        
        data=fiberData(4,timeStep:timeStep+bytes-1);
        
%         average_data = mean(data);
%         max_difference = max(data)-min(data);
        
        timeStep = timeStep + bytes;
        lowerBound = lowerBound + bytes;
        upperBound = upperBound + bytes;
        byteCount = byteCount + bytes;

        plot(ax1,Axis(1:timeStep-1),fiberData(4,1:timeStep-1),'r');
        axis(ax1,[lowerBound,upperBound,-1.8,1.8]);
%         axis(ax2,[lowerBound,upperBound,20,270]);
        drawnow
        
%         if(average_data>=1.5)
%             disp("Off Bed");
%             mask(4,timeStep-bytes:timeStep)=1;
%         elseif(max_difference>=1)
%             disp("Body Movement");
%             mask(4,timeStep-bytes:timeStep)=1;
%         end

    end
    
    if(byteCount==interval)
        batchCount = batchCount + 1;
% 
%         data=fiberData(timeStep-interval:timeStep-1);
% 
%         heartRate=function_synthesize_arithmetic_2048_5(data);
%         respirationRate=round(function_breathprocess(data));
% 
%         c=fix(clock);
%         heartRateData(1:3,batchCount)=c(4:6);
%         heartRateData(4,batchCount)=heartRate;
%         respirationRateData(1:3,batchCount)=c(4:6);
%         respirationRateData(4,batchCount)=respirationRate;
% 
%         disp(['HR: ',num2str(heartRate),', ','RR: ',num2str(respirationRate)]);
%         
%         plot(ax2,Axis(1:interval:timeStep-1),heartRateData(1:batchCount),'r');
%         hold on
%         plot(ax2,Axis(1:interval:timeStep-1),respirationRateData(1:batchCount),'b');
%         legend(ax2,"Heart Rate","Respiration Rate");
%         drawnow
%         
        byteCount=0; 
     end
end

fclose(s);
delete(s);
clear