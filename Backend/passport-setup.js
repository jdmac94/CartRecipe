const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth2').Strategy;
const { Usuario } = require("./models/usuario");
const mongoose = require("mongoose");
require("./database");


passport.use(new GoogleStrategy({
    clientID:     "444962992521-irs2t134pvli3d2td0hmrevn1r5838ju.apps.googleusercontent.com",
    clientSecret: "COxfSIHlrmOP-3xfKlEf9Cct",
    callbackURL: "http://localhost:3000/api/v1/auth/auth/google/callback",
    passReqToCallback   : true
  },
  async function(request, accessToken, refreshToken, profile, done) {
      require("./database");
      //usamos el user id para comprobar si el usuario está registrado en la base de datos

      let user = await Usuario.findOne({ googleId: profile.id });//bscamos si el usuario existe registrado con google

      console.log(user);

      if (user) {
        console.log("*se le da acceso / se loguea*")
      } else {
        let user = await Usuario.findOne({ correo: profile.email });//buscamos si el mail de google coincide con un correo ya registrado de forma "normal"

        if (user) {
            console.log("*se añade el id de google y se le da acceso / se loguea*")
        } else {//creamos el nuevo usuario al no existir de ninguna forma en la bd
            user = new Usuario();
            user.nombre = profile.given_name;
            user.apellido = profile.family_name;
            user.correo = profile.email;
            user.password = -1;
            user.googleId = profile.id;//enctiptar?
            const result = user.save();
            //if (result) res.send(user.generateAuthToken());
            
        }
      }


      return user;

    // User.findOrCreate({ googleId: profile.id }, 
    //     function (err, user) {
    //     return done(err, user);
    //     }
    // );
     
  }
));