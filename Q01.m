% Questão 1 - questao1.m
% Defina as variáveis a = 14.75, b = -5.92, c = 61.4, d = 0.6(ab - c)

a = 14.75;
b = -5.92;
c = 61.4;
d = 0.6 * (a * b - c);

% Item (a): a + (ab/c) * (a+d)²/√|ab|
resultado_a = a + (a*b/c) * (a + d)^2 / sqrt(abs(a*b));

% Item (b): d*e^(d/2) + ((ad+cd)/(25/a + 35/b))/(a+b+c+d)
termo1 = d * exp(d/2);
termo2 = ((a*d + c*d) / (25/a + 35/b)) / (a + b + c + d);
resultado_b = termo1 + termo2;

fprintf('Questão 1 - Resultados:\n');
fprintf('d = %.4f\n', d);
fprintf('(a) = %.6f\n', resultado_a);
fprintf('(b) = %.6f\n', resultado_b);
