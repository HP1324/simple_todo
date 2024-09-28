import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/app_theme.dart';
import 'package:planner/globals.dart';
import 'package:planner/models/task.dart';
import 'package:get/get.dart';

class TaskEditorPage extends StatefulWidget {
  const TaskEditorPage({super.key, this.task, required this.editMode});
  final Task? task;
  final EditMode editMode;

  @override
  State<TaskEditorPage> createState() => _TaskEditorPageState();
}

class _TaskEditorPageState extends State<TaskEditorPage> {
  Text _setTitle() => widget.editMode == EditMode.newTask
      ? const Text('New Task')
      : const Text('Edit Task');

  String selectedCategory = 'Personal';
  bool isDropDown = true;
  var icon = Icons.add;
  final categoryTextFieldFocusNode = FocusNode();
  final titleTextFieldFocusNode = FocusNode();
  var categoryController = TextEditingController();
  @override
  void initState() {
    categoryTextFieldFocusNode.attach(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleTextFieldFocusNode.dispose();
    categoryTextFieldFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = AppController.of(context);
  List<String> categories = provider.categories;
    return Scaffold(
        appBar: AppBar(
          title: _setTitle(),
          titleSpacing: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  focusNode: titleTextFieldFocusNode,
                  controller: provider.titleController,
                  textInputAction: TextInputAction.done,
                  cursorColor: AppTheme.darkTeal,
                  autofocus: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                    filled: true,
                    fillColor: AppTheme.cardTeal,
                    hintText: widget.editMode == EditMode.newTask
                        ? 'What’s on your to-do list?'
                        : 'What needs changing?',
                    hintStyle:
                        TextStyle(color: AppTheme.darkTeal, fontSize: 16),
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Select a category',
                  style: TextStyle(
                      color: AppTheme.darkTeal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        firstChild: DropdownMenu(
                          initialSelection: widget.task != null
                              ? widget.task!.category
                              : selectedCategory,
                          width: MediaQuery.sizeOf(context).width * 0.75,
                          dropdownMenuEntries: categories
                              .map((category) => DropdownMenuEntry(
                                  value: category, label: category))
                              .toList(),
                          onSelected: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                            print(selectedCategory);
                          },
                        ),
                        secondChild: TextField(
                          focusNode: categoryTextFieldFocusNode,
                          controller: categoryController,
                          decoration: const InputDecoration(
                            hintText: 'Add new category here',
                            hintStyle: TextStyle(
                                color: AppTheme.darkTeal, fontSize: 16),
                            filled: true,
                            fillColor: AppTheme.cardTeal,
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                categories.add(value);
                                selectedCategory = value;
                                categoryController.clear();
                                icon = Iconsax.add;
                                isDropDown = true;
                              }
                            });

                          },
                        ),
                        crossFadeState: isDropDown
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (isDropDown) {
                            icon = Iconsax.minus;
                            isDropDown = false;
                            titleTextFieldFocusNode.unfocus();

                            ///Had to use future.delayed because it was trying to get focus before the [TextField] exists. That is because [TextField] comes after clicking on the button, and before it comes, the requestFocus is run and it can't find TextField, this error was thrown: FocusNode#ce5d6(context: Focus, NOT FOCUSABLE), this happens in microseconds,so even delaying the requestFocus by 1 milliseconds, it works perfect, because textfield is getting built in less than a millisecond.
                            Future.delayed(
                                Duration(milliseconds: 100),
                                () =>
                                    categoryTextFieldFocusNode.requestFocus());
                          } else {
                            icon = Iconsax.add;
                            isDropDown = true;
                            categoryTextFieldFocusNode.unfocus();
                          }
                        });
                      },
                      child: Icon(
                        icon,
                        size: 50,
                        color: AppTheme.darkTeal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.065,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.tealShade500,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: Text(
                        'Add reminder',
                        style: TextStyle(
                            color: AppTheme.tealShade50, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.065,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppTheme.tealShade600,
                      borderRadius: BorderRadius.circular(7)),
                  child: InkWell(
                    onTap: () async {
                      if(!provider.categories.contains(categoryController.text) && categoryController.text.isNotEmpty){
                        provider.categories.add(categoryController.text);
                      }
                      if (widget.editMode == EditMode.newTask) {
                        debugPrint(' this is selected : $selectedCategory');
                        Task task = Task(
                            title: provider.titleController.text,
                            category: selectedCategory,
                            isDone: false);
                        if (await provider.addTask(task)) {
                          Get.back();
                          showSnackBar(context, content: 'Task added');
                          provider.titleController.clear();
                        }
                      }
                      if (widget.editMode == EditMode.editTask) {
                        selectedCategory = categoryController.text;
                        if(provider.titleController.text.isNotEmpty) {
                          widget.task!.title = provider.titleController.text;
                        }
                        widget.task!.category = selectedCategory;
                        if (await provider.editTask(
                          task: widget.task!,
                        )) {
                          Get.back();
                          showSnackBar(context, content: 'Task edited');
                          provider.titleController.clear();
                        }
                      }
                    },
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: AppTheme.tealShade50, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
