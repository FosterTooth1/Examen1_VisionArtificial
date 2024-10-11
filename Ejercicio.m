clc; % limpia pantalla
clear; % limpia todo
close all; % cierra todo
warning off all;

figure(1);
hold on;
axis equal;
view(3);

% Dibujar los puntos de cada clase
Clase1 = [1 1 1; 0 0 0; 1 0 0; 0 1 0; 1 0 1]; 
Clase2 = [0 1 1; 1 0 1; 0 1 0];

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

% Asegurar que las clases tienen el mismo número de filas antes de concatenar
max_filas = max(size(Clase1, 1), size(Clase2, 1));
Clase1_padded = [Clase1; zeros(max_filas - size(Clase1, 1), 3)];
Clase2_padded = [Clase2; zeros(max_filas - size(Clase2, 1), 3)];

% Definir el número de clases y los datos de las clases
num_clases = 2;
Clases = cat(3, Clase1_padded, Clase2_padded);
centroides = [centroide_clase1; centroide_clase2];
distancia_maxima = 1.5; % umbral para determinar si está fuera del cubo

% Clasificación usando la distancia de Mahalanobis
distancias_mahalanobis = zeros(1, num_clases);
for i = 1:num_clases
    matriz_cov = cov(squeeze(Clases(:,:,i)));
    inv_cov = inv(matriz_cov);
    rest = vector' - centroides(i,:)';
    distancias_mahalanobis(i) = sqrt((rest)' * inv_cov * rest);
end

nombres_clases = {'RGB', 'NO RGB'};

% Comprobar si el vector está en la línea de grises
if x == y && y == z
    disp('El vector desconocido está en la línea de grises.');
else
    [minimo, clase] = min(distancias_mahalanobis);
    if minimo <= distancia_maxima
        fprintf('\nMahalanobis: El vector pertenece a la clase %d %s', clase, nombres_clases{clase});
        fprintf('\nLa mínima distancia es de: %f\n', minimo);
    else
        disp('El vector desconocido no pertenece a ninguna clase.');
        fprintf('\nLa mínima distancia es de: %f\n', minimo);
    end
end

hold off;


