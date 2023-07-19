%Aluno: Adeilson Ribeiro dos Santos
%Aluno: Jo�o Paulo da Costa Barroso
%Aluno: Gilsandro Maia Reis

clear all
clc
close all

load hil_cat5_62_9.mat;

frequeInicial = 10e3;
frequeFinal = 100e6;
espacamento = 43.125e3;

freq = frequeInicial:espacamento:frequeFinal;

%% PSD Transmitida
psdTrans = -76 * ones (length(freq),1);
plot(freq,psdTrans);
grid on;
title('PSD Transmitida');
xlabel('Frequ�ncia (MHz)');
ylabel('PSD (dBm/Hz)');

%% PSD Transmitida em dbm p/ mw 
psdMW = 10.^(psdTrans./10);

%%PSD Recebida
Tx_mw = psdMW.*abs(hil).^2;

%Transformando de mW/Hz para dbm/Hz
Tx_dbm = 10*log10(Tx_mw);

figure; plot(freq,Tx_dbm);
grid on;
xlabel('Frequency (MHz)');
ylabel('dBm');
title('PSD Recebida');

%% Fun��o de Transferencia
figure; plot(freq,20*log10(abs(hil)));
grid on;
title('Fun��o de Transfer�ncia da Linha');
xlabel('Frequ�ncia (MHz)');
ylabel('Ganho (dB)');

%%Ru�do
psd_ruido = -140 * ones (length(freq),1);
psd_ruido_awgn = awgn(psd_ruido,1);
psd_ruido_awgn_mw = 10.^(psd_ruido_awgn./10);
%figure; plot(freq,psd_ruido);
figure; plot(freq,psd_ruido_awgn);
grid on;
xlabel('Frequ�ncia (Hz)');
ylabel('PSD do Ru�do (dBm/Hz)');
title('PSD do Ru�do');

%%SNR
gamaSnr = 9.75;
delta = 6;
gc = 5;
dmt = gamaSnr+delta-gc;
dmtMW = 10^(dmt/10);
snr = ((abs(hil).^2).*(psdMW))./((dmtMW).*(psd_ruido_awgn_mw));
snr_dbm = 10*log10(snr);
figure; plot(freq,snr_dbm);
grid on;
title('SNR');
xlabel('Frequ�ncia (MHz)');
ylabel('SNR (dB)');

%%Bitloading
bit = floor(log2(1 + snr));
figure; plot(freq,bit);
grid on;
xlabel('Frequ�ncia (Hz)');
ylabel('Bitloading');
title('Bitloading');


%%Potencia tx em mW
pot_tx_mw = 43.125e3 * sum(psdMW); 
disp ('Pot�ncia Transmitida em MW');
disp (pot_tx_mw);

%%Potencia tx em dBm
pot_tx_dbm = 10*log10(pot_tx_mw);
disp ('Pot�ncia Transmitida em dBm');
disp (pot_tx_dbm);

%%Potencia rx em dbm e mw
pot_rx_mw = 43.125e3 * sum(Tx_mw);
disp ('Pot�ncia recebida em mW');
disp (pot_rx_mw);
pot_rx_dbm = 10*log10(pot_rx_mw);
disp ('Pot�ncia recebida em dBm');
disp (pot_rx_dbm);

%%capacidade do canal
capacidade = 43.125e3*sum(bit);
disp ('Capacidade de canal');
disp (capacidade);
