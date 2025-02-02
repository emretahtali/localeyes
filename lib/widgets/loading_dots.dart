import 'package:flutter/material.dart';

class LoadingDotsText extends StatefulWidget {
  final String text;
  const LoadingDotsText({required this.text});
  @override
  _LoadingDotsTextState createState() => _LoadingDotsTextState();
}

class _LoadingDotsTextState extends State<LoadingDotsText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {
          _dotCount = (_controller.value * 3).floor();
        });
      });

    _startAnimation();
  }

  void _startAnimation() async {
    while (mounted) {
      await _controller.forward();
      await _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.text),
        ...List.generate(3, (index) {
          return Text(
            index < _dotCount ? '.' : ' ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          );
        }),
      ],
    );
  }
}
