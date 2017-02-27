
	 $(document).ready(function(){
			$("#mainContent").load("/src/common/login/login2.tpl.html");
	var x = location.port;		
		if (x == 8181){
			
			console.log("you are secured!");
						$( "#dialog" ).dialog({
						  autoOpen: false,
						  resizable: false,
						  draggable:false,
						  show: {
							effect: "none"
						  },
						  hide: {
							effect: "none"
						  }
						});
					$("#dialog").html("<form roll='form' class='loginDialog'><p class='titles'>Authentication Required </p><p class='top-para'>http://10.11.17.135:8181 requires a username and password.</p><p class='second-para'>Your connection is not private.</p><table class='userTable'><tr><td>User Name:</td><td><input ng-model='login.username' name='username' type='text' autofocus></td></tr><tr><td>Password:</td><td><input ng-model='login.password' name='password' type='password' value=''></td></tr></table><button class='btns cancel' type='button'>Cancel</button><button ng-click='sendLogin()' class='btns log'>Login</button></form>");
			
			
			
			
				$('.btn-block').click(function(){
				
						$( "#dialog" ).dialog( "open" );
						$(".ui-dialog").removeClass(' ui-draggable-disabled ui-state-disabled');
						$(".cancel").click(function(){
							$("#dialog"  ).dialog( "close" );

						});
						  });
						
					$(".loginDialog").submit(function(event){
						var username= $("input[name = 'usernames']").val();
						var password =$("input[name = 'passwords']").val();
						var dataString = '&usernames='+ username + '&passwords='+ password
						$.ajax({
						type: "POST",
						url: "restconf/modules",
						//url: "src/checkUser.php",
						data: dataString,
						success: function() {
						console.log(username);
						console.log(password);
						console.log('success');

						}
						});
						$("#dialog"  ).dialog( "close" ).delay( 800 ).fadeIn( 400 );
							event.preventDefault();
						$( "#dialog" ).dialog( "open" ).delay( 800 ).fadeIn( 400 );
					});
					
							
		}else{
			console.log("you are not secured");
			$('.btn-block').click(function(){
					var username= $("input[name = 'usernames']").val();
					var password =$("input[name = 'passwords']").val();
					var dataString = '&usernames='+ username + '&passwords='+ password
							$.ajax({
								type: "POST",
								url: "restconf/modules",
								data: dataString,
								success: function() {
									console.log(username);
									console.log(password);
									console.log('success');		
									}
								  });
							  });
			}			
}); 

var app = angular.module('myApp', []);
app.controller('myCtrl', function($scope) {
$scope.name;
$scope.sendLogin = function() {
$scope.name = "Unable to Login";
}
});


