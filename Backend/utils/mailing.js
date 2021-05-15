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


async function sendMailPassword(destinationAddress) {

    var mailOptions = {
        to: destinationAddress,
        subject: 'Sending Email using Node.js',
        text: 'That was easy!',
        // html: `<h1>Welcome</h1>
        //       <p>That was easy!</p>
        //       <a href="http://158.109.74.46:55005/">
        //         Haga click aquí para reestablecer contraseña
        //       </a>`,
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