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
        var recquestEffofPortfolio = $("#portfolio").rplot("getEff", {
        }).fail(function(){
          alert("Failed to plot stock: " + req.responseText)
        });
  
        
  //disable searchby buttons until submit
  // ask user for a name for the portfolio...
  //send portfolio ticker and weight to R and persist it under the user
  //ask r for a plot of the portfolio 
  //then ask for eff frontier plot using the assets 
  //then allow user to hover over the points, and if selected, produce a new weight distribution table
}