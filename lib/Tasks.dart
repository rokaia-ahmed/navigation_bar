import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder:(context,index) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40.0,
                child: Text(
                  '02:00 pm',
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Task Title',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '2 april,2021',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ) ,
        separatorBuilder: (context,index) =>Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Container(
            width: double.infinity,
            height:1.0 ,
            color: Colors.grey[300],
          ),
        ),
        itemCount: 18,
    );
  }
}
