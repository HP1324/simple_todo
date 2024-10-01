import 'package:flutter/material.dart';
import 'package:planner/app_controller.dart';
import 'package:planner/app_theme.dart';
import 'package:planner/globals.dart';
import 'package:planner/main.dart';
import 'package:planner/models/category.dart';
import 'package:planner/models/task.dart';
import 'package:planner/providers/category_provider.dart';
import 'package:planner/widgets/planner_text_field.dart';
import 'package:provider/provider.dart';
//ignore: must_be_immutable
class TaskEditorPage extends StatelessWidget {
  TaskEditorPage({super.key, this.task,this.editMode});
  Task? task;
   bool? editMode;

  Widget build(BuildContext context) {
    var provider = AppController.of(context);
    var categories = context.watch<CategoryProvider>().categories;
    return Scaffold(
        appBar: AppBar(
          title: editMode!
              ? const Text('Edit Task')
              : const Text('New Task'),
          titleSpacing: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                PlannerTextField(
                  controller: provider.titleController,
                  isMaxLinesNull: true,
                  isAutoFocus: true,
                  hintText: 'What\'s on your to-do list?',
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownMenu(
                        hintText: 'Select a category',
                        initialSelection: categories,
                        width: MediaQuery.sizeOf(context).width * 0.85,
                        dropdownMenuEntries: categories.map((e){
                            var categoryObj = CategoryModel.fromJson(e);
                            return DropdownMenuEntry(value: categoryObj, label: categoryObj.categoryName);
                        }
                        ).toList(),
                      ),
                    ),
                    InkWell(
                      child: Icon(
                        Icons.add,
                        size: 50,
                      ),
                      onTap:(){

                      }
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.065,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.tealShade500,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: const Center(
                      child: Text(
                        'Add reminder',
                        style: TextStyle(
                            color: AppTheme.tealShade50, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.065,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppTheme.tealShade600,
                      borderRadius: BorderRadius.circular(7)),
                  child: InkWell(
                    onTap: () {},
                    child: const Center(
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
