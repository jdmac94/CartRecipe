import 'package:cartrecipe/screens/welcome.dart';
import 'package:cartrecipe/widgets/perfil/sure_remove.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class RemoveAccount extends StatefulWidget {
  const RemoveAccount({Key key}) : super(key: key);
  @override
  State<RemoveAccount> createState() => _RemoveAccount();
}

String dropdownValue = 'Duis aute irure dolor in';

Future<void> dialogSureRemoveAccount(
    BuildContext context, String dropdownValue) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return SureRemove(dropdownValue);
    },
  );
}

@override
class _RemoveAccount extends State<RemoveAccount> {
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Eliminar cuenta'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('¿Por qué razón quieres eliminar la cuenta?'),
            // ignore: missing_required_param
            SizedBox(height: 10),
            SizedBox(
              height: 70,
              child: DropdownButton<String>(
                isExpanded: true,
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 1,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>[
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor .',
                  'Ut enim ad minim veniam, quis nostrud exercitation',
                  'Duis aute irure dolor in',
                  'Excepteur sint occaecat cupidatat non proident, sunt in'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Eliminar cuenta'),
          onPressed: () {
            dialogSureRemoveAccount(context, dropdownValue);
          },
        ),
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
