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

m <- phOR%>% 
  leaflet() %>%
  addTiles() %>%
  addCircles(lng=~dec_long_va, lat= ~dec_lat_va, color="red") 

m

#finding WQPs sites in Oregon 
type= "Stream"
sitesOR <- whatWQPsites(stateCd="OR", siteType=type)

 
write.csv(sitesOR, file = "data/ORSites.csv")
metrics <- whatWQPmetrics(stateCd = "OR", siteType=type)
sitesWA <- whatWQPsites(stateCd="WA", siteType=type)
sitesID <- whatWQPsites(stateCd="ID", siteType=type)

sitesPNW <- bind_rows(sitesOR, sitesWA)
sitesPNW <- bind_rows(sitesPNW,sitesID)

write.csv(sitesPNW, file = "data/PNWSites.csv")

unique_Orginizations <- sitesPNW %>% 
    select(OrganizationFormalName, ProviderName) %>% 
    distinct(OrganizationFormalName, ProviderName)

write.csv(unique_Orginizations, file = "data/Unique_Organization.csv")

m <- sitesPNW%>% 
  leaflet() %>%
  addTiles() %>%
  addCircles(lng=~as.double(LongitudeMeasure), lat= ~as.double(LatitudeMeasure), color="red") 
m
