##Charger les librairies
library(RMySQL)
library(ggplot2)
library(lubridate)

##connexion à la base de données
mydb = dbConnect(MySQL(), user='data', password='data', dbname='odk_prod', host='192.168.1.62')


###Querie 1: Enfants qui sont épouse
strSQL1 = "SELECT MEMBERSHIP_CORE.RELATIONSHIP_TO_GROUP_HEAD, T.INDIVIDUAL_INFO_FIRST_NAME, T.INDIVIDUAL_INFO_LAST_NAME
FROM (
  SELECT INDIVIDUAL_INFO_FIRST_NAME, INDIVIDUAL_INFO_LAST_NAME, INDIVIDUAL_INFO_INDIVIDUAL_ID
  FROM BASELINE_CORE
  WHERE INDIVIDUAL_INFO_MOTHER_ID <> 'UNK'
  OR INDIVIDUAL_INFO_FATHER_ID <> 'UNK'
) AS T, MEMBERSHIP_CORE
WHERE MEMBERSHIP_CORE.OPENHDS_INDIVIDUAL_ID = T.INDIVIDUAL_INFO_INDIVIDUAL_ID
AND  MEMBERSHIP_CORE.RELATIONSHIP_TO_GROUP_HEAD = '2'"

Querie.1 = dbGetQuery(mydb,strSQL1)


###Querie 2: Age supérieur à 100 ans
strSQL2 = " SELECT  INDIVIDUAL_INFO_FIRST_NAME, INDIVIDUAL_INFO_LAST_NAME, INDIVIDUAL_INFO_DATE_OF_BIRTH
FROM BASELINE_CORE"
CalculAge= dbGetQuery(mydb,strSQL2)

## calcul de l'age
CalculAge$date1 <- as.Date(strptime(CalculAge$INDIVIDUAL_INFO_DATE_OF_BIRTH,"%Y-%m-%d %H:%M:%S") )
CalculAge$date2 <- rep(Sys.Date(), nrow(CalculAge))
CalculAge$date2 <- as.Date(CalculAge$date2)
CalculAge$age<- time_length(interval(CalculAge$date1,CalculAge$date2),  "years")
CalculAge$age<- round(CalculAge$age)
Age_final <- CalculAge[ , -c(3,4,5)]

Querie.2 = subset(Age_final, age >= 100)

##Querie 3:	Nombre de caractère du matricule CNAMGS
strSQL3 = "SELECT OPENHDS_LOCATION_ID, INDIVIDUAL_INFO_INDIVIDUAL_ID,  INDIVIDUAL_INFO_LAST_NAME,
VISIT_DATE, MATRICULCNAM, LENGTH( MATRICULCNAM )
FROM BASELINE_CORE
WHERE CNAMGS = 'yes'
AND LENGTH( MATRICULCNAM ) <>13 and  LENGTH( MATRICULCNAM ) <> 10"

Querie.3 = dbGetQuery(mydb, strSQL3)

#Querie 4:	Nom et nom du groupe social
strSQL4 = "SELECT SOCIAL_GROUP_REGISTRATION_CORE.GROUP_NAME, BASELINE_CORE.INDIVIDUAL_INFO_LAST_NAME
FROM BASELINE_CORE, SOCIAL_GROUP_REGISTRATION_CORE
WHERE SOCIAL_GROUP_REGISTRATION_CORE.OPENHDS_INDIVIDUAL_ID <> BASELINE_CORE.INDIVIDUAL_INFO_INDIVIDUAL_ID"

Querie.4 = dbGetQuery(mydb, strSQL4)


#Querie 5: Les femmes enceintes identifiées dans le formulaire <<Baseline>>.  
#Les informations sur la grossesse sont-elles prises ?

#Celles qui ont les informations sur la grossesse
strSQL5.1 = "SELECT PREGNANCY_OBSERVATION_CORE.META_INSTANCE_NAME, INDIVIDUAL_INFO_LAST_NAME, INDIVIDUAL_INFO_FIRST_NAME
FROM PREGNANCY_OBSERVATION_CORE, BASELINE_CORE
WHERE BASELINE_CORE.INDIVIDUAL_INFO_INDIVIDUAL_ID = PREGNANCY_OBSERVATION_CORE.OPENHDS_INDIVIDUAL_ID"

Querie5.1 = dbGetQuery(mydb, strSQL5.1)

#Celles qui n’ont pas des informations sur la grossesse
strSQL5.2 = "SELECT OPENHDS_LOCATION_ID, INDIVIDUAL_INFO_LAST_NAME, INDIVIDUAL_INFO_FIRST_NAME, INDIVIDUAL_INFO_GROSSESSE
FROM BASELINE_CORE
WHERE INDIVIDUAL_INFO_GROSSESSE = 'yes'
AND BASELINE_CORE.INDIVIDUAL_INFO_INDIVIDUAL_ID NOT 
IN (
  
  SELECT OPENHDS_INDIVIDUAL_ID
  FROM PREGNANCY_OBSERVATION_CORE, BASELINE_CORE
  WHERE BASELINE_CORE.INDIVIDUAL_INFO_INDIVIDUAL_ID = PREGNANCY_OBSERVATION_CORE.OPENHDS_INDIVIDUAL_ID
)"

Querie5.2 = dbGetQuery(mydb, strSQL5.2)


#Les IDs des ménages de QField  sont vides
select id_menage, visited, type_habit, type_hab_1 from polygones where Type_Habit = '0' and quarter = 'Moussamoukougou' and id_menage IS NULL;
