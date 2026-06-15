# Genetic Algorithm for FFNN Training (3-Parity Problem)

Tugas GA3 - Algoritma Genetika
Universitas Hasanuddin, 2025/2026

## Deskripsi
Implementasi Algoritma Genetika dengan Binary Encoding 
untuk melatih Feed-Forward Neural Network pada kasus 3-parity.

## Arsitektur FFNN
- Input  : 3 neuron
- Hidden : 3 neuron (sigmoid)
- Output : 1 neuron (sigmoid)
- Total parameter : 16 (bobot + bias)

## Parameter AG
| Parameter | Nilai  |
|-----------|--------|
| UkPop     | 100    |
| Psilang   | 0.8    |
| Pmutasi   | 0.03   |
| MaxG      | 2000   |
| Nbit      | 20     |
| Interval  | [-10, 10] |

## Cara Menjalankan
1. Buka MATLAB
2. Set Current Directory ke folder `src/`
3. Jalankan pelatihan: ketik `FFNNBinaryLatih` di Command Window
4. Jalankan pengujian: ketik `FFNNtes` di Command Window
