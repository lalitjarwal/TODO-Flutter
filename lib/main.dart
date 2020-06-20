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
  final _linearGradient = LinearGradient(
      colors: [Color(0xfffc00ff), Color(0xff00dbde)], stops: [0.0, 0.7]);
  final _formkey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          tooltip: 'Add item to ToDo list',
          backgroundColor: Color(0xfffc00ff),
          icon: Icon(Icons.add),
          onPressed: () {
            testAlert(context);
          },
          label: Text('Add')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        flexibleSpace:
            Container(decoration: BoxDecoration(gradient: _linearGradient)),
        leading: Icon(Icons.work,),
        elevation: 0.0,
        title: Text('What To Do!'),
      ),
      body: Container(
          decoration: BoxDecoration(gradient: _linearGradient), child: Home()),
    );
  }

  void testAlert(BuildContext context) {
    var alert = AlertDialog(
    title: Text("Today\'s List"),
    content: SizedBox(
        child: Form(
      key: _formkey,
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Entry can\'t be empty!';
          }
          return null;
        },
        cursorColor: Colors.deepPurple,
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'TODO',
          hintText: 'What to do today.',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          prefixIcon: Icon(
            Icons.work,
          ),
        ),
      ),
    )),
    actions: [
      FlatButton(
          onPressed: () {
            setState(() {
              if (_formkey.currentState.validate()) {
                _HomeState.list.add(_controller.text);
                _HomeState._color.add(Colors.blue);
                _HomeState._current.add(true);
                _HomeState._style.add(null);
                _controller.clear();
                Navigator.of(context).pop();
              }
            });
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
  static String formatted = formatter.format(now);
  static List _color = [];
  static List _current = [];
  static List list = [];
  static List _style = [];
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
                color: Color(0xffececec)),
            child: Padding(
              padding: EdgeInsets.only(
                top: 30.0,
                left: 10.0,
                right: 10.0,
              ),
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffececec),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(10, 10),
                                color: Colors.black38,
                                blurRadius: 20),
                            BoxShadow(
                                offset: Offset(-10, -10),
                                color: Colors.white.withOpacity(0.85),
                                blurRadius: 20)
                          ]),
                      child: ListTile(
                        leading: Icon(
                          Icons.arrow_right,
                        ),
                        title: Text(
                          list[index],
                          style: _style[index],
                        ),
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
                                        : Colors.blue;
                                    _style[index] = _current[index]
                                        ? TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough)
                                        : null;
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
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
