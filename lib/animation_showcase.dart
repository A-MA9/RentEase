import 'package:flutter/material.dart';
import 'utils/loading_animations.dart';

class AnimationShowcasePage extends StatelessWidget {
  const AnimationShowcasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingAnimations.animationShowcase();
  }
}

// Use this route to see all available animations:
// Navigator.push(context, MaterialPageRoute(builder: (context) => AnimationShowcasePage())); 