% Solicitar al usuario el intervalo
minValue = input('Ingrese el valor mínimo del intervalo: ');
maxValue = input('Ingrese el valor máximo del intervalo: ');

% Clase 1: Números Primos
numerosPrimos = find(isprime(minValue:maxValue)); % Encuentra números primos

% Graficar números primos
figure;
scatter(numerosPrimos, zeros(size(numerosPrimos)), 'filled');
title('Números Primos');
xlabel('Números Primos');
ylabel('Cero');
xlim([-maxValue maxValue]);
ylim([-1 1]);
grid on;
axis equal;

% Clase 2: Números No Primos
todosLosNumeros = minValue:maxValue;
noPrimos = setdiff(todosLosNumeros, numerosPrimos); % Encuentra números no primos

% Graficar números no primos
figure;
scatter(noPrimos + 10, zeros(size(noPrimos)), 'filled'); % Desplazados a la derecha
title('Números No Primos');
xlabel('Números No Primos (desplazados a la derecha)');
ylabel('Cero');
xlim([0 maxValue + 10]);
ylim([-1 1]);
grid on;
axis equal;

% Pedir al profesor un vector
vector = input('Ingrese un numero: ');

% Clasificar el vector
perteneceClase1 = ismember(vector, numerosPrimos);
perteneceClase2 = ismember(vector, noPrimos);

for i = 1:length(vector)
    if vector(i) < minValue || vector(i) > maxValue
        fprintf('El número %d no pertenece a ninguna clase.\n', vector(i));
    elseif perteneceClase1(i)
        fprintf('El número %d pertenece a la Clase 1 (Números Primos).\n', vector(i));
    elseif perteneceClase2(i)
        fprintf('El número %d pertenece a la Clase 2 (Números No Primos).\n', vector(i));
    else
        fprintf('El número %d no pertenece a ninguna clase.\n', vector(i));
    end
end
