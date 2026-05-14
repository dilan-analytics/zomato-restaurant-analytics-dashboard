Select * from restaurants_stage

--Basic Exploration (EDA)
SELECT COUNT(*) FROM restaurants_stage;  --count number of data entries

SELECT DISTINCT [listed_in(type)] FROM restaurants_stage;


--check null values if available . 
SELECT * 
FROM restaurants_stage
WHERE rate IS NULL;

--Buisness Analytics

--A.Most Common Restaurant Types

SELECT [listed_in(type)], COUNT(*) AS total
FROM restaurants_stage
GROUP BY [listed_in(type)]
ORDER BY total DESC;

--Online order Distribituion

SELECT online_order, COUNT(*) AS total
FROM restaurants_stage
GROUP BY online_order;

--Average Rating by Restaurant Type

SELECT [listed_in(type)], ROUND(AVG(rate),2) AS avg_rating
FROM restaurants_stage
GROUP BY [listed_in(type)]
ORDER BY avg_rating DESC;


--Cost vs Rating analysis
SELECT [approx_cost(for two people)], ROUND(AVG(rate),2) AS avg_rating
FROM restaurants_stage
GROUP BY [approx_cost(for two people)]
ORDER BY [approx_cost(for two people)];

-- online orders vs ratings

SELECT online_order, ROUND(AVG(rate),2) AS avg_rating
FROM restaurants_stage
GROUP BY online_order;

--Heat Map SQL
SELECT 
    [listed_in(type)],
    SUM(CASE WHEN online_order = 'Yes' THEN 1 ELSE 0 END) AS online_yes,
    SUM(CASE WHEN online_order = 'No' THEN 1 ELSE 0 END) AS online_no
FROM restaurants_stage
GROUP BY  [listed_in(type)];

--Top rated resturants

SELECT TOP 10 name, rate
FROM restaurants_stage
ORDER BY rate DESC;

-- Top restaurants within each category

SELECT 
    [listed_in(type)],
    name,
    rate,
    RANK() OVER (PARTITION BY  [listed_in(type)] ORDER BY rate DESC) AS rank
FROM restaurants_stage;


--New Table
SELECT 
    name,
   [listed_in(type)],
    online_order,
    book_table,
    CAST(rate AS FLOAT) AS rating,
    [approx_cost(for two people)]
INTO clean_restaurants
FROM restaurants_stage
WHERE rate IS NOT NULL;

select * from clean_restaurants

