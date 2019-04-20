# define function for calling the OSRM API
#' Title get polygon using OSRM given defalt 0 - 30 increamental 5 mins drive time
#'
#' @param x dataframe contain some info
#'
#' @return spatial dataframe containing the result
#' @export
#'
#' @examples
#' \dontrun{
#' getPolygonsfromOSRM(ds)
#' }
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

