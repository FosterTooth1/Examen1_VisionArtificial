clc % limpia pantalla
clear %limpia todo
close all %cierra todo
warning off all


figure(1);
hold on;
axis equal;
view(3);

% Dibujar los puntos de cada clase
Clase1 = [1 0 0; 0 0 0; 1 0 1; 1 1 0]; 
Clase2 = [1 1 1; 0 0 1; 0 1 1; 0 1 0];

% Dibujar los vértices de cada clase (Cubo)
plot3(Clase1(:,1), Clase1(:,2), Clase1(:,3), 'ro', 'MarkerSize', 10, 'DisplayName', 'Clase 1');
plot3(Clase2(:,1), Clase2(:,2), Clase2(:,3), 'bo', 'MarkerSize', 10, 'DisplayName', 'Clase 2');

legend;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Cubo con Clasificación');
grid on;

% Calcular la matriz de covarianza de cada clase
cov_clase1 = cov(Clase1);
cov_clase2 = cov(Clase2);

% Mostrar las matrices de covarianza
disp('Matriz de covarianza Clase 1:');
disp(cov_clase1);
disp('Matriz de covarianza Clase 2:');
disp(cov_clase2);

% Definir los centroides de cada clase
centroide_clase1 = mean(Clase1);
centroide_clase2 = mean(Clase2);

% Pedir la ubicación del vector desconocido (ingresar valores x, y, z uno por uno)
x = input('Introduce la coordenada X del vector desconocido: ');
y = input('Introduce la coordenada Y del vector desconocido: ');
z = input('Introduce la coordenada Z del vector desconocido: ');
vector = [x, y, z];

figure(2); % Corrección de la creación de figura
hold on;
axis equal;
view(3);

% No es necesario volver a definir las clases aquí, ya están definidas arriba

% Dibujar los vértices de cada clase (Cubo)
plot3(Clase1(:,1), Clase1(:,2), Clase1(:,3), 'ro', 'MarkerSize', 10, 'DisplayName', 'Clase 1');
plot3(Clase2(:,1), Clase2(:,2), Clase2(:,3), 'bo', 'MarkerSize', 10, 'DisplayName', 'Clase 2');

legend;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Cubo con Clasificación');
grid on;

% Dibujar el punto del vector desconocido sobre el cubo
plot3(vector(1), vector(2), vector(3), 'go', 'MarkerSize', 10, 'DisplayName', 'Vector Desconocido');
legend;

% Definir el número de clases y los datos de las clases
num_clases = 2;
Clases = cat(3, Clase1, Clase2);
centroides = [centroide_clase1; centroide_clase2];
distancia_maxima = 1.5*2; % umbral para determinar si está fuera del cubo

% Mostrar el vector desconocido sobre el cubo antes de elegir la clasificación
disp('El vector desconocido ha sido plotteado en la gráfica.');

% Pedir al usuario que elija entre distancia de Mahalanobis o máxima probabilidad
opcion = input('Seleccione el método de clasificación: 1 para Mahalanobis, 2 para Máxima Probabilidad: ');

if opcion == 1
    % Clasificación usando la distancia de Mahalanobis
    distancias_mahalanobis = zeros(1, num_clases);
    for i = 1:num_clases
        matriz_cov = cov(squeeze(Clases(:,:,i)));
        inv_cov = inv(matriz_cov);
        rest = vector' - centroides(i,:)';
        distancias_mahalanobis(i) = sqrt((rest)' * inv_cov * rest);
    end
    [minimo, clase] = min(distancias_mahalanobis);
    if minimo <= distancia_maxima
        fprintf('\nMahalanobis: El vector pertenece a la clase %d', clase);
        fprintf('\nLa mínima distancia es de: %f\n', minimo);
    else
        disp('El vector desconocido no pertenece a ninguna clase.');
        fprintf('\nLa mínima distancia es de: %f\n', minimo);
    end
elseif opcion == 2
    distancias_mahalanobis = zeros(1, num_clases);
    for i = 1:num_clases
        matriz_cov = cov(squeeze(Clases(:,:,i)));
        inv_cov = inv(matriz_cov);
        rest = vector' - centroides(i,:)';
        distancias_mahalanobis(i) = sqrt((rest)' * inv_cov * rest);
    end
    [minimo, clase] = min(distancias_mahalanobis);
    % Clasificación usando la máxima probabilidad
    probabilidades = zeros(1, num_clases);
    for i = 1:num_clases
        matriz_cov = cov(squeeze(Clases(:,:,i)));
        inv_cov = inv(matriz_cov);
        det_cov = det(matriz_cov);
        d = 3; % Dimensión de los datos (x, y, z)
        rest = vector' - centroides(i,:)';
        probabilidades(i) = (1 / ((2 * pi)^(d / 2) * sqrt(det_cov))) * exp(-0.5 * rest' * inv_cov * rest);
    end

    % Normalización de probabilidades para que sumen 1
    suma_probabilidades = sum(probabilidades);
    probabilidades_normalizadas = probabilidades / suma_probabilidades;

    [max_prob, clase] = max(probabilidades_normalizadas);
    
    % Convertir probabilidad a porcentaje y verificar si es mayor al 60%
    max_prob_porcentaje = max_prob * 100;
    
    if minimo <= distancia_maxima
        fprintf("\nMáxima Probabilidad: El vector pertenece a la clase %d", clase);
        fprintf('\nLa máxima probabilidad es de: %.2f%%\n', max_prob_porcentaje);
    else
        fprintf("\nLa máxima probabilidad es menor al 60%%, el vector no pertenece a ninguna clase.");
    end
else
    disp('Opción no válida. Seleccione 1 para Mahalanobis o 2 para Máxima Probabilidad.');
end

hold off;

