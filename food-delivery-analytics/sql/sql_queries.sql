
SELECT
    city,
    COUNT(*) AS total_orders,
    SUM(net_revenue) AS total_revenue,
    ROUND(AVG(net_revenue), 2) AS avg_order_value
FROM orders
WHERE order_status = 'Delivered'
GROUP BY city
ORDER BY total_revenue DESC;


SELECT
    traffic_level,
    COUNT(*) AS order_count,
    ROUND(AVG(delivery_time_min), 2) AS avg_delivery_time
FROM orders
GROUP BY traffic_level
HAVING COUNT(*) > 50
ORDER BY avg_delivery_time DESC;


SELECT
    promo_used,
    COUNT(*) AS order_count,
    ROUND(AVG(subtotal), 2) AS avg_order_value,
    ROUND(SUM(discount_amount), 2) AS total_discount_given,
    ROUND(SUM(net_revenue), 2) AS total_net_revenue
FROM orders
GROUP BY promo_used;


SELECT
    city,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(100.0 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2)
        AS cancellation_rate_pct
FROM orders
GROUP BY city
ORDER BY cancellation_rate_pct DESC;


SELECT city, restaurant_name, total_revenue, rnk
FROM (
    SELECT
        city,
        restaurant_name,
        SUM(net_revenue) AS total_revenue,
        RANK() OVER (PARTITION BY city ORDER BY SUM(net_revenue) DESC) AS rnk
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY city, restaurant_name
)
WHERE rnk <= 3;



SELECT city, restaurant_category, order_count
FROM (
    SELECT
        city,
        restaurant_category,
        COUNT(*) AS order_count,
        RANK() OVER (PARTITION BY city ORDER BY COUNT(*) DESC) AS rnk
    FROM orders
    GROUP BY city, restaurant_category
)
WHERE rnk = 1;