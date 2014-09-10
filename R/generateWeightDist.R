# this function generates a random distribution of wheights according to the number of assets provided
# it makes sure it sums up to 1
getSampleDistributionOfWeights = function(numofass){

  numOfAssets = numofass
  matrixofweights = NULL
  available = 1
  max = 0.45
  step = 0.0000001

  for(i in 1 : numOfAssets){  
    if(max < available){
      max = max
    } else {
      max = available
    }
    some = matrix(seq(0,max,step))
    if(available > 0 ){
      extractvalue = sample(some,1)
    } else {
      extractvalue = 0
    }
    some = some[1:(length(some)-extractvalue/step)]
    available = available - extractvalue
    
    print(extractvalue)
    
    if(is.null(matrixofweights)){
      matrixofweights = extractvalue
    } else {
      matrixofweights = c(matrixofweights, extractvalue)
    }
  }
  print(matrixofweights)
  matrixofweights
}