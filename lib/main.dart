import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Todo List Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<TodoListData> todoList = [];
  List<TodoListData> todoAllList = [];
  TextEditingController enterDataController = new TextEditingController();

  String error;
  bool isAll = true;

  @override
  Widget build(BuildContext context) {

    void _addListItem() {
      setState(() {
        if(enterDataController.text.isNotEmpty) {
          var json = {
            "text": "${enterDataController.text}",
            "status": "assign"
          };
          TodoListData data = new TodoListData.fromJson(json);
          todoAllList.add(data);
          isAll = true;
          error = null;
          enterDataController.clear();
        }else {
          error = "Please enter data";
        }
      });
    }

    void _progress() {
      setState(() {
        todoList.clear();
        for(int i = 0; i < todoAllList.length; i++) {
          if(todoAllList[i].status == "progress") {
            todoList.add(todoAllList[i]);
          }
        }
        isAll = false;
      });
    }

    void _complete() {
      setState(() {
        todoList.clear();
        for(int i = 0; i < todoAllList.length; i++) {
          if(todoAllList[i].status == "completed") {
            todoList.add(todoAllList[i]);
          }
        }
        isAll = false;
      });
    }

    void _all() {
      setState(() {
        todoList.clear();
        isAll = true;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: enterDataController,
                  decoration: InputDecoration(
                    hintText: "Enter data",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        style: BorderStyle.solid,
                      ),
                    ),
                    errorText: error,
                    suffixIcon: IconButton(icon: Icon(Icons.send), onPressed: _addListItem)
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: isAll ? todoAllList.length : todoList.length,
                  itemBuilder: (context, index) {

                    Color status = Colors.black;
                    String statusVal = isAll ? todoAllList[index].status : todoList[index].status;
                    if(statusVal == "assign") {
                      status = Colors.black;
                    } else if(statusVal == "progress") {
                      status = Colors.blue;
                    } else if(statusVal == "completed") {
                      status = Colors.green;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Column(
                            children: [
                              Text(isAll ? todoAllList[index].text : todoList[index].text + " - " + (isAll ? todoAllList[index].status : todoList[index].status), style: TextStyle(color: status, fontSize: 20),),
                              SizedBox(height: 10,),
                              isAll ? Row(
                                children: [
                                  IconButton(icon: Icon(Icons.assignment_turned_in, color: Colors.black,), onPressed: () {
                                    setState(() {
                                      todoAllList[index].status = 'completed';
                                    });
                                  }),
                                  Spacer(),
                                  IconButton(icon: Icon(Icons.access_alarms, color: Colors.black,), onPressed: () {
                                    setState(() {
                                      todoAllList[index].status = 'progress';
                                    });
                                  }),
                                  Spacer(),
                                  IconButton(icon: Icon(Icons.delete, color: Colors.black,), onPressed: () {
                                    setState(() {
                                      todoAllList.removeAt(index);
                                    });
                                  }),
                                ],
                              ) : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _progress,
            tooltip: 'progress filter',
            child: Icon(Icons.access_time_outlined),
          ),
          SizedBox(height: 5,),
          FloatingActionButton(
            onPressed: _complete,
            tooltip: 'complete filter',
            child: Icon(Icons.assignment_turned_in_rounded),
          ),
          SizedBox(height: 5,),
          FloatingActionButton(
            onPressed: _all,
            tooltip: 'all filter',
            child: Icon(Icons.assignment),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class TodoListData {
  TodoListData({
    this.text,
    this.status,
  });

  String text;
  String status;

  factory TodoListData.fromJson(Map<String, dynamic> json) => TodoListData(
    text: json["text"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "status": status,
  };
}