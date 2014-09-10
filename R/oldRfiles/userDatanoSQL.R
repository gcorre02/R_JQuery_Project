#-> do this into sql and make it updated everytime a password changes or a portfolio is added/changed
createUserData = function(username, password){
  userData = vector("list",0)
  userDetail = list(user = username, pass = password, numberOfPortfolios = 0)
  userData[[1]] = userDetail
  userData
}

#probably unnecessary code:
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