$(document).ready(function(){
  alert("the thing was");
  alert("changed!");
  
        $("#submitbutton").on("click", function(){
        //disable the button to prevent multiple clicks
        $("#submitbutton").attr("disabled", "disabled");
        alert("inside the button");
        //read the value for 'myname'
        //var myname = $("#namefield").val();
        var myname = $("#fname").val() + " " + $("#lname").val();
        //perform the request
        
        var req = ocpu.rpc("sayHello", {
          myname : myname
        }, function(output){
          $("#output").text(output);
          alert(output);
        });
        
        var reques = ocpu.rpc("searchQuandle", {
          query : "SP500"
        }, function(output){
          alert("Should be working quandle it is");
          $("#SP500").text(output);
          
        });
        
        /*
        var publishQuandlResults = ocpu.rpc("getQuandlInfo", {
          query : $("#SP500").val()
        }, function(data){
          alert("Should be printing results it is");
          $("#results").text(data);
        });
        */
        
        //publish plot
        var plo = $("#plotable").rplot("getQuandlPlot", {
          //target : $("#SP500").val() 
          target : "GOOG/EPA_LVOL"
        }).fail(function(){
          alert("Failed to plot stock: " + req.responseText)
        });
    
        //if R returns an error, alert the error message
        //req.fail(function(){
        //  alert("Server error: " + req.responseText);
        //});
        //
        //after request complete, re-enable the button 
        //req.always(function(){
        //  $("#submitbutton").removeAttr("disabled")
        //});
      });

  
});