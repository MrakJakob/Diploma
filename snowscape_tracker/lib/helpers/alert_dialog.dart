import 'package:flutter/material.dart';

void showAlertDialog(BuildContext context, String title, String content,
    void Function() onContinue, void Function() onCancel) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: onCancel,
  );
  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed: onContinue,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
