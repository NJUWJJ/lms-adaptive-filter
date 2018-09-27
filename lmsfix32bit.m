%lms fixed point simulation

close all
Fs = 200000;    
w = 2*pi/Fs;    
% xs32 for the origin signal 
t=0:999999;
xs32=int32(5*sin(w*10000*t)*2^14);
figure;
subplot(2,1,1);
plot(t,xs32);grid;
ylabel('AMP');
title('ORIGINAL SIGNAL');

% xn32 for the noise signal
t=0:999999;
xn32=int32(3*sin(w*10100*t)*2^14);
subplot(2,1,2);
plot(t,xn32);grid;
ylabel('AMP');
xlabel('TIME');
title('NOISE SIGNAL');

% generate the input signal
xn32=xs32+xn32;
xn32=xn32.';
dn32=xs32.';
M  = 150;   % taps for filter

mu=0.0001;
mu32=int32(mu*2^16);
itr = length(xn32);
en = zeros(itr,1);             
W  = int32(zeros(M,itr));             
% compute
for k = M:itr                  
    x = xn32(k:-1:k-M+1);        % input of filter
    y=int32(0);
    for i=1:M
        y=y+W(i,k-1)*x(i,1)/2^14;% output of filter
    end
    en(k) = dn32(k) - int32(y);  % error for kth loop
    % renew W
    W(:,k) = W(:,k-1) + 2*mu32*en(k)*x/2^30;
end
% final output signal
yn = zeros(size(xn32));
for k = M:length(xn32)
    x = xn32(k:-1:k-M+1);
    for i=1:M
        yn(k,1)=yn(k,1)+W(i,end)*x(i,1)/2^24;
    end
end

% draw input signal
figure;
subplot(2,1,1);
plot(t,xn32);grid;
ylabel('AMP');
xlabel('TIME');
title('INPUT SIGNAL');

% draw output signal
subplot(2,1,2);
plot(t,yn);grid;
ylabel('AMP');
xlabel('TIMNE');
title('OUTPUT SIGNAL');

% draw error signal
figure 
plot(t,en);grid;
ylabel('AMP');
xlabel('TIME');
title('ERROR SIGNAL');

 