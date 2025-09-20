% circuito_rlc.m
% ========================================================================
% Exercício 1 - Determinação da frequência em circuito RLC
% Métodos numéricos: Bissecção e Secante
% ========================================================================

clear all; close all; clc;


R = 140;        % Resistência [Ohms]
L = 260e-3;     % Indutância [H] (260 mH convertido para H)
C = 25e-6;      % Capacitância [F] (25 μF convertido para F)
v_m = 24;       % Amplitude da tensão [V]
i_m = 0.15;     % Amplitude da corrente [A]
tol = 0.0001;   % Tolerância para critério de parada



function y = funcao_objetivo(f, R, L, C, v_m, i_m)
    omega = 2 * pi * f;

    % Calcular reatâncias
    X_L = omega * L;           % Reatância indutiva
    X_C = 1 / (omega * C);      % Reatância capacitiva

    % Calcular impedância total
    Z = sqrt(R^2 + (X_L - X_C)^2);

    % Função objetivo
    y = v_m/i_m - Z;
end

% ========================================================================
% MÉTODO DA BISSECÇÃO
% ========================================================================
function [raiz, iter, historico] = bisseccao(func, a, b, tol, params)
    iter = 0;
    historico = [];

    % Avaliar função nos extremos
    fa = func(a, params{:});
    fb = func(b, params{:});

    % Verificar mudança de sinal
    if fa * fb > 0
        error('ERRO: Não há mudança de sinal no intervalo [%.2f, %.2f]', a, b);
    end

    % Iterações do método da bissecção
    while (b - a)/2 > tol
        iter = iter + 1;
        c = (a + b) / 2;
        fc = func(c, params{:});

        % Armazenar histórico
        historico = [historico; iter, a, b, c, fc, abs(fc)];

        % Verificar critério de parada
        if abs(fc) < tol
            raiz = c;
            return;
        end

        % Atualizar intervalo
        if fa * fc < 0
            b = c;
            fb = fc;
        else
            a = c;
            fa = fc;
        end

        % Proteção contra loop infinito
        if iter > 100
            warning('Máximo de 100 iterações atingido!');
            raiz = c;
            return;
        end
    end

    raiz = (a + b) / 2;
end

% MÉTODO DA SECANTE

function [raiz, iter, historico] = secante(func, x0, x1, tol, params)
    iter = 0;
    historico = [];
    max_iter = 100;

    while iter < max_iter
        iter = iter + 1;

        % Avaliar função nos pontos
        fx0 = func(x0, params{:});
        fx1 = func(x1, params{:});

        % Verificar divisão por zero
        if abs(fx1 - fx0) < eps
            warning('Divisão por zero detectada na iteração %d', iter);
            raiz = x1;
            return;
        end

        % Calcular próxima aproximação
        x2 = x1 - fx1 * (x1 - x0) / (fx1 - fx0);
        fx2 = func(x2, params{:});

        % Armazenar histórico
        historico = [historico; iter, x0, x1, x2, fx2, abs(fx2)];

        % Verificar critério de parada
        if abs(fx2) < tol
            raiz = x2;
            return;
        end

        % Atualizar pontos para próxima iteração
        x0 = x1;
        x1 = x2;
    end

    warning('Máximo de %d iterações atingido!', max_iter);
    raiz = x2;
end


% Calcular frequência de ressonância teórica
f_ressonancia = 1 / (2 * pi * sqrt(L * C));

% Criar vetor de frequências para análise
f_min = 1;
f_max = 200;
f_test = linspace(f_min, f_max, 1000);
y_test = zeros(size(f_test));

% Avaliar função em cada frequência
for i = 1:length(f_test)
    y_test(i) = funcao_objetivo(f_test(i), R, L, C, v_m, i_m);
end

% Plotar função objetivo
figure(1);
subplot(2,1,1);
plot(f_test, y_test, 'b-', 'LineWidth', 1.5);
hold on;
plot(f_test, zeros(size(f_test)), 'r--', 'LineWidth', 1);
plot(f_ressonancia, funcao_objetivo(f_ressonancia, R, L, C, v_m, i_m), 'go', ...
     'MarkerSize', 8, 'MarkerFaceColor', 'g');
grid on;
xlabel('Frequência [Hz]');
ylabel('g(f) = v_m/i_m - |Z|');
title('Função Objetivo do Circuito RLC');
legend('g(f)', 'y = 0', 'f_{ressonância}', 'Location', 'best');
xlim([f_min, f_max]);

% Zoom na região de interesse
subplot(2,1,2);
idx_zoom = find(f_test >= 20 & f_test <= 120);
plot(f_test(idx_zoom), y_test(idx_zoom), 'b-', 'LineWidth', 1.5);
hold on;
plot(f_test(idx_zoom), zeros(size(f_test(idx_zoom))), 'r--', 'LineWidth', 1);
plot(f_ressonancia, funcao_objetivo(f_ressonancia, R, L, C, v_m, i_m), 'go', ...
     'MarkerSize', 8, 'MarkerFaceColor', 'g');
