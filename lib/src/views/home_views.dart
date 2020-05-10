import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final toDoController = TextEditingController();
  List toDoList = [];
  Map<String, dynamic> lastRemoved;
  int lastRemovedPosition;

  @override
  void initState() {
    super.initState();
    readData().then((data) {
      setState(() {
        toDoList = json.decode(data);
      });
    });
  }

  void addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo['title'] = toDoController.text;
      toDoController.text = '';
      newToDo['ok'] = false;
      toDoList.add(newToDo);
      saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 20,
        title: Text(
          '✓ To Do List',
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 250,
                  height: 250,
                  child: Image.asset(
                    'assets/images/home_image.jpg',
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: toDoController,
                      decoration: InputDecoration(
                        labelText: 'Nova Tarefa',
                        labelStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RaisedButton(
                    elevation: 10,
                    color: Theme.of(context).accentColor,
                    onPressed: addToDo,
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemBuilder: buildItem,
                itemCount: toDoList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(
        DateTime.now().millisecondsSinceEpoch.toString(),
      ),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                '  Excluir Tarefa!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          lastRemoved = Map.from(toDoList[index]);
          lastRemovedPosition = index;
          toDoList.removeAt(index);
          saveData();

          final snack = SnackBar(
            content: Text(
              'Tarefa \"${lastRemoved['title']}\" removida!',
            ),
            action: SnackBarAction(
              label: 'Desfazer',
              onPressed: () {
                setState(() {
                  toDoList.insert(lastRemovedPosition, lastRemoved);
                  saveData();
                });
              },
            ),
            duration: Duration(seconds: 3),
          );

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
      child: Card(
        elevation: 8,
        child: CheckboxListTile(
          onChanged: (check) {
            setState(() {
              toDoList[index]['ok'] = check;
              saveData();
            });
          },
          value: toDoList[index]['ok'],
          title: Text(toDoList[index]['title']),
          secondary: CircleAvatar(
            child: Icon(
              toDoList[index]['ok'] ? Icons.check : Icons.child_care,
            ),
          ),
        ),
      ),
    );
  }

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  Future<File> saveData() async {
    String data = json.encode(toDoList);
    final file = await getFile();
    return file.writeAsString(data);
  }

  Future<String> readData() async {
    try {
      final file = await getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
