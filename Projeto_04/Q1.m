% Limpar ambiente
clear all;
close all;
clc;

% Nomes dos arquivos
arquivos = {'DadosExp1.txt', 'DadosExp2.txt', 'DadosExp3.txt', ...
            'DadosExp4.txt', 'DadosExp5.txt'};

% Ler todos os arquivos
n_experimentos = length(arquivos);
dados = cell(n_experimentos, 1);

for i = 1:n_experimentos
    % Usar dlmread para pular a primeira linha
    % Sintaxe: dlmread(arquivo, delimitador, linha_inicial, coluna_inicial)
    try
        dados{i} = dlmread(arquivos{i}, ' ', 1, 0);
    catch
        % Se dlmread falhar, tentar com textscan
        fid = fopen(arquivos{i}, 'r');
        fgetl(fid); % Pular primeira linha
        temp = textscan(fid, '%f %f');
        fclose(fid);
        dados{i} = [temp{1}, temp{2}];
    end

    fprintf('Arquivo %s carregado: %d pontos\n', arquivos{i}, size(dados{i}, 1));
end

% Determinar o número mínimo de pontos (caso haja diferenças)
n_pontos = min(cellfun(@(x) size(x, 1), dados));

% Calcular média ponto a ponto dos 5 experimentos
deformacao_media = zeros(n_pontos, 1);
tensao_media = zeros(n_pontos, 1);

for i = 1:n_pontos
    soma_def = 0;
    soma_tens = 0;
    for j = 1:n_experimentos
        soma_def = soma_def + dados{j}(i, 1);
        soma_tens = soma_tens + dados{j}(i, 2);
    end
    deformacao_media(i) = soma_def / n_experimentos;
    tensao_media(i) = soma_tens / n_experimentos;
end

% Método dos Mínimos Quadrados
% Para reta y = a*x + b que passa pela origem: y = a*x
% Módulo de Elasticidade E = σ/ε => σ = E*ε

% Cálculo da inclinação (módulo de elasticidade)
% E = Σ(x*y) / Σ(x²)
modulo_elasticidade = sum(deformacao_media .* tensao_media) / ...
                      sum(deformacao_media .^ 2);

% Exibir resultado
fprintf('\n========================================\n');
fprintf('RESULTADOS DA ANÁLISE\n');
fprintf('========================================\n');
fprintf('Número de pontos analisados: %d\n', n_pontos);
fprintf('Módulo de Elasticidade (E): %.2f Pa\n', modulo_elasticidade);
fprintf('Módulo de Elasticidade (E): %.2e Pa\n', modulo_elasticidade);
fprintf('Módulo de Elasticidade (E): %.2f GPa\n', modulo_elasticidade/1e9);
fprintf('========================================\n\n');

% Plotar resultados
figure('Position', [100, 100, 800, 600]);

% Plotar dados médios
plot(deformacao_media, tensao_media, 'bo', 'MarkerSize', 3, 'DisplayName', 'Dados Médios');
hold on;

% Plotar reta ajustada
x_fit = linspace(min(deformacao_media), max(deformacao_media), 100);
y_fit = modulo_elasticidade * x_fit;
plot(x_fit, y_fit, 'r-', 'LineWidth', 2, 'DisplayName', 'Ajuste Linear');

xlabel('Deformação Específica (ε)', 'FontSize', 12);
ylabel('Tensão (σ) [Pa]', 'FontSize', 12);
title(sprintf('Curva Tensão-Deformação\nE = %.2e Pa', modulo_elasticidade), ...
      'FontSize', 14);
legend('Location', 'northwest');
grid on;
hold off;
