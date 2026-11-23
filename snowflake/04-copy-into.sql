USE ROLE ACCOUNTADMIN;
USE DATABASE FOOD;
USE SCHEMA RAW;
USE WAREHOUSE FOOD_WH;


-- carga de datos desde s3 hasta sus respectivas tablas en snowflake

COPY INTO RAW.restaurants 
FROM @FOOD_RAW_STAGE/restaurants/
FILES = ('restaurant.csv')
ON_ERROR = 'CONTINUE';

COPY INTO RAW.food 
FROM @FOOD_RAW_STAGE/food/
FILES = ('food.csv')
ON_ERROR = 'CONTINUE';

COPY INTO RAW.menu 
FROM @FOOD_RAW_STAGE/menu/
FILES = ('menu.csv')
ON_ERROR = 'CONTINUE';

COPY INTO RAW.orders 
FROM @FOOD_RAW_STAGE/orders/
FILES = ('orders.csv')
ON_ERROR = 'ABORT_STATEMENT';

COPY INTO RAW.order_items 
FROM @FOOD_RAW_STAGE/order_items/
FILES = ('order_items.csv')
ON_ERROR = 'ABORT_STATEMENT';

COPY INTO RAW.reviews 
FROM @FOOD_RAW_STAGE/reviews/
FILES = ('reviews.csv')
ON_ERROR = 'ABORT_STATEMENT';

COPY INTO RAW.users 
FROM @FOOD_RAW_STAGE/users/
FILES = ('users.csv')
ON_ERROR = 'CONTINUE';


SELECT 'restaurants' t, COUNT(*) n FROM RAW.restaurants
UNION ALL SELECT 'users',       COUNT(*) FROM RAW.users
UNION ALL SELECT 'food',        COUNT(*) FROM RAW.food
UNION ALL SELECT 'menu',        COUNT(*) FROM RAW.menu
UNION ALL SELECT 'orders',      COUNT(*) FROM RAW.orders
UNION ALL SELECT 'order_items', COUNT(*) FROM RAW.order_items
UNION ALL SELECT 'reviews',     COUNT(*) FROM RAW.reviews
ORDER BY t;
