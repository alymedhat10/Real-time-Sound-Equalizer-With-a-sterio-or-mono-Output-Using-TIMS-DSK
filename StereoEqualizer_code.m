clc;
clear all;
close all;

[in_sound, Fs] = audioread('test.WAV');     %load a sound and store the amplitude, sampling rate and the number of bits
Ts = 1/Fs;                                  %calculating the periodic time of the input stereo
N = length(in_sound);  
df = Fs/N;
f = df*[0:1:N-1];

%LOWPASS FIlter
[Lnum, Lden] = butter(3,64/(Fs/2), 'low');   %LPF with order = 3, cutoff freq= 64
Lpf = filter(Lnum,Lden,in_sound);
Lpf_fft = abs(fft(Lpf));
Lpf_dB = 20*log10(Lpf_fft);


%BANDPASS Filters
% 64Hz to 500Hz
[Hznum_64, Hzden_64] = butter(2,[64 500]/(Fs/2), 'bandpass');
bp_64 = filter(Hznum_64,Hzden_64,in_sound);
bp_64_fft = abs(fft(bp_64));
bp_64_dB = 20*log10(bp_64_fft);

% 500Hz to 1000Hz
[Hznum_500, Hzden_500] = butter(5,[500 1000]/(Fs/2), 'bandpass');
bp_500 = filter(Hznum_500,Hzden_500,in_sound);
bp_500_fft = abs(fft(bp_500));
bp_500_dB = 20*log10(bp_500_fft);

% 1000Hz to 4000Hz
[Hznum_1000, Hzden_1000] = butter(6,[1000 4000]/(Fs/2), 'bandpass');
bp_1000 = filter(Hznum_1000,Hzden_1000,in_sound);
bp_1000_fft = abs(fft(bp_1000));
bp_1000_dB = 20*log10(bp_1000_fft);

% 4000Hz to 8000HZ
[Hznum_4000, Hzden_4000] = butter(14,[4000 8000]/(Fs/2), 'bandpass');
bp_4000 = filter(Hznum_4000,Hzden_4000,in_sound);
bp_4000_fft = abs(fft(bp_4000));
bp_4000_dB = 20*log10(bp_4000_fft);

% 8000Hz to 16000Hz
[Hznum_8000, Hzden_8000] = butter(25,[8000 16000]/(Fs/2), 'bandpass');
bp_8000 = filter(Hznum_8000,Hzden_8000,in_sound);
bp_8000_fft = abs(fft(bp_8000));
bp_8000_dB = 20*log10(bp_8000_fft);

%HIGHPASS Filter
[Hnum_16000, Hden_16000] = butter(20,16000/(Fs/2), 'high'); %hpf with order = 20, Cutoff frequancy = 16kHz
Hpf = filter(Hnum_16000,Hden_16000,in_sound);
Hpf_fft = abs(fft(Hpf));
Hpf_db = 20*log10(Hpf_fft);


%CHANNEL SPLITTING
Lpf_l = Lpf(:,1);
Lpf_r = Lpf(:,2);

bp_64_l = bp_64(:,1);
bp_64_r = bp_64(:,2);

bp_500_l = bp_500(:,1);
bp_500_r = bp_500(:,2);

bp_1000_l = bp_1000(:,1);
bp_1000_r = bp_1000(:,2);

bp_4000_l = bp_4000(:,1);
bp_4000_r = bp_4000(:,2);

bp_8000_l = bp_8000(:,1);
bp_8000_r = bp_8000(:,2);

Hpf_l = Hpf(:,1);
Hpf_r = Hpf(:,2);

%Left Channel Gain
a_32_dB_l = 0;
a_32_l = 10^(a_32_dB_l/20);

a_64_dB_l = 0;
a_64_l = 10^(a_64_dB_l/20);

a_500_dB_l = 0;
a_500_l = 10^(a_500_dB_l/20);

a_1000_dB_l = 0;
a_1000_l = 10^(a_1000_dB_l/20);

a_4000_dB_l = 0;
a_4000_l = 10^(a_4000_dB_l/20);

a_8000_dB_l = 0;
a_8000_l = 10^(a_8000_dB_l/20);

a_16000_dB_l = 0;
a_16000_l = 10^(a_16000_dB_l/20);

% Right Channel Gain
a_32_dB_r = 0;
a_32_r = 10^(a_32_dB_r/20);

a_64_dB_r = 0;
a_64_r = 10^(a_64_dB_r/20);

a_500_dB_r = 0;
a_500_r = 10^(a_500_dB_r/20);

a_1000_dB_r = 0;
a_1000_r = 10^(a_1000_dB_r/20);

a_4000_dB_r = 0;
a_4000_r = 10^(a_4000_dB_r/20);

a_8000_dB_r = 0;
a_8000_r = 10^(a_8000_dB_r/20);

a_16000_dB_r = 0;
a_16000_r = 10^(a_16000_dB_r/20);


%SIGNAL ADDITION 
bp_l =   a_32_l*Lpf_l + a_64_l*bp_64_l +  ...
        + a_500_l*bp_500_l ... 
       + a_1000_l*bp_1000_l + a_4000_l*bp_4000_l ...
       + a_8000_l*bp_8000_l + a_16000_l*Hpf_l;
       
bp_r =   a_32_r*Lpf_r + a_64_r*bp_64_r + a_500_r*bp_500_r + ...
         a_1000_r*bp_1000_r + a_4000_r*bp_4000_r ...
         + a_8000_r*bp_8000_r + a_16000_r*Hpf_r
     
bp_stereo = [bp_l bp_r];

%MONO OUTPUT

 mono = sum(bp_stereo, 2);                              % Sum Across Columns
 bp_stereo = mono/2;                              % Divide Rows Without Zeros By ‘2’ To Get Mean


audiowrite('Out.WAV',bp_stereo, Fs);