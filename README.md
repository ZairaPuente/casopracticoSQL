# Caso práctico modulo 3 - ***Base de datos y SQL*** por Zaira Puente

En este repositorio se detalla el analisis del caso práctico del modulo 3 - ***Base de datos y SQL***

## __Contexto__

El restaurante "Sabores del Mundo", es conocido por su auténtica cocina y su ambiente acogedor.
Este restaurante lanzó un nuevo menú a principios de año y ha estado recopilando información detallada sobre las transacciones de los clientes para identificar áreas de oportunidad y provechar al máximo sus datos para optimizar las ventas.

## __Objetivo__

Identificar cuáles son los productos del menú que han tenido más éxito y cuales son los que menos han gustado a los clientes.

##  __Pasos a seguir__

### ***a) Crear la base de datos con el archivo create_restaurant_db.sql***
  - Se creo la BD con el nombre de restaurant
    
    ![image](https://github.com/user-attachments/assets/d22a3537-2e9f-497c-9974-44542bfb16f5)


### ***b) Explorar la tabla “menu_items” para conocer los productos del menú.***
- Para explorar la tabla, se uliza la siguiente sentencia.
  
```SQL
SELECT *
FROM menu_items;
```
- Extracto de la tabla:

|"menu_item_id"|	"item_name"	|"category"|	"price"|
|--------------|--------------|----------|---------|
|101|	"Hamburger"|	"American"|	12.95|
|102|	"Cheeseburger"|	"American"|	13.95|
|103|	"Hot Dog"|	"American"|	9.00|
|104|	"Veggie Burger"|	"American"|	10.50|
|105|	"Mac & Cheese"|	"American"|	7.00|
|106|	"French Fries"|	"American"|	7.00|
|107|	"Orange Chicken"|	"Asian"|	16.50|
|108|	"Tofu Pad Thai"|	"Asian"|	14.50|

### ***b.1) Realizar consultas para contestar las siguientes preguntas:***

####  b.1.1) Encontrar el número de artículos en el menú.
```SQL   
  SELECT COUNT(menu_item_id)
  FROM menu_items;
```  
  
  ![image](https://github.com/user-attachments/assets/060c1689-56c6-4495-a3a6-fcbd94c5588a)

  -  Son 32 artículos.

####  b.1.2) ¿Cuál es el artículo menos caro y el más caro en el menú?
```SQL
SELECT item_name, price AS Precio
FROM menu_items
WHERE price = (SELECT MAX(price) FROM menu_items)
UNION
SELECT item_name, price AS Precio
FROM menu_items
WHERE price = (SELECT MIN(price) FROM menu_items);
```      

  ![image](https://github.com/user-attachments/assets/6ca4e6cb-76da-4722-9165-b6a8e6f2318c)

  -  El artículo más economico es Edamame con un precio de $5 y el más caro es el Shrimp Scampi con preciode $19.95

####  b.1.3) ¿Cuántos platos americanos hay en el menú?

```SQL
SELECT COUNT(category) AS "Cantidad de Platillos"
FROM menu_items
WHERE category = 'American';
```  

![image](https://github.com/user-attachments/assets/7731a5d2-d371-4ba7-a42c-3bd635aab81c)


  -  Existen 6 platillos en la categoría American.

####  b.1.4) ¿Cuál es el precio promedio de los platos?

```SQL  
SELECT Round(AVG(price),2) AS Precio_Promedio
FROM menu_items;
```

![image](https://github.com/user-attachments/assets/bf958942-8781-4075-9fe7-d4bc4fc4559b)


  -  El promedio de precios redondeado a dos decimales es de $13.29

### ***c) Explorar la tabla “order_details” para conocer los datos que han sido recolectados.***

```SQL
SELECT *
FROM order_details;
```

* Extracto de tabla

|order_details_id|order_id|order_date|order_time|item_id|
|:-:|:-:|:-:|:-:|:-:|
|1|	1|2023-01-01|11:38:36|	109|
|2|	2|2023-01-01|11:57:40|	108|
|3|	2|2023-01-01|11:57:40|	124|
|4|	2|2023-01-01|11:57:40|	117|
|5|	2|2023-01-01|11:57:40|	129|
|6|	2|2023-01-01|11:57:40|	106|
|7|	3|2023-01-01|12:12:28|	117|
|8|	3|2023-01-01|12:12:28|	119|

### ***c.1) Realizar consultas para contestar las siguientes preguntas:***

#### c.1.1) ¿Cuántos pedidos únicos se realizaron en total?

```SQL
SELECT COUNT(DISTINCT (order_id))
FROM order_details;
```
  -  Se realizaron 5,370 pedidos

#### c.1.2) ¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?

```SQL
SELECT order_id AS ID_Orden, COUNT(item_id) AS Cantidad_Articulos
FROM order_details
GROUP BY order_id
ORDER BY Cantidad_Articulos DESC, ID_Orden
LIMIT 5;
```

  -  El TOP 5 de las ordenes son las siguientes: 330, 440, 443, 1957, 2675 con 14 artículos cada una.

#### c.1.3) ¿Cuándo se realizó el primer pedido y el último pedido?

```SQL
SELECT * FROM order_details
WHERE order_id = (SELECT MIN(order_id)FROM ORDER_DETAILS)
UNION
SELECT * FROM order_details
WHERE order_id = (SELECT MAX(order_id)FROM ORDER_DETAILS)
ORDER BY order_id;
```

  -  El primer pedido se realizo el 2023-01-01 y el último el 2023-03-31

#### c.1.4) ¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?

```SQL
SELECT COUNT(*)
FROM order_details
WHERE order_date BETWEEN '2023-01-01' AND '2023-01-05';
```
  -  Se realizaron 702 pedidos en el lapzo de tiempo solicitado.

### ***d) Usar ambas tablas para conocer la reacción de los clientes respecto al menú.***

### ***d.1) Realizar un left join entre entre order_details y menu_items con el identificador item_id(tabla order_details) y menu_item_id(tabla menu_items).***

> [!NOTE]
> Con esta query se pueden observar datos nulos que hay en la tabla order_details
```SQL
SELECT *
FROM order_details
LEFT JOIN menu_items 
ON  item_id = menu_item_id;
```
> [!IMPORTANT]
> Ya que en la tabla menu_items no hay datos nulos, esta query nos arroja datos más limpios y sera el join que utilizare.
```SQL
SELECT *
FROM menu_items
LEFT JOIN order_details 
ON  item_id = menu_item_id;
```

### ***e) Una vez que hayas explorado los datos en las tablas correspondientes y respondido las preguntas planteadas, realiza un análisis adicional utilizando este join entre las tablas. El objetivo es identificar 5 puntos clave que puedan ser de utilidad para los dueños del restaurante en el lanzamiento de su nuevo menú. Para ello, crea tus propias consultas y utiliza los resultados obtenidos para llegar a estas conclusiones.***

#### 1.- ¿Qué categoriría tiene más y menos ventas? y ¿Qué categoría es la más pedida?

```SQL
SELECT ar_menu.category, SUM(price) AS suma_precios, COUNT(ar_menu.category) AS conteo_ordenes
FROM menu_items AS ar_menu
LEFT JOIN order_details AS d_o
ON  item_id = menu_item_id
GROUP BY ar_menu.category
ORDER BY suma_precios DESC;
```
  -  La categoría de comida con más ventas es "Italian" cuenta con $49,462.70 dolares en ventas, La categoría de comida con menos ventas "American" cuenta con $28,237.75 dolares en ventas. y la categoría que más se vende es la "Asian" con 3,470 veces ordenada.

#### 2.- ¿Cuál es el precio promedio por categoria?

```SQL
SELECT ar_menu.category, ROUND(AVG(price)) AS "Costo promedio"
FROM menu_items AS ar_menu
LEFT JOIN order_details AS d_o
ON d_o.item_id = ar_menu.menu_item_id
GROUP BY ar_menu.category
ORDER BY "Costo promedio" DESC;
```
|category|Costo promedio|
|:-:|:-:|
|Italian|	17|
|Asian|	13|
|Mexican|	12|
|American|	10|

#### 3.- ¿Cuál es el platillo más vendido y el menos vendido?

```SQL
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
```
  -  El platillo Hamburger, es el más vendido con 622 ordenes.
  -  El platillo Chicken Tacos, es el menos vendido con 123 ordenes.

#### 4.- ¿Qué día tuvo más ordenes? y ¿Cuanto fue la venta de ese día?
```SQL
SELECT d_o.order_date, COUNT(d_o.order_id) AS conteo_de_ordenes, SUM(price) AS venta_del_día
FROM menu_items AS ar_menu
LEFT JOIN order_details AS d_o
ON d_o.item_id = ar_menu.menu_item_id
GROUP BY d_o.order_date
ORDER BY conteo_de_ordenes DESC
LIMIT 1;
```
  -  El día con mayor número de ordenes fue 2023-02-01 con una venta total de $2,396.35 dolares.

#### 5.- ¿Qué día hubo menos ventas?

```SQL
SELECT d_o.order_date, SUM(price) AS venta_del_día
FROM menu_items AS ar_menu
LEFT JOIN order_details AS d_o
ON d_o.item_id = ar_menu.menu_item_id
GROUP BY d_o.order_date
ORDER BY venta_del_día
LIMIT 1;
```
  -  Las venta más baja fue el día 2023-03-22 con $1,016.90 dolares.

## __Análisis__ 
Con las consultas realizadas se recomienda que se retire del menú el platillo Chicken Tacos, también se observa que se obtinen más ganancias con la categoría Italian pero la categoría más vendida es la Asian, la categoría Italian tiene los platillos con costo mayor y la categoría con menos ganancias es la American pues sus costos son menores y el platillo que más se vende es Hamburger correspondiente a esta categoría.

Con lo anterior se logra idendificar que los productos del menú que han tenido más éxito son la Hamburger, Edamame, Korean Beef Bowl y los que menos han gustado a los clientes son Cheese Lasagna, Potstickers, Chicken Tacos, siendo este último el menos pedido.

![grafic_ventas](https://github.com/user-attachments/assets/bbbc9cab-9070-4dab-8889-f76cc19fef7e)

