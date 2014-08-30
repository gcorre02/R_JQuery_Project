
load("data/logins.Rda")

persistData = function(logins, filename){
  target = paste0("data/", filename,".Rda")
 # logins = data
 assign("logins", logins, envir = .GlobalEnv) 
 #save(logins, file = target)
  #saveRDS(data,target)
}

addUser = function(username, password){
  loginsFile = logins#readRDS(file="data/logins.Rda")
  if(is.na(loginsFile[username,])){
  loginsFile = rbind(loginsFile, as.data.frame(password,row.names=username, col.names= "password"))
  persistData(loginsFile,"logins")
    return(ls())
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
  loginsFile = logins #readRDS(file="data/logins.Rda")
  
  if(is.na(loginsFile[user,])){
    return("unregistered")
    #throw error, ask for registering
  } else {
    if(loginsFile[user,]!=pass){
      return("false") #throw error, wrong password
    } else {
      return("true")
    }
  }
}

