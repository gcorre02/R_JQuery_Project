##################################################################
##setup data


#ticker = c("CMG","LNKD","AMZN","GOOGL","WFC","SBUX")

#this has to be called right before the server is (plus lines 93 and 94 )
#sp500Tickers = as.matrix((read.csv("~/sp500list.csv"))$Sym[-354])[,1]

# analyse 500 -> depends on computing power ???


######################################################
#eff generator

#converted from an Octave script written @http://www.calculatinginvestor.com/2011/06/14/efficient-frontier-part-2/
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#  % Mean Variance Optimizer Inputs (Update this section with your own inputs)
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#  % S is matrix of security covariances
#S = c(185.0, 86.5, 80.0, 20.0, 86.5, 196.0, 76.0, 13.5, 80.0, 76.0, 411.0, -19.0, 20.0, 13.5, -19.0, 25.0)
#S = matrix(S, nrow = 4, ncol = 4)
#% Vector of security expected returns, in %
#zbar = matrix(c(14, 12, 15, 7))



#%%%%%%%%%%%%%%%%%%%%1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#% Calculating Variables
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#function, like in Octave
ones = function(length, numOfCols){
  onesMatrix = as.vector(matrix(rep(1,length),ncol = numOfCols))
  onesMatrix
}


#function plot point
plotPoint = function(h,v){
  abline(h = h, v = v )
}



#function to generate weights of portfolio with input return step
stepThroughEffPortfolios = function(start, end, step, A,B,C,D, w_g, w_d, zbar, S){
  portfolioCollection = NULL
  index = 1
  for(i in seq(start, end, step))#start:step)
  {    
    
    #
    mu_tar = i
    lambda_target = (C - mu_tar*B)/D
    gamma_target =  (mu_tar*A-B)/D
    w_s = t((lambda_target[1,1]%*%A)%*%w_g) + (gamma_target%*%B)[1,1]*w_d
    
    
    
    #% Expected Return of Target Portfolio (should match target)
    mu_s = t(w_s)%*%zbar
    
    #% Variance and Standard Deviation of target portfolio
    var_s = t(w_s)%*%S%*%w_s
    std_s = sqrt(var_s)
    
    
    #add points to the graph
    #points(std_s,mu_s)
    
    index = index + 1
    
    #
    if(index == 1){
      portfolioCollection = vector("list", 0)
      currentPortfolio = list( expectedReturn = i, portfolioWeights = w_s, risk = std_s)
      portfolioCollection[[index]] = currentPortfolio
    } else {
      currentPortfolio = list( expectedReturn = i, portfolioWeights = w_s, risk = std_s)
      portfolioCollection[[index]] = currentPortfolio
    }
    
  }
  pointsDF = data.frame(stringsAsFactors = FALSE)
  for(item in portfolioCollection){pointsDF = rbind(pointsDF,cbind(item$risk,item$expectedReturn))}
  names(pointsDF) = c("minstd","mu")
  portfolioCollection$pointsDF = pointsDF
  portfolioCollection
}


