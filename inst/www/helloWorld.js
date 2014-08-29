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