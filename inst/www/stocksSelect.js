
function generateStocksList() {
      var x = document.createElement("INPUT");
      x.setAttribute("list", "tickers");
      document.getElementById("securityList").appendChild(x);
  
      var y = document.createElement("DATALIST");
      y.setAttribute("id", "tickers");
      document.getElementById("securityList").appendChild(y);
  
      var z = document.createElement("OPTION");
      z.setAttribute("value", "Chrome");
      document.getElementById("tickers").appendChild(z);
      
      appendOptions("awesome", "tickers");
      ocpu.rpc("getTickers",{
      //args?
      },function(output){
        //something = ("ewrdad,aerwefsef,aer,ar,ad");
        //alert( typeof String(output).split(','));
        
        allTickers = String(output).split(',');
        for(tcker in allTickers){
          appendOptions(allTickers[tcker], "tickers");      
        }
      });
}

function appendOptions(content, idOfElement){
  var z = document.createElement("OPTION");
      z.setAttribute("value", content);
      document.getElementById(idOfElement).appendChild(z);
}


//"generateStocksNamesList()"