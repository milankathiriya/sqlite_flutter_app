import 'package:flutter/material.dart';
import 'helpers/db_helper.dart';
import 'models/student_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> _insertFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  String name = "";
  int age = 0;

  @override
  void initState() {
    super.initState();
    dbh.getAllStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLite App"),
        centerTitle: true,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: openInsertForm,
      ),
    );
  }

  openInsertForm() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text("Insert Data")),
            content: Form(
              key: _insertFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    validator: (val) {
                      if (val!.isEmpty || val == " " || val == "") {
                        return "Enter your name first...";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        name = val!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Enter name",
                    ),
                  ),
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val!.isEmpty ||
                          val == " " ||
                          val == "" ||
                          val.length == 0) {
                        return "Enter your age first...";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        age = int.parse(val!);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Age",
                      hintText: "Enter age",
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                child: Text("Insert"),
                onPressed: validateAndInsertData,
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  nameController.clear();
                  ageController.clear();
                },
                child: Text("Cancel"),
              ),
            ],
          );
        });
  }

  validateAndInsertData() async {
    if (_insertFormKey.currentState!.validate()) {
      _insertFormKey.currentState!.save();

      // TODO: insert into DB
      Student s = Student(
        age: int.parse(ageController.text),
        name: nameController.text,
      );
      int insertedId = await dbh.insertData(s);

      Navigator.of(context).pop();
      nameController.clear();
      ageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data inserted of id: $insertedId"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid Form"),
        ),
      );
      Navigator.of(context).pop();
      nameController.clear();
      ageController.clear();
    }
  }
}
