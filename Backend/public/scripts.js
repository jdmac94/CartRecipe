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
      document.getElementById("warning").innerHTML = "";
    } else {
      document.getElementById("warning").innerHTML =
        "Error: las contraseñas introducidas no coinciden";
    }
  } else {
    document.getElementById("warning").innerHTML = "";
  }
}

function checkSubmit() {
  var RPassword = document.getElementById("RPassword").value;
  var CPassword = document.getElementById("CPassword").value;

  if (pwdFormatCheck(CPassword) && pwdFormatCheck(RPassword)) {
    if (CPassword != "" && CPassword == RPassword) {
      console.log("si");
      SendChangeRequest();
    }
    // else {
    //     console.log("no");
    //     document.getElementById("warning").innerHTML = "Error: las contraseñas introducidas no coinciden";
    // }
  } else {
    document.getElementById("warning").innerHTML =
      "Error: mal formato de la contraseña, vuelva a intentarlo";
  }
}

function pwdFormatCheck(pwd) {
  var regx = /(?=.*\d)(?=.*[A-z])[0-9a-zA-Z]{8,}/i;

  return true;

  //he hecho la funcion para añadir el cambio de estilo
}

function SendChangeRequest() {
  var http = new XMLHttpRequest();
  var url =
    "http://158.109.74.46:55005/api/v1/accSettings/restorePasswordReception/";
  var x = window.location.pathname.split("/");
  var str = x[x.length - 1];
  //str = "609d57cd272c4800300ae433";

  var RPassword = document.getElementById("RPassword").value;
  var CPassword = document.getElementById("CPassword").value;

  if (CPassword == RPassword) {
    http.open("POST", url, true);
    http.setRequestHeader("Content-Type", "application/json");

    http.onreadystatechange = function () {
      if (http.readyState == 4 && http.status == 200) {
        document.getElementById("main_container").innerHTML = http.responseText;
      } else
        document.getElementById("main_container").innerHTML =
          "Ha habido un error en el envío de la solicitud. Por favor, vuelva a intentarlo";
    };
    console.log(str);
    console.log(CPassword);
    var data = JSON.stringify({ id: str, password: CPassword });
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

  var form = document.getElementById("passform").getAttribute("action");
  var x = window.location.pathname.split("/");

  ObjIdHexRegExp = /^(?=[a-f\d]{24}$)(\d+[a-f]|[a-f]+\d)/i;

  // document.getElementById("passform").setAttribute("action", form + x[x.length-1]);
  str = x[x.length - 1];
  console.log(str);
}

document.addEventListener("DOMContentLoaded", load, false);
