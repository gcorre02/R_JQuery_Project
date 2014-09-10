library(Quandl)

#form some kind of instruction that calls all the necessary libraries, look into that.

searchQuandle = function(query){

  results = Quandl.search(query)
  returnthis = results[[1]]$code
  returnthis
}

sayHello = function(myname){
  response = paste("hello ", myname)
  response
}

getQuandlInfo = function(target){

  contents = Quandl(target, type = "raw", "2013-01-01","2014-01-01")
  head(contents) 
}
getQuandlPlot = function(target){

  contents = Quandl(target, type = "raw", "2013-01-01","2014-01-01")
  contents$lowpoint <- min(contents$Close);
  ggplot(data = contents, ymin=lowpoint, aes(Date, ymin=lowpoint, ymax=Close)) + geom_ribbon(color="black", fill="lightblue", alpha=0.5) + ylim(range(contents$Close));  
}

