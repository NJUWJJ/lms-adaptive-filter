close  all
Fs = 200000;    % sampling rate ,200kHz
w = 2*pi/Fs;    % omega = 2*pi/Fs
% �����źŵĲ��� 
t=0:9999999;
xs=5*sin(w*10000*t);
figure;
subplot(2,1,1);
plot(t,xs);grid;
ylabel('��ֵ');
title('�����������ź�');

% �����źŵĲ���
t=0:9999999;
xn=3*sin(w*10100*t);
subplot(2,1,2);
plot(t,xn);grid;
ylabel('��ֵ');
xlabel('ʱ��');
title('��������ź�');

% �ź��˲�
xn = xs+xn;
xn = xn.' ;   % �����ź�����
dn = xs.' ;   % Ԥ�ڽ������
M  = 49 ;   % �˲����Ľ���

% rho_max = max(eig(xn*xn.'));   % �����ź���ؾ�����������ֵ
% mu = (1/rho_max) ;    % �������� 0 < mu < 1/rho
mu=0.0001
itr = length(xn);
en = zeros(itr,1);             % �������,en(k)��ʾ��k�ε���ʱԤ�������ʵ����������
W  = zeros(M,itr);             % ÿһ�д���һ����Ȩ����,ÿһ�д���-�ε���,��ʼΪ0
% ��������
for k = M:itr                  % ��k�ε���
    x = xn(k:-1:k-M+1);        % �˲���M����ͷ������
    y = W(:,k-1).' * x;        % �˲��������
    en(k) = dn(k) - y ;        % ��k�ε��������
    % �˲���Ȩֵ����ĵ���ʽ
    W(:,k) = W(:,k-1) + 2*mu*en(k)*x;
end
% ������ʱ�˲������������  r���û��yn���ز������Բ�Ҫ�����
yn = inf * ones(size(xn)); % inf ����������˼
for k = M:length(xn)
    x = xn(k:-1:k-M+1);
    yn(k) = W(:,end).'* x;%�����õ�����ѹ��Ƶõ����
end

% �����˲��������ź�
figure;
subplot(2,1,1);
plot(t,xn);grid;
ylabel('��ֵ');
xlabel('ʱ��');
title('�˲��������ź�');

% ��������Ӧ�˲�������ź�
subplot(2,1,2);
plot(t,yn);grid;
ylabel('��ֵ');
xlabel('ʱ��');
title('����Ӧ�˲�������ź�');

% ��������Ӧ�˲�������ź�,Ԥ������źź����ߵ����
figure 
plot(t,en,'g');grid;
legend('Ԥ�����');
ylabel('��ֵ');
xlabel('ʱ��');
title('����Ӧ�˲���');

 