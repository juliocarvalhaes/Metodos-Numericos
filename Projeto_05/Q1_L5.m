% Problema 1 - Análise de trajetória de projétil (com interpolação)
clear all; close all; clc;

% Dados originais da tabela
t = [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36];
x = [0 198 395 593 790 988 1185 1383 1580 1778 1975 2173 2370 2568 2765 2963 3160 3358 3555];
y = [200 523 806 1050 1254 1420 1546 1633 1681 1690 1659 1589 1480 1331 1144 917 651 345 1];

n = length(t);
dt = t(2) - t(1);

% (a) Cálculo de vx e vy usando diferenças finitas
vx = zeros(1, n);
vy = zeros(1, n);

vx(1) = (x(2) - x(1)) / dt;
vy(1) = (y(2) - y(1)) / dt;

for i = 2:n-1
    vx(i) = (x(i+1) - x(i-1)) / (2*dt);
    vy(i) = (y(i+1) - y(i-1)) / (2*dt);
end

vx(n) = (x(n) - x(n-1)) / dt;
vy(n) = (y(n) - y(n-1)) / dt;

% (b) Cálculo da velocidade total
v = sqrt(vx.^2 + vy.^2);

% Interpolação para plotagem mais suave
t_interp = 0:0.1:36;  % Pontos a cada 0.1s (10x mais denso)
vx_interp = interp1(t, vx, t_interp, 'spline');
vy_interp = interp1(t, vy, t_interp, 'spline');
v_interp = interp1(t, v, t_interp, 'spline');

% Exibir alguns resultados
fprintf('=== Resultados (dados originais) ===\n\n');
fprintf('t=0s:  vx = %.2f m/s, vy = %.2f m/s, v = %.2f m/s\n', vx(1), vy(1), v(1));
fprintf('t=18s: vx = %.2f m/s, vy = %.2f m/s, v = %.2f m/s\n', vx(10), vy(10), v(10));
fprintf('t=36s: vx = %.2f m/s, vy = %.2f m/s, v = %.2f m/s\n', vx(n), vy(n), v(n));

% (c) Plotar os gráficos
figure('Position', [100 100 1000 600]);

% Curvas interpoladas (suaves)
plot(t_interp, vx_interp, 'b-', 'LineWidth', 2);
hold on;
plot(t_interp, vy_interp, 'r-', 'LineWidth', 2);
plot(t_interp, v_interp, 'g-', 'LineWidth', 2);

% Pontos originais calculados
plot(t, vx, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
plot(t, vy, 'rs', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
plot(t, v, 'g^', 'MarkerSize', 6, 'MarkerFaceColor', 'g');

grid on;
xlabel('Tempo (s)', 'FontSize', 12);
ylabel('Velocidade (m/s)', 'FontSize', 12);
title('Componentes de Velocidade em Função do Tempo', 'FontSize', 14);
legend('v_x (horizontal)', 'v_y (vertical)', 'v (total)', 'Location', 'best');
plot([0 36], [0 0], 'k--', 'LineWidth', 0.5);

hold off;

fprintf('\nGráfico gerado com interpolação!\n');
