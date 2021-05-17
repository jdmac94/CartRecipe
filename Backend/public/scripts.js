// var script = document.createElement('script');
// script.src = 'https://code.jquery.com/jquery-3.4.1.min.js';
// script.type = 'text/javascript';
// document.getElementsByTagName('head')[0].appendChild(script);

// document.getElementById("passform").onsubmit = function() {submiteo()};
// <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

function CheckPasswordCoincidence() {
    
    if (!document.getElementById("CPassword").value == "") {
        var RPassword = document.getElementById("RPassword").value;
        var CPassword = document.getElementById("CPassword").value;
        
        if (CPassword == RPassword) {
            document.getElementById("warning").innerHTML = "OK";
        } else {
            document.getElementById("warning").innerHTML = "NOK";
        }
    } else {
        document.getElementById("warning").innerHTML = "";
    }

}


function checkSubmit() {
    var RPassword = document.getElementById("RPassword").value;
    var CPassword = document.getElementById("CPassword").value;
    console.log(CPassword);
    
    if (CPassword != "" && CPassword == RPassword) {
        console.log("si");
        SendChangeRequest();
    } else {
        console.log("no");
    }

}

function SendChangeRequest() {
    
    var http = new XMLHttpRequest();
    var url = "http://localhost:55005/api/v1/accSettings/restorePasswordReception/";
    str = "609d57cd272c4800300ae433";

    var RPassword = document.getElementById("RPassword").value;
    var CPassword = document.getElementById("CPassword").value;

    if (CPassword == RPassword) {
        
        http.open("POST", url + str, true);
        http.setRequestHeader("Content-Type", "application/json");

        http.onreadystatechange = function() {
            if(http.readyState == 4 && http.status == 200) { 
                document.getElementById("main_container").innerHTML = http.responseText;
            } else
                document.getElementById("main_container").innerHTML = xmlhttp.status;
        }

        var data = JSON.stringify({ "id": "609d57cd272c4800300ae433", "password": CPassword});
        http.send(data);
    
    }
    
}

function load() {
    
    var RPassword = document.getElementById("RPassword");
    var CPassword = document.getElementById("CPassword");
    var sendForm = document.getElementById("sub");
    
    RPassword.addEventListener("input", CheckPasswordCoincidence, false);
    CPassword.addEventListener("input", CheckPasswordCoincidence, false);
    
    sendForm.addEventListener("click", checkSubmit, false);
    
    // var form = document.getElementById("passform").getAttribute("action");
    // var x = window.location.pathname.split("/");
    
    // document.getElementById("passform").setAttribute("action", form + x[x.length-1]);

  }

document.addEventListener("DOMContentLoaded", load, false);