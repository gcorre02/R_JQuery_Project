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
  mylist <- read.csv("http://finviz.com/export.ashx?v=111&&f=idx_sp500&&o=ticker", stringsAsFactors=FALSE);
  mylist[c("Ticker", "Company", "Sector", "Industry", "Country")];
}

getTickers = function(){
  makestocktable()$Ticker
}

getCompanies = function(){
  makestocktable()$Company
}