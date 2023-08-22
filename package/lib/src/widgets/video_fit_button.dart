import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class VideoFitButton extends StatelessWidget {
  final Responsive responsive;
  const VideoFitButton({Key? key, required this.responsive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerScope.controllerOf(context);
    final Widget customIcon = _.customIcons.videoFit;

    return PlayerButton(
      size: responsive.buttonSize(),
      circle: false,
      customIcon: customIcon,
      onPressed: () {
        customDebugPrint("toggleVideoFit");
        _.toggleVideoFit();
      },
    );
  }
}
