library(Quandl)
library(quantmod)
#probably unnecessary code
getCollectionOfDataSets = function(idNumbersOfStocks){
  Quandl.auth("KPa5Cq6QQ38HzEywAQnd")
  start = "2010-01-01"
  end = "2014-01-01"
  ticker = ""
  stocks = makestocktable()
  ine = stocks$Ticker[67]
  result = Quandl.search(query = ine, silent = T, page = 1,source = "GOOG")
  ticker = result[[1]]$code
  retrievedData = Quandl(code = ticker, type = 'raw', start_date = start, end_date = end)
}
