function [peso_libras, altura_polegadas] = Q05(peso_kg, altura_cm)
    % Função que converte peso de kg para libras e altura de cm para polegadas
    %
    % Argumentos de entrada:
    %   peso_kg - peso em quilogramas (kg)
    %   altura_cm - altura em centímetros (cm)
    %
    % Argumentos de saída:
    %   peso_libras - peso em libras (lb)
    %   altura_polegadas - altura em polegadas (in)
    %
    % Fatores de conversão:
    %   1 kg = 2.20462 libras
    %   1 cm = 0.393701 polegadas

    % Conversão de kg para libras
    peso_libras = peso_kg * 2.20462;

    % Conversão de cm para polegadas
    altura_polegadas = altura_cm * 0.393701;

end
