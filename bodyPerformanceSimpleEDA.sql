--Exploaratory analysis of bodyPerformance dataset
--The main focus will be ages and sex differences for visualization

Select *
From PortfolioProjects.dbo.bodyPerformance
ORDER BY age

--checking demographics
--number of males and females
Select gender, COUNT(*) num_of_people
From PortfolioProjects.dbo.bodyPerformance
GROUP BY gender
--many more men in the study than women


--age range
Select gender, MIN(age) youngest, MAX(age) oldest
From PortfolioProjects.dbo.bodyPerformance
GROUP BY gender

--Looking at body fat and weight by age
Select gender, age, AVG(body_fat) AverageFatPercent, AVG(weight_kg) AverageWeight
From PortfolioProjects.dbo.bodyPerformance
Group by age, gender
ORDER By age

--Creating two seperate temp tables to distinguish between male and female peformance

SELECT age,
	gender,
	height_cm,
	weight_kg,
	body_fat,
	diastolic,
	systolic,
	gripForce,
	sit_and_bend_forward_cm,
	sit_ups_counts,
	broad_jump_cm,
	class
INTO #Males
From PortfolioProjects.dbo.bodyPerformance
Where gender = 'M'


SELECT age,
	gender,
	height_cm,
	weight_kg,
	body_fat,
	diastolic,
	systolic,
	gripForce,
	sit_and_bend_forward_cm,
	sit_ups_counts,
	broad_jump_cm,
	class
INTO #Females
From PortfolioProjects.dbo.bodyPerformance
Where gender = 'F'

Select *
From #Females
ORDER BY age

Select *
From #Males
ORDER BY age

--using the temp tables to discover some simple statistics
Select age, Count(age) num_of_females, AVG(height_cm) mean_height, AVG(weight_kg) mean_weight,
AVG(sit_ups_counts) mean_situps, AVG(broad_jump_cm) mean_broad_jump
From #Females
GROUP BY age
ORDER BY age

Select age, Count(age) num_of_males, AVG(height_cm) mean_height, AVG(weight_kg) mean_weight,
AVG(sit_ups_counts) mean_situps, AVG(broad_jump_cm) mean_broad_jump
From #Males
GROUP BY age
ORDER BY age


--checking how the number of situps by age regardless of gender

SELECT age, SUM(#Males.sit_ups_counts) total_situps
FROM #Males
GROUP BY age
ORDER BY age

SELECT age, SUM(#Females.sit_ups_counts) total_situps
FROM #Females
GROUP BY age
ORDER BY age

--Putting them into one simple table
SELECT gender, age, SUM(CAST(#Males.sit_ups_counts AS int)) total_situps
FROM #Males
GROUP BY age, gender
UNION
SELECT gender, age, SUM(CAST(#Females.sit_ups_counts AS int)) total_situps
FROM #Females
GROUP BY age, gender
ORDER BY age






