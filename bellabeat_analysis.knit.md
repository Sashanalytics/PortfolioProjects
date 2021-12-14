---
title: "Bellabeat Analysis"
author: "Sean Ashby"
date: "11/10/2021"
output:
  pdf_document: default
  html_document: default
---

## Bellabeat Analysis

Welcome to my simple analysis of the Bellabeat case study in the Google Data 
Analytics certificate. This is my first business analysis so I am sure there
are many ways I can improve it, so any comments are welcomed.

### Business Task and Process

Identify trends in the smart device usage market and utilize them to provide recommendations a for marketing strategy.

Data to be used is the FitBit Fitness Tracker Data provided by Mobius on Kaggle. 
This Kaggle data set contains personal fitness tracker from *thirty consenting fitbit users including output for
physical activity, daily activity, heart rate, steps, and sleep monitoring.

*While the description of the data stated 30 users, analysis indicated 33Users may have worn multiple bands, we cannot tell form the data so we will use 33 users as our population.*

### Analysis
*What is the data telling us?*

First, let's install the packages and libraries we will use in the analysis.


```r
install.packages("tidyverse")
```

```
## Installing package into '/home/rstudio-user/R/x86_64-pc-linux-gnu-library/4.0'
## (as 'lib' is unspecified)
```

```r
library(tidyverse)
```

```
## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
```

```
## v ggplot2 3.3.3     v purrr   0.3.4
## v tibble  3.1.0     v dplyr   1.0.5
## v tidyr   1.1.4     v stringr 1.4.0
## v readr   1.4.0     v forcats 0.5.1
```

```
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
install.packages("tidyr")
```

```
## Installing package into '/home/rstudio-user/R/x86_64-pc-linux-gnu-library/4.0'
## (as 'lib' is unspecified)
```

```r
library(tidyr)

install.packages("viridis")
```

```
## Installing package into '/home/rstudio-user/R/x86_64-pc-linux-gnu-library/4.0'
## (as 'lib' is unspecified)
```

```r
library(viridis)
```

```
## Loading required package: viridisLite
```

Now, we can create data frames for the data we are using.


```r
daily_activity <- read.csv("dailyActivity_merged.csv")
dailycalories <- read_csv("dailyCalories_merged.csv")
```

```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   Id = col_double(),
##   ActivityDay = col_character(),
##   Calories = col_double()
## )
```

```r
heartrate_seconds <- read_csv("heartrate_seconds_merged.csv")
```

```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   Id = col_double(),
##   Time = col_character(),
##   Value = col_double()
## )
```

```r
minutemets <- read_csv("minuteMETsNarrow_merged.csv")
```

```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   Id = col_double(),
##   ActivityMinute = col_character(),
##   METs = col_double()
## )
```

```r
weightlog <- read_csv("weightLogInfo_merged.csv")
```

```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   Id = col_double(),
##   Date = col_character(),
##   WeightKg = col_double(),
##   WeightPounds = col_double(),
##   Fat = col_double(),
##   BMI = col_double(),
##   IsManualReport = col_logical(),
##   LogId = col_double()
## )
```

```r
sleep_day <- read.csv("sleepDay_merged.csv")
```

Now we can take a look at some basic data in the daily_activity data frame.


```r
head(daily_activity)
```

```
##           Id ActivityDate TotalSteps TotalDistance TrackerDistance
## 1 1503960366    4/12/2016      13162          8.50            8.50
## 2 1503960366    4/13/2016      10735          6.97            6.97
## 3 1503960366    4/14/2016      10460          6.74            6.74
## 4 1503960366    4/15/2016       9762          6.28            6.28
## 5 1503960366    4/16/2016      12669          8.16            8.16
## 6 1503960366    4/17/2016       9705          6.48            6.48
##   LoggedActivitiesDistance VeryActiveDistance ModeratelyActiveDistance
## 1                        0               1.88                     0.55
## 2                        0               1.57                     0.69
## 3                        0               2.44                     0.40
## 4                        0               2.14                     1.26
## 5                        0               2.71                     0.41
## 6                        0               3.19                     0.78
##   LightActiveDistance SedentaryActiveDistance VeryActiveMinutes
## 1                6.06                       0                25
## 2                4.71                       0                21
## 3                3.91                       0                30
## 4                2.83                       0                29
## 5                5.04                       0                36
## 6                2.51                       0                38
##   FairlyActiveMinutes LightlyActiveMinutes SedentaryMinutes Calories
## 1                  13                  328              728     1985
## 2                  19                  217              776     1797
## 3                  11                  181             1218     1776
## 4                  34                  209              726     1745
## 5                  10                  221              773     1863
## 6                  20                  164              539     1728
```

```r
colnames(daily_activity)
```

