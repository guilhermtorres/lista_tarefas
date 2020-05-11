import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:lista_tarefas/src/utils/flushbar.dart';
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

  void addToDo(BuildContext context) {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      if (toDoController.text.isEmpty) {
        Flushbar(
          messageText: Text(
            'Você esqueceu da Tarefa!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          margin: EdgeInsets.all(25),
          borderRadius: 50,
          duration: Duration(seconds: 2),
          title: 'Ops',
        ).show(context);
      } else if (toDoList.indexWhere((map) => map['title'] == toDoController.text) == -1) {
        newToDo['title'] = toDoController.text;
        toDoController.text = '';
        newToDo['ok'] = false;
        toDoList.add(newToDo);
        saveData();
      } else {
        Flushbar(
          messageText: Text(
            'Ops, essa tarefa já existe!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          margin: EdgeInsets.all(25),
          borderRadius: 50,
          duration: Duration(seconds: 2),
        ).show(context);
      }
    });
  }

  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      toDoList.sort((a, b) {
        if (a['ok'] && !b['ok'])
          return 1;
        else if (!a['ok'] && b['ok'])
          return -1;
        else
          return 0;
      });
      saveData();
    });
    return null;
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
                    onPressed: () => addToDo(context),
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
              child: RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: buildItem,
                  itemCount: toDoList.length,
                ),
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
          FlushBarWidget().fodase(
            context: context,
            error: true,
            title: 'Tarefa \"${lastRemoved['title']}\" removida!',
            f: () {
              setState(() {
                if (toDoList.indexWhere((map) => map['title'] == lastRemoved['title']) == -1){
                toDoList.insert(lastRemovedPosition, lastRemoved);
                saveData();} else { Flushbar(
          messageText: Text(
            'Ops, essa tarefa já existe!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          margin: EdgeInsets.all(25),
          borderRadius: 50,
          duration: Duration(seconds: 2),
        ).show(context);}
              });
            },
          );
        });
      },
      child: Card(
        elevation: 8,
        child: CheckboxListTile(
          onChanged: (check) {
            setState(() {
              toDoList[index]['ok'] = check;
              saveData();
              if (check)
                FlushBarWidget().check(
                  title: toDoList[index]['title'],
                  selected: check,
                  context: context,
                );
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
