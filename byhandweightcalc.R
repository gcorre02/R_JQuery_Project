#needs to load assets data to work
this one matches the results on webpage:
#Wa = as.numeric(as.character(assets$percentage))[1]/100
#Wb = as.numeric(as.character(assets$percentage))[2]/100

#this one matches pos 12, return = 1%
Wa = props$pc[[12]]$portfolioWeights[1]
Wb = props$pc[[12]]$portfolioWeights[2]
Wa
Wb
#pricesA = sample(seq(7,15, by = 0.0004), size = 500)
#pricesB = sample(seq(9,22, by = 0.0004), size = 500)

ticker = assets$ticker

acquiredStocks = getReturns(ticker, freq = "day", get = c("overlapOnly"), end = "2014-08-31", start = "2014-07-30")  

allStockHistory = NULL
for(i in 1:length(acquiredStocks$ticker)){
  if(is.null(allStockHistory)){
    allStockHistory = as.matrix(acquiredStocks$full[[i]]$Close)
    colnames(allStockHistory) = acquiredStocks$ticker[i]
  }else{
    previousNames = colnames(allStockHistory)
    allStockHistory = cbind(allStockHistory, acquiredStocks$full[[i]]$Close)  
    colnames(allStockHistory) = c(previousNames, acquiredStocks$ticker[i])
  }  
}

pricesA = allStockHistory[,1]
pricesB = allStockHistory[,2]

Ra = mean(acquiredStocks$R[,1])*100 #verified this is the real value
Rb = mean(acquiredStocks$R[,2])*100
Ra
Rb
SDa = sd(pricesA)
SDb = sd(pricesB)
SDa
SDb
corAB = cor(pricesA,pricesB)
corBA = cor(pricesA,pricesB)

eReturn = Wa*Ra + Wb*Rb
prtfVar = Wa*Wa*SDa*SDa + Wb*Wb*SDb*SDb + Wa*Wb*SDa*SDb*corAB + Wb*Wa*SDb*SDa*corBA

eRp
VarRp

eReturn
sqrt(prtfVar)