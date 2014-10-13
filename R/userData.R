#this file handles user data: 
# > current user logged in
# > all user's portfolios
# > accessed to add more user portfolios


#-> collect data from website and generate portfolio dataframe
receivePortfolio = function(id, ticker, company, percentage, prtfName){
  currentPrtf = as.data.frame(prtfName)
  names(currentPrtf) = c("prtfNAME")  
  con <- dbConnect(dbDriver("SQLite"), dbname = "/usr/local/lib/R/site-library/test3/data/portfolioManager")
  currentUser = dbReadTable(con, "currentLogin")
  dbWriteTable(con, "currentPortfolio", currentPrtf, overwrite = T)
  dbDisconnect(con)
  if(checkPortfolioAlreadyExists(currentUser,prtfName)){
    return('Portfolio Already Exists, new input not saved')
  } else {
    assets = data.frame(cbind(id, user = currentUser$username, ticker, company, percentage, prtfName), stringsAsFactors = FALSE)
    addToTable(assets, "portfolio")
    return("successful")
  }
}

checkPortfolioAlreadyExists = function(currentUser,prtfName){
  con <- dbConnect(dbDriver("SQLite"), dbname = "/usr/local/lib/R/site-library/test3/data/portfolioManager")
  exists = dbGetQuery(con,paste0("select * from portfolio where username = '", currentUser, "' and prtfNAME = '",prtfName,"';"))
  dbDisconnect(con)
  if(nrow(exists)!=0){
    return(T)
  } else {
    
    return(F)
  }
}

addToTable = function(assets, portfolio){
  con <- dbConnect(dbDriver("SQLite"), dbname = "/usr/local/lib/R/site-library/test3/data/portfolioManager")
  
  for (i in 1:nrow(assets)){
    res = dbSendQuery(con,paste("insert into portfolio values ('",   paste(assets[i,],collapse = "','") ,"');"))
  }  
  
  
  dbDisconnect(con)
  
}

#-> add a get portfolio method and a user interface

#-> add methods to edit portfolios
#-> add visualizations of all available portfolio
#-> handle persistence, like in test3?

#-> calculate portfolio's details :
#-> collectionWeights = as.numeric(levels(assets$percentage))/100

getPortfolio = function(){
  con <- dbConnect(dbDriver("SQLite"), dbname = "/usr/local/lib/R/site-library/test3/data/portfolioManager")
  currentUser = dbReadTable(con, "currentLogin")
  currentPortfolio = dbReadTable(con, "currentPortfolio")
  reqPortfolio = dbGetQuery(con,paste0("select * from portfolio where username = '", currentUser$username[1], "' and prtfNAME = '",currentPortfolio$prtfNAME[1]," ';")); # !! <ATTENTION> added a space here that might be unnecessary
  dbDisconnect(con)
  returnable = reqPortfolio[,c(1,3:5)]
  names(returnable) = c("id",names(returnable[-1]))
  returnable
}

getEff = function(){
  assets = getPortfolio()  
  ticker = assets$ticker
  getEffPlot(ticker)
}

setCurrentPortfolioAndUser = function(currentUser, currentPrtf){
  con <- dbConnect(dbDriver("SQLite"), dbname = "/usr/local/lib/R/site-library/test3/data/portfolioManager")
  currentLogin = as.data.frame(currentUser)
  names(currentLogin) = c("username")
  dbWriteTable(con, "currentLogin", currentLogin, overwrite = T)
  currentPrtf = as.data.frame(currentPrtf)
  names(currentPrtf) = c("prtfNAME")
  dbWriteTable(con, "currentPortfolio", currentPrtf, overwrite = T)
  dbDisconnect(con)
}