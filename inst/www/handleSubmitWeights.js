//this js file handles what happens when the submitWeights button is pressed.
//todo: add toUpperCase in the search box recognition thingy, when filling the prtfolio data
function activateButton(){
  //alert("activate button called");
  $("#inputpNAME").removeAttr("disabled");
  $("#submitpNAME").removeAttr("disabled");
  
  $("#submitpNAME").on("click", function(){
   
    submitzeWeights();
  });  
}

function submitzeWeights(){
  portfolioName = $("#inputpNAME").val();
  username = $("#user").val();
  //alert("clicked! Portfolio: " +portfolioName + " user : " + username);


  var checkpNotExists = ocpu.rpc("checkPortfolioAlreadyExists",{
    currentUser : username,
    prtfName : portfolioName
  },function(output){
    //alert(String(output));
      if(String(output) == "true"){
        //alert("portfolio already exists!");
      
      } else{
        $("#submitWeights").removeAttr("disabled");
        $("#submitWeights").on("click", function(){
          doAbunchOfStuffWithR();
        });
      }
  }).fail(function(){
          //alert("Failed to check if portfolio already exists: " + checkpNotExists.responseText)
  });
}

function doAbunchOfStuffWithR(){
  index = 0;
  id = new Array(0);
  ticker = new Array(0);
  opposite = new Array(0);
  percentage = new Array(0);
  
  $("#tableBody").find("td").each(function(i, value){
    ////alert(i+" : "+value.innerHTML);
    
    switch(index){
      case 0 : 
        id.push.apply(id, [parseInt(value.innerHTML)]);
      //  //alert("id = " + id);
        break;
      
      case 1 :
        ticker.push.apply(ticker, [value.innerHTML]);
    //    //alert("ticker = " + ticker);
        break;
      
      case 2 :
        opposite.push.apply(opposite, [value.innerHTML]);
  //      //alert("opposite = " + opposite);
        break;
      
      case 3 : 
        percentage.push.apply(percentage, [parseFloat(value.innerHTML)]);
//        //alert("% = " + percentage);
        index = -1;
        break;
      
      default:
      index = 0;
      //alert("looping not done propperly");
    }
    
    index++;
  
  
  });
  
  portfolioName = $("#inputpNAME").val();
  //alert("portfolio new name is : " + portfolioName);
  var sendPortfData = ocpu.rpc("receivePortfolio", {
          id : id,
          ticker : ticker,
          company : opposite,
          percentage : percentage,
          prtfName : portfolioName
        }, function(output){
          //alert("R persistence of Portfolio: " + output);
        }).fail(function(){
          //alert("failed to persist portfolio details: " + sendPortfData.responseText)
        });
        
 
  
        var plon = $("#plotable").rplot("getEff", {
          
        }).fail(function(){
          //alert("Failed to plot stock: " + plon.responseText)
        });
        $("#plotable").find('div').css("height","600");
        
        var getWeightPoint = ocpu.rpc("getWeighted",{},
        function(output){
        //  //alert(String(output));
        $("#weightedResults").html("<p>"+String(output)+"</p>");
        }).fail(function(){
          //alert("failed to calculate weighted portfolio details: " + getWeightPoint.responseText)
        });
       
        generateTableButtons();
        
       
      
  //disable searchby buttons until submit
  // ask user for a name for the portfolio...
  //send portfolio ticker and weight to R and persist it under the user
  //ask r for a plot of the portfolio 
  //then ask for eff frontier plot using the assets 
  //then allow user to hover over the points, and if selected, produce a new weight distribution table
}

function generateTableButtons(){
  $("#tableButtons").html("<p>Choose Target Portfolio by Return and see its new distribution</p>");

  createElement("BUTTON", "", "", "tableButtons", "firstprtftable","produce weights table");
  
  createElement("SELECT", "", "", "tableButtons", "selectReturn","<option value=2>Please select a target Return</option>");
  
  populateselectReturns();

  $("#firstprtftable").on("click",function(){
    //alert("you chose number : "+ $("#selectReturn").val());
    populateWTables($("#selectReturn").val());
  
  });
}

//tis requesting the index of the array, not the actual return!
//also, later user can input the range of values he wants to produce optimized portfolios for and the step around it, this input box[chooseReturn] will show this data straight out.


function populateselectReturns(){
  var selectReturnsPop = ocpu.rpc("getVectorOfProducedExpectedReturs",{
  
  },function(output){
      //alert(String(eval(output)));
      pos = 2
      String(output).split(",").forEach(function(entry){
        //alert(String(entry));
     //   instead of entry you can put an int that has to do with its position in the list
        createElement("OPTION", "value", pos, "selectReturn", "",entry);
        pos++;
  
      });
  });
}

function populateWTables(targetreturn){ 
  var populateWeightTables = ocpu.rpc("getTablesOfEffPlot",{
  targetreturn : targetreturn
  },
        function(output){
          //alert(String(output));
        $("#generatedPrtf").html(String(output));
//        $("#generatedPrtf").find('th')attr("class","");
        $("#generatedPrtf").find('tr').each(function(i){
          if(i == 0){
            $(this).find('th').each(function(i){
              if(i == 0){
                $(this).html("Ticker");
              } else {
                $(this).css("text-align","right");
              }
            })
          }
          else{
            $(this).attr("class","success");
          //  $(this).find('td').each(function(){
          }
        });
        
        }).fail(function(){
          //alert("failed to publish generated efficient portfolio tables: " + populateWeightTables.responseText)
        });
        
}