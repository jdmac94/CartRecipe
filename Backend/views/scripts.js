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

function SendChangeRequest() {
    
    var http = new XMLHttpRequest();
    var url = "http://localhost:55005/api/v1/accSettings/restorePasswordReception/";
    
    var RPassword = document.getElementById("RPassword").value;
    var CPassword = document.getElementById("CPassword").value;
    
    if (CPassword == RPassword) {
        
        http.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        http.open("POST", url, true);

        http.onreadystatechange = function() {
            if(http.readyState == 4 && http.status == 200) { 
               //aqui obtienes la respuesta de tu peticion
               alert(http.responseText);
            }
        }

        http.send(JSON.stringify({pass:RPassword}));
    
    }
    
    
    
}


// $(document).ready(function(){

//     $('#passform').submit(function() {
//         alert("no");
//         return false; // return false to cancel form action
//     });

// });


function submiteo() {
    
    var RPassword = document.getElementById("RPassword").value;
    var CPassword = document.getElementById("CPassword").value;
    
    // if (CPassword == RPassword) {
    //     alert("aha");
    //     return true;
    // } else {
        alert("no");
        return false;
    // }

}

function load() {
    
    var RPassword = document.getElementById("RPassword");
    var CPassword = document.getElementById("CPassword");
    
    var sendForm = document.getElementById("passform");
    
    RPassword.addEventListener("input", CheckPasswordCoincidence, false);
    CPassword.addEventListener("input", CheckPasswordCoincidence, false);
    console.log("goes")
    sendForm.addEventListener("submit", submiteo, false);
    console.log("brrr")
    var form = document.getElementById("passform").getAttribute("action");
    var x = window.location.pathname.split("/");
    
    document.getElementById("passform").setAttribute("action", form + x[x.length-1]);

  }

document.addEventListener("DOMContentLoaded", load, false);