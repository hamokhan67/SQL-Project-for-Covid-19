
SELECT *
FROM [sql_project 1]..covid_deaths
ORDER BY 3,4

--SELECT *
--FROM [sql_project 1]..covid_vaccination
--ORDER BY 3,4;

-- Select the Data that we are using 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [sql_project 1]..covid_deaths
ORDER BY 1,2


-- looking at total cases vs total deaths

ALTER TABLE dbo.covid_deaths 
ALTER COLUMN total_cases numeric;




SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM [sql_project 1]..covid_deaths
ORDER BY 1,2;


-- Looking at total cases vs population

ALTER TABLE dbo.covid_deaths 
ALTER COLUMN population numeric;

SELECT location, date,continent, population,  (total_cases),(total_cases/population)*100 AS infection_percantage
FROM [sql_project 1]..covid_deaths
ORDER BY 1,2;

-- Looking at Countries with highest Infection Rate compare to the population


SELECT location, population, max(total_cases) AS HighestInflationCount,max((total_cases/population))*100 AS infection_percantage
FROM [sql_project 1]..covid_deaths
GROUP BY location, population
ORDER BY infection_percantage desc


-- Showing Countries with Highest Death Count per Population

SELECT location, population, max(total_deaths) AS HighestInfactionCount,max((total_deaths/population))*100 AS death_percantage
FROM [sql_project 1]..covid_deaths
WHERE  continent is NOT NULL
GROUP BY location, population
ORDER BY location 

-- Lets do it for Continent

-- Showing continents with the highest deaths count per population

SELECT location,  max(total_deaths) AS total_death_count 
FROM [sql_project 1]..covid_deaths
WHERE  continent is  NULL
GROUP BY location
ORDER BY total_death_count DESC

-- Globel Numbers

SELECT SUM(cast(new_cases AS NUMERIC)) AS Total_cases, SUM(CAST(new_deaths AS NUMERIC)) AS Total_deaths, 
(SUM(CAST(new_deaths AS NUMERIC))/SUM(cast(new_cases AS NUMERIC)))*100 AS DeathPercentage
FROM [sql_project 1]..covid_deaths
WHERE continent IS NOT NULL


-- Looking population vs vaccinations


SELECT death.location, death.continent,death.date, death.population, vacc.new_vaccinations,
SUM(CONVERT(numeric,vacc.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location,death.date) AS totalvaccination,
(SUM(CONVERT(numeric,vacc.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location,death.date)/death.population)*100 AS vaccinationpercentage
FROM [sql_project 1]..covid_deaths AS death
JOIN [sql_project 1]..covid_vaccination AS vacc
ON		 death.location	=	vacc.location AND
		death.date = vacc.date
WHERE death.continent IS NOT NULL
--GROUP BY population, death.continent
ORDER BY 1,2
 

 --USE CTE FOR PAKISTAN

 WITH PopvsVac (Location, Continent, Date, Population,New_vaccination, totalvaccination, vaccinationpercentage)
 AS 
 (
 SELECT death.location, death.continent,death.date, death.population, vacc.new_vaccinations,
SUM(CONVERT(numeric,vacc.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location,death.date) AS totalvaccination,
(SUM(CONVERT(numeric,vacc.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location,death.date)/death.population)*100 AS vaccinationpercentage
FROM [sql_project 1]..covid_deaths AS death
JOIN [sql_project 1]..covid_vaccination AS vacc
ON		 death.location	=	vacc.location AND
		death.date = vacc.date
WHERE death.continent IS NOT NULL
)
SELECT * 
FROM PopvsVac
WHERE Location = 'Pakistan' AND Date = '2024-04-14'




--Creating Temp Table

DROP TABLE IF EXISTS #Percentpeoplevacccinated
CREATE TABLE #Percentpeoplevacccinated
(
Location NVARCHAR (250),
Continent NVARCHAR (250),
Date DATETIME,
Population NUMERIC,
New_vaccination NUMERIC,
totalvaccination NUMERIC,
vaccinationpercentage NUMERIC
)
INSERT INTO #Percentpeoplevacccinated

SELECT death.location, death.continent,death.date, death.population, vacc.new_vaccinations,
SUM(CONVERT(numeric,vacc.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location,death.date) AS totalvaccination,
(SUM(CONVERT(numeric,vacc.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location,death.date)/death.population)*100 AS vaccinationpercentage
FROM [sql_project 1]..covid_deaths AS death
JOIN [sql_project 1]..covid_vaccination AS vacc
ON		 death.location	=	vacc.location AND
		death.date = vacc.date
WHERE death.continent IS NOT NULL
ORDER BY 1,2
SELECT * 
FROM #Percentpeoplevacccinated


-- Creating View to Store Data For Visualizations

DROP VIEW IF EXISTS PercentPopulationVaccinated;


CREATE VIEW PercentPopulationVaccinated
AS 
SELECT death.location, death.continent,death.date, death.population, vacc.new_vaccinations,
SUM(CONVERT(numeric,vacc.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location,death.date) AS totalvaccination,
(SUM(CONVERT(numeric,vacc.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location,death.date)/death.population)*100 AS vaccinationpercentage
FROM [sql_project 1]..covid_deaths AS death
JOIN [sql_project 1]..covid_vaccination AS vacc
ON		 death.location	=	vacc.location AND
		death.date = vacc.date
WHERE death.continent IS NOT NULL
--ORDER BY 1,2











