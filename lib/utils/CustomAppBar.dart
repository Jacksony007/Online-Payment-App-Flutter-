import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final bool centerTitle;
  final List<Widget> actions;
  final double elevation;
  final TextTheme textTheme;

  CustomAppBar({
    required this.title,
    this.backgroundColor = Colors.blue,
    this.centerTitle = true,
    this.actions = const [],
    this.elevation = 4.0,
    this.textTheme = const TextTheme(),
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: backgroundColor,
      centerTitle: centerTitle,
      actions: actions,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
