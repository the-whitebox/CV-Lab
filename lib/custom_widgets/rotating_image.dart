import 'package:flutter/material.dart';

class RotatingImage extends StatefulWidget {
  final double width;
  final double height;

  const RotatingImage({Key? key, this.width = 70.0, this.height = 70.0})
      : super(key: key);

  @override
  RotatingImageState createState() => RotatingImageState();
}

class RotatingImageState extends State<RotatingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _controller,
        child: Image.asset(
          'assets/images/bone.png',
          width: widget.width,
          height: widget.height,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