```
##  [1] "Id"                       "ActivityDate"            
##  [3] "TotalSteps"               "TotalDistance"           
##  [5] "TrackerDistance"          "LoggedActivitiesDistance"
##  [7] "VeryActiveDistance"       "ModeratelyActiveDistance"
##  [9] "LightActiveDistance"      "SedentaryActiveDistance" 
## [11] "VeryActiveMinutes"        "FairlyActiveMinutes"     
## [13] "LightlyActiveMinutes"     "SedentaryMinutes"        
## [15] "Calories"
```

Doing the same for the sleep_day data frame.

```r
head(sleep_day)
```

```
##           Id              SleepDay TotalSleepRecords TotalMinutesAsleep
## 1 1503960366 4/12/2016 12:00:00 AM                 1                327
## 2 1503960366 4/13/2016 12:00:00 AM                 2                384
## 3 1503960366 4/15/2016 12:00:00 AM                 1                412
## 4 1503960366 4/16/2016 12:00:00 AM                 2                340
## 5 1503960366 4/17/2016 12:00:00 AM                 1                700
## 6 1503960366 4/19/2016 12:00:00 AM                 1                304
##   TotalTimeInBed
## 1            346
## 2            407
## 3            442
## 4            367
## 5            712
## 6            320
```

```r
colnames(sleep_day)
```

```
## [1] "Id"                 "SleepDay"           "TotalSleepRecords" 
## [4] "TotalMinutesAsleep" "TotalTimeInBed"
```

Looking to some usage statistics with respect to daily activity and sleep.


```r
n_distinct(daily_activity$Id)
```

```
## [1] 33
```

```r
n_distinct(sleep_day$Id)
```

```
## [1] 24
```

We can see the number of users with sleep information is less than those for daily activity. This simply means some users do not wear their smart devices to bed. Is sleep information still a viable feature?


```r
(24/33)*100
```

```
## [1] 72.72727
```

Over 70% of users wear their smart devices to bed, as such, sleep monitoring is still a useful feature to keep on devices.

Continuing looking into daily activities and sleep.


```r
nrow(daily_activity)
```

```
## [1] 940
```

```r
nrow(sleep_day)
```

```
## [1] 413
```
Summarizing daily_activity.


```r
daily_activity %>%  
  select(TotalSteps,
         TotalDistance,
         SedentaryMinutes) %>%
  summary()
```

```
##    TotalSteps    TotalDistance    SedentaryMinutes
##  Min.   :    0   Min.   : 0.000   Min.   :   0.0  
##  1st Qu.: 3790   1st Qu.: 2.620   1st Qu.: 729.8  
##  Median : 7406   Median : 5.245   Median :1057.5  
##  Mean   : 7638   Mean   : 5.490   Mean   : 991.2  
##  3rd Qu.:10727   3rd Qu.: 7.713   3rd Qu.:1229.5  
##  Max.   :36019   Max.   :28.030   Max.   :1440.0
```

Same for sleep_day.


```r
sleep_day %>%  
  select(TotalSleepRecords,
         TotalMinutesAsleep,
         TotalTimeInBed) %>%
  summary()
```

```
##  TotalSleepRecords TotalMinutesAsleep TotalTimeInBed 
##  Min.   :1.000     Min.   : 58.0      Min.   : 61.0  
##  1st Qu.:1.000     1st Qu.:361.0      1st Qu.:403.0  
##  Median :1.000     Median :433.0      Median :463.0  
##  Mean   :1.119     Mean   :419.5      Mean   :458.6  
##  3rd Qu.:1.000     3rd Qu.:490.0      3rd Qu.:526.0  
##  Max.   :3.000     Max.   :796.0      Max.   :961.0
```

These give us a basic look. Let's see how it looks graphically.


```r
ggplot(data=daily_activity, aes(x=TotalSteps, y=SedentaryMinutes)) + 
  geom_point()
```

![](bellabeat_analysis_files/figure-latex/fig. 1 showing sedentary minutes vs total steps-1.pdf)<!-- --> 

*This plot shows those with higher sedentary minutes in general took fewer steps. Giving users a 'daily steps' goal can get people walking more and increase interest in the product.*

Looking into sleep time and time in bed.


```r
ggplot(data=sleep_day, aes(x=TotalMinutesAsleep, y=TotalTimeInBed)) + 
  geom_point()
```

![](bellabeat_analysis_files/figure-latex/fig 2 showing total time in bed vs minutes actually asleep-1.pdf)<!-- --> 

This was expected to be a straight line, however it is not, meaning some users may have trouble falling or staying asleep. They are in bed for longer than they are asleep. Digging deeper into this.


```r
combined_data <- merge(sleep_day, daily_activity, by="Id", all= TRUE)
n_distinct(combined_data$Id)
```

