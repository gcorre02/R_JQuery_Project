//this file contains functions to create and update tables, as needed.

function createElement(elementType, attributeName, attributeContent, appendTO, id,anyInnerHtml){
    var x = document.createElement(elementType);
    x.setAttribute("id",id);
  
  if(attributeName != ""){
    x.setAttribute(attributeName, attributeContent);
  }
  if(anyInnerHtml!=""){
    x.innerHTML = anyInnerHtml;
  } 
  document.getElementById(appendTO).appendChild(x);
}
//need to incorporate automatic  ticker and company filling by accessing R
function generateTable(inTicker,inPercentage, correspondingValue){
   
  createElement("table","class","table table-striped table-hover","tabletest", "tabler","");
//  var x = document.createElement("table");
//  x.setAttribute("class", "table table-striped table-hover");
//  document.getElementById("tabletest").appendChild(x);
  createElement("thead","","","tabler","tableHeader","");
  createElement("tr","","","tableHeader","headRow","");
  createElement("th","","","headRow","chead1","#");
  createElement("th","","","headRow","chead2","Ticker");
  createElement("th","","","headRow","chead3","Opposite");
  createElement("th","","","headRow","chead4","Percentage");
  createElement("tbody","","","tabler","tableBody","");
  createElement("tr","class","info","tableBody","firstRow","");
  createElement("td","","","firstRow","firstcell","1");
  createElement("td","","","firstRow","secondcell",inTicker);
  createElement("td","","","firstRow","thirdcell",correspondingValue);
  createElement("td","","","firstRow","fourthcell",inPercentage);
  createElement("tfoot","","","tabler","tableFoot","");
  createElement("tr","class","info","tableFoot","lastRow","");
  createElement("td","","","lastRow","firstcell","<b>Total<b>");
  createElement("td","","","lastRow","secondcell","");
  createElement("td","","","lastRow","thirdcell","");
  createElement("td","","","lastRow","percentageResult",inPercentage);
  
  // create submit button for the portfolio
  
  createElement("BUTTON","disabled","disabled","portfolio","submitWeights","Submit Portfolio"); 
  
  // create submit button for the name of the portfolio
  createElement("INPUT","disabled","disabled","portfolio","inputpNAME",""); 
  
  createElement("BUTTON","disabled","disabled","portfolio","submitpNAME","Submit Portfolio Name"); 
  
  
  if(parseFloat(inPercentage) == 100){
    activateButton();
  }
}
//at the moment it is adding to the only table, but that can be improved.
function addToTable(inTicker,inPercentage,position, correspondingValue){
  runningTotal = document.getElementById("percentageResult");
  current = parseFloat(runningTotal.innerHTML);
  if(current == NaN){
    current = 0;
  }
  // need to roundit to 2 or 3 cases!!
  result = current + parseFloat(inPercentage);
  if(result > 100){
    alert("Your selection is above 100%");
  } else {
  
    nameRow = position+"row";
    createElement("tr","class","info","tableBody",nameRow,"");
    createElement("td","","",nameRow,"firstcell",position);
    createElement("td","","",nameRow,"secondcell",inTicker);
    createElement("td","","",nameRow,"thirdcell",correspondingValue);
    createElement("td","","",nameRow,"fourthcell",inPercentage);
    runningTotal.innerHTML = result;
    if(result == 100){
      activateButton();
    }
  }
}

//code from http://stackoverflow.com/questions/1027224/how-can-i-test-if-a-letter-in-a-string-is-uppercase-or-lowercase-using-javascrip
function checkUpperCase(someInput){
  return(someInput === someInput.toUpperCase());
}

