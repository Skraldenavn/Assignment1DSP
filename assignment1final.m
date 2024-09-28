% a)
% Clean 1000 Hz wave
% Sampling frequency at 50 kHz(samples 50000 times per second)
fs = 50000;
% Amplitude of 1(wave wont go above 1 or below -1)
A = 1;
% Time vector that goes from 0 to 1(duration)-1/50000 and steps each 1/50000. Defines the time axis
t = 0:1/fs:1-1/fs; % Could be used with step 2/fs to half samples
% Frequency (number of cycles per second)
f = 1000;
% Sinusoidal signal
y = A * sin(2 * pi * f * t);

% Import my recorded audio file. File must be in same folder as script.
[yRec, fsRec] = audioread('iii.wav');

% File is too long, shorten it to a duration of 1 second ish to match the signal.
yRec = yRec(1:fsRec*1,:); 

% Resample to ensure it is the same as our sample frequency from the clean signal. Makes everything easier to 
% work with and makes sense to compare signals on the same sampling frequency.
yRec = resample(yRec,fs,fsRec); 

% Time vector. We have ensured same frequency and duration of file so time vector is essentially the exact same
tRec = t;

% Normalise to match amplitude of 1 at one point and scale remaining points accordingly
yRecNorm = yRec / max(abs(yRec));

% Plot it all
figure;
plot(t,y, 'b',tRec,yRecNorm, 'r');
xlabel('Time (s)');
ylabel('Amplitude');
title('1000 Hz clean signal compared to normalised iii sound from me');
grid on;
legend('Clean 1000Hz signal', 'Recording of iiiii');
ylim([-1.1 1.1]);
xlim([0.21 0.22]);
% My attempt needed to be higher pitched to try and match the frequency of the 1000 Hz sine wave.
% Several attempts but voice wouldn't go any higher.

% b) recreate the signal on the paper
% We assign a yLen variable to be able to set frequency resolution by reducing number of samples. This takes
% us from 50000 to 25000.
yLen = length(y)/2;

% Frequency resolution = fs/yLen and we need = 2 Hz. we take values from idx 1 to 50000/2 as new signal. 
% truncating like this could give some issues(artifacts) but seems fine.
y = y(1:yLen); 

% Matlab fft function computes the fast fourier transform of the signal
yftt = fft(y); 

% Convert complex value(amplitude, phase) to its absolute value(magnitude) and divide by signal length to normalise.
P2 = abs(yftt/yLen);

% P2 is symmetric around midpoint so we only need one half. We choose 1st half, 2nd half is therefore redundant.
% and slice out DC-component
P1 = P2(1:yLen/2+1);

% Defining our frequency domain. Each val in 0-12500 multiplied by sampling freq and divided by length of signal.
fDom = fs*(0:(yLen/2))/yLen;

% Convert to dB with a ratio of 20 for plotting
dBconv = 20*log10(P1); 

% Repeat for audio signal
yRecLen = length(yRec)/2;
yRec = yRec(1:yRecLen); 
yRecftt = fft(yRec);

P2Rec = abs(yRecftt/yRecLen);
P1Rec = P2Rec(1:yRecLen/2+1);

fDomRec = fs*(0:(yRecLen/2))/yRecLen; %fsRec or fs? fs cause of resample

dBconvRec = 20*log10(P1Rec);

figure; % Create a plot for the frequency-domain
plot(fDom, dBconv,'b',fDomRec, dBconvRec,'r');
xlabel('Frequency (Hz)');
ylabel('Magnitude (a.u., dB)');
title('Spectrum of 1000 Hz Sinusoidal Signal and signal from recording');
grid on;
legend('Clean 1000Hz signal', 'Recording of iiiii');
xlim([0 3000]);