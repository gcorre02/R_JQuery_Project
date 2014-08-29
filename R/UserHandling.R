
persistData = function(data, filename){
  target = paste0("data/", filename,".Rda")
  saveRDS(data,target)
}

addUser = function(username, password){
  loginsFile = readRDS(file="data/logins.Rda")
  if(is.na(loginsFile[username,])){
    loginsFile = rbind(loginsFile, as.data.frame(password,row.names=username, col.names= "password"))
  }
  persistData(loginsFile,"logins")
  #else error !
}

createNewUserDB = function(){
  k = as.data.frame("user",row.names="admin", col.names="password")
  colnames(k) = "password"
  persistData(k,"logins")
}

checkLogin = function(user, pass){
  loginsFile = readRDS(file="data/logins.Rda")
  if(is.na(loginsFile[user,])){
    #throw error, ask for registering
  } else {
    if(loginsFile[user,]!=pass){
      return( F) #throw error, wrong password
    } else {
      return( T)
    }
  }
}