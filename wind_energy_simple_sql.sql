/* EDA using data from Spain about energy usage and weather.
Many insights can be obtained from looking into this data.
For now I will look at a basic connection between wind energy generated, weather, and price.
*/

USE world;

SELECT 
    *
FROM
    energy_data1;

alter Table energy_data1
modify column time datetime;

SELECT 
    *
FROM
    weather_features;

ALTER TABLE weather_features
MODIFY COLUMN dt_iso datetime;

#duplicating the tables to manipulate

DROP TABLE IF EXISTS ed_dup;
CREATE TABLE ed_dup AS
SELECT *
FROM energy_data1;

SELECT *
FROM ed_dup;

DROP TABLE IF EXISTS wf_dup;
CREATE TABLE wf_dup AS
SELECT *
FROM weather_features;

SELECT *
FROM wf_dup;

ALTER TABLE wf_dup
RENAME COLUMN dt_iso TO time;

/*Now that we have formatted the data, we will use these tables mainly going forward*/
SELECT *
from wf_dup;

SELECT *
from ed_dup;

#looking at the data holistically first
#checking price differences

SELECT time, price_day_ahead, price_actual, ROUND((price_actual-price_day_ahead), 2) as price_diff
from ed_dup;

#exploring energy generated

SELECT 
    time, total_load_actual
FROM
    ed_dup
ORDER BY total_load_actual DESC
LIMIT 100;

SELECT 
    SUM(generation_fossil_gas) total_fossil_gas,
    SUM(generation_fossil_hard_coal) total_coal,
    SUM(generation_nuclear) total_nuclear,
    SUM(generation_wind_onshore) total_wind,
    SUM(total_load_actual) total_load
FROM
    ed_dup;

#These numbers are a bit hard to read so showing them as percentages may be wiser

SELECT 
    ROUND((SUM(generation_fossil_gas) / SUM(total_load_actual)) * 100,
            2) fossil_gas,
    ROUND((SUM(generation_fossil_hard_coal) / SUM(total_load_actual)) * 100,
            2) coal,
    ROUND((SUM(generation_nuclear) / SUM(total_load_actual)) * 100,
            2) nuclear,
    ROUND((SUM(generation_wind_onshore) / SUM(total_load_actual)) * 100,
            2) wind,
    (ROUND((SUM(generation_fossil_gas) / SUM(total_load_actual)) * 100,
            2) + ROUND((SUM(generation_fossil_hard_coal) / SUM(total_load_actual)) * 100,
            2) + ROUND((SUM(generation_nuclear) / SUM(total_load_actual)) * 100,
            2) + ROUND((SUM(generation_wind_onshore) / SUM(total_load_actual)) * 100,
            2)) main_sources_percent,
    SUM(total_load_actual) total_load
FROM
    ed_dup;


SELECT DISTINCT
    weather_main
FROM
    wf_dup;

SELECT DISTINCT
    weather_description
FROM
    wf_dup;

CREATE VIEW weather_price AS
    (SELECT 
        w.time,
        ROUND(w.temp, 2) temp,
        w.weather_main,
        w.weather_description,
        ROUND((e.generation_wind_onshore / e.total_load_actual * 100),
            2) wind_energy_percent,
        e.total_load_actual,
        e.price_actual
    FROM
        wf_dup w
            JOIN
        ed_dup e ON w.time = e.time);
#How much of that comees from energy

SELECT 
    time,
    ROUND(((generation_wind_offshore + generation_wind_onshore) / total_load_actual) * 100,
            2) wind_energy_percent,
    total_load_actual
FROM
    ed_dup;

SELECT 
    SUM(generation_wind_offshore)
FROM
    ed_dup;

#So it is evident that all the wind energy generated was generated onshore
#Now looking at the wind energy ratio according to weather and the resulting price

SELECT 
        w.weather_main,
        ROUND(avg((e.generation_wind_onshore / e.total_load_actual * 100)),
            2) wind_energy_percent,
        avg(e.total_load_actual) avg_load,
        avg(e.price_actual) avg_price
FROM
        wf_dup w
            JOIN
        ed_dup e ON w.time = e.time
WHERE weather_main = 'clear';

SELECT 
        w.weather_main,
        ROUND(avg((e.generation_wind_onshore / e.total_load_actual * 100)),
            2) wind_energy_percent,
        avg(e.total_load_actual) avg_load,
        avg(e.price_actual) avg_price
FROM
        wf_dup w
            JOIN
        ed_dup e ON w.time = e.time
WHERE weather_main = 'clouds';

/*This can be duplicated for all unique weather, as this is a demonstration we will leave it here. 
Also note that the above code does not account for seasonality which occurs both daily with peak and off-peak times and yearly
corresponding to summer and winter months. The changes are best shown in visulizations rather than tables showing various numbers.
 */

