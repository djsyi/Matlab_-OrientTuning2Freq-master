function [a,b] = fftz(signal, sampling_freq)
X = signal;
X = detrend(X,0);
Fs = sampling_freq;
T = 1/Fs;             % Sampling period       
L = length(signal);             % Length of signal
t = (0:L-1)*T;        % Time vector

y = fft(X);

ly = length(y);
f = (-ly/2:ly/2-1)/ly*Fs;
a = abs(fftshift(y));

x1= f(f>0); % this is used for plotting the frequency values. 
y1 = a(f>0); % excluding the negative frequency values

x1 = x1(1:50)';
y1 = y1(1:50);

stem(x1,y1)
xlabel('Frequency (Hz)')


end