```
## [1] 33
```

Seeing how sleep relates to total steps.


```r
ggplot(data=combined_data, mapping = aes(x=TotalSteps, y=TotalMinutesAsleep)) +
  geom_point()
```

```
## Warning: Removed 227 rows containing missing values (geom_point).
```

![](bellabeat_analysis_files/figure-latex/fig 3 showing total minutes asleep vs total steps taken that day-1.pdf)<!-- --> 
This plot shows that a higher activity day with more steps taken does not necessarily lead to longer or better sleep. Many other factors outside the scope of this analysis affect sleep.

Looking at the weight log data frame.


```r
glimpse(weightlog)
```

```
## Rows: 67
## Columns: 8
## $ Id             <dbl> 1503960366, 1503960366, 1927972279, 2873212765, 2873212~
## $ Date           <chr> "5/2/2016 11:59:59 PM", "5/3/2016 11:59:59 PM", "4/13/2~
## $ WeightKg       <dbl> 52.6, 52.6, 133.5, 56.7, 57.3, 72.4, 72.3, 69.7, 70.3, ~
## $ WeightPounds   <dbl> 115.9631, 115.9631, 294.3171, 125.0021, 126.3249, 159.6~
## $ Fat            <dbl> 22, NA, NA, NA, NA, 25, NA, NA, NA, NA, NA, NA, NA, NA,~
## $ BMI            <dbl> 22.65, 22.65, 47.54, 21.45, 21.69, 27.45, 27.38, 27.25,~
## $ IsManualReport <lgl> TRUE, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, ~
## $ LogId          <dbl> 1.462234e+12, 1.462320e+12, 1.460510e+12, 1.461283e+12,~
```

```r
n_distinct(weightlog$Id)
```

```
## [1] 8
```

```r
(8/33)*100
```

```
## [1] 24.24242
```

Seems that less than a quarter of the users actually used the weight log feature in the study. Looking at the distribution of values closer.


```r
ggplot(data=weightlog, mapping = aes(x=Date, y=WeightKg)) + geom_point() + 
  facet_wrap(~Id) + theme(axis.text.x = element_blank())
```

![](bellabeat_analysis_files/figure-latex/fig 4  showing weight log entries by date-1.pdf)<!-- --> 

From the more detailed user separated graphs one can see that only two(2) users consistently uploaded weight log information through the course of the study. This could be because data has to be inputted mainly manually. Let's check.


```r
weightlog %>%
  select(IsManualReport) %>%
  summary()
```

```
##  IsManualReport 
##  Mode :logical  
##  FALSE:26       
##  TRUE :41
```

Most entries were indeed manual. As a smart device user myself, I relate to the difficulties of remaining consistent logging information. As useful as a feature this is for the most serious of body health enthusiasts, it is not an avenue to pursue for growth yet.

Taking a look at the heartrate data frame now.


```r
head(heartrate_seconds)
```

```
## # A tibble: 6 x 3
##           Id Time                 Value
##        <dbl> <chr>                <dbl>
## 1 2022484408 4/12/2016 7:21:00 AM    97
## 2 2022484408 4/12/2016 7:21:05 AM   102
## 3 2022484408 4/12/2016 7:21:10 AM   105
## 4 2022484408 4/12/2016 7:21:20 AM   103
## 5 2022484408 4/12/2016 7:21:25 AM   101
## 6 2022484408 4/12/2016 7:22:05 AM    95
```

And seeing how many individual users we have information from.


```r
n_distinct(heartrate_seconds$Id)
```

```
## [1] 14
```

Summarizing this data.


```r
avg_heartrate <- heartrate_seconds%>%
  group_by(Id) %>%
  summarise_at(vars(Value), list(avg_heartrate = mean))
```


```r
head(avg_heartrate)
```

```
## # A tibble: 6 x 2
##           Id avg_heartrate
##        <dbl>         <dbl>
## 1 2022484408          80.2
## 2 2026352035          93.8
## 3 2347167796          76.7
## 4 4020332650          82.3
## 5 4388161847          66.1
## 6 4558609924          81.7
```

This information is useful but does not tell the whole story. The average heart rate does not take into consideration time spent working out or sleeping. In general, a lower resting heart rate indicates a fitter person or could be indicative or a condition. Similarly, a way too high heart rate can show one has issues with clogged veins and arteries causing the heart to work harder. 


```r
n_distinct(filter(heartrate_seconds, Value>=180)$Id)
```

```
## [1] 8
```

```r
n_distinct(filter(heartrate_seconds, Value<60)$Id)
```

```
## [1] 13
```

