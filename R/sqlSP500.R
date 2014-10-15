persistSP500DB = function(){#need to handle time frames around here!
  ticker = getTickers()#as.matrix((read.csv("~/sp500list.csv"))$Sym[-354])[,1]
  acquiredStocks = getReturns(ticker, freq = "day", get = c("overlapOnly"), end = "2014-08-31", start = "2014-06-30")# 
  #save(acquiredStocks, file = "~/test3/data/acquiredStocks.Rda", compress = F)
  con <- dbConnect(dbDriver("SQLite"), dbname = "/usr/local/lib/R/site-library/test3/data/newDB.sqlite")
  rwrite = dbWriteTable(con, "fullSP500returns", acq$R, overwrite = T)
  cwrite = dbWriteTable(con, "fullSP500close", acq$Close, overwrite = T)
  dbDisconnect(con)
  return(rwrite&cwrite)
}

removeAllSp500RandomsFromSQL = function(){
  #use this to trim the sql file
  con <- dbConnect(dbDriver("SQLite"), dbname = "/usr/local/lib/R/site-library/test3/data/newDB.sqlite")
  res = dbGetQuery(con, ' delete from portfolio where username = \'sp500General\'')
  dbDisconnect(con)  
}

#had to convert this large object into something SQLite can understand
convertAcqtoDF = function(acquiredStocks){
  returnable = vector("list",0)
  returns = as.data.frame(cbind(rownames(acquiredStocks$R),acquiredStocks$R), stringsAsFactors = FALSE)
  names(returns) = c("DATE", acquiredStocks$ticker)
  returnable$R = returns
  fullClose = data.frame(row.names = acquiredStocks$full$A$Date,stringsAsFactors = FALSE)
  for(item in acquiredStocks$full){
    fullClose = cbind(fullClose, item$Close)
  }
  fullClose = cbind(acquiredStocks$full$A$Date,fullClose)
  colnames(fullClose) = c("DATE",acquiredStocks$ticker)
  returnable$Close = fullClose
  return(returnable)
}

getReturnsFromDatabase = function(ticker){
  
  con <- dbConnect(dbDriver("SQLite"), dbname = "/usr/local/lib/R/site-library/test3/data/newDB.sqlite")
  rcheck = dbExistsTable(con,"fullSP500returns")
  ccheck = dbExistsTable(con,"fullSP500close")
  #later -> dbDisconnect(con)
  
  if(!rcheck&ccheck){
    dbDisconnect(con)
    persistSP500DB() 
    con <- dbConnect(dbDriver("SQLite"), dbname = "/usr/local/lib/R/site-library/test3/data/newDB.sqlite")
  } 
  
  acquiredStocks = list()
  # !!!!!maybe i can just get the info straight from sql!
  #ret = dbReadTable(con,"fullSP500returns")
  acquiredStocks$R = dbGetQuery(con,paste("select DATE,",paste0(ticker[-length(ticker)],sep=',',collapse = ""),ticker[length(ticker)], " from fullSP500returns;",collapse = ""))#use limit 10 for example to select shorter time periods quickly/
  acquiredStocks$close = dbGetQuery(con,paste("select DATE,",paste0(ticker[-length(ticker)],sep=',',collapse = ""),ticker[length(ticker)], " from fullSP500close;",collapse = ""))#use limit 10 for example to select shorter time periods quickly/
  dbDisconnect(con)
  
  R = apply(acquiredStocks$R[-1],2,as.numeric) #bring the values back to numeric
  rownames(R) = acquiredStocks$R$DATE
  ticker = ticker
  #  period = acquiredStocks$period
  #  start = acquiredStocks$start
  #  end = acquiredStocks$end
  full = acquiredStocks$close[-1]
  rownames(full) = acquiredStocks$close$DATE
  returnable = list(R = R, ticker = ticker, full = full)
  
  return(returnable)
}