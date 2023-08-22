import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class FullscreenButton extends StatelessWidget {
  final double size;
  const FullscreenButton({Key? key, this.size = 30}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerScope.controllerOf(context);
    return RxBuilder(
      //observables: [_.fullscreen],
      (__) {
        Widget customIcon = _.customIcons.minimize;

        if (!_.fullscreen.value) customIcon = _.customIcons.fullscreen;
        return PlayerButton(
          size: size,
          circle: false,
          customIcon: customIcon,
          onPressed: () {
            _.toggleFullScreen(context);
          },
        );
      },
    );
  }
}
