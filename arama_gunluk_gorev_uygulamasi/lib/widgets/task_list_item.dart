import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../model/task_model.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

var titleTextController = TextEditingController();

class _TaskItemState extends State<TaskItem> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    titleTextController.text = widget.task.task;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 10)
          ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            setState(() {
              widget.task.taskCompleted = !widget.task.taskCompleted;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: widget.task.taskCompleted
                    ? Colors.green.shade200
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 0.8)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: widget.task.taskCompleted
            ? Text(
                widget.task.task,
                style: GoogleFonts.openSans(
                    fontSize: 20,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough),
              )
            : TextField(
                textInputAction: TextInputAction.done,
                minLines: 1,
                maxLines: null,
                onSubmitted: (value) {
                  if (value.length >= 3) {
                    widget.task.task = value;
                  }
                },
                controller: titleTextController,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.date),
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }
}
