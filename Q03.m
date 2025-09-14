% Questão 3
% Crie a matriz mostrada usando a notação adequada

A = [0      1.0000  2.0000  3.0000  4.0000  5.0000  6.0000;
     3.0000 9.1667  15.3333 21.5000 27.6667 33.8333 40.0000;
     28.0000 27.7500 27.5000 27.2500 27.0000 26.7500 26.5000;
     6.0000 5.0000  4.0000  3.0000  2.0000  1.0000  0];

fprintf('Matriz A:\n');
disp(A);

% Método alternativo usando vetores
linha1 = 0:6;
linha2 = 3 + (0:6) * (37/6);
linha3 = 28 - (0:6) * 0.25;
linha4 = 6:-1:0;

A_alt = [linha1; linha2; linha3; linha4];

fprintf('\nMatriz criada com vetores:\n');
disp(A_alt);
