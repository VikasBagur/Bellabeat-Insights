library(tidyverse)
library(basictabler)

#Insight No 1 - Calories, Intensity and Steps
hourly_calories <- read_csv("C:/Users/vikas/Desktop/My files/Course/Google Data Analytics/Portfolio/Bellabeat/Datasets/hourlyCalories_merged.csv")
hourly_intensities <- read_csv("C:/Users/vikas/Desktop/My files/Course/Google Data Analytics/Portfolio/Bellabeat/Datasets/hourlyIntensities_merged.csv")
hourly_steps <- read_csv("C:/Users/vikas/Desktop/My files/Course/Google Data Analytics/Portfolio/Bellabeat/Datasets/hourlySteps_merged.csv")

hourly_calories$date <- as.Date(hourly_calories$ActivityHour, format = "%m/%d/%Y")
hourly_calories$time <- format(strptime(hourly_calories$ActivityHour, "%m/%d/%Y %I:%M:%S %p"), "%H:%M:%S")

join_calories_intensities <- inner_join(hourly_calories, hourly_intensities, by = c("Id","ActivityHour"))[,c("Id","Calories","ActivityHour","date","time","TotalIntensity")] %>% 
  arrange(Id, date, time)
final_join <- inner_join(join_calories_intensities, hourly_steps, by = c("Id","ActivityHour"))[,c("Id","Calories","date","time","TotalIntensity","StepTotal")]

Sum_activities <- aggregate(cbind(Calories,TotalIntensity,StepTotal) ~ time, data = final_join, FUN = sum) %>% arrange(-Calories, -TotalIntensity, -StepTotal)

ggplot(data = Sum_activities) + geom_col(mapping = aes(x = time, y = Calories))

#Insight No 2 - BMI over 25

weightlog <- read_csv("C:/Users/vikas/Desktop/My files/Course/Google Data Analytics/Portfolio/Bellabeat/Datasets/weightLogInfo_merged.csv")

BMI_above_25 <- nrow(distinct(select(filter(weightlog, BMI > 25), Id)))

class(BMI_above_25)
ids <- nrow(distinct(select(weightlog, Id)))

nrow(BMI_above_25)
nrow(ids)

percentage = ((BMI_above_25 / ids) * 100)

percentage

insight_2 <- BasicTable$new()
insight_2$addData(data.frame(ids, BMI_above_25, percentage),
                  explicitColumnHeaders = c("Users","Users with BMI > 25","Percentage of Users")
)
insight_2$theme <- "largeplain"
insight_2$renderTable(styleNamePrefix = "t2")


#Insight No 3 - Sleep less than 7 Hrs

sleepday <- read_csv("C:/Users/vikas/Desktop/My files/Course/Google Data Analytics/Portfolio/Bellabeat/Datasets/sleepDay_merged.csv")

avg_hours <- sleepday %>% group_by(Id) %>% summarize(avg_hours_slept = round(mean(TotalMinutesAsleep / 60), digits = 2)) %>% arrange(avg_hours_slept)

sleep_ids <- nrow(distinct(select(sleepday, Id)))
sleep_less_than_7 <- nrow(distinct(select(filter(avg_hours, avg_hours_slept < 7),Id)))
percentage_people_sleeping_less_hrs <- (sleep_less_than_7 / sleep_ids) * 100


insight_3 <- BasicTable$new()
insight_3$addData(data.frame(sleep_ids, sleep_less_than_7, percentage_people_sleeping_less_hrs),
                  firstColumnAsRowHeaders = FALSE,
                  explicitColumnHeaders = c("Users","Users who sleep < 7Hrs","Percentage of users"),
)

insight_3$theme <- "largeplain"
insight_3$renderTable(styleNamePrefix="t2")




