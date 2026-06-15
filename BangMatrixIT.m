%============================================================
% Membangkitkan matriks Input dan Target untuk pelatihan FFNN
%
% Masukan
%   JumMasukan : Jumlah masukan
%   JPmasukan  : Jumlah pola masukan
%
% Keluaran
%   IM : matriks Input berukuran JPmasukan x JumMasukan
%   TM : matriks target berukuran JPmasukan x 1
%============================================================

function [IM, TM] = BangMatrixIT(JumMasukan, JPmasukan)

for ii = 1:JPmasukan,
    IM(ii,:) = Int2Bin(ii - 1, JumMasukan);
    if mod(sum(IM(ii,:)), 2) == 1,  % angka 1 pada pola input berjumlah ganjil
        TM(ii) = 1;
    else                             % angka 1 pada pola input berjumlah genap
        TM(ii) = 0;
    end
end
