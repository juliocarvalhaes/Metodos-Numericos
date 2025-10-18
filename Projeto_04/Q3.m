% Limpar ambiente
clear all;
close all;
clc;

% Dados fornecidos
x = [1, 2.5, 2, 3, 4, 5];
y = [1, 7, 5, 8, 2, 1];

% Ordenar os dados (interp1 requer x crescente)
[x_ord, idx] = sort(x);
y_ord = y(idx);

% Valor para interpolação
x_interp = 3.5;

% Interpolação usando spline cúbico
y_interp = interp1(x_ord, y_ord, x_interp, 'spline');

% Criar pontos para plotar a curva suave
x_plot = linspace(min(x_ord), max(x_ord), 100);
y_plot = interp1(x_ord, y_ord, x_plot, 'spline');

% Exibir resultado
fprintf('\n========================================\n');
fprintf('INTERPOLAÇÃO POLINOMIAL \n');
fprintf('========================================\n');
fprintf('Valor interpolado em x = %.1f:\n', x_interp);
fprintf('y = %.4f\n', y_interp);
fprintf('========================================\n\n');

% Visualização
figure('Position', [100, 100, 800, 600]);

% Pontos originais
plot(x_ord, y_ord, 'bo', 'MarkerSize', 10, 'LineWidth', 2, ...
     'MarkerFaceColor', 'b', 'DisplayName', 'Pontos Dados');
hold on;

% Curva interpolada
plot(x_plot, y_plot, 'b-', 'LineWidth', 2, 'DisplayName', 'Spline Interpolador');

% Ponto interpolado
plot(x_interp, y_interp, 'r*', 'MarkerSize', 15, 'LineWidth', 2, ...
     'DisplayName', sprintf('Interpolado (%.1f, %.4f)', x_interp, y_interp));

% Linha vertical tracejada
plot([x_interp, x_interp], [0, y_interp], 'r--', 'LineWidth', 1, ...
     'HandleVisibility', 'off');
plot([min(x_ord), x_interp], [y_interp, y_interp], 'r--', 'LineWidth', 1, ...
     'HandleVisibility', 'off');

xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
title('Interpolação Polinomial - Spline Cúbico', 'FontSize', 14);
legend('Location', 'best');
grid on;
hold off;

% Tabela formatada dos dados ordenados
fprintf('Dados ordenados:\n');
fprintf('  x  |  y\n');
fprintf('-----|-----\n');
for i = 1:length(x_ord)
    fprintf('%4.1f | %4.0f\n', x_ord(i), y_ord(i));
end
