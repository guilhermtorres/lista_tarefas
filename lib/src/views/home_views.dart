import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 20,
          title: Text(
            'To Do List ✓ ',
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300,
                  height: 300,
                  child: Image.asset(
                    'assets/images/home_image.jpg',
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
