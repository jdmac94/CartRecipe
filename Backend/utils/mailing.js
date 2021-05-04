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
        from: 'youremail@gmail.com',
        to: destinationAddress,
        subject: 'Sending Email using Node.js',
        text: 'That was easy!'
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