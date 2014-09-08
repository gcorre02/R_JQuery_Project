#library(opencpu)
l1 = new.env(hash = TRUE, parent = parent.frame(), size = 29L)
load("~/test3/data/logins.Rda",  envir = l1)

persistData = function(logins, filename){
  target = paste0("/Users/gctribeiro/test3/data/", filename,".Rda")#this must be solved on the server itself., how do you access session variables?
 # logins = data
  unlockBinding("logins", l1)
  assign("logins", logins, envir = l1) 
  lockBinding("logins", l1)
  save(logins, file = target, compress = F)
  #saveRDS(data,target)
}

addUser = function(username, password){
  unlockBinding("logins", l1)
  load("/Users/gctribeiro/test3/data/logins.Rda",  envir = l1)
  
  loginsFile = l1$logins#readRDS(file="data/logins.Rda")
  if(is.na(loginsFile[username,])){
    loginsFile = rbind(loginsFile, as.data.frame(password,row.names=username, col.names= "password"))
    persistData(loginsFile,"logins")
    return("successful")
  }
  #add trycatch with return of success or notelse error !
  return("unsuccessful")
}

createNewUserDB = function(){
  logins = as.data.frame("user",row.names="admin", col.names="password")
  colnames(logins) = "password"
  persistData(logins,"logins")
}

checkLogin = function(user, pass){
  unlockBinding("logins", l1)
  load("/Users/gctribeiro/test3/data/logins.Rda",  envir = l1)
  
  loginsFile = l1$logins #readRDS(file="data/logins.Rda")
  
  if(is.na(loginsFile[user,])){
    return("Unregistered")
    #throw error, ask for registering
  } else {
    if(loginsFile[user,]!=pass){
      return("false") #throw error, wrong password
    } else {
      return("true")
    }
  }
}

