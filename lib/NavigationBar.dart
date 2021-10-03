import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigation_bar/Archived.dart';
import 'package:navigation_bar/Done.dart';
import 'package:navigation_bar/Tasks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';


class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}
class _NavigationBarState extends State<NavigationBar> {
  int currentIndex= 0;
  List<Widget> screens =[
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  List<String> titles =[
    'Tasks',
    'Done',
    'Archived'
  ];
 late Database database;
 var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
 bool isBottomSheet = false ;
 IconData icon = Icons.add;
 var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  List<Map> tasks = [];
  @override
  void initState() {
    super.initState();
    createDatabase();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:scaffoldKey ,
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
        ),
      ),
      body: screens[currentIndex],
      floatingActionButton:FloatingActionButton(
        onPressed: ()
        {
          if (isBottomSheet){
            if(formKey.currentState!.validate()){
              insertDatabase(
                title:titleController.text ,
                date: dateController.text,
                time: timeController.text,
              ).then((value){
                Navigator.pop(context);
                isBottomSheet =false;
                setState(() {
                  icon =Icons.edit;
                });
              });

            }

          }else{
            scaffoldKey.currentState!.showBottomSheet(
                  (context)=>Container(
                    padding: EdgeInsets.all(20.0),
                    color: Colors.grey[100],
                    child: Form(
                      key:formKey ,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller:titleController,
                            validator: ( value){
                              if (value!.isEmpty){
                                return'title must be not empty';
                              }
                              return '';
                            },
                            keyboardAppearance:Brightness.dark,
                            decoration:InputDecoration(
                              icon: Icon(Icons.title),
                            ) ,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            controller:timeController,
                            validator: ( value){
                              if (value!.isEmpty){
                                return'time must be not empty';
                              }
                              return '';
                            },
                            onTap:(){
                              showTimePicker(context: context,
                                  initialTime: TimeOfDay.now() ,
                              ).then((value){
                                timeController.text =value.toString();
                                print(value.toString());
                              }
                              );
                            } ,
                            keyboardAppearance:Brightness.dark,
                            decoration:InputDecoration(
                               icon: Icon(Icons.watch_later_outlined),
                            ) ,

                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            controller:dateController,
                            validator: ( value){
                              if (value!.isEmpty){
                                return'date must be not empty';
                              }
                              return '';
                            },
                            onTap:(){
                             showDatePicker(context: context,
                                 initialDate: DateTime.now(),
                                 firstDate:DateTime.now(),
                                 lastDate: DateTime.parse('2021-08-06'),
                             ).then((value){
                              // print(value.toString());
                               dateController.text = value.toString();
                             });
                            } ,
                            keyboardAppearance:Brightness.dark,
                            decoration:InputDecoration(
                              icon: Icon(Icons.calendar_today),
                            ) ,

                          ),
                        ],
                      ),
                    ),
                  ),
            );
            isBottomSheet = true;
            setState(() {
              icon =Icons.add;
            });
          }

        },
        child: Icon(icon),
      ) ,
      bottomNavigationBar:
      BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index){
       setState(() {
         currentIndex = index;
       });
        },
        items: [
          BottomNavigationBarItem(icon:
          Icon(
            Icons.menu,
          ),
            label: 'tasks',
          ),
          BottomNavigationBarItem(icon:
          Icon(
            Icons.check_circle,
          ),
            label: 'Done',
          ),
          BottomNavigationBarItem(icon:
          Icon(
            Icons.archive_outlined,
          ),
            label: 'archived',
          ),
        ],
      ),
    );
  }

 Future <String>getName() async
  {
    return 'Rokaia Ahmed';
  }

   void createDatabase() async
   {
     database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database,version) async
      {
        print('database create');
        await database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)');
        print('create table');
      },
      onOpen: (database){
        print('database opened');
        getDataFormDatabase (database).then((value){
          tasks = value;
          print (tasks);
        });
      },
    );
   }

  Future insertDatabase({
  required String title,
  required String time,
  required String date,

}) async {
   return await database.transaction((txn)
    {
      return txn.rawInsert
        ('INSERT INTO tasks (title,date,time,status) VALUES("$title","$time","$date","new")').then((value)
      {
        print('$value insert successfully');
      }).catchError((error){
        print('error when inserting ${error.toString()}');
      });

    }
    );
   }

   Future<List<Map>> getDataFormDatabase (database) async
   {
  return await database.rawQuery('SELECT * FROM tasks');
   }

}
