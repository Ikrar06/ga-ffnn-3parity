%============================================================
% Pengujian FFNN hasil pelatihan
%
% Fungsi ini me-load file FFNNterbaik.mat yang berisi variabel FFNNterbaik,
% yaitu struktur FFNN hasil pelatihan
%============================================================

clc
clear all

c  = 1;
n  = 3;
n2 = n^2;

% Load struktur FFNN terbaik hasil pelatihan
load FFNNterbaik.mat

MT = 1;
while MT == 1,
    disp('Pengujian FFNN');
    disp(' ');
    disp('Masukkan tiga input biner untuk FFNN');
    x1 = input('X1: ');
    x2 = input('X2: ');
    x3 = input('X3: ');

    IM = [x1 x2 x3];

    NNS = FFNNterbaik;

    Wtemp = NNS(1:n2);
    for ii = 1:n,
        Wih(ii,:) = Wtemp((ii - 1) * n + 1 : ii * n);
    end

    bih = NNS(n2 + 1 : n2 + n);
    Who = NNS(n2 + n + 1 : n2 + 2*n);
    bho = NNS((n + 1)^2);

    for ii = 1:n,
        SumWIb = 0;
        for jj = 1:n,
            SumWIb = SumWIb + Wih(ii,jj) * IM(jj) + bih(jj);
        end
        Xih(ii) = 1 / (1 + exp(-c * SumWIb));
    end

    SumWXb = 0;
    for jj = 1:n,
        SumWXb = SumWXb + Who(jj) * Xih(jj) + bho;
    end
    Xho = 1 / (1 + exp(-c * SumWXb));

    if Xho <= 0.02,
        HasilTes = '0';
    else
        if Xho >= 0.98,
            HasilTes = '1';
        else
            HasilTes = 'Unidentified';
        end
    end

    disp(' ');
    disp(['Output bilangan real: ', num2str(Xho)]);
    disp(['Output FFNN adalah: ',   HasilTes]);
    disp(' ');

    MT = input('Tekan 1 untuk tes lagi, dan tekan 0 untuk keluar: ');
end
