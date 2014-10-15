//edit this function to work both for tickers and stock names
//attention: forms reload!!!, that might be interesting ?
include(tableGenerator.js);
function generateStocksList(listType, formId,target) {//got this: from somewhere! w3 school thingy ? 
      var x = document.createElement("INPUT");
      x.setAttribute("list", target);
      x.setAttribute("id", "input_" + target);
      document.getElementById(formId).appendChild(x);
  
      var y = document.createElement("DATALIST");
      y.setAttribute("id", target);
      document.getElementById(formId).appendChild(y);
      
      var numBox = document.createElement("INPUT");
      numBox.setAttribute("type", "text");
      numBox.setAttribute("id", "numbox");
      document.getElementById(formId).appendChild(numBox);

      
      var button = document.createElement("BUTTON");
      button.setAttribute("id", ("submit"+target));
      var btnText = document.createTextNode("Submit");
      button.appendChild(btnText);
      document.getElementById(formId).appendChild(button);
      
      //appendOptions("awesome", target);
      //the list type directly calls the right R method
      ocpu.rpc(listType,{
      //args?
      },function(output){
        //something = ("ewrdad,aerwefsef,aer,ar,ad");
        ////alert( typeof String(output).split(','));
        
        allTickers = eval(output);//this function coerces to array the contents of the JSON provided by R (server)
    //    //alert(allTickers);
        for(tcker in allTickers){
          appendOptions(allTickers[tcker], target);      
        }
      });
      
      $("#"+"submit"+target).on("click", function(){
        
        //disable the button to prevent multiple clicks
        $("#"+"submit"+target).attr("disabled", "disabled");
        var choice = $("#"+"input_" + target).val();
        var percentage = $("#numbox").val();
      
        ocpu.rpc("getOtherValue",{
          valueType : listType,
          namtckr : choice
        }, function(output){
           ////alert("got this from R: " + output);
           handleTables(choice, percentage, output);
        });
       
       
        
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

function handleTables(choice, percentage, correspondingValue){
  if(checkUpperCase(String(correspondingValue))){
    ticker = correspondingValue;
    company = choice;
  } else {
    ticker = choice;
    company = correspondingValue;
  }
  //test for generated table existence, if false, gentable() else addToTable()!
        if (document.getElementById('tabler') == null) {
          generateTable(ticker,percentage, company);
        } else{
          pos = document.getElementsByTagName("tr").length-1;
          addToTable(ticker, percentage,pos, company)  
        }
       // var regpass = $("#regPass").val();
      ////alert("Submit button pressed, choice: " + choice + " for a weight of: "+ percentage + "%");
        
}

//"generateStocksNamesList()"