##function
collectData = function(ticker, zoom = 200, end = "2014-08-31", start = "2014-06-30", targetScale, local = T){#dates here matter, but only when getReturnsFromDatabase can handle it.
  #zoom = 100
  #review target return value -> magic number ish
  targetReturn = 2

  
 # if(local){
#    acquiredStocks = getReturnsFromDatabase(ticker)
#  } else { 
#    acquiredStocks = getReturns(ticker, freq = "day", get = c("overlapOnly"), end = end, start = start)
#  }
#
#
#  allStockHistory = NULL
#  for(i in 1:length(acquiredStocks$ticker)){
#    if(is.null(allStockHistory)){
#      allStockHistory = as.matrix(acquiredStocks$full[[i]]$Close)
#      colnames(allStockHistory) = acquiredStocks$ticker[i]
#    }else{
#      previousNames = colnames(allStockHistory)
#      allStockHistory = cbind(allStockHistory, acquiredStocks$full[[i]]$Close)  
#      colnames(allStockHistory) = c(previousNames, acquiredStocks$ticker[i])
#    }  }
#  repeating code:
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


  #important variables
  averageReturn = colMeans(acquiredStocks$R)*100#((1 + colMeans(acquiredStocks$R))^(365)-1)*100 ##-> missing probability here!
  stocksVariance = cov(allStockHistory)#this should probably be cov not var


  
  ##application
  ######################################################
  S = stocksVariance
  zbar = matrix(averageReturn)
  rownames(zbar) = names(averageReturn)
  #% Target Return in %percentage%
  #mu_tar = 2
  mu_tar = targetReturn
  
  #graph zoom, already defined by function
  #zoom = 500
  
  #% Unity vector..must have same length as zbar
  unity = ones(length(zbar),1)
  
  #% Vector of security standard deviations
  stdevs = sqrt(diag(S))
  
  #A = unity'*S^-1*unity
  #B = unity'*S^-1*zbar
  #C = zbar'*S^-1*zbar
  #D = A*C-B^2
  
  #provision the use of GINV() for the out of size matrixes
  A = sum(solveWCompSingular(S)) #solve(S) does the propper algebraic based inverse operation of the matrix
  B = colSums(solveWCompSingular(S))%*%zbar
  C = t(zbar) %*% solveWCompSingular(S) %*%zbar
  D <- A*C-B^2
  
  #% Calculate Lambda and Gamma
  lambda_target = (C - mu_tar*B)/D;
  gamma_target =  (mu_tar*A-B)/D;
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #% Efficient Frontier
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  min = floor(targetScale) - 0.5#MAGIC NUMBER
  max = floor(targetScale) + 2.5#MAGIC NUMBER
  mu = seq(from = (min-0.25), to = (max+0.25), by = (max-min)/zoom)
#  mu = mu/zoom;

  minvar = ((A*mu^2)-2*B*mu+C)/D;
  minstd = sqrt(minvar);
  
  #remove
  #effrontier = plot(minstd, mu, main = 'Efficient Frontier with Individual Securities', ylab = ('Expected Return (%)'), xlab = ('Standard Deviation'), type = "l")
  # this adds the individual points of each security
#  points(stdevs,zbar, type = "p")
  
  
  
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #% Global Minimum Variance Portfolio
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  #% Mean and Variance of Global Minimum Variance Portfolio
  mu_g = B/A
  var_g = 1/A
  std_g = sqrt(var_g)
  
  #% Minimum Variance Portfolio Weights
  w_g = (colSums(solveWCompSingular(S)))/A
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #% Tangency Portfolio with a Risk Free Rate = 0
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  #% Weights for Tangency Portfolio, R=0
  w_d = (solveWCompSingular(S)%*%zbar)/B[1,1]
  
  #% Expected Return of Tangency Portfolio
  mu_d = t(w_d)%*%zbar
  
  #% Variance and Standard Deviation of Tangency Portfolio
  var_d = t(w_d)%*%S%*%w_d
  std_d = sqrt(var_d)
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #% Portfolio with Expected Return = 14%
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  # Weights for portfolio with target return = 14%
  
  w_s = t((lambda_target[1,1]%*%A)%*%w_g) + (gamma_target%*%B)[1,1]*w_d
  
  #% Expected Return of Target Portfolio (should match target)
  mu_s = t(w_s)%*%zbar
  
  #% Variance and Standard Deviation of target portfolio
  var_s = t(w_s)%*%S%*%w_s
  std_s = sqrt(var_s)
  
  globalReturnX = 0
  globalReturnY = 0  
  ##generate collection of efficient portfolios according to a step and interval of returns
  #add the inputs to this function to the reactive
  #must match the sliderInput() values, remove the magic numbers
  
  pc = stepThroughEffPortfolios(min,max,0.25, A, B, C, D, w_g, w_d, zbar, S)
  
  
  #populate a global variable with all the points on the efficient frontier for which a weight distribution was calculated.
  for(i in 1:length(pc)){
    globalReturnX = c(globalReturnX, pc[[i]]$risk)
    globalReturnY = c(globalReturnY, pc[[i]]$expectedReturn)
  }
  
#  plotPoint(mu_d,std_d)
#  plotPoint(mu_g,std_g)
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #% Plot Efficient Frontier and Key Points
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
#  points(std_g,mu_g)#'Global Minimum Variance Portfolio'
#  points(std_d,mu_d)#'Tangency Portfolio when R=0'
#  points(std_s,mu_s)#Portfolio with Target Return of 14%
#  plotPoint(mu_d,std_d)#indicate 'Tangency Portfolio when R=0'
#  plotPoint(mu_g,std_g)#indicate'Global Minimum Variance Portfolio'
 # plotPoint(mu_s,std_s)#Portfolio with Target Return of 14%
  
  tangencyPortfolio = list( expectedReturn = mu_d, portfolioWeights = w_g, risk = std_g)
  globMinVariancePrtfolio = list( expectedReturn = mu_g, portfolioWeights = w_g, risk = std_g)
  
  
  #  returnableData = list( expectedReturn = i, portfolioWeights = w_s, risk = std_s)
  
  #
  #  p <- plot(minstd,mu,main = 'Efficient Frontier with Individual Securities', ylab = ('Expected Return (%)'), xlab = ('Standard Deviation (%)'), type = "l")  
  #  p = p + points(stdevs,zbar)
  #  p = p + points(globalReturnX, globalReturnY)  
  #
  
  returnableData = list(data = as.data.frame(cbind(minstd,mu),stringsAsFactors = FALSE), stdevs = stdevs, zbar = zbar, 
                        globalReturnX = globalReturnX, globalReturnY = globalReturnY, 
                        tangencyPortfolio = tangencyPortfolio, globMinVariancePrtfolio = globMinVariancePrtfolio, pc = pc)
  
  returnableData
}
#<HERE>
getEffPlot = function(ticker, local = T){
  
 #ticker = c("RHI",  "GT",   "SPG",  "CTXS", "PH",   "AMGN", "MSFT", "OMC" )
  userPrtf = as.data.frame(t(getWeighted()), stringsAsFactors = FALSE)
  targetScale = userPrtf$expectedPrtfReturn
  effData = collectData(ticker, zoom = 500, end = "2014-08-31", start = "2014-07-30", targetScale,local)# using local makes it lose the names of the tickers...
  #then js is ready to call the tables as necessary!!
  save(effData, file = "/usr/local/lib/R/site-library/test3/data/prtfdata.Rda", compress = F)
  #dfDemo <- structure(list(Y = c(0.906231077471568, 0.569073561538186,0.0783433165521566, 0.724580209473378, 0.359136092118470, 0.871301974471722,0.400628333618918, 1.41778205350433, 0.932081770977729, 0.198188442350644), X = c(0.208755495088456, 0.147750173706688, 0.0205864576474412,0.162635017485883, 0.118877260137735, 0.186538613831806, 0.137831912094464,0.293293029083812, 0.219247919537514, 0.0323148791663826), Z = c(11114987L,11112951L,11713300L, 14331476L, 11539301L, 12233602L, 15764099L, 10191778L,12070774L, 11836422L, 15148685L)), .Names = c("Y", "X", "Z"), row.names = c(NA, 10L), class = "data.frame")
  returns = qplot(x = effData$data$minstd, y = effData$data$mu, geom=c("path")) + geom_line(fill = "blue", colour="grey", alpha = 1/3 )#geom = c("line", "smooth")
  returns = returns + geom_point(data=effData$pc$pointsDF, aes(x = minstd, y = mu, colour = minstd), size = 3.5) + scale_colour_gradient(low = "green",high = "red")
  returns = returns + geom_point(data = userPrtf, aes(y = expectedPrtfReturn, x = prtfVariance, colour = prtfVariance), size = 5)  + annotate("text", x = userPrtf$prtfVariance, y = userPrtf$expectedPrtfReturn, label = "User Portfolio", hjust=-0.1, vjust=0) 
  stockPoints = as.data.frame(cbind(effData$stdevs, effData$zbar),stringsAsFactors = FALSE)
  names(stockPoints) = c("stdevs","zbar")
  returns = returns + geom_point(data = stockPoints, aes(x = stdevs, y = zbar , colour = stdevs), size = 3) + annotate("text", y = stockPoints$zbar, x = stockPoints$stdevs, label = rownames(stockPoints), size = 2,hjust=-0.1, vjust=0)
  print(returns)
 
  #getTablesOfEffPlot(data) would do this if using R2HTML 
  returns
}

