import 'package:flutter/material.dart';

class Round_Button extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const Round_Button({super.key,
    required this.title,
    required this.onTap,
    required this.loading
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(27),
        ),
        child: Center(
          child: loading
          ? CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          )
          : Text(title, style: TextStyle(
             color: Colors.white,
             fontWeight: FontWeight.bold,
             fontSize: 22
          ),),
        ),
      ),
    );
  }
}
