/*b) Explorar la tabla “menu_items” para conocer los productos del menú.*/
SELECT * FROM menu_items;

/*1.- Realizar consultas para contestar las siguientes preguntas:
● Encontrar el número de artículos en el menú. */
SELECT COUNT(menu_item_id) FROM menu_items;
--R= Son 32 artículos.

--● ¿Cuál es el artículo menos caro y el más caro en el menú?
SELECT item_name, price AS Precio
FROM menu_items
WHERE price = (SELECT MAX(price) FROM menu_items)
UNION
SELECT item_name, price AS Precio
FROM menu_items
WHERE price = (SELECT MIN(price) FROM menu_items);
--R= El artículo menos caro es Edamame con un precio de $5 y el más caro es el Shrimp Scampi con preciode $19.95

--● ¿Cuántos platos americanos hay en el menú?
SELECT COUNT(category) AS "Cantidad de Platillos"
FROM menu_items
WHERE category = 'American';
--R= Existen 6 platillos americanos.

--● ¿Cuál es el precio promedio de los platos?
SELECT Round(AVG(price),2) AS Precio_Promedio
FROM menu_items;
--R= El promedio de precios redondeado a dos decimales es de $13.29

/*c) Explorar la tabla “order_details” para conocer los datos que han sido recolectados.*/
SELECT * FROM order_details;

/*1.- Realizar consultas para contestar las siguientes preguntas:
● ¿Cuántos pedidos únicos se realizaron en total?*/
SELECT COUNT(DISTINCT (order_id))
FROM order_details;
--R= Se realizaron 5,370 pedidos

/*● ¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?*/
SELECT order_id AS ID_Orden, COUNT(item_id) AS Cantidad_Articulos
FROM order_details
GROUP BY order_id
ORDER BY Cantidad_Articulos DESC, ID_Orden
LIMIT 5;
--R= El TOP 5 de las ordenes son las siguientes: 330, 440, 443, 1957, 2675 con 14 artículos cada una.

/*● ¿Cuándo se realizó el primer pedido y el último pedido?*/
SELECT * FROM order_details
WHERE order_id = (SELECT MIN(order_id)FROM ORDER_DETAILS)
UNION
SELECT * FROM order_details
WHERE order_id = (SELECT MAX(order_id)FROM ORDER_DETAILS)
ORDER BY order_id;
--R= El primer pedido se realizo el 2023-01-01 y el último el 2023-03-31

/*● ¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?*/
SELECT COUNT(*)
FROM order_details
WHERE order_date BETWEEN '2023-01-01' AND '2023-01-05';
--R= Se realizaron 702 pedidos en el lapzo de tiempo solicitado.

/*d) Usar ambas tablas para conocer la reacción de los clientes respecto al menú.
1.- Realizar un left join entre entre order_details y menu_items con el identificador
item_id(tabla order_details) y menu_item_id(tabla menu_items).*/
-- Con esta query se pueden observar datos nulos que hay en la tabla order_details
SELECT *
FROM order_details
LEFT JOIN menu_items 
ON  item_id = menu_item_id;

/* Ya que en la tabla menu_items no hay datos nulos, esta query nos arroja datos más limpios 
y sera el join que utilizare.*/
SELECT *
FROM menu_items
LEFT JOIN order_details 
ON  item_id = menu_item_id;

/*e) Una vez que hayas explorado los datos en las tablas correspondientes y respondido las
preguntas planteadas, realiza un análisis adicional utilizando este join entre las tablas. El
objetivo es identificar 5 puntos clave que puedan ser de utilidad para los dueños del
restaurante en el lanzamiento de su nuevo menú. Para ello, crea tus propias consultas y
utiliza los resultados obtenidos para llegar a estas conclusiones.*/

--1.- ¿Qué categoriría tiene más y menos ventas? y ¿Qué categoría es la más pedida?
SELECT ar_menu.category, SUM(price) AS suma_precios, COUNT(ar_menu.category) AS conteo_ordenes
FROM menu_items AS ar_menu
LEFT JOIN order_details AS d_o
ON  item_id = menu_item_id
GROUP BY ar_menu.category
ORDER BY suma_precios DESC;
/*R= La categoría de comida con más ventas es "Italian" cuenta con $49,462.70 dolares en ventas, La categoría de comida con menos ventas "American" cuenta con $28,237.75 dolares en ventas. y la categoría que más
se vende es la "Asian" con 3,470 veces ordenada.*/

--2.- ¿Cuál es el precio promedio por categoría?

SELECT ar_menu.category, ROUND(AVG(price)) AS "Costo promedio"
FROM menu_items AS ar_menu
LEFT JOIN order_details AS d_o
ON d_o.item_id = ar_menu.menu_item_id
GROUP BY ar_menu.category
ORDER BY "Costo promedio" DESC;
-- Categoría "Italian"	costo promedio 17
-- Categoría "Asian" costo promedio 13
-- Categoría "Mexican" costo promedio 12
-- Categoría "American"	costo promedio 10

--3.- ¿Cuál es el platillo más vendido y el menos vendido?
(
    SELECT d_o.item_id, ar_menu.item_name, COUNT(*) AS veces_repetido
    FROM menu_items AS ar_menu
    LEFT JOIN order_details AS d_o ON d_o.item_id = ar_menu.menu_item_id
    GROUP BY d_o.item_id, ar_menu.item_name
    ORDER BY veces_repetido DESC
    LIMIT 1
)
UNION ALL
(
    SELECT d_o.item_id, ar_menu.item_name, COUNT(*) AS veces_repetido
    FROM menu_items AS ar_menu
    LEFT JOIN order_details AS d_o ON d_o.item_id = ar_menu.menu_item_id
    GROUP BY d_o.item_id, ar_menu.item_name
    ORDER BY veces_repetido ASC
   LIMIT 1
);
--R= El platillo Hamburgesa, es el más vendido con 622 ordenes.
--R= El platillo Chicken Tacos, es el menos vendido con 123 ordenes.

--4.- ¿Qué día tuvo más ordenes? y ¿Cuanto fue la venta de ese día?
SELECT d_o.order_date, COUNT(d_o.order_id) AS conteo_de_ordenes, SUM(price) AS venta_del_día
FROM menu_items AS ar_menu
LEFT JOIN order_details AS d_o
ON d_o.item_id = ar_menu.menu_item_id
GROUP BY d_o.order_date
ORDER BY conteo_de_ordenes DESC
LIMIT 1;
--R= El día con mayor número de ordenes fue 2023-02-01 con una venta total de $2,396.35

--5.- ¿Qué día hubo menos ventas?
SELECT d_o.order_date, SUM(price) AS venta_del_día
FROM menu_items AS ar_menu
LEFT JOIN order_details AS d_o
ON d_o.item_id = ar_menu.menu_item_id
GROUP BY d_o.order_date
ORDER BY venta_del_día
LIMIT 1;
--R= Las venta más baja fue el día 2023-03-22 con $1,016.90