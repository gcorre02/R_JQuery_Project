#this script is responsible for identifying the risk and expected return of the inputed portfolio distribution
library(stats)
library(tseries)
library(stockPortfolio)
source("R/generateWeightDist.R")

sampleSize = 8
sp500Tickers = as.matrix((read.csv("~/sp500list.csv"))$Sym[-354])[,1]
ticker = sp500Tickers#sample(sp500Tickers, sampleSize)
acquiredStocks = getReturns(ticker, freq = "day", get = c("overlapOnly"), end = "2014-08-31", start = "2014-01-01")  

collectionWeights = rep(1/sampleSize,sampleSize);

#collectionWeights = getSampleDistributionOfWeights(30)
#collectionWeights = c(0.4,0.6)

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

#important variables
averageReturn = colMeans(acquiredStocks$R)  #using average return for the expected ?
stocksVariance = var(acquiredStocks$R)#was using allStockHistory instead

#todo now: 

#gettheweightedaverage of average returns
wmeanReturn = weighted.mean(averageReturn,collectionWeights)

#do the same for the variances / covariances
#stocksCov = cov.wt(x = var(allStockHistory),wt = collectionWeights)$cov
#Portfolio Variance is what handles weights, not cov.:
StocksCov = cov(allStockHistory)  
#variance of the portfolio is : sum() of all weightofI * weightofJ * covOf(i,j)

#equal weights
# include collection  probabilities ? collectionProbs = rep(1/18,18)
weightsMatrix = collectionWeights %*% t(collectionWeights) 
portfolioVar = sum(StocksCov*weightsMatrix )#* collectionProbs)

#results
eRp = ((1 + wmeanReturn)^(365)-1)*100 # average annual rate of return
VarRp = sqrt(portfolioVar)
eRp
VarRp

Wa = 0.4
Wb = 0.6
#pricesA = sample(seq(7,15, by = 0.0004), size = 500)
#pricesB = sample(seq(9,22, by = 0.0004), size = 500)

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