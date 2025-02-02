import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  Function onPressed;
  String text;
  Color foregroundColor;
  Color backgroundColor;
  LoginButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.foregroundColor = Colors.white,
      this.backgroundColor = const Color.fromARGB(255, 250, 199, 16)});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: BorderSide(color: Colors.grey.withOpacity(0.4)),
        maximumSize: const Size(400, 55),
        fixedSize: Size(MediaQuery.sizeOf(context).width - 100, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: foregroundColor, fontWeight: FontWeight.w600)),
    );
  }
}
