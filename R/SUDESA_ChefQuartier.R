##Connexion on ODK
library(RMySQL)
library(dplyr)
library(ggplot2)
library(knitr)
library(stringr)
library(RPostgreSQL)
library(lubridate)
library(tidyr)

mydb = dbConnect(MySQL(), user='data', password='data', dbname='odk_prod', host='192.168.1.62')

##Connexion on openhds
mydb2 = dbConnect(MySQL(), user='data', password='data', dbname='openhds', host='192.168.1.62')

##Read data table at baseline
data.baseline <- dbReadTable(mydb, "BASELINE_CORE")

##Read data table on location
data.location <- dbReadTable(mydb, "LOCATION_REGISTRATION_CORE")
data.location.sub <- data.location[, c("OPENHDS_LOCATION_ID", "QUARTER")]

##Merging
data.merging <- merge(data.baseline, data.location.sub, all.x = F)


##Fangui et adouma
data.base1 <- data.merging %>%
  distinct(INDIVIDUAL_INFO_INDIVIDUAL_ID, .keep_all = T) %>%
    filter(QUARTER == 'Adouma' | QUARTER == 'Fanguy')

tab.1 <- data.base1 %>%
  count(INDIVIDUAL_INFO_GENDER)

tab.2 <- data.base1 %>%
  count(INDIVIDUAL_INFO_GROSSESSE)

tab.3 <- data.base1 %>%
  count(CNAMGS)



## calcul de l'age
CalculAge$date1 <- as.Date(strptime(CalculAge$INDIVIDUAL_INFO_DATE_OF_BIRTH,"%Y-%m-%d %H:%M:%S") )
CalculAge$date2 <- rep(Sys.Date(), nrow(CalculAge))
CalculAge$date2 <- as.Date(CalculAge$date2)
CalculAge$age<- time_length(interval(CalculAge$date1,CalculAge$date2),  "years")
CalculAge$age<- round(CalculAge$age)
Age_final <- CalculAge[ , -c(3,4,5)]


tab.4 <-  data.base1 %>%
  mutate(date1 = as.Date(strptime(INDIVIDUAL_INFO_DATE_OF_BIRTH,"%Y-%m-%d %H:%M:%S") ),
         date2 = Sys.Date(),
           Age = ceiling(time_length(interval(date1, date2),  "years"))) %>%
             filter(Age < 10) %>%
               count()
  
  
  