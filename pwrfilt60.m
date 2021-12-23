% 源信号参数定义
Fs=1e3; % 采样率1kHz

% 加载信号
load('voltagetestdata60hz.mat', 'openLoopVoltage');
y=openLoopVoltage;

% 绘制原始信号频谱
[P,F] = pwelch(y,ones(512,1),512/2,512,Fs,'power');
helperFilterIntroductionPlot1(F,P,[60 60],[-9.365 -9.365],...
  {'原始信号频谱', '60 Hz'});

% 滤波器参数定义
passbandFreqFloor=40;   % 通带下限
passbandFreqCeil=80;    % 通带上限
stopbandFreqFloor=59;   % 阻带下限
stopbandFreqCeil=61;    % 阻带上限
stopbandAttenuation=60; % 阻带衰减

% designfilt 设计滤波器
df = designfilt('bandstopiir',...
                'PassbandFrequency1',passbandFreqFloor,...
                'StopbandFrequency1',stopbandFreqFloor,...
                'StopbandFrequency2',stopbandFreqCeil,...
                'PassbandFrequency2',passbandFreqCeil,...
                'PassbandRipple1',1,...
                'StopbandAttenuation',stopbandAttenuation,...
                'PassbandRipple2',1,...
                'SampleRate',Fs,...
                'DesignMethod','butter');


% 绘制频率响应
hfvt = fvtool(df,'Fs',Fs,'FrequencyScale','log',...
  'FrequencyRange','Specify freq. vector','FrequencyVector',F(F>F(2)));

% 执行滤波操作
ybs = filtfilt(df,y);

% 绘制滤波后频谱
[P2,F2] = pwelch(ybs,ones(512,1),512/2,512,Fs,'power');
helperFilterIntroductionPlot1(F2,P2,[60 60],[-9.365 -9.365],...
  {'滤波后信号频谱', '60 Hz'});