Values for high and low heart rates vary on an individual basis, however, some simple values such as a resting rate below 60bpm(beats per minute), or an active rate above 180bpm could be signs of health problems. For low heart rates, *bradycardia* is a real possibility and could lead to further complications if untreated. A high heart rate could mean high blood pressure, clogged arteries and viens, and in general an overworked heart.

All these issues are potentially problematic. My suggestion based on this data is simple yet can save/change many lives. An alert which notifies the user of their heart health if it is in the danger zone. Perhaps a vibration or some flashes. This could be used to market the device as not only a fitness/lifestyle assistant, but one that could potentially save your life. 


Now, continuing into personal health. The daily calories data frame has drawn our attention.


```r
head(dailycalories)
```

```
## # A tibble: 6 x 3
##           Id ActivityDay Calories
##        <dbl> <chr>          <dbl>
## 1 1503960366 4/12/2016       1985
## 2 1503960366 4/13/2016       1797
## 3 1503960366 4/14/2016       1776
## 4 1503960366 4/15/2016       1745
## 5 1503960366 4/16/2016       1863
## 6 1503960366 4/17/2016       1728
```

```r
nrow(dailycalories)
```

```
## [1] 940
```

Next, how many participants in this data frame.


```r
n_distinct(dailycalories$Id)
```

```
## [1] 33
```

Now we can summarize.


```r
avg_dailycalories <- dailycalories%>%
  group_by(Id) %>%
  summarise_at(vars(Calories), list(avg_dailycalories = mean))
```



```r
glimpse(avg_dailycalories)
```

```
## Rows: 33
## Columns: 2
## $ Id                <dbl> 1503960366, 1624580081, 1644430081, 1844505072, 1927~
## $ avg_dailycalories <dbl> 1816.419, 1483.355, 2811.300, 1573.484, 2172.806, 25~
```

Looking at heart and calories burned.


```r
heartrate_calories <- merge(avg_heartrate, avg_dailycalories, by="Id")
```



```r
head(heartrate_calories)
```

```
##           Id avg_heartrate avg_dailycalories
## 1 2022484408      80.23686          2509.968
## 2 2026352035      93.77631          1540.645
## 3 2347167796      76.72279          2043.444
## 4 4020332650      82.30058          2385.806
## 5 4388161847      66.13300          3093.871
## 6 4558609924      81.67395          2033.258
```

What insights can we gain from this? How hard are our users' hearts working?


```r
ggplot(data=heartrate_calories, aes(x=avg_dailycalories, y=avg_heartrate)) + 
  geom_point()
```

![](bellabeat_analysis_files/figure-latex/fig 5 showing average heart rate and average calories burned daily-1.pdf)<!-- --> 

Some users with very high heart rates aren't burning much calories, as mentioned earlier this is a cause for concern with respect to high blood pressure and lifestyle diseases. Such information could be useful to users and enhance the standing in potential customers' minds.

Furthermore, we know those who walk more tend to burn more calories. Looking at it graphically.


```r
ggplot(data=dailycalories, mapping = aes(x=ActivityDay, y=Calories)) + 
  geom_point() + theme(axis.text.x = element_text(angle=60))
```

![](bellabeat_analysis_files/figure-latex/fig 6 showing grouping of calories burned by the day-1.pdf)<!-- --> 

We can represent this better showing the groupings of most individuals and the top burners.


```r
ggplot(data=dailycalories, mapping = aes(x=ActivityDay, y=Calories)) +
  scale_fill_viridis(discrete=TRUE, alpha = 0.6) + 
  labs(title="Calories burned per day") + 
  geom_violin() + theme(axis.text.x = element_text(angle = 66))
```

![](bellabeat_analysis_files/figure-latex/unnamed-chunk-23-1.pdf)<!-- --> 

The violin plot shows the by size where the majority stack up. Many people enjoy knowing this information, seeing how they stack up against the average. We can use this to have simple weekly competitions where people compete to be the top burners in their friend group, or publicly. Rewards can be as simple as gold stars leading up to monthly or yearly prizes such as store coupons of varying values depending on the user's performance.


## Putting it all together

For this analysis, I chose the product "Leaf Urban". The simple design and features will definitely be a draw for many potential customers. The aim of this analysis was to use data to suggest marketing strategy for this product. My recommendations are as follows:

- Walking competition: People set daily step goals and see how their actual daily activity stacks up against the average. Fun competition can drive people into being healthier and get users to recommend their friends to buy the same product so it becomes a group activity.

- Health Watch: An alert if heart rates are too low or too high, so if medical attention is needed it can be quickly received. Low and high heart rates have major implications, having a smart device looking out for the users is comforting. Pushing this angle can make the company appear caring and bring new customers.

Thus ends my analysis on Bellabeat. Thank you for reading.




*SeanA*

