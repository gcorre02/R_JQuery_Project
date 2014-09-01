//edit this function to work both for tickers and stock names
//attention: forms reload!!!, that might be interesting ?
function generateStocksList(listType, formId,target) {//got this: from somewhere! w3 school thingy ? 
      var x = document.createElement("INPUT");
      x.setAttribute("list", target);
      x.setAttribute("id", "input_" + target);
      document.getElementById(formId).appendChild(x);
  
      var y = document.createElement("DATALIST");
      y.setAttribute("id", target);
      document.getElementById(formId).appendChild(y);
      
      var numBox = document.createElement("INPUT");
      numBox.setAttribute("id", "numbox");
      document.getElementById(formId).appendChild(numbox);

      
      var button = document.createElement("BUTTON");
      button.setAttribute("id", ("submit"+target));
      var btnText = document.createTextNode("Submit");
      button.appendChild(btnText);
      document.getElementById(formId).appendChild(button);
      
      appendOptions("awesome", target);
      //the list type directly calls the right R method
      ocpu.rpc(listType,{
      //args?
      },function(output){
        //something = ("ewrdad,aerwefsef,aer,ar,ad");
        //alert( typeof String(output).split(','));

        allTickers = String(output).split(',');
        for(tcker in allTickers){
          appendOptions(allTickers[tcker], target);      
        }
      });
      
      $("#"+"submit"+target).on("click", function(){
        //disable the button to prevent multiple clicks
        $("#"+"submit"+target).attr("disabled", "disabled");
        var choice = $("#"+"input_" + target).val();
        var percentage = $("#numbox").val();
       // var regpass = $("#regPass").val();
        alert("Submit button pressed, choice: " + choice + " for a weight of: "+ percentage + "%");
        
        //have form
        //update/populate form
        //submit form to R!!
        
        /*
        var validateRegister = ocpu.rpc("addUser", {
          username : reguser,
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
          }
        }).fail(function(){
          alert("R failed " + validateLogin.responseText)
        });*/
        
        $("#"+"submit"+target).removeAttr("disabled");
        //create a function for this:
        document.getElementById(formId).removeChild(x);
        document.getElementById(formId).removeChild(y);
        document.getElementById(formId).removeChild(button);
        document.getElementById(formId).removeChild(numbox);

      });
}

function appendOptions(content, idOfElement){
  var z = document.createElement("OPTION");
      z.setAttribute("value", content);
      document.getElementById(idOfElement).appendChild(z);
}


//"generateStocksNamesList()"