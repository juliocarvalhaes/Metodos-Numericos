% Questão 4 - questao4.m
% Defina a como escalar a = 0.8 e x como vetor x = 3, -1.8, -2.6, ..., 2.6, 2.8, 3
% Calcule y = 8a²/(x² + 4a²) e trace um gráfico de y versus x

% Definindo o escalar a
a = 0.8;

% Criando o vetor x
x = -3:0.2:3;

% Calculando y = 8a²/(x² + 4a²)
y = (8 * a^2) ./ (x.^2 + 4 * a^2);

% Criando o gráfico
figure;
plot(x, y, 'b-', 'LineWidth', 2);
grid on;
xlabel('x');
ylabel('y = 8a²/(x² + 4a²)');
title(sprintf('Gráfico de y = 8a²/(x² + 4a²) com a = %.1f', a));

% Marcando valor máximo
[y_max, idx_max] = max(y);
hold on;
plot(x(idx_max), y_max, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
text(x(idx_max), y_max + 0.05, sprintf('Máximo: (%.1f, %.3f)', x(idx_max), y_max), ...
     'HorizontalAlignment', 'center');

ylim([0 max(y)*1.5]);  % Aumenta limite superior em 50%
hold off;

fprintf('Questão 4 - Resultados:\n');
fprintf('a = %.1f\n', a);
fprintf('Valor máximo: y = %.3f em x = %.1f\n', y_max, x(idx_max));
