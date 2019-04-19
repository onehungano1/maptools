

# read in input csv file
branches <- read.csv("asbmaptest.csv")
branches <- read.csv("banklocations.csv", encoding="UTF-8") 
colnames(branches) <- c(colnames(branches)[1:2], c("address", 'lat', 'lng'), colnames(branches)[6:9])
head(branches)

# define function for calling the OSRM API
getPolygonsfromOSRM <- function(x){
  branch <- data.frame(x)
  branch.spdf <-  osrmIsochrone(loc = c(branch$lng, branch$lat), breaks = seq(from = 0,to = 30, by = 5))
  branch.spdf@data$drive_times <- factor(paste(branch.spdf@data$min, "to", branch.spdf@data$max, "min"))
  branch.spdf@data$address <- branch$address
  branch.spdf@data$Bank <- branch$Bank
  branch.spdf@data$Branch_Name <- branch$Branch_Name
  branch.spdf@data$Area_Unit <- branch$Area_Unit
  branch.spdf@data$AU_Name <- branch$AU_Name
  branch.spdf@data$Region <- branch$Region
  branch.spdf@data$Super_Region <- branch$Super_Region
  return(branch.spdf) 
}


branches.spdf <- list(nrow(branches))
for (i in c(1:nrow(branches.spdf))){
  branches.spdf[i] <- getPolygonsfromOSRM(branches[i,])
}




names(branches.spdf)(paste(branches$Bank, '--', branches$address, sep=''))


#save data as rds
filename <- paste("branches_polygons.rds_", Sys.Date(), sep = '')
saveRDS(branches.spdf, file = filename)
#819 is NULL

#restore data in different name and validate if two data are identical
branch.spdfs <- readRDS(filename)
assert_that(identical(branches.spdf, branch.spdfs))

