import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showCustomSnackBar(BuildContext context, String message,
    Color foregroundColor, Color backgroundColor, Icon? icon,
    {Function? buttonPressed, String? buttonText}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: icon ?? const SizedBox.shrink(),
          ),
          AutoSizeText(message,
              presetFontSizes: const [14, 15, 16],
              style: GoogleFonts.inter(
                  color: foregroundColor, fontWeight: FontWeight.w600)),
          const Spacer(),
          if (buttonPressed != null && buttonText != null)
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                buttonPressed();
              },
              child: Text(buttonText,
                  style: GoogleFonts.inter(
                      color: foregroundColor, fontWeight: FontWeight.w700)),
            )
        ],
      ),
    ),
  );
}
