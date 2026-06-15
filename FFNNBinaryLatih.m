%============================================================
% Algoritma Genetika dengan Binary Encoding untuk melatih FFNN
%
% Memanggil fungsi-fungsi berikut:
% 1. BangMatrixIT
% 2. InisialisasiPopulasi
% 3. DekodekanKromosom
% 4. BinaryEvalInd
% 5. LinearFitnessRanking
% 6. RouletteWheel
% 7. PindahSilang
% 8. Mutasi
%============================================================

clc
clear all

JumMasukan  = 3;                        % Jumlah masukan
JPmasukan   = 2^JumMasukan;            % Jumlah pola masukan
Nbit        = 20;                       % Jumlah bit yang mengkodekan satu variabel
JumGen      = Nbit * (JumMasukan+1)^2; % Jumlah gen
Nvar        = JumGen / Nbit;            % Jumlah variabel
Rb          = -10;                      % Batas bawah interval
Ra          = 10;                       % Batas atas interval
MinDelta    = 0.01;                     % Delta minimum yang diharapkan
Fthreshold  = 1 / MinDelta;            % Threshold untuk nilai Fitness
Bgraf       = Fthreshold;              % Untuk menangani tampilan grafis

UkPop   = 100;   % Jumlah kromosom dalam populasi
Psilang = 0.8;   % Probabilitas pindah silang
Pmutasi = 0.03;  % Probabilitas mutasi
MaxG    = 2000;  % Jumlah generasi

% Inisialisasi grafis
hfig = figure;
hold on
title('Algoritma Genetika dengan Binary Encoding untuk pelatihan FFNN')
set(hfig, 'position', [50, 50, 600, 400]);
set(hfig, 'DoubleBuffer', 'on');
axis([1 MaxG 0 Bgraf]);
hbestplot1 = plot(1:MaxG, zeros(1, MaxG));
hbestplot2 = plot(1:MaxG, zeros(1, MaxG));
htext1 = text(0.6*MaxG, 0.25*Bgraf, sprintf('Fitness terbaik: %7.6f', 0.0));
htext2 = text(0.6*MaxG, 0.20*Bgraf, sprintf('Fitness rata-rata: %7.6f', 0.0));
htext3 = text(0.6*MaxG, 0.15*Bgraf, sprintf('Ukuran populasi: %3.0f', 0.0));
htext4 = text(0.6*MaxG, 0.10*Bgraf, sprintf('Prob. Pindah Silang: %4.3f', 0.0));
htext5 = text(0.6*MaxG, 0.05*Bgraf, sprintf('Prob. Mutasi: %4.3f', 0.0));
xlabel('Generasi');
ylabel('Fitness');
hold off
drawnow;

% Bangkitkan matrix Input and Target untuk pelatihan FFNN
[IM, TM] = BangMatrixIT(JumMasukan, JPmasukan);

% Inisialisasi Populasi
Populasi = InisialisasiPopulasi(UkPop, JumGen);

for generasi = 1:MaxG,
    FFNNstruk              = DekodekanKromosom(Populasi(1,:), Nvar, Nbit, Ra, Rb);
    Fitness(1)             = BinaryEvalInd(FFNNstruk, JumMasukan, JPmasukan, IM, TM);
    MaxF                   = Fitness(1);
    MinF                   = Fitness(1);
    IndeksIndividuTerbaik  = 1;

    for ii = 2:UkPop,
        FFNNstruk  = DekodekanKromosom(Populasi(ii,:), Nvar, Nbit, Ra, Rb);
        Fitness(ii) = BinaryEvalInd(FFNNstruk, JumMasukan, JPmasukan, IM, TM);
        if (Fitness(ii) > MaxF),
            MaxF                  = Fitness(ii);
            IndeksIndividuTerbaik = ii;
            FFNNterbaik           = FFNNstruk;
        end
        if (Fitness(ii) <= MinF),
            MinF = Fitness(ii);
        end
    end

    FitnessRataRata = mean(Fitness);

    % Penanganan grafis
    plotvector1           = get(hbestplot1, 'YData');
    plotvector1(generasi) = MaxF;
    set(hbestplot1, 'YData', plotvector1);
    plotvector2           = get(hbestplot2, 'YData');
    plotvector2(generasi) = FitnessRataRata;
    set(hbestplot2, 'YData', plotvector2);
    set(htext1, 'String', sprintf('Fitness terbaik: %7.6f',  MaxF));
    set(htext2, 'String', sprintf('Fitness rata-rata: %7.6f', FitnessRataRata));
    set(htext3, 'String', sprintf('Ukuran populasi: %3.0f',  UkPop));
    set(htext4, 'String', sprintf('Prob. Pindah Silang: %4.3f', Psilang));
    set(htext5, 'String', sprintf('Probabilitas Mutasi: %4.3f', Pmutasi));
    drawnow

    if MaxF > Fthreshold,
        break;
    end

    TemPopulasi = Populasi;

    % Elitisme:
    % - Buat satu kopi kromosom terbaik jika ukuran populasi ganjil
    % - Buat dua kopi kromosom terbaik jika ukuran populasi genap
    if mod(UkPop, 2) == 0,         % ukuran populasi genap
        IterasiMulai            = 3;
        TemPopulasi(1,:)        = Populasi(IndeksIndividuTerbaik,:);
        TemPopulasi(2,:)        = Populasi(IndeksIndividuTerbaik,:);
    else                            % ukuran populasi ganjil
        IterasiMulai            = 2;
        TemPopulasi(1,:)        = Populasi(IndeksIndividuTerbaik,:);
    end

    LinearFitness = LinearFitnessRanking(UkPop, Fitness, MaxF, MinF);

    for jj = IterasiMulai:2:UkPop,
        IP1 = RouletteWheel(UkPop, LinearFitness);
        IP2 = RouletteWheel(UkPop, LinearFitness);
        if (rand < Psilang),
            Anak                   = PindahSilang(Populasi(IP1,:), Populasi(IP2,:), JumGen);
            TemPopulasi(jj,:)      = Anak(1,:);
            TemPopulasi(jj + 1,:)  = Anak(2,:);
        else
            TemPopulasi(jj,:)      = Populasi(IP1,:);
            TemPopulasi(jj + 1,:)  = Populasi(IP2,:);
        end
    end

    for kk = IterasiMulai:UkPop,
        TemPopulasi(kk,:) = Mutasi(TemPopulasi(kk,:), JumGen, Pmutasi);
    end

    Populasi = TemPopulasi;
end

FFNNterbaik
save FFNNterbaik.mat FFNNterbaik
