![Tableau Visualization](https://public.tableau.com/app/profile/steve.patsy/viz/USAMassShootingsDashboard/USAMassShootingsDashboard)

—Lets start by looking at the data
SELECT *
FROM mass_shootings;


—Total Deaths by State
SELECT DISTINCT(state), 
	SUM(dead) AS deaths 
FROM mass_shootings
GROUP BY state
ORDER BY deaths DESC;


—Top 10 Deadliest States by Total Deaths
SELECT DISTINCT(state), 
	SUM(dead) AS deaths 
FROM mass_shootings
GROUP BY state
ORDER BY deaths DESC
LIMIT 10;


—Deadliest Mass Shootings by Deaths
SELECT date, city, state, MAX(dead) AS deaths, injured, total, description
FROM mass_shootings
GROUP BY date, city, state, injured, total, description
ORDER BY deaths DESC;


—Top 10 Deadliest Mass Shootings
SELECT date, city, state, MAX(dead) AS deaths, injured, total, description
FROM mass_shootings
GROUP BY date, city, state, injured, total, description
ORDER BY deaths DESC
LIMIT 10;


—Top 10 States by Total Injuries
SELECT DISTINCT(state), 
	SUM(injured) 
FROM mass_shootings
GROUP BY state
ORDER BY SUM(injured) DESC
LIMIT 10;


—Top 10 States by Totals (deaths and injuries)
SELECT DISTINCT(state), 
	SUM(total) AS totals
FROM mass_shootings
GROUP BY state
ORDER BY totals DESC
LIMIT 10;

--Mass Shootings by Year > 2022
SELECT date, city, state, MAX(dead) AS deaths, injured, total, description
FROM mass_shootings
WHERE date > '2022-01-01'
GROUP BY date, city, state, injured, total, description
ORDER BY date DESC;
