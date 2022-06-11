-- These queries are some queries that are possible on this data. 
SELECT *
FROM CovidDeaths
ORDER BY location;
-- SELECT * FROM CovidVaccinations
-- ORDER BY location;
SELECT location,
    _date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM CovidDeaths
ORDER BY location,
    _date;
-- Look at total_cases vs. total_deaths
-- Let's see the percent of people who died who got COVID.
SELECT location,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 as DeathPercent
FROM CovidDeaths
ORDER BY DeathPercent DESC;
-- Let's see the percent of people who died only in France 
SELECT _date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 as DeathPercent
FROM CovidDeaths
WHERE location LIKE "%France%"
ORDER BY _date DESC;
-- Let's see the top 10 countries with the highest average death percentages;
SELECT location,
    AVG(total_deaths / total_cases) * 100 as DeathPercent
FROM CovidDeaths
GROUP BY location
ORDER BY DeathPercent DESC
LIMIT 10;
-- Let's see the top 10 locatoins with the highest cases;
SELECT location,
    MAX(total_cases) as MaximumCases
FROM CovidDeaths
GROUP BY location
ORDER BY MaximumCases DESC
LIMIT 10;
-- Let's see the top 10 locations with the highest infection rates
SELECT location,
    population,
    MAX(total_cases) as MaximumCases,
    MAX(total_cases / population) * 100 as InfectionRate
FROM CovidDeaths
GROUP BY location,
    population
ORDER BY InfectionRate DESC
LIMIT 10;
-- Let's see the death count per continent
SELECT continent,
    AVG(total_deaths) as AverageDeath
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent;
-- Let's see new cases 
SELECT _date,
    SUM(new_cases) as total_cases,
    SUM(new_deaths) as total_deaths,
    (SUM(new_deaths) / SUM(new_cases)) * 100 as DeathPercent
FROM CovidDeaths
WHERE CONTINENT IS NOT NULL
GROUP BY _date
ORDER BY _date DESC;
-- Let's see total cases globally (at the time of this data)
SELECT SUM(total_cases) as global_cases,
    SUM(total_deaths) as global_deaths,
    SUM(total_deaths) / SUM(total_cases) * 100 as global_death_percentage
FROM CovidDeaths;
-- Let's see a cumulative sum of people getting vaccinated
SELECT CovidDeaths.continent,
    CovidDeaths.location,
    CovidDeaths._date,
    CovidDeaths.population,
    CovidVaccinations.new_vaccinations,
    SUM(CovidVaccinations.new_vaccinations) OVER (
        PARTITION BY CovidDeaths.location
        ORDER BY CovidVaccinations.new_vaccinations ASC
    ) as CumulativeVaccinations
FROM CovidDeaths
    JOIN CovidVaccinations ON CovidDeaths.location = CovidVaccinations.location
    AND CovidDeaths._date = CovidVaccinations._date;
-- Let's see how the vaccination rates increase over time
WITH vaccinatedPopulation (
    Continent,
    Location,
    _Date,
    Population,
    New_Vaccinations,
    CumulativeVaccinations
) as (
    SELECT CovidDeaths.continent,
        CovidDeaths.location,
        CovidDeaths._date,
        CovidDeaths.population,
        CovidVaccinations.new_vaccinations,
        SUM(CovidVaccinations.new_vaccinations) OVER (
            PARTITION BY CovidVaccinations.location
            ORDER BY CovidVaccinations.new_vaccinations ASC
        )
    FROM CovidDeaths
        JOIN CovidVaccinations ON CovidDeaths.location = CovidVaccinations.location
        AND CovidDeaths._date = CovidVaccinations._date
)
SELECT *,
    (CumulativeVaccinations / Population) as CumulativeVaccineRate
FROM vaccinatedPopulation;
CREATE TABLE VaccinatedPopulation (
    Continent VARCHAR(100),
    Location VARCHAR(100),
    _Date date,
    Population INT,
    New_Vaccinations INT,
    Cumulative_Vaccinations INT,
    Cumulative_Vaccination_Rate FLOAT
);
INSERT INTO VaccinatedPopulation (
        WITH vaccinatedPopulation (
            Continent,
            Location,
            _Date,
            Population,
            New_Vaccinations,
            CumulativeVaccinations
        ) as (
            SELECT CovidDeaths.continent,
                CovidDeaths.location,
                CovidDeaths._date,
                CovidDeaths.population,
                CovidVaccinations.new_vaccinations,
                SUM(CovidVaccinations.new_vaccinations) OVER (
                    PARTITION BY CovidVaccinations.location
                    ORDER BY CovidVaccinations.new_vaccinations ASC
                )
            FROM CovidDeaths
                JOIN CovidVaccinations ON CovidDeaths.location = CovidVaccinations.location
                AND CovidDeaths._date = CovidVaccinations._date
        )
        SELECT *,
            (CumulativeVaccinations / Population) as CumulativeVaccineRate
        FROM vaccinatedPopulation
    );
SELECT *
FROM VaccinatedPopulation;
SHOW TABLES;