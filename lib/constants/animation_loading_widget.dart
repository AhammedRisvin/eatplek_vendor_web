import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'colors.dart';

class AnimationLoadingWidget extends StatelessWidget {
  const AnimationLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: AppColor.darkBlue,
            size: 50,
          ),
        ),
      ],
    );
  }
}
