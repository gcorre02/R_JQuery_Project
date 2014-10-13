#' Generate stock table.
#' 
#' look into http://finviz.com/screener.ashx?v=111&f=idx_sp500 to explore how to add more args, this after sp500 is the only needed.
#' 
#' This function pulls some data from finviz.com and creates a table with stocks.
#' Because this can be a bit slow and the result rarely changes, a fixed table with stocks called 'stocktable' is shipped with the package.
#' 
#' Also the site returns a lot of stocks. By setting the 'max' parameter, only stocks with the highest market capital are returned.
#' 
#' @param max Max number of stocks to return 
#' @return dataframe 'stocktable'
#' @examples stocktable <- makestocktable(); 
#' @export
makestocktable <- function(){
  con <- dbConnect(dbDriver("SQLite"), dbname = "/usr/local/lib/R/site-library/test3/data/portfolioManager")
  stocktable = dbReadTable(con, "sp500tickers")
  dbDisconnect(con)
  stocktable
}

getTickers = function(){
  con <- dbConnect(dbDriver("SQLite"), dbname = "/usr/local/lib/R/site-library/test3/data/portfolioManager")
  tickers = dbGetQuery(con, "select Ticker from sp500tickers")
  dbDisconnect(con)
  as.vector(tickers$Ticker,"character")
}

getCompanies = function(){
  #this way is slower:
  #mylist <- read.csv("http://finviz.com/export.ashx?v=111&&f=idx_sp500&&o=ticker", stringsAsFactors=FALSE);
  #toSQL = mylist[c("Ticker", "Company", "Sector", "Industry", "Country")];
  #toSQL$Company
  #this way is faster:
  #makestocktable()$Company
  #this way uses sql
  con <- dbConnect(dbDriver("SQLite"), dbname = "/usr/local/lib/R/site-library/test3/data/portfolioManager")
  companies = dbGetQuery(con, "select Company from sp500tickers")
  dbDisconnect(con)
  as.vector(companies$Company,"character")
}

getOtherValue = function(valueType, namtckr){
  if(valueType == "getTickers"){
    return( getCompanyByTicker(namtckr))
  } else {
    return(getTickerByCompany(namtckr))
  }
}

#current$Company[which(current$Ticker == "AA")]

getCompanyByTicker = function(namtckr){
  #not worth converting to sql access since the which function is very practic
  current = makestocktable()
  result = current$Company[which(current$Ticker == namtckr)]
  if(length(result) == 0){
    result = "noname"
  }
  result
}

getTickerByCompany = function(namtckr){
  current = makestocktable()
  result = current$Ticker[which(current$Company == namtckr)]
  result
}

#removed problematic rows because of incompatible characters with query, to be resolved
#also removing PCLN because it is a massive outlier.
populateStockTable = function(){
  mylist <- read.csv("http://finviz.com/export.ashx?v=111&&f=idx_sp500&&o=ticker", stringsAsFactors=FALSE);
  toSQL = mylist[c("Ticker", "Company", "Sector", "Industry", "Country")];
  toSQL = toSQL[c(-27,-61,-70,-267,-281,-286,-292,-295,-349,-352),]
  con <- dbConnect(dbDriver("SQLite"), dbname = "/usr/local/lib/R/site-library/test3/data/portfolioManager")
  dbWriteTable(con, "sp500tickers", toSQL, overwrite = T)
  dbDisconnect(con)
}
