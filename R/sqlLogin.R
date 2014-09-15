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


#current user and login must be stored in the html, not the sql!!! otherwise no concurrency!!!
#the same needs to happen with the eff file that is being generated!!! it needs to be added to sql with a user name and portfolio name id like the portfolio table


checkLoginExists = function(user){
  con <- dbConnect(dbDriver("SQLite"), dbname = "~/data/portfolioManager")#  "~/test3/data/portfolioManager")
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
    res = dbSendQuery(con, paste0("insert into logins values (1,'",user,"','",password,"') "))    
    currentLogin = as.data.frame(user)
    names(currentLogin) = c("username")
    dbWriteTable(con, "currentLogin", currentLogin, overwrite = T)
    dbDisconnect(con)
    return("successful")
  }
}

validateLoginDetails = function(user,pass){
  if(!checkLoginExists(user)){
    return("Unregistered")
  } else{
    con <- dbConnect(dbDriver("SQLite"), dbname =  "~/html/data/portfolioManager")# "~/test3/data/portfolioManager")
    validateLoginDets = dbGetQuery(con, paste0("select * from logins where username = '",user,"' AND password = '",pass,"';"))
    dbDisconnect(con)
    if(nrow(validateLoginDets)==0){
      return("false") #throw error, wrong password
    } else {
      con <- dbConnect(dbDriver("SQLite"), dbname =  "~/data/portfolioManager")#"~/test3/data/portfolioManager")
      currentLogin = as.data.frame(user)
      names(currentLogin) = c("username")
      dbWriteTable(con, "currentLogin", currentLogin, overwrite = T)
      dbDisconnect(con)
      return("true")
    }
  }
}

createNewUserDB = function(){
  con <- dbConnect(dbDriver("SQLite"), dbname = "~/test3/data/portfolioManager")
  newLogin = as.data.frame(cbind(c("admin","sp500General"),c("pass","sp500")))
  names(newLogin) = c("username","password"  )  
  dbWriteTable(con, "logins", newLogin, overwrite = T)
  dbDisconnect(con)
}