getTablesOfEffPlot = function(targetreturn){
  load(file = "/usr/local/lib/R/site-library/test3/data/prtfdata.Rda")
  targetreturn = as.numeric(targetreturn)
  outtableHtml = as.data.frame(effData$pc[[targetreturn]]$portfolioWeights, stringsAsFactors = FALSE)
  #loop to do this to every point:
  names(outtableHtml) = (paste0("Expected Return of ", round(effData$pc[[targetreturn]]$expectedReturn,3) , " for a risk of " , round(effData$pc[[targetreturn]]$risk,3)))
  htmtable = xtable(outtableHtml)#look into other args
  x = print(htmtable, type = "html", html.table.attributes='class="table table-striped table-hover"  align="center" ',html.row.attributes='class = "success"')
  x
  #using R2HTML : writes the tables to a file, but updates that file, so it is a viable option  
  #varH = HTML(as.data.frame(outtableHtml), file = "testTable.html")
}

getVectorOfProducedExpectedReturs = function(){
  load(file = "/usr/local/lib/R/site-library/test3/data/prtfdata.Rda")
  effData$pc$pointsDF$mu
}

#than transform this into a sampling funciton of the sp500, with n of assets as args
getSP500 = function(sample){
  sample = as.numeric(as.character(sample))
  sp500Tickers = getTickers()#as.matrix((read.csv("~/sp500list.csv"))$Sym[-354])[,1]
  sp500Tickers = sample(sp500Tickers, sample)
  validateLoginDetails("sp500General", "sp500")
  spPrtfname = paste0("sp500general",paste(strsplit(split = " ",as.character(Sys.time()))[[1]],collapse = ""), collapse =  " ")
  receivePortfolio(id = (1:sample) ,ticker = sp500Tickers ,company = getCompaniesFromTickers(sp500Tickers) ,percentage = rep(1/sample*100, sample),prtfName = spPrtfname)#handle adding company names matrix
  getEffPlot(sp500Tickers, T)
}

getCompaniesFromTickers = function(tickers){
  #getCompanyByTicker use sql and make this function use sql directly
  pos = 0
  for(ticker in tickers){
    if(pos == 0){
      companies = getCompanyByTicker(ticker)
    } else {
      companies = c(companies, getCompanyByTicker(ticker)) 
    }
    pos = pos + 1
  }
  companies
}


solveWCompSingular = function(somematrix){
  returnable = tryCatch({
    solve(somematrix)
  }, warning = function(w) {
    print(w)
  }, error = function(e) {
    ginv(somematrix)
  })
  colnames(returnable) = rownames(somematrix)
  rownames(returnable) = colnames(somematrix)
  returnable
}

#data = collectData(ticker, zoom = 100, end = "2014-08-31", start = "2014-07-30")
#allData = rbind(data$data, data$pc$pointsDF)
#prtfPoints = gvisScatterChart(data = data$pc$pointsDF)
#effPoints = gvisLineChart(data = data$data)
#mer = gvisMerge(prtfPoints, effPoints)
#plot(prtfPoints)
#plot(effPoints)
#bub = gvisMotionChart(allData)
#plot(bub)



