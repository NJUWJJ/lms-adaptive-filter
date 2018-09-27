close  all
Fs = 200000;    % sampling rate ,200kHz
w = 2*pi/Fs;    % omega = 2*pi/Fs
% 周期信号的产生 
t=0:9999999;
xs=5*sin(w*10000*t);
figure;
subplot(2,1,1);
plot(t,xs);grid;
ylabel('幅值');
title('输入周期性信号');

% 噪声信号的产生
t=0:9999999;
xn=3*sin(w*10100*t);
subplot(2,1,2);
plot(t,xn);grid;
ylabel('幅值');
xlabel('时间');
title('随机噪声信号');

% 信号滤波
xn = xs+xn;
xn = xn.' ;   % 输入信号序列
dn = xs.' ;   % 预期结果序列
M  = 49 ;   % 滤波器的阶数

% rho_max = max(eig(xn*xn.'));   % 输入信号相关矩阵的最大特征值
% mu = (1/rho_max) ;    % 收敛因子 0 < mu < 1/rho
mu=0.0001
itr = length(xn);
en = zeros(itr,1);             % 误差序列,en(k)表示第k次迭代时预期输出与实际输入的误差
W  = zeros(M,itr);             % 每一行代表一个加权参量,每一列代表-次迭代,初始为0
% 迭代计算
for k = M:itr                  % 第k次迭代
    x = xn(k:-1:k-M+1);        % 滤波器M个抽头的输入
    y = W(:,k-1).' * x;        % 滤波器的输出
    en(k) = dn(k) - y ;        % 第k次迭代的误差
    % 滤波器权值计算的迭代式
    W(:,k) = W(:,k-1) + 2*mu*en(k)*x;
end
% 求最优时滤波器的输出序列  r如果没有yn返回参数可以不要下面的
yn = inf * ones(size(xn)); % inf 是无穷大的意思
for k = M:length(xn)
    x = xn(k:-1:k-M+1);
    yn(k) = W(:,end).'* x;%用最后得到的最佳估计得到输出
end

% 绘制滤波器输入信号
figure;
subplot(2,1,1);
plot(t,xn);grid;
ylabel('幅值');
xlabel('时间');
title('滤波器输入信号');

% 绘制自适应滤波器输出信号
subplot(2,1,2);
plot(t,yn);grid;
ylabel('幅值');
xlabel('时间');
title('自适应滤波器输出信号');

% 绘制自适应滤波器输出信号,预期输出信号和两者的误差
figure 
plot(t,en,'g');grid;
legend('预期输出');
ylabel('幅值');
xlabel('时间');
title('自适应滤波器');

 