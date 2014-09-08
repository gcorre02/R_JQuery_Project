#this file handles user data: 
# > current user logged in
# > all user's portfolios
# > accessed to add more user portfolios

library(ggplot2)


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
receivePortfolio = function(id, ticker, company, percentage){
  assets = data.frame(cbind(id, ticker, company, percentage), stringsAsFactors = FALSE)
  save(assets, file = "~/test3/data/assetsTest.Rda",compress = F) #belongs to addPortfolio.... methinks
  #createPortfolio()
  #addPorfolio
  #createUserData must be asscoiated with the creation of a new user, and then the html must maintain the user login info to pass as argument in here!
  return("sucessful")

}

#-> add methods to edit portfolios
#-> add visualizations of all available portfolio
#-> handle persistence, like in test3?

#-> calculate portfolio's details :
#-> collectionWeights = as.numeric(levels(assets$percentage))/100


getEff = function(){
 # library(googleVis)#needs to be imported somewhere else, namespace ?
  
#  m = gvisMotionChart(Fruits,'Fruit','Year')
#  collage = c(m$html$header, m$html$chart,m$html$caption,m$html$footer)
  #collage = m$html$chart
#  cat(collage, file="/Library/Frameworks/R.framework/Versions/3.1/Resources/library/test3/www/tmp.html")
#  collage
 # cat(m$html$chart)
  #  load("~/test3/data/assetsTest.Rda")
  #  ticker = as.character(assets$ticker)
  #
  #prtf = collectData(ticker, zoom = 200, end = "2014-08-31", start = "2014-06-30") #user inputs
  #contentsX = prtf$minstd
  #contentsY = prtf$mu
  #ggplot(data = contents, ymin=lowpoint, aes(Date, ymin=lowpoint, ymax=Close)) + geom_ribbon(color="black", fill="lightblue", alpha=0.5) + ylim(range(contents$Close));  
  #  qplot(prtf$minstd, prtf$mu, type = "l")+  geom_ribbon(color="black", fill="lightblue", alpha=0.5) + aes(ymin = -0.5, ymax = 1)
  
  load(file = "~/test3/data/assetsTest.Rda")
  ticker = assets$ticker
  getEffPlot(ticker)
}
