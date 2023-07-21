import 'package:arama_gunluk_gorev_uygulamasi/data/local_storage.dart';
import 'package:arama_gunluk_gorev_uygulamasi/main.dart';
import 'package:arama_gunluk_gorev_uygulamasi/model/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/task_list_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
late LocalStorage _localStorage;
late List<Task> _allTasks;

class _HomeState extends State<Home> {
  @override
  initState()  {
    // TODO: implement initState
    super.initState();
    _localStorage=locator<LocalStorage>();
    _allTasks = <Task>[];
    _getFromDbAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                _showAddTaskBottomSheet();
              },
              icon: Icon(Icons.add))
        ],
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () => _showAddTaskBottomSheet(),
          child: Text(
            "Günlük Görevler",
            style: GoogleFonts.openSans(
                color: Colors.black, fontWeight: FontWeight.w700, fontSize: 30),
          ),
        ),
      ),
      body: Container(
          color: Colors.white,
          child: _allTasks.isEmpty
              ? Center(
                  child: Text("You dont have any Task.."),
                )
              : Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 14.h),
                  child: ListView.builder(
                      itemCount: _allTasks.length,
                      itemBuilder: (context, index) {
                        var currentValue = _allTasks[index];
                        return Dismissible(
                          background: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text("Bu görev silindi.")
                              ]),
                          onDismissed: (direction) {
                            _allTasks.removeAt(index);
                            _localStorage.deleteTask(task: currentValue);
                            setState(() { });
                          },
                          key: Key(currentValue.id),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0.w),
                            child: TaskItem(
                              task: currentValue,
                            ),
                          ),
                        );
                      }),
                )),
    );
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              onSubmitted: (value) {
                if (value.length < 3) {
                  Navigator.pop(context);
                } else {
                  DatePicker.showTimePicker(context,
                      showTitleActions: true,
                      showSecondsColumn: false, onConfirm: (time) async{
                    var yeniGorev = Task.create(task: value, date: time);
                    _allTasks.add(yeniGorev);
                    await _localStorage.addTask(task: yeniGorev);
                    Navigator.pop(context);
                    setState(() {});
                  });

                  print(value);
                }
              },
              style: GoogleFonts.openSans(fontSize: 14.h),
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Görev nedir.."),
            ),
          ),
        );
      },
    );
  }

  void _getFromDbAllTasks() async{
    _allTasks=await _localStorage.getAllTasks();
    setState(() {});
  }
}
