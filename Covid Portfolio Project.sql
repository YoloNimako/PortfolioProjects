Select *
From PortfolioProject..CovidDeaths$
order by 3, 4

--Select *
--From PortfolioProject..CovidVaccination$
--order by 3, 4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
order by 1, 2

-- Looking at Total Cases vs Total Deaths in South Africa
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
From PortfolioProject..CovidDeaths$
Where location like '%South Africa%'
order by 1, 2

--Looking at Total Cases vs Population
--shows what percentage of population got COVID

Select Location, date,population , total_cases, (total_cases/population) * 100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Where location like '%South Africa%'
order by 1, 2

--Looking at countries with Highest Infection Rate compared to population

Select Location,population , MAX(total_cases) as HighestInfectionCount, Max(total_cases/population) * 100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Group by Location,population
order by PercentPopulationInfected desc

-- Showing Countries with the Highest Death Count per Population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by Location
order by TotalDeathCount desc

--Death Rate by Continent

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Global Numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

--Total Population vs Vaccinations using CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac

 