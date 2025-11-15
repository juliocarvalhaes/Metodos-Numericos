% Exercício 01 do Trabalho 06:
clc;
clear;

% 1. Definir os dados da tabela
r_km = [0, 800, 1200, 1400, 2000, 3000, 3400, 3600, 4000, 5000, 5500, 6370];
rho  = [13000, 12900, 12700, 12000, 11650, 10600, 9900, 5500, 5300, 4750, 4500, 3300];

% 2. Converter o raio de km para metros
r_m = r_km * 1000;

% 3. Calcular o integrando: f(r) = rho * 4 * pi * r^2
integrando = rho .* (4 * pi * r_m.^2);

% 4. Calcular a integral usando a regra trapezoidal composta
% trapz(x, y) onde x é o vetor de raios (r_m) e y é o vetor do integrando
massa = trapz(r_m, integrando);

% 5. Exibir o resultado
fprintf('A massa da Terra calculada pelo método trapezoidal é de aproximadamente %.4e kg.\n', massa);

% Valor real calculado para fazer a comparação (aprox. 5.972e24 kg)
% O nosso resultado está na ordem de grandeza correta.
