#this file handles user data: 
# > current user logged in
# > all user's portfolios
# > accessed to add more user portfolios


createUserData = function(username, password){
  userData = vector("list",0)
  userDetail = list(user = username, pass = password, numberOfPortfolios = 0)
  userData[[1]] = userDetail
  userData
}

index = 1
index = index + 1

#

addPortfolio =function(userData, portfolio){
#  -> recognize length
#  -> start adding portfolios on position 2
  newPortfolioPosition = length(userData) + 1
  userData[[newPortfolioPosition]] = portfolio
  userData[[1]]$numberOfPortfolios = userData[[1]]$numberOfPortfolios + 1
  userData
}

#-> createPortfolio function
createPortfolio = function(portfolioDataFrame, portfolioName, typeOfPortfolio){
  dateCreated = Sys.time()
  portfolio = list(content = portfolioDataFrame, name = portfolioName, type = typeOfPortfolio, datecreated = dateCreated)
  portfolio
}

#-> collect data from website and generate portfolio dataframe
receivePortfolio = function(id, ticker, opp, percentage){

  assets = data.frame(cbind(id, ticker, opp, percentage))
#  save(assets, file = "/Users/gctribeiro/test3/data/assetsTest.Rda")
  return(assets)

}

#-> add methods to edit portfolios
#-> add visualizations of all available portfolio
#-> handle persistence, like in test3?



