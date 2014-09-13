#this script is responsible for identifying the risk and expected return of the inputed portfolio distribution

#source("~/test3/R/generateWeightDist.R")

getWeighted = function(){

local = T # make this an input
assets = getPortfolio()
ticker = assets$ticker
#ticker = sample(sp500Tickers, sampleSize)
allStockHistory = NULL


if(local){
  acquiredStocks = getReturnsFromDatabase(ticker)
  allStockHistory = acquiredStocks$full
  
  } else { 
  acquiredStocks = getReturns(ticker, freq = "day", get = c("overlapOnly"), end = "2014-08-31", start = "2014-07-30") 
  
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
  
}
 

collectionWeights = as.numeric(as.character(assets$percentage))/100

#collectionWeights = getSampleDistributionOfWeights(30)
#collectionWeights = c(0.4,0.6)


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
eRp = wmeanReturn*100 #((1 + wmeanReturn)^(365)-1)*100 # average annual rate of return
VarRp = sqrt(portfolioVar)#/100 # big???? twas because the % of the weights weren't normalized at input

returnable = c(VarRp, eRp);
names(returnable) = c("prtfVariance","expectedPrtfReturn");
returnable
}

