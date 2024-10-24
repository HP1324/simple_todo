import 'package:flutter/material.dart';
import 'package:planner/app_theme.dart';
import 'package:planner/globals.dart';
import 'package:planner/providers/category_provider.dart';
import 'package:planner/widgets/planner_text_field.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class CategoryDialog extends StatelessWidget {
  CategoryDialog({super.key});
  var categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 250,
          width: MediaQuery.sizeOf(context).width * 0.8,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppTheme.tealShade100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlannerTextField(
                controller: categoryController,
                isMaxLinesNull: false,
                isAutoFocus: true,
                hintText: 'Add new category here',
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      categoryController.clear();
                      Navigator.pop(context);
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Container(
                      width: 90,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppTheme.tealShade100,
                        border:
                            Border.all(color: AppTheme.darkTeal, width: 0.5),
                      ),
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style:
                              TextStyle(color: AppTheme.darkTeal, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      var scaffoldMessenger = ScaffoldMessenger.of(context);
                      var navigator = Navigator.of(context);
                      context.read<CategoryProvider>();
                      if (await context
                          .read<CategoryProvider>()
                          .addCategory(categoryName: categoryController.text)) {
                        navigator.pop();
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          showSnackBar(scaffoldMessenger,
                              content: 'Category added');
                        });
                      } else {}
                    },
                    child: Container(
                      width: 90,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppTheme.darkTeal,
                      ),
                      child: const Center(
                        child: Text(
                          'Save',
                          style:
                              TextStyle(color: Color(0xffffffff), fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
