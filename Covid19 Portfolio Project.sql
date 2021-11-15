-- Let us begin! To start off, I will be going to explore the CovidDeaths Table.
SELECT *
FROM covid_deaths;

-- I realized that there are many extra columns that we will not be using for this project.
-- I only want to select the follow columns (location, date, total cases,new cases and total deaths)
SELECT location, date, total_cases ,new_cases, total_deaths
FROM covid_deaths
ORDER BY location;

-- Now, I want to take a look at the Total Cases vs the Total Death (in percentage)
SELECT location, date, total_cases ,new_cases, total_deaths, ROUND((total_deaths/total_cases) * 100, 2) AS "Death Percentage (%)"
FROM covid_deaths
ORDER BY location;

-- This shows the likelihood of dying if you contract covid in Argentina. (used the wildcard character to be sure I don't miss out anything)
-- Using data for Argentina because I kinda know the Covid numbers in Singapore and yeah, just wanted to check someplace else!
SELECT location, date, total_cases ,new_cases, total_deaths, ROUND((total_deaths/total_cases) * 100, 2) AS "Death Percentage (%)"
FROM covid_deaths
WHERE location LIKE "%tina%"
ORDER BY location;

-- Now, I want to look a the Total Cases vs Population in Argentina
SELECT location, date, total_cases ,population, ROUND((total_cases/population) * 100, 2) AS "Infection Percentage by Population (%)"
FROM covid_deaths
WHERE location LIKE "%argen%"
ORDER BY location;

-- Looking at countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) AS "Highest Infection Count",(MAX((total_cases/population) * 100)) AS "Infection Percentage by Country (%)"
FROM covid_deaths
GROUP BY location, population
ORDER BY 4 DESC;

-- Going to show countries with the Highest Death Count
-- Used the CAST() function because the original datatype was TEXT. Hence I had to use cast() to convert it.
SELECT location, MAX(cast(total_deaths AS unsigned)) AS "Total Death Count"
FROM covid_deaths
GROUP BY location
ORDER BY 2 DESC;

-- Going to show Continents with the Highest Death Count
SELECT continent, MAX(cast(total_deaths AS unsigned)) AS "Total Death Count"
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC;

-- Global Numbers (based on this dataset): total cases, total deaths and death percentage each day
SELECT date, SUM(total_cases) AS "Total Global Cases", SUM(cast(total_deaths AS unsigned)) AS "Total Global Deaths", (SUM(total_cases)/SUM(cast(total_deaths AS unsigned))) AS "Global Death Percentage"
FROM covid_deaths
GROUP BY date;

-- I know want to know the Total Population vs Vaccinations
-- Joining covid_deaths & covid_vaccinations table

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(cast(vac.new_vaccinations AS unsigned)) OVER (Partition By dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
ORDER BY 2;

