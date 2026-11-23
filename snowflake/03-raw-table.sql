USE ROLE ACCOUNTADMIN;
USE DATABASE FOOD;
USE SCHEMA RAW;


-- restaurant raw table

CREATE TABLE IF NOT EXISTS RAW.restaurants (
_idx VARCHAR,
id VARCHAR,
name VARCHAR,
city VARCHAR,
rating VARCHAR,
rating_count VARCHAR,
cost VARCHAR,
cuisine VARCHAR,
lic_no VARCHAR,
link VARCHAR,
address VARCHAR,
menu VARCHAR
);


-- users raw table

CREATE TABLE IF NOT EXISTS RAW.users (
_idx VARCHAR,
user_id VARCHAR,
name VARCHAR,
email VARCHAR,
password VARCHAR,
age VARCHAR,
gender VARCHAR,
marital_status VARCHAR,
occupation VARCHAR,
monthly_income VARCHAR,
education VARCHAR,
family_size VARCHAR
);


-- food raw table

CREATE TABLE IF NOT EXISTS RAW.food (
  _idx VARCHAR,
  f_id VARCHAR, item VARCHAR, veg_or_non_veg VARCHAR
);


-- menu raw table

CREATE TABLE IF NOT EXISTS RAW.menu (
  _idx VARCHAR,
  menu_id VARCHAR,
  r_id VARCHAR,
  f_id VARCHAR,
  cuisine VARCHAR,
  price VARCHAR
);


-- orders raw table

CREATE TABLE IF NOT EXISTS RAW.orders (
  order_id          NUMBER,
  order_timestamp   TIMESTAMP_NTZ,
  order_date        DATE,
  user_id           NUMBER,
  r_id              NUMBER,
  restaurant_city   VARCHAR,
  cuisine           VARCHAR,
  items_count       NUMBER,
  sales_qty         NUMBER,
  subtotal          NUMBER,
  discount          NUMBER,
  delivery_fee      NUMBER,
  gst               NUMBER,
  sales_amount      NUMBER,
  currency          VARCHAR,
  payment_method    VARCHAR,
  order_status      VARCHAR,
  customer_rating   NUMBER,
  delivery_time_min NUMBER
);


-- order_items raw table

CREATE TABLE IF NOT EXISTS RAW.order_items (
  order_item_id NUMBER,
  order_id      NUMBER,
  r_id          NUMBER,
  f_id          VARCHAR,
  price         NUMBER,
  quantity      NUMBER,
  line_amount   NUMBER
);


-- reviews raw table

CREATE TABLE IF NOT EXISTS RAW.reviews (
  review_id     NUMBER,
  order_id      NUMBER,
  user_id       NUMBER,
  restaurant_id NUMBER,
  rating        NUMBER,
  comment       VARCHAR,
  review_date   DATE
);

