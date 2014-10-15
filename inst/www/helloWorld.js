$(document).ready(function(){
  //alert("the thing was");
  alert("this new version");
  
        $("#submitbutton").on("click", function(){
        //disable the button to prevent multiple clicks
        $("#submitbutton").attr("disabled", "disabled");
        
        var myname = $("#fname").val() + " " + $("#lname").val();
        //perform the request
        
        $("#plotable").find('div').css("height","600");
        //publish plot
        var plo = $("#plotable").rplot("getSP500", {
          //target : $("#sp500input").val() 
          sample : $("#sp500input").val()
        }).fail(function(){
          alert("Failed to plot stock: " + plo.responseText)
        });
    
        $("#submitbutton").removeAttr("disabled");
      });

      $("#loginbutton").on("click", function(){
        //disable the button to prevent multiple clicks
        $("#loginbutton").attr("disabled", "disabled");
        var user = $("#user").val();
        var pass = $("#pass").val();
        //alert("loginbutton pressed " + user + " " + pass);

        var validateLogin = ocpu.rpc("validateLoginDetails", {
          user : user,
          pass : pass
        }, function(output){
          //should link somewhere
          alert("Your login is " + output) ;
          if(output == "true"){//note : only == works here...
            $("#login").text("Login Successful");
            $("#loginform").attr("display","none");
          } else if (output == "false"){
            $("#login").text("Login unsuccessful");
          } else {
            $("#login").text("Please Register");
            //call function to generate user registration
            addInputMethod();
          }
        }).fail(function(){
          alert("R failed " + validateLogin.responseText)
        });
        
        $("#loginbutton").removeAttr("disabled");
      });
      
      
     
      
});
function addInputMethod() {



    $('#registerform').after('User: <input type="text" id = "regUser" ' + '"/><br />'); 
    $('#regUser').after('Pass: <input type="text" id = "regPass" ' + '"/><br />');
    $('#regPass').after('<button id= "registerbutton">REGISTER</button>' + '<br />');
    
      $("#registerbutton").on("click", function(){
        //disable the button to prevent multiple clicks
        $("#registerbutton").attr("disabled", "disabled");
        var reguser = $("#regUser").val();
        var regpass = $("#regPass").val();
        alert("registerbutton pressed " + reguser + " " + regpass);
        
        var validateRegister = ocpu.rpc("addNewLogin", {
          user : reguser,
          password : regpass
        }, function(output){
          //should link somewhere
          alert("Your registration was " + output) ;/*
          if(output == "true"){//note : only == works here...
            $("#login").text("Login Successful");
          } else if (output == "false"){
            $("#login").text("Login unsuccessful");
          } else {
            $("#login").text("Please Register");
            //call function to generate user registration
            addInputMethod();
          }*/
        }).fail(function(){
          alert("R failed " + validateLogin.responseText)
        });
        
        $("#loginbutton").removeAttr("disabled");
      });
}