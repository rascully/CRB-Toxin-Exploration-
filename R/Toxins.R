library(leaflet)
library(dataRetrieval)
library(tidyverse)

#Chemicals of Concern in the CRB
#polybrominated diphenyl ethers (PBDEs),
#per- and polyfluoroalkyl substances (PFAS), 
#estrogen-like compounds, pharmaceuticals, 
#personal care products, 
#and perfluorinated compounds (PFCs)

pCode <- c("00662","00665")
phOR <- readNWISdata(stateCd="OR", parameterCd=pCode,
                     service="site", seriesCatalogOutput=TRUE)


#finding WQPs sites in Oregon 
sitesOR <- whatWQPsites(stateCd="OR")
write.csv(sitesOR, file = "data/ORSites.csv")

sitesWA <- whatWQPsites(stateCd="WA")
sitesID <- whatWQPsites(stateCd="ID")

sitesOR$VerticalMeasure.MeasureValue <- as.character(sitesOR$VerticalMeasure.MeasureValue)
sitesID$VerticalMeasure.MeasureValue <- as.character(sitesID$VerticalMeasure.MeasureValue)


sitesPNW <- bind_rows(sitesOR, sitesWA)
sitesPNW <- bind_rows(sitesPNW,sitesID)

write.csv(sitesPNW, file = "data/PNWSites.csv")

unique_Orginizations <- sitesPNW %>% 
    select(OrganizationFormalName, ProviderName) %>% 
    distinct(OrganizationFormalName, ProviderName)

write.csv(unique_Orginizations, file = "data/Unique_Organization.csv")


#Create a map 
m <- sitesPNW%>% 
  leaflet() %>%
  addTiles() %>%
  addCircles(lng=~as.double(LongitudeMeasure), lat= ~as.double(LatitudeMeasure), color="blue") 
m

metrics <- whatWQPmetrics(stateCd = "OR")
