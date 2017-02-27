#####Afficher la carte de lambaréné##############

#Package
library(leaflet)
library(geosphere)
library(DT)
library(maptools)


#Importation des fichiers shapiles
Lambarene_polygon<-readShapeSpatial('Data/shapfiles/polygones_10_02_2017')


##reclasser les types de batiments
Lambarene_polygon@data$Build <- NA
Lambarene_polygon@data$Build[grepl('0|o|^men', Lambarene_polygon@data$type_habit)] <- 'Ménage'
Lambarene_polygon@data$Build[grepl('1|2|3|4|5|6|7|8|9|10|12|13|14', Lambarene_polygon@data$type_habit)] <- 'Autre batiment'
Lambarene_polygon@data$Build[grepl("15", Lambarene_polygon@data$type_habit)] <- 'Refus'
Lambarene_polygon@data$Build[is.na(Lambarene_polygon@data$type_habit) |
                               Lambarene_polygon@data$type_habit == 'NA'] <- 'Batiment non visité'
Lambarene_polygon@data$Build <- factor(Lambarene_polygon@data$Build, levels = c('Ménage', 'Autre batiment', 'Refus', 'Batiment non visité'))

##Recuperer les coordonnees des centroides des polygones
CoordPoly <- as.data.frame(coordinates(Lambarene_polygon))
names(CoordPoly) <- c('longitude', 'latitude')

##Merge avec Lambarene_polygon et CoordPoly
dataLambarene <- cbind(Lambarene_polygon@data, CoordPoly)

##Definir la couleur selon le type de batiments
colorBat <- colorFactor(c('blue','green','red', 'black'), Lambarene_polygon@data$Build)

# ##Definir les icons selon les menages et hopital choisi
# icon.hop <-  awesomeIcons(icon = 'home',
#                markerColor = ifelse(dataLambarene$Build == 'Ménage', 'blue', 'white'),
#                library = 'fa',
#                iconColor = 'black')

##Afficher la carte
leaflet(data = Lambarene_polygon) %>%
    addProviderTiles("CartoDB.Positron") %>%
    addPolygons(
      fillOpacity = 0.8, 
      color = ~colorBat(Build), 
      weight = 1 )%>%             
    setView(10.21915,  -0.67913, zoom =16)%>%
    addLegend(pal = colorBat, values = ~Build, opacity = 1, position = "bottomleft", 
              na.label = 'Aunce information', title = 'Batiments') 


