-- To create this table, I used the Pandas library in Python
-- To fill all blank spaces in the original CSV file with '\N' so that mySQL could interpret 
-- that string as a NULL value. Otherwise, it would not continue past row 1.
DROP TABLE sampleproject.CovidVaccinations;
CREATE TABLE sampleproject.CovidVaccinations (
    iso_code VARCHAR(100),
    continent VARCHAR(100),
    location VARCHAR(100),
    _date DATE,
    new_tests INT,
    total_tests INT,
    total_tests_per_thousand FLOAT,
    new_tests_per_thousand FLOAT,
    new_tests_smoothed FLOAT,
    new_tests_smoothed_per_thousand FLOAT,
    positive_rate FLOAT,
    tests_per_case FLOAT,
    test_units VARCHAR(50),
    total_vaccinations INT,
    people_vaccinated INT,
    people_fully_vaccinated INT,
    new_vaccinations INT,
    new_vaccinations_smoothed INT,
    total_vaccinations_per_hundred FLOAT,
    people_vaccinated_per_hundred FLOAT,
    people_fully_vaccinated_per_hundred FLOAT,
    new_vaccinations_smoothed_per_million INT,
    strigency_index FLOAT,
    population INT,
    population_density FLOAT,
    media_age FLOAT,
    aged_65_older FLOAT,
    aged_70_older FLOAT,
    gdp_per_capita FLOAT,
    extreme_poverty FLOAT,
    cardiovasc_death_rate FLOAT,
    diabetes_prevalence FLOAT,
    female_smokers FLOAT,
    male_smokers FLOAT,
    handwashing_facilities FLOAT,
    hospital_beds_per_thousand FLOAT,
    life_expectancy FLOAT,
    human_development_index FLOAT
);
-- Load CSV files into the table
LOAD DATA INFILE '/usr/local/mysql-8.0.29-macos12-arm64/CovidVaccinations.csv' INTO TABLE sampleproject.CovidVaccinations FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS (
    iso_code,
    continent,
    location,
    @_date,
    new_tests,
    total_tests,
    total_tests_per_thousand,
    new_tests_per_thousand,
    new_tests_smoothed,
    new_tests_smoothed_per_thousand,
    positive_rate,
    tests_per_case,
    test_units,
    total_vaccinations,
    people_vaccinated,
    people_fully_vaccinated,
    new_vaccinations,
    new_vaccinations_smoothed,
    total_vaccinations_per_hundred,
    people_vaccinated_per_hundred,
    people_fully_vaccinated_per_hundred,
    new_vaccinations_smoothed_per_million,
    strigency_index,
    population,
    population_density,
    media_age,
    aged_65_older,
    aged_70_older,
    gdp_per_capita,
    extreme_poverty,
    cardiovasc_death_rate,
    diabetes_prevalence,
    female_smokers,
    male_smokers,
    handwashing_facilities,
    hospital_beds_per_thousand,
    life_expectancy,
    human_development_index
)
SET _date = STR_TO_DATE(@_date, '%m/%d/%y');
SELECT *
FROM CovidDeaths;
SHOW TABLES;