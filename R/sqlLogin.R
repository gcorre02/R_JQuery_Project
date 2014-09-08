#con <- dbConnect(dbDriver("SQLite"), dbname = "~/test3/data/portfolioManager")
#dbListTables(con)
#dbReadTable(con,"portfolio")
#prtfToAdd = cbind(rep("admin",150),assets[,-1],rep("spSample",150))
#names(prtfToAdd) = c("username",   "ticker",     "company",    "percentage", "prtfNAME"  )
#head(prtfToAdd)
#dbWriteTable(con, "portfolio", prtfToAdd, overwrite = T)
#res = dbSendQuery(con, "insert into logins values ('alvaro','cunhal') ")
#dbFetch(res)
#dbReadTable(con,"logins")
#removeExtra = dbSendQuery(con, "delete from logins where username = 'awesome'")
#dbDisconnect(con)

checkLoginExists = function(user){
  con <- dbConnect(dbDriver("SQLite"), dbname = "~/test3/data/portfolioManager")
  validateLogin = dbGetQuery(con, paste0("select * from logins where username = '",user,"'"))
  dbDisconnect(con)
  if(nrow(validateLogin)==0){
     return(F)
  } else {return(T)}
}

addNewLogin = function(user, password){
  if(checkLoginExists(user)){
    return("unsuccessful")
  }else {
    con <- dbConnect(dbDriver("SQLite"), dbname = "~/test3/data/portfolioManager")
    res = dbSendQuery(con, paste0("insert into logins values ('",user,"','",password,"') "))
    dbDisconnect(con)
    return("successful")
  }
}

validateLoginDetails = function(user,pass){
  if(!checkLoginExists(user)){
    return("Unregistered")
  } else{
    con <- dbConnect(dbDriver("SQLite"), dbname = "~/test3/data/portfolioManager")
    validateLoginDets = dbGetQuery(con, paste0("select * from logins where username = '",user,"' AND password = '",pass,"';"))
    dbDisconnect(con)
    if(nrow(validateLoginDets)==0){
      return("false") #throw error, wrong password
    } else {
      return("true")
    }
  }
}

createNewUserDB = function(){
  con <- dbConnect(dbDriver("SQLite"), dbname = "~/test3/data/portfolioManager")
  newLogin = as.data.frame(cbind("admin","pass"))
  names(newLogin) = c("username","password"  )
  dbWriteTable(con, "logins", newLogin, overwrite = T)
  dbDisconnect(con)
}

