import 'package:flutter/material.dart';
import 'package:PersonalAssistant/todoapp/chart.dart';
import 'package:PersonalAssistant/todoapp/dbhelper.dart';

class todoui extends StatefulWidget {
  @override
  _todouiState createState() => _todouiState();
}

class _todouiState extends State<todoui> {
  int _completed = 0;
  int _notCompleted = 0;
  final dbhelper = Databasehelper.instance;
  int count = 0;
  final texteditingcontroller = TextEditingController();
  bool validated = true;
  String errtext = "";
  String todoedited = "";
  var myitems = List();
  List<Widget> children = new List<Widget>();
  @override
  void initState() {
    setState(() {
      getCount();
    });
    super.initState();
  }
  void addtodo() async {
    Map<String, dynamic> row = {
      Databasehelper.columnName: todoedited,
    };
    final id = await dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
    todoedited = "";
    setState(() {
      validated = true;
      errtext = "";
    });
  }
  Future<bool> query() async {
    myitems = [];
    children = [];
    var allrows = await dbhelper.queryall();
    allrows.forEach((row) {
      myitems.add(row.toString());
      children.add(Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children:<Widget>[
              ListTile(
                title: Text(
                  row['todo'].substring(0, row['todo'].length - 1),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "Raleway",
                  ),
                ),
                onLongPress: () {
                  dbhelper.deletedata(row['id']);
                  setState(() {
                    getCount();
                  });
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Checkbox(
                      onChanged: (bool e) => doChange(row['id'], row['todo']),
                      value: row['todo'].substring(row['todo'].length-1, row['todo'].length) == '0' ? false:true,
                      activeColor: Colors.purple,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      row['todo'].substring(row['todo'].length-1, row['todo'].length) == '0' ? 'Not Completed':'Completed',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: "Raleway",
                        color: row['todo'].substring(row['todo'].length-1, row['todo'].length) == '0' ? Colors.red:Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
    });
    return Future.value(true);
  }

  void showalertdialog() {
    texteditingcontroller.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(
                "Add Task",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    showCursor: true,
                    cursorColor: Colors.purple,
                    controller: texteditingcontroller,
                    autofocus: true,
                    
                    onChanged: (_val) {
                      todoedited = _val;
                      todoedited = todoedited + '0';
                    },
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Raleway",
                    ),
                    decoration: InputDecoration(
                      errorText: validated ? null : errtext,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            if (texteditingcontroller.text.isEmpty) {
                              setState(() {
                                errtext = "Can't Be Empty";
                                validated = false;
                              });
                            } else if (texteditingcontroller.text.length >
                                512) {
                              setState(() {
                                errtext = "Too may Chanracters";
                                validated = false;
                              });
                            } else {
                              addtodo();
                            }
                            setState(() {
                              getCount();
                            });
                          },
                          color: Colors.purple,
                          child: Text("ADD",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Raleway",
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.hasData == null) {
          return Center(
            child: Text(
              "No Data",
            ),
          );
        } else {
          if (myitems.length == 0) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showalertdialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.purple,
              ),
              //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
              appBar: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                title: Text(
                  "My Tasks",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              //backgroundColor: Colors.black,
              body: Center(
                child: Text(
                  "No Task Avaliable",
                  style: TextStyle(
                    fontFamily: "Raleway", 
                    fontSize: 20.0,
                    color: Colors.white12,
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showalertdialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.purple,
              ),
              appBar: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                title: Text(
                  "My Tasks",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              //backgroundColor: Colors.grey,
              body: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0), 
                    child:Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                        child: MyPieChart(_completed , _notCompleted),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: children,
                    ),
                  ),
                ],
              ),
            );
          }
        }
      },
      future: query(),
    );
  }
  
  void doChange(int id, String pass) {
    String temp = pass.substring(0, pass.length - 1);
    String temp1 = pass.substring(pass.length - 1, pass.length);
    if (temp1 == '0') {
      temp = temp + '1';
    }
    else {
      temp = temp + '0';
    }
    dbhelper.updatedata(id, temp);
    setState(() {
      getCount();
    });
  }

  getCount() async {
    var res = await dbhelper.queryall();
    int total = res.length;
    int com = 0;
    int notCom = 0;
    for (int i = 0; i < total; i++) {
      if (res[i]['todo'].substring(res[i]['todo'].length - 1, res[i]['todo'].length) == '0') {
        notCom += 1;
      }
      else {
        com += 1;
      }
    }
    _completed = com;
    _notCompleted = notCom;
  }
}