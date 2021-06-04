var nodemailer = require("nodemailer");

var mailCR = "not.reply.cartrecipe@gmail.com";
var passCR = "adminCR21";

var transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: mailCR,
    pass: passCR,
  },
});

async function sendMailPassword(destinationAddress, userid) {
  url = "http://158.109.74.46:55005/api/v1/accSettings/restoreForm/" + userid;
  //http://localhost:55005/api/v1/accSettings/restorePasswordReception/?RPassword=asdasd&CPassword=adasdsa
  //TO-DO: personalizar el mail añadiendo los datos del usaurio (nombre y apellidos)
  var mailOptions = {
    to: destinationAddress,
    subject: "Recuperación de contraseña de CartRecipe",
    html: `<h3>Hemos recibido una solicitud para restablecer tu contraseña. Si no has realizado esta solicitud, sencillamente ignora este mensaje. Si has sido tú, puedes restablecer tu contraseña haciendo clic sobre el siguiente enlace:</h3><a href="${url}">Haga click aquí para reestablecer contraseña</a>`,
  };

  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log(error);
      return -1;
    } else {
      console.log("Email sent: " + info.response);
      return 0;
    }
  });
}

module.exports = { sendMailPassword };
