with customer_orders as (
 select
   customers.id as customer_id,
   customers.name,
   customers.email,
   -- add coalesce if you do a left join to get customers with 0 orders
   count(orders.id) as number_of_orders
 from `analytics-engineers-club.coffee_shop.customers` customers
 -- could left join to get customers who don't have any orders 
 inner join `analytics-engineers-club.coffee_shop.orders` orders
   on customers.id = orders.customer_id
 group by customers.id, customers.name, customers.email
),
 
first_order as (
 select
   customer_id,
   min(created_at) as first_order_at
 from `analytics-engineers-club.coffee_shop.orders`
 group by customer_id
)
 
 
select
 customer_orders.customer_id,
 customer_orders.name,
 customer_orders.email,
 first_order.first_order_at,
 customer_orders.number_of_orders
from customer_orders
inner join first_order
 on customer_orders.customer_id = first_order.customer_id
limit 5