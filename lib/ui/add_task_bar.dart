import 'package:flutter/material.dart';
import 'package:flutterdiaryapp/Controllers/task_controller.dart';
import 'package:flutterdiaryapp/ui/theme.dart';
import 'package:flutterdiaryapp/ui/widgets/button.dart';
import 'package:flutterdiaryapp/ui/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';


class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> with SingleTickerProviderStateMixin {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  int _selectedColor=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body:Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
             Text(
               "Add Note",
               style: headingStyle,
             ),
              MyInputField(title: "Title", hint: "Enter your title", controller: _titleController,),
              MyInputField(title: "Note", hint: "Write your thoughts", controller: _noteController,),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                icon: Icon(Icons.calendar_today_outlined,
                color: Colors.grey),
                onPressed: () {
                  _getDateFromUser();
                },

              )
              ),
              SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 _colorPallete(),
                  MyButton(label: "   Create Diary", onTap: ()=>_validateDate())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateDate(){
    if(_titleController.text.isNotEmpty&&_noteController.text.isNotEmpty){
     _addTaskToDb();
     Get.back();
    }else if(_titleController.text.isEmpty ||_noteController.text.isEmpty){
      Get.snackbar("Required", "All fields are required!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: pinkClr,
      icon: Icon(Icons.warning_amber_rounded,
      color:Colors.red)
      );
    }
  }

_addTaskToDb() async {
    int value = await _taskController.addTask(
        task:Task(
          note: _noteController.text,
          title: _titleController.text,
          date: DateFormat.yMd().format(_selectedDate),
          color: _selectedColor,
          isCompleted: 0,
        )
    );
    print("My id is "+"$value");
}


  _colorPallete(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color",
          style: titleStyle,
        ),
        SizedBox(height: 8.0,),
        Wrap(
          children: List<Widget>.generate(
              3,
                  (int index){
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedColor=index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: index==0?primaryClr:index==1?yellowClr:pinkClr,
                      child: _selectedColor==index?Icon(Icons.done,
                        color: Colors.white,
                        size: 16,
                      ):Container(),
                    ),
                  ),
                );
              }
          ),
        )

      ],

    );
  }


  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
            Get.back();
        },
        child: Icon(Icons.arrow_back_ios,
            size: 20,
            color: Get.isDarkMode ? Colors.white:Colors.black
        ),
      ),
      actions: [
        Icon(Icons.person, size: 20,),
        SizedBox(width: 20,),
      ],
    );
  }


  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context, initialDate:
        DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2050)
    );

    if(_pickerDate!=null){
      setState(() {
        _selectedDate = _pickerDate;
      });
    }else{
      print("Fuck you for that silly mistake");
    }
  }
}
