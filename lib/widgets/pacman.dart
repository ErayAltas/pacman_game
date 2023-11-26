import 'package:flutter/widgets.dart';

class Pacman extends StatelessWidget {
  const Pacman({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset('assets/images/pacman.png'),
    );
  }
}

class Ghost extends StatelessWidget {
  const Ghost({super.key, required this.ghostType});
  final int ghostType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Image.asset('assets/images/ghost$ghostType.png'),
    );
  }
}

class MyPath extends StatelessWidget {
  final Color? innerColor;
  final Color? outerColor;
  final Widget? child;

  const MyPath({super.key, this.innerColor, this.outerColor, this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(12),
          color: outerColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: innerColor,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class MyPixel extends StatelessWidget {
  final Color? innerColor;
  final Color? outerColor;
  final Widget? child;

  const MyPixel({super.key, this.innerColor, this.outerColor, this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(4),
          color: outerColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: innerColor,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
