clc % limpia pantalla
clear %limpia todo
close all %cierra todo
warning off all

a = imread("peppers.png");

rojo = a;
azul = a;
verde = a;
gris = a;

rojo(:,:,2) = 0;
rojo(:,:,3) = 0;

azul(:,:,1) = 0;
azul(:,:,2) = 0;

verde(:,:,1) = 0;
verde(:,:,3) = 0;

aux = rgb2gray(a);
gris(:,:,1) = aux;
gris(:,:,2) = aux;
gris(:,:,3) = aux;

imagen = [rojo verde; azul gris];

figure()
imshow(imagen)

[x, y, ~] = impixel(imagen);

[alto, ancho, ~] = size(imagen);

% Calcular las mitades
mitad_alto = alto / 2;
mitad_ancho = ancho / 2;

num_puntos = 100;
% Definimos las clases en las cuatro regiones de la imagen
% Clase 1: Región superior izquierda
Clase1 = [1 + (mitad_alto - 1) * rand(num_puntos, 1), 1 + (mitad_ancho - 1) * rand(num_puntos, 1)];

% Clase 2: Región superior derecha
Clase2 = [1 + (mitad_alto - 1) * rand(num_puntos, 1), (mitad_ancho + 1) + (ancho - mitad_ancho - 1) * rand(num_puntos, 1)];

% Clase 3: Región inferior izquierda
Clase3 = [(mitad_alto + 1) + (alto - mitad_alto - 1) * rand(num_puntos, 1), 1 + (mitad_ancho - 1) * rand(num_puntos, 1)];

% Clase 4: Región inferior derecha
Clase4 = [(mitad_alto + 1) + (alto - mitad_alto - 1) * rand(num_puntos, 1), (mitad_ancho + 1) + (ancho - mitad_ancho - 1) * rand(num_puntos, 1)];

% Calcular la matriz de covarianza de cada clase
cov_clase1 = cov(Clase1);
cov_clase2 = cov(Clase2);
cov_clase3 = cov(Clase3);
cov_clase4 = cov(Clase4);

% Calculo de la media correctamente como escalar
m1 = mean(Clase1(:));
m2 = mean(Clase2(:));
m3 = mean(Clase3(:));
m4 = mean(Clase4(:));

% Matrices de covarianza calculadas sobre los datos vectorizados
cov1 = cov(Clase1(:));
cov2 = cov(Clase2(:));
cov3 = cov(Clase3(:));
cov4 = cov(Clase4(:));

% Vector de entrada ajustado (x, y) como columna
vec = [x; y];

% Inversas de las matrices de covarianza
inv_cov1 = inv(cov1);
inv_cov2 = inv(cov2);
inv_cov3 = inv(cov3);
inv_cov4 = inv(cov4);

% Determinantes de las matrices de covarianza
det_cov1 = det(cov1);
det_cov2 = det(cov2);
det_cov3 = det(cov3);
det_cov4 = det(cov4);

% Dimensión de los datos (2 dimensiones: x1, x2)
d = 2;

% Calculamos la función de probabilidad para cada clase
prob1 = (1 / ((2 * pi)^(d / 2) * sqrt(det_cov1))) * exp(-0.5 * (vec - m1)' * inv_cov1 * (vec - m1));
prob2 = (1 / ((2 * pi)^(d / 2) * sqrt(det_cov2))) * exp(-0.5 * (vec - m2)' * inv_cov2 * (vec - m2));
prob3 = (1 / ((2 * pi)^(d / 2) * sqrt(det_cov3))) * exp(-0.5 * (vec - m3)' * inv_cov3 * (vec - m3));
prob4 = (1 / ((2 * pi)^(d / 2) * sqrt(det_cov4))) * exp(-0.5 * (vec - m4)' * inv_cov4 * (vec - m4));

% Almacenamos las probabilidades
probabilidades = [prob1, prob2, prob3, prob4];

% Mostramos las probabilidades
disp(probabilidades);

suma_probabilidades = sum(probabilidades);
probabilidades_normalizadas = probabilidades / suma_probabilidades;

disp('Probabilidades normalizadas:');
disp(probabilidades_normalizadas);

% Encontramos la clase con la mayor probabilidad
[max_prob, clase] = max(probabilidades);

% Nombres de las clases
nombres_clases = {'Rojo', 'Verde', 'Azul', 'Ninguna (Gris)'};

% Verificamos si el punto pertenece a la región gris
if clase == 4
    fprintf("\nMáxima Probabilidad \nEl vector no pertenece a ninguna clase (región gris).\n");
else
    fprintf("\nMáxima Probabilidad \nEl vector pertenece a la clase [%s]\n", nombres_clases{clase});
end

