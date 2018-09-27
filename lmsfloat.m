%lms float simulation

close  all
Fs = 200000;  
w = 2*pi/Fs;    
% xs for the origin signal
t=0:9999999;
xs=5*sin(w*10000*t);
figure;
subplot(2,1,1);
plot(t,xs);grid;
ylabel('AMP');
title('ORIGINAL SIGNAL');

% xn for the noise signal
t=0:9999999;
xn=3*sin(w*10100*t);
subplot(2,1,2);
plot(t,xn);grid;
ylabel('AMP');
xlabel('TIME');
title('NOISE SIGNAL');

% generate the input signal
xn = xs+xn;
xn = xn.' ;   
dn = xs.' ;   
M  = 49 ;   % taps for filter

% rho_max = max(eig(xn*xn.'));  
% mu = (1/rho_max) ;    
mu=0.0001
itr = length(xn);
en = zeros(itr,1);             
W  = zeros(M,itr);             
% compute
for k = M:itr                  
    x = xn(k:-1:k-M+1);        % input of filter
    y = W(:,k-1).' * x;        % output of filter
    en(k) = dn(k) - y ;        % error for kth loop
    % renew w
    W(:,k) = W(:,k-1) + 2*mu*en(k)*x;
end
% final output signal
yn = inf * ones(size(xn)); 
for k = M:length(xn)
    x = xn(k:-1:k-M+1);
    yn(k) = W(:,end).'* x;
end

% draw input signal
figure;
subplot(2,1,1);
plot(t,xn);grid;
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

 