import 'package:cartrecipe/api/api_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var nombreController;
  var apellidoController;
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final repitedPasswordController = TextEditingController();
  String name, surname, password;
  String nombreUsuario;
  String apellidoUsuario;

  bool flag460 = false; //La contraseña no coincide

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getLocalUserData().then((result) {
      setState(() {
        nombreController = TextEditingController(text: nombreUsuario);
        apellidoController = TextEditingController(text: apellidoUsuario);
      });
    });
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();

    super.dispose();
  }

  void turnFlagsOff() {
    setState(() {
      flag460 = false;
    });
  }

  getLocalUserData() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    nombreUsuario = user.getString('nombre');
    apellidoUsuario = user.getString('apellido');
  }

  setLocalUserData() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    user.setString('nombre', nombreController.text);
    user.setString('apellido', apellidoController.text);
  }

  _validateOldPassword(value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, introduzca la actual contraseña';
    } else if (flag460) {
      return 'La contraseña es incorrecta';
    } else {
      return null;
    }
  }

  String _validateNewPassword(String value) {
    //Minimum eight characters, at least one letter and one number
    //final patternEmail = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
    //final regExp = RegExp(patternEmail);

    if (value == null || value.isEmpty) {
      return 'Por favor, introduzca una nueva contraseña';
    } else {
      return null;
    }
  }

  String _validateNombreyApellido(String value) {
    final patternNombre = r"[a-zA-Z]";
    final regExp = RegExp(patternNombre);
    if (value == null || value.isEmpty) {
      return 'Introduzca datos';
      // } else if (flag464) {
      //   return 'Nombre mal formateado';
    } else if (!regExp.hasMatch(value)) {
      return 'Nombre mal formateado';
    } else {
      return null;
    }
  }

  void _validateForm(String value) {
    print('El valor del flag es $value');
    if (value != 'Error') {
      if (value == '460') {
        setState(() {
          flag460 = true;
          _formKey.currentState.validate();
        });
      } else if (value == '200') {
        _showDialog(context);
        setLocalUserData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar datos de usuario'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://cdn.icon-icons.com/icons2/1863/PNG/512/account-circle_119476.png"))),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Nombre",
                    ),
                    controller: nombreController,
                    validator: (value) => _validateNombreyApellido(value),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Apellidos',
                      hintText: apellidoUsuario,
                    ),
                    controller: apellidoController,
                    validator: (value) => _validateNombreyApellido(value),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Contraseña actual',
                      hintText: '************',
                    ),
                    controller: oldPasswordController,
                    validator: (value) => _validateOldPassword(value),
                    obscureText: true,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nueva contraseña',
                      hintText: '************',
                    ),
                    controller: newPasswordController,
                    validator: (value) => _validateNewPassword(value),
                    obscureText: true,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Repite la nueva contraseña',
                      hintText: '************',
                    ),
                    controller: repitedPasswordController,
                    validator: (value) {
                      if (value != newPasswordController.text) {
                        return 'La nueva contraseña no coincide';
                      }

                      return null;
                    },
                    obscureText: true,
                  ),
                  ElevatedButton(
                    child: Text('Modificar datos'),
                    onPressed: () => {
                      if (_formKey.currentState.validate())
                        {
                          ApiWrapper()
                              .modifyProfile(
                                  nombreController.text,
                                  apellidoController.text,
                                  oldPasswordController.text,
                                  newPasswordController.text)
                              .then((value) => _validateForm(value))
                        },
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¡Cambio correcto!'),
          content: Text('Los datos han sido modificados satisfactoriamente'),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
