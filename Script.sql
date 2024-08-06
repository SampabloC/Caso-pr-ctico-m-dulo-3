-- Tabla Menu Items
select * from menu_items mi;

-- Numero de articulos en el menu: 32
select count(*) from menu_items mi;

-- Cual es el articulo menos caro y el mas caro del menu
-- Mas caro: Shrimp Scampi $19.95
-- Menos caro Edamame $5.00 
select price, item_name from menu_items mi order by price desc limit 1;
select price, item_name from menu_items mi order by price asc limit 1;

-- Cuantos platos americanos hay en el menu: 6
select count(*) from menu_items mi where category = 'American';

-- Precio promedio de los platos: $13.29
select round(avg(price), 2) from menu_items mi; 

-- Tabla Order Details
select * from order_details od;

-- Cuantos pedidos unicos se realizaron en total: 5,370
select count(distinct order_id) from order_details od;

-- Cuales son los 5 pedidos que tuvieron el mayor numero de articulos: Ordenes 440, 2,675, 3,473, 4,305 y 443.
select count(*), order_id from order_details od group by order_id order by count(*) desc limit 5;

-- Cuando se realizo el primer pedido y el ultimo pedido
-- Primer pedido: 2023-01-01 11:38:36
-- Ultimo pedido: 2023-03-31 22:15:48
select * from order_details od order by order_date asc, order_time asc;
select * from order_details od order by order_date desc, order_time desc;
select * from (
  (select * from order_details od order by order_details_id asc limit 1)
  union all
  (select * from order_details od order by order_details_id desc limit 1)
) as subquery
order by order_details_id;

-- Cuantos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05': 702 pedidos de 308 ordenes
select count(*), count(distinct order_id) from order_details od where order_date::date between '2023-01-01' and '2023-01-05';

-- Usar ambas tablas para conocer la reaccion de los clientes respecto al menu
select * from menu_items mi 
left join order_details od on mi.menu_item_id = od.item_id ;

-- Considerar el top 10 de productos mas ordenados del menu
select mi.item_name, count(od.order_details_id) ventas from menu_items mi 
left join order_details od on mi.menu_item_id = od.item_id 
group by mi.item_name 
order by ventas desc limit 10;



-- Considerar los 3 articulos mas vendidos de categoria americana
select mi.item_name, count(od.order_details_id) ventas from menu_items mi 
left join order_details od on mi.menu_item_id = od.item_id 
where mi.category = 'American'
group by mi.item_name 
order by ventas desc limit 3;

-- Conocer cual es el tipo de comida que mas se vende: Asian
select mi.category, count(od.order_details_id) ventas from menu_items mi 
left join order_details od on mi.menu_item_id = od.item_id 
group by mi.category 
order by ventas desc;

-- Conocer los platillos que se ordenaron mas de 100 veces en el mes de enero de categoria Mexican
select mi.item_name, count(od.order_details_id) ventas from menu_items mi 
left join order_details od on mi.menu_item_id = od.item_id
where mi.category = 'Mexican' and od.order_date between '2023-01-01' and '2023-01-31'
group by mi.item_name 
having count(od.order_details_id) > 100
order by ventas desc;

-- Conocer los 3 platillos que se venden en promedio mas entre las 2 pm y las 4 pm
-- Los platillo mas pedidos a esta hora en promedio son Eggplant Parmesa, Chicken Parmesa y Shrimp Scampi
select mi.item_name, avg(od.item_id) ventas from menu_items mi 
left join order_details od on mi.menu_item_id = od.item_id
where od.order_time between '14:00:00' and '16:00:00'
group by mi.item_name 
order by ventas desc limit 3;

-- Conocer cuanta gasta en promedio una mesa entre las 2pm y las 4pm y cuantos platillos consume
-- Gastan en promedio $28.85 con un promedio de 2 platillos
select round(avg(ventas), 2), round(avg(platillos),0) from ( 
select od.order_id, sum(mi.price) ventas, count(*) platillos from menu_items mi
join order_details od on mi.menu_item_id = od.item_id
where od.order_time between '14:00:00' and '16:00:00'
group by od.order_id) totales;






