-- Looking at the data
SELECT *
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

-- Select Data that we need
SELECT location,date,total_cases,new_cases,total_deaths,population
FROM coviddeaths
ORDER BY 1,2;

-- Looking at Total Cases vs Total Deaths Worldwide
-- Shows liklihood of dying if you contract COVID
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 
	AS death_percentage
FROM coviddeaths
WHERE location = 'United States'
ORDER BY 1,2;

-- Looking at Total Cases vs Total Deaths United States
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 
	AS death_percentage
FROM coviddeaths
WHERE location = 'United States'
ORDER BY 1,2;

-- Looking at Total Cases vs Population
-- Shows what percentage of population has contracted COVID
SELECT location,date,population,total_cases,(total_cases/population)*100 
	AS percentage_got_covid
FROM coviddeaths
WHERE location = 'United States'
ORDER BY 1,2;

-- Looking at Countries with Highest Infection Rate compared to the Population
SELECT location,population,MAX(total_cases) AS highest_infection_count,
	MAX((total_cases/population))*100 AS percentage_pop_infected
FROM coviddeaths
GROUP BY location,population
ORDER BY percentage_pop_infected DESC;

-- Showing Countries with Highest Death Count per Population
SELECT location,MAX(total_deaths) AS total_death_count
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC

-- LET'S BREAK THINGS DOWN BY CONTINENT

--SELECT location,MAX(total_deaths) AS total_death_count
--FROM coviddeaths
--WHERE continent IS NULL
--GROUP BY location
--ORDER BY total_death_count DESC

-- Looking at Total Deaths per Continent
SELECT continent,MAX(total_deaths) AS total_death_count
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC

-- Global Numbers
SELECT date,SUM(new_cases) AS total_cases,SUM(new_deaths) 
	AS total_deaths,SUM(new_deaths)/SUM(new_cases)*100 
	AS death_percentage
FROM coviddeaths
--WHERE location = 'United States'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

-- Global Numbers (total cases and deaths)
SELECT SUM(new_cases) AS total_cases,SUM(new_deaths) 
	AS total_deaths,SUM(new_deaths)/SUM(new_cases)*100 
	AS death_percentage
FROM coviddeaths
--WHERE location = 'United States'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2;

-- Joining the second table CV
SELECT *
FROM coviddeaths cd
JOIN cv
	ON cd.location = cv.location
	AND cd.date = cv.date
ORDER BY 1,2,3;
	
-- Looking at Total Population vs Vaccinations
SELECT cd.continent,cd.location,cd.date,cd.population,
	cv.new_vaccinations
FROM coviddeaths cd
JOIN cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3;

-- Looking at Total Population vs Vaccinations and adding running total
SELECT cd.continent,cd.location,cd.date,cd.population,
	cv.new_vaccinations,SUM(cv.new_vaccinations) 
	OVER (PARTITION by cd.location ORDER BY cd.location,cd.date) 
	AS running_total
FROM coviddeaths cd
JOIN cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3;

-- USE CTE
WITH PopvsVac (continent,location,date,population,new_vaccinations,running_total)
AS
(
SELECT cd.continent,cd.location,cd.date,cd.population,
	cv.new_vaccinations,SUM(cv.new_vaccinations) 
	OVER (PARTITION by cd.location ORDER BY cd.location,cd.date) 
	AS running_total
	--(running_total/population)*100
FROM coviddeaths cd
JOIN cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (running_total/population)*100 AS percent_vac
FROM PopvsVac

-- Temp Table
--DROP TABLE IF exists percent_population_vaccinated
CREATE TABLE percent_population_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
running_total numeric
)
insert into percent_population_vaccinated
SELECT cd.continent,cd.location,cd.date,cd.population,
	cv.new_vaccinations,SUM(cv.new_vaccinations) 
	OVER (PARTITION by cd.location ORDER BY cd.location,cd.date) 
	AS running_total
	--(running_total/population)*100
FROM coviddeaths cd
JOIN cv
	ON cd.location = cv.location
	AND cd.date = cv.date
--WHERE cd.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (running_total/population)*100 AS percent_vac
FROM percent_population_vaccinated

-- Creating view to store data for later visualizations

CREATE VIEW percent_population_vaccinated AS
SELECT cd.continent,cd.location,cd.date,cd.population,
	cv.new_vaccinations,SUM(cv.new_vaccinations) 
	OVER (PARTITION by cd.location ORDER BY cd.location,cd.date) 
	AS running_total
	--(running_total/population)*100
FROM coviddeaths cd
JOIN cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
--ORDER BY 2,3