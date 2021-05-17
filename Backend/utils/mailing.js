var nodemailer = require('nodemailer');

var mailCR = 'not.reply.cartrecipe@gmail.com';
var passCR = 'adminCR21';

var transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: mailCR,
    pass: passCR
  }
});


async function sendMailPassword(destinationAddress, userid) {

  url = "http://localhost:55005/api/v1/accSettings/restoreForm/" + userid;
  //http://localhost:55005/api/v1/accSettings/restorePasswordReception/?RPassword=asdasd&CPassword=adasdsa
    //TO-DO: personalizar el mail añadiendo los datos del usaurio (nombre y apellidos)
    var mailOptions = {
        to: destinationAddress,
        subject: 'Recuperación de contraseña de CartRecipe',
        html: `<h1>Welcome</h1>
          <p>That was easy!</p>
          <a href="${url}">Haga click aquí para reestablecer contraseña</a>`,
    };

    transporter.sendMail(mailOptions, function(error, info){
      if (error) {
        console.log(error);
        return -1;
      } else {
        console.log('Email sent: ' + info.response);
        return 0;
      }
    });
}

module.exports = { sendMailPassword };