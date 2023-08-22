import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class PlayBackSpeedButton extends StatelessWidget {
  final Responsive responsive;
  final TextStyle textStyle;
  const PlayBackSpeedButton({Key? key, required this.responsive, required this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerScope.controllerOf(context);
    return RxBuilder(
        //observables: [_.fullscreen],
        (context) {
      return TextButton(
        style: TextButton.styleFrom(),
        onPressed: () {
          customDebugPrint("togglePlaybackSpeed");
          _.togglePlaybackSpeed();

          _.controls = true;
        },
        onLongPress: () async {},
        child: Text(
          _.playbackSpeed.toString(),
          style: textStyle,
        ),
      );
    });
  }
}
