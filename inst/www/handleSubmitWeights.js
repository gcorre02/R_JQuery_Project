//this js file handles what happens when the submitWeights button is pressed.
//todo: add toUpperCase in the search box recognition thingy, when filling the prtfolio data
function activateButton(){
  $("#submitWeights").removeAttr("disabled");
  $("#submitWeights").on("click", function(){doAbunchOfStuffWithR()});
}

function doAbunchOfStuffWithR(){
  index = 0;
  id = new Array(0);
  ticker = new Array(0);
  opposite = new Array(0);
  percentage = new Array(0);
  
  $("#tableBody").find("td").each(function(i, value){
    //alert(i+" : "+value.innerHTML);
    
    switch(index){
      case 0 : 
        id.push.apply(id, [parseInt(value.innerHTML)]);
      //  alert("id = " + id);
        break;
      
      case 1 :
        ticker.push.apply(ticker, [value.innerHTML]);
    //    alert("ticker = " + ticker);
        break;
      
      case 2 :
        opposite.push.apply(opposite, [value.innerHTML]);
  //      alert("opposite = " + opposite);
        break;
      
      case 3 : 
        percentage.push.apply(percentage, [parseFloat(value.innerHTML)]);
//        alert("% = " + percentage);
        index = -1;
        break;
      
      default:
      index = 0;
      alert("looping not done propperly");
    }
    
    index++;
  
  
  });
  
  var sendPortfData = ocpu.rpc("receivePortfolio", {
          id : id,
          ticker : ticker,
          company : opposite,
          percentage : percentage
        }, function(output){
          alert("R persistence of Portfolio: " + output);
        });
        
  //publish eff frontier plot to div<effPlot>
        /*
        var recquestEffofPortfolio = ocpu.rpc("getEff", {
          
        },function(output){
          alert(String(eval(output)));
          //alert($.("#prtfGraph").html());
            $("#prtfGraph").removeAttr("hidden");
         //$("#prtfGraph").attr("srcdoc",String(output));
         // $("#prtfGraph").html("<iframe srcdoc =\""+ String(eval(output)) + "\"></iframe>");
     //works:
          $("#prtfGraph").attr("src","tmp.html");

          //$("#prtfGraph").html("<iframe src = \"tmp.html\"></iframe>");
        }).fail(function(){
          alert("Failed to plot stock: " + recquestEffofPortfolio.responseText)
        });*/
  
        var plon = $("#plotable").rplot("getEff", {
          
        }).fail(function(){
          alert("Failed to plot stock: " + plon.responseText)
        });
        $("#plotable").find('div').css("height","600");
        
        var getWeightPoint = ocpu.rpc("getWeighted",{},
        function(output){
        //  alert(String(output));
        $("#weightedResults").html("<p>"+String(output)+"</p>");
        }).fail(function(){
          alert("failed to calculate weighted portfolio details: " + getWeightPoint.responseText)
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
  $("#tableButtons").html("<p>Choose Target Portfolio by Return, but currently just count the points from the lowest y , beginning in 2...</p>");
  createElement("input", "type", "text", "tableButtons", "chooseReturn","");
  createElement("BUTTON", "", "", "tableButtons", "firstprtftable","produce weights table");
  
  $("#firstprtftable").on("click",function(){
    alert("you chose number : "+ $("#chooseReturn").val());
    populateWTables($("#chooseReturn").val());
    
  });
}

//tis requesting the index of the array, not the actual return!
//also, later user can input the range of values he wants to produce optimized portfolios for and the step around it, this input box[chooseReturn] will show this data straight out.
function populateWTables(targetreturn){ 
  var populateWeightTables = ocpu.rpc("getTablesOfEffPlot",{
  targetreturn : targetreturn
  },
        function(output){
          alert(String(output));
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
          alert("failed to publish generated efficient portfolio tables: " + populateWeightTables.responseText)
        });
        
}