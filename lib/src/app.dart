import 'package:flutter/material.dart';
import 'package:lista_tarefas/src/views/home_views.dart';

class ToDoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'DidactGothic',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              subtitle: TextStyle(
                fontFamily: 'DidactGothic',
                fontSize: 24,
              ),
            ),
        primarySwatch: Colors.teal,
        accentColor: Colors.cyan[200],
        appBarTheme: AppBarTheme(
          color: Colors.teal[400],
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'PassionOne',
                  // fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
        ),
        canvasColor: Colors.white,
      ),
      home: HomeView(),
    );
  }
}
