library(Quandl)

#form some kind of instruction that calls all the necessary libraries, look into that.

searchQuandle = function(query){
  library(Quandl)
  results = Quandl.search(query)
  returnthis = results[[1]]$code
  returnthis
}

sayHello = function(myname){
  response = paste("hello ", myname)
  response
}

getQuandlInfo = function(target){
  library(Quandl)
  contents = Quandl(target, type = "raw", "2013-01-01","2014-01-01")
  head(contents) 
}
getQuandlPlot = function(target){
  library(Quandl)
  library(ggplot2)
  contents = Quandl(target, type = "raw", "2013-01-01","2014-01-01")
  contents$lowpoint <- min(contents$Close);
  ggplot(data = contents, ymin=lowpoint, aes(Date, ymin=lowpoint, ymax=Close)) + geom_ribbon(color="black", fill="lightblue", alpha=0.5) + ylim(range(contents$Close));  
}
