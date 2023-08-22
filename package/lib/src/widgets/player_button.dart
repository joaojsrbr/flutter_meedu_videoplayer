import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class PlayerButton extends StatelessWidget {
  final double size;

  final VoidCallback onPressed;
  final bool circle;
  final Widget customIcon;

  const PlayerButton({
    Key? key,
    this.size = 40,
    required this.onPressed,
    this.circle = true,
    required this.customIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(minimumSize: const Size(20, 20)),
      //padding: EdgeInsets.zero,
      //minSize: 20,
      // iconSize: size,
      onPressed: () {
        onPressed();
        MeeduPlayerScope.controllerOf(context).controls = true;
      },
      icon: customIcon,
    );
  }
}
