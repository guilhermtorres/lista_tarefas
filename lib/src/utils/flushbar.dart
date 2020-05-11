import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushBarWidget {
  fodase({String title, bool error = false, BuildContext context, Function f}) {
    Flushbar(
      messageText: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: error ? Theme.of(context).accentColor : Colors.red,
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.BOTTOM,
      mainButton: FlatButton(
        onPressed: () {
          f();
        },
        child: Text(
          'Desfazer',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      margin: EdgeInsets.all(20),
      flushbarStyle: FlushbarStyle.FLOATING,
    ).show(context);
  }

  check({
    String title,
    bool selected,
    BuildContext context,
  }) =>
      Flushbar(
        messageText: Text(
          'Tarefa \"' + title + (selected ? '\" Concluída!' : ''),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: selected ? Theme.of(context).accentColor : Colors.red,
        margin: EdgeInsets.all(20),
        flushbarStyle: FlushbarStyle.FLOATING,
        flushbarPosition: selected ? FlushbarPosition.BOTTOM : FlushbarPosition.TOP,
        duration: Duration(seconds: 3),
      ).show(context);
}
