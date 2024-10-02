import 'package:flutter/material.dart';
import 'package:planner/app_theme.dart';

class PlannerTextField extends StatelessWidget {
  const PlannerTextField(
      {super.key,
      required this.controller,
      this.focusNode,
      required this.isMaxLinesNull,
      required this.isAutoFocus,
      required this.hintText,
      this.fillColor,
      this.onSubmitted});

  final dynamic controller;
  final FocusNode? focusNode;
  final bool isMaxLinesNull;
  final bool isAutoFocus;
  final String hintText;
  final Color? fillColor;
  final void Function(String value)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.done,
      maxLines: isMaxLinesNull ? null : 1,
      autofocus: isAutoFocus,
      cursorColor: AppTheme.darkTeal,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        filled: true,
        fillColor: fillColor ?? AppTheme.cardTeal,
        hintText: hintText,
        hintStyle: TextStyle(color: AppTheme.darkTeal, fontSize: 16),
        border: InputBorder.none,
      ),
      onSubmitted: onSubmitted,
    );
  }
}
