library(zipcode)
library(dplyr)
library(plyr)
library(ggplot2)
library(maptools)
gpclibPermit()
library(mapdata)
library(ggthemes)
library(tibble)
library(viridis)
library(mapproj)

names(AmbassadorMaster)[names(AmbassadorMaster)=="Ship To Zip Code"] <- "Zipcode"

zips$Zipcode <- clean.zipcodes(zips$Zipcode)

us <- map_data("state")

zips$ZipCodeType <- NULL
zips$City <- NULL
zips$State <- NULL
zips$LocationType <- NULL
zips$Location <- NULL
zips$Decommisioned <- NULL
zips$TaxReturnsFiled <- NULL
zips$EstimatedPopulation <- NULL
zips$TotalWages <- NULL

AmbassadorMaster <- merge(AmbassadorMaster, zips, by = "Zipcode")

##Set working directory##
setwd("C:/Users/bronars.DCIM/Desktop/Ambassador Radius/SF 60")

##Bring in radius file 
##from https://www.freemaptools.com/find-zip-codes-inside-radius.htm
SF_60mile <- read_csv("C:/Users/bronars.DCIM/Desktop/Ambassador Radius/SF60/SF_60mile.csv")
SF_60mile$Zipcode <- clean.zipcodes(SF_60mile$Zipcode)

##Match
AmbassadorMaster$SF_60 <- {match(AmbassadorMaster$Zipcode, SF_60mile$Zipcode, nomatch = 0)
  AmbassadorMaster$Zipcode %in% SF_60mile$Zipcode}

SF60_Ambassadors <- subset(AmbassadorMaster, SF_60 == "TRUE",)

##export list
write.csv(SF60_Ambassadors, file = "Ambassadors SF Area.csv", append = FALSE)

###ggplot
names(SF60_Ambassadors)[names(SF60_Ambassadors)=="Lat"] <- "lat"
names(SF60_Ambassadors)[names(SF60_Ambassadors)=="Long"] <- "long"

##US Map##
gg <- ggplot()
gg <- gg + geom_map(data=us, map=us,
                    aes(x=long, y=lat, map_id=region),
                    color="#2b2b2b", fill="#eff098", size=.5)
gg <- gg + geom_point(data=SF60_Ambassadors,
                      aes(x=long, y=lat, map_id=Zipcode),
                      shape=21, color="#2b2b2b", fill="#ff1438", size=1)
gg <- gg + coord_map("polyconic")
gg <- gg + theme_map()
gg <- gg + theme(plot.margin=margin(20,20,20,20))
gg <- gg + scale
gg

##Subset map to state##
CA <- subset(us, region %in% c("california"))

gg <- ggplot()
gg <- gg + geom_map(data=CA, map=CA,
                    aes(x=long, y=lat, map_id=region),
                    color="#2b2b2b", fill="#eff098", size=.5)
gg <- gg + geom_point(data=SF60_Ambassadors,
                      aes(x=long, y=lat, map_id=Zipcode),
                      shape=21, color="#2b2b2b", fill="#ff1438", size=1)
gg <- gg + coord_map("polyconic")
gg <- gg + theme_map()
gg <- gg + theme(plot.margin=margin(20,20,20,20))
gg <- gg + scale
gg
