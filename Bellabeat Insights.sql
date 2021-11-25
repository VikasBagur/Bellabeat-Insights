--The time of the day when most calories are burnt, high activity intensity and no of steps walked
WITH merged AS
(
SELECT Calories.Id,
Calories.ActivityHour,
Calories.Calories,
Intensity.TotalIntensity,
Intensity.AverageIntensity,
Steps.StepTotal,
CAST(Calories.ActivityHour AS date) AS Date,
CAST(Calories.ActivityHour AS time) AS Time
FROM hourlyCalories_merged AS Calories
JOIN hourlyIntensities_merged AS Intensity
ON Calories.Id = Intensity.Id
AND Calories.ActivityHour = Intensity.ActivityHour
JOIN hourlySteps_merged AS Steps
ON Calories.Id = Steps.Id
AND Calories.ActivityHour = Steps.ActivityHour
)
SELECT Time, SUM(Calories) as Calories, SUM(TotalIntensity) AS Intensity, SUM(StepTotal) AS Steps
FROM merged
GROUP BY Time
ORDER BY Calories DESC, Intensity DESC, Steps DESC

--Data about people who have BMI more than 25, which includes overweight and obese people
SELECT *
FROM weightLogInfo_merged
WHERE BMI > 25.0

SELECT DISTINCT Id
FROM weightLogInfo_merged
WHERE BMI > 25.0

SELECT COUNT(DISTINCT Id) *100.0 / (SELECT COUNT(DISTINCT Id) FROM weightLogInfo_merged) as Percentage
FROM weightLogInfo_merged
WHERE BMI > 25.0

--Data about people who have slept less than 7 hours
SELECT Id, AVG(TotalMinutesAsleep / 60) as Avg_hours_slept
FROM sleepDay_merged
GROUP BY Id
ORDER BY Avg_hours_slept ASC


WITH hours_slept AS
(
SELECT Id, AVG(TotalMinutesAsleep / 60) as Avg_hours_slept
FROM sleepDay_merged
GROUP BY Id
)
SELECT COUNT(Avg_hours_Slept) * 100 / (SELECT COUNT(Avg_hours_slept) FROM hours_slept) as sleeping_less
FROM hours_slept
WHERE Avg_hours_slept < 7