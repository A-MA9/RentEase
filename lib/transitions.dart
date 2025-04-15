import 'package:flutter/material.dart';

class SharedAxisTransition extends PageRouteBuilder {
  final Widget page;
  final SharedAxisTransitionType type;

  SharedAxisTransition({
    required this.page,
    this.type = SharedAxisTransitionType.horizontal,
  }) : super(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

enum SharedAxisTransitionType {
  horizontal,
  vertical,
  scaled,
} 