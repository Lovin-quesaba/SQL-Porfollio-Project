SELECT 
	*
FROM
	MyPorfollioProject. .CovDeath
ORDER BY
	3,4


SELECT 
	*
FROM
	MyPorfollioProject. .CovVax
ORDER BY
	3,4


-- Selecting data to work with

SELECT 
	continent, 
	location,
	date,
	population, 
	total_cases,
	total_deaths
FROM
	MyPorfollioProject. .CovDeath
ORDER BY
	2,3




-- Filters data with correct date format

SELECT 
	continent, 
	location,
	CAST(date AS date) AS date,
	population, 
	total_cases,
	new_cases,
	total_deaths
FROM
	MyPorfollioProject. .CovDeath
WHERE
	continent = 'Asia' AND continent IS NOT NULL AND 
	date BETWEEN '2021-01-01' AND '2022-10-30'
ORDER BY
	2,3




-- Countries in Asia with atleast 1M new cases date BETWEEN '2022-01-01' AND '2022-10-30'


SELECT
	location country,
	SUM(new_cases) new_cases,
	SUM(CAST(new_deaths AS INT)) new_deaths
FROM 
	MyPorfollioProject. .CovDeath
WHERE 
	continent = 'Asia' AND
	date BETWEEN '2022-01-01' AND '2022-10-30'
GROUP BY 
	location
HAVING
	SUM(new_cases) >=1000000
ORDER BY
	new_cases DESC



-- Total Cases vs Total Deaths between January 2021 to January 2022
-- Shows likelihood of dying if confirmed positive with covid in variuos country in Asia

SELECT 
	continent, 
	location,
	CAST(date AS date) AS date,
	population, 
	total_cases,
	total_deaths,
	(total_deaths/total_cases)*100 AS death_percantage
FROM
	MyPorfollioProject. .CovDeath
WHERE
	continent = 'Asia' AND continent IS NOT NULL AND 
	date BETWEEN '2021-01-01' AND '2022-10-30'
ORDER BY
	death_percantage DESC



-- Total Cases vs Population
-- Shows what percentage of population infected with Covid in Asia from January 2021 to January 2022

SELECT 
	continent,
	location,
	CAST(date AS date) AS date,
	population, 
	total_cases,
	(total_cases/population)*100 AS percentage_infected_population
FROM
	MyPorfollioProject. .CovDeath
WHERE
	continent = 'Asia' AND continent IS NOT NULL AND 
	date BETWEEN '2021-01-01' AND '2022-10-30'
ORDER BY
	percentage_infected_population DESC



-- Countries with Highest Infection Rate compared to Population IN Asia

SELECT 
	location,
	population,
	MAX(total_cases) as HighestInfectionCount,
	Max((total_cases/population))*100 as percentage_infected_population
FROM 
	MyPorfollioProject. .CovDeath
WHERE
	continent = 'Asia' AND continent IS NOT NULL AND 
	date BETWEEN '2021-01-01' AND '2022-10-30'
GROUP BY
	location, 
	Population
ORDER BY
	percentage_infected_population desc



-- Countries with Highest Death Count and Percentage per Population

SELECT 
	location,
	population,
	MAX(total_deaths) as total_death_count,
	Max((total_deaths/population))*100 as population_death_percentage
FROM 
	MyPorfollioProject. .CovDeath
WHERE
	continent = 'Asia' AND continent IS NOT NULL AND 
	date BETWEEN '2021-01-01' AND '2022-10-30'
GROUP BY
	location, 
	Population
ORDER BY
	population_death_percentage desc



-- BREAKING THINGS DOWN BY COUNTRY IN ASIA

-- Showing countries with the highest death count per population

SELECT 
	location,
	MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM
	MyPorfollioProject. .CovDeath
--Where location like '%states%'
WHERE
	continent = 'Asia' AND continent IS NOT NULL
GROUP BY
	location
ORDER BY
	TotalDeathCount desc



-- ASIAN TOTAL NUMBER OF CASES, TOTAL NUMBER OF DEATHS, AND NEW DEATHS OVER NEW CASES %

SELECT
	--CAST(date AS date) AS date,
	SUM(new_cases) AS total_cases,
	SUM(cast(new_deaths AS int)) AS total_deaths,
	SUM(cast(new_deaths AS int))/SUM(New_Cases)*100 AS DeathPercentage
From 
	MyPorfollioProject. .CovDeath
WHERE
	continent = 'Asia' AND continent IS NOT NULL AND 
	date BETWEEN '2021-01-01' AND '2022-10-30'
--Group By 
--	date
ORDER BY 
	1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vax.new_vaccinations,
	SUM(CONVERT(int,vax.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) AS RollingPeopleVaccinated
FROM 
	MyPorfollioProject. .CovDeath dea
JOIN 
	MyPorfollioProject. .CovVax vax
	ON 
		dea.location = vax.location
	and 
		dea.date = vax.date
WHERE 
	dea.continent is not null
ORDER BY
	2,3



