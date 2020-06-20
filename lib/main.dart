import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO App',
      home: Body(),
    );
  }
}

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          tooltip: 'Add item to ToDo list',
          backgroundColor: Colors.deepPurple,
          icon: Icon(Icons.add),
          onPressed: () {
            testAlert(context);
          },
          label: Text('Add')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        leading: Icon(Icons.work),
        elevation: 0.0,
        title: Text('What To Do!'),
        backgroundColor: Colors.transparent,
      ),
      body: Home(),
    );
  }

  void testAlert(BuildContext context) {
    var alert = AlertDialog(
      title: Text("Add Something"),
      content: SizedBox(
          child: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'What to do today.'),
      )),
      actions: [
        FlatButton(
            onPressed: () {
              setState(() {
                try {
                  _HomeState.list.add(_controller.text);
                  _HomeState._color.add(Colors.deepPurple);
                  _HomeState._current.add(true);
                  _controller.clear();
                } on Exception catch (e) {
                  debugPrint('$e');
                }
              });
              Navigator.of(context).pop();
            },
            child: Text("Add"))
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static var now = new DateTime.now();
  static var formatter = new DateFormat('dd-MM-yyyy');
  String formatted = formatter.format(now);
  static List _color = [];
  static List _current = [];
  static List list = [];
  @override
  Widget build(BuildContext context) {
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
    String res = timeOfDay.format(context);
    //bool is12HoursFormat = res.contains(new RegExp(r'[A-Z]'));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 70,
          child: Column(children: [
            Text(
              '$res',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '$formatted',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            )
          ]),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50)),
                color: Color(0XFFECECEC)),
            child: Padding(
              padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: ListTile(
                    leading: Icon(
                      Icons.arrow_right,
                      color: Colors.deepPurple,
                    ),
                    title: Text(list[index]) ?? Text("Hello"),
                    trailing: ButtonBar(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: "Done",
                          child: IconButton(
                            icon: Icon(
                              Icons.check_box,
                              color: _color[index],
                            ),
                            onPressed: () {
                              setState(() {
                                _color[index] = _current[index]
                                    ? Colors.green
                                    : Colors.deepPurple;
                                _current[index] = !_current[index];
                              });
                            },
                          ),
                        ),
                        Tooltip(
                          message: "Delete",
                          child: IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                setState(() {
                                  list.removeAt(index);
                                });
                              }),
                        )
                      ],
                    ),
                  ));
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