grid on;
xlabel('Frequência [Hz]');
ylabel('g(f)');
title('Zoom na região de interesse');
xlim([20, 120]);

% Identificar mudanças de sinal
mudancas_sinal = [];
for i = 1:length(f_test)-1
    if y_test(i) * y_test(i+1) < 0
        % Refinar intervalo
        a_ref = f_test(i);
        b_ref = f_test(i+1);
        mudancas_sinal = [mudancas_sinal; a_ref, b_ref];
    end
end

% MÉTODO DA BISSECÇÃO


if ~isempty(mudancas_sinal)
    % Usar o primeiro intervalo encontrado
    a_bissec = mudancas_sinal(1, 1);
    b_bissec = mudancas_sinal(1, 2);

    % Aplicar método
    params = {R, L, C, v_m, i_m};
    [f_bissec, iter_bissec, hist_bissec] = bisseccao(@funcao_objetivo, ...
                                                      a_bissec, b_bissec, tol, params);

    % Exibir resultado
    disp('MÉTODO DA BISSECÇÃO:');
    fprintf('Frequência encontrada: f = %.4f Hz\n', f_bissec);
    fprintf('Número de iterações: %d\n', iter_bissec);
    fprintf('Valor final de g(f): %.6e\n\n', funcao_objetivo(f_bissec, R, L, C, v_m, i_m));
else
    f_bissec = NaN;
    disp('ERRO: Não foi possível aplicar o método da bissecção!');
end

% MÉTODO DA SECANTE

% Escolher pontos iniciais
if ~isempty(mudancas_sinal)
    % Usar pontos próximos ao intervalo encontrado
    x0_sec = mudancas_sinal(1, 1) - 5;
    x1_sec = mudancas_sinal(1, 2) + 5;
else
    % Usar pontos em torno da frequência de ressonância
    x0_sec = f_ressonancia - 15;
    x1_sec = f_ressonancia + 15;
end

% Aplicar método
[f_secante, iter_secante, hist_secante] = secante(@funcao_objetivo, ...
                                                  x0_sec, x1_sec, tol, params);

disp('MÉTODO DA SECANTE:');
fprintf('Frequência encontrada: f = %.4f Hz\n', f_secante);
fprintf('Número de iterações: %d\n', iter_secante);
fprintf('Valor final de g(f): %.6e\n\n', funcao_objetivo(f_secante, R, L, C, v_m, i_m));

% Plotar convergência
figure(2);

if ~isnan(f_bissec)
    subplot(2,1,1);
    semilogy(1:iter_bissec, hist_bissec(:,6), 'bo-', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    grid on;
    xlabel('Iteração');
    ylabel('|g(f)|');
    title('Convergência - Método da Bissecção');
    xlim([1, iter_bissec]);
end

subplot(2,1,2);
semilogy(1:iter_secante, hist_secante(:,6), 'ro-', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
grid on;
xlabel('Iteração');
ylabel('|g(f)|');
title('Convergência - Método da Secante');
xlim([1, iter_secante]);


% VERIFICAÇÃO DA SOLUÇÃO


% Usar a solução do método da bissecção (se disponível)
if ~isnan(f_bissec)
    f_final = f_bissec;
else
    f_final = f_secante;
end

% Calcular valores do circuito
omega_final = 2 * pi * f_final;
X_L = omega_final * L;
X_C = 1 / (omega_final * C);
Z = sqrt(R^2 + (X_L - X_C)^2);
i_calculado = v_m / Z;
erro_percentual = abs(i_calculado - i_m) / i_m * 100;

% Calcular ângulo de fase
phi = atan((X_L - X_C) / R) * 180 / pi;

disp('VERIFICAÇÃO:');
fprintf('Para f = %.4f Hz:\n', f_final);
fprintf('  Impedância |Z| = %.2f Ω\n', Z);
fprintf('  Corrente calculada: %.4f A\n', i_calculado);
fprintf('  Corrente esperada:  %.4f A\n', i_m);
fprintf('  Erro relativo: %.4f%%\n\n', erro_percentual);

% Verificar todas as raízes encontradas
if size(mudancas_sinal, 1) > 1
    disp('MÚLTIPLAS SOLUÇÕES ENCONTRADAS:');

    for i = 1:size(mudancas_sinal, 1)
        % Encontrar raiz em cada intervalo
        [f_raiz, ~, ~] = bisseccao(@funcao_objetivo, ...
                                   mudancas_sinal(i,1), mudancas_sinal(i,2), ...
                                   tol, params);

        omega = 2 * pi * f_raiz;
        X_L = omega * L;
        X_C = 1 / (omega * C);

        fprintf('Solução %d: f = %.4f Hz', i, f_raiz);
        if X_L > X_C
            fprintf(' (Regime INDUTIVO)\n');
        elseif X_L < X_C
            fprintf(' (Regime CAPACITIVO)\n');
        else
            fprintf(' (RESSONÂNCIA)\n');
        end
    end
end
