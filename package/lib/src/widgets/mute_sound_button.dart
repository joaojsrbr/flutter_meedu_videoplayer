import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class MuteSoundButton extends StatelessWidget {
  final Responsive responsive;
  const MuteSoundButton({Key? key, required this.responsive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerScope.controllerOf(context);
    return RxBuilder(
        //observables: [_.mute, _.fullscreen],
        (__) {
      Widget customIcon = _.customIcons.mute;

      if (!_.mute.value) customIcon = _.customIcons.sound;

      return PlayerButton(
        size: responsive.buttonSize(),
        circle: false,
        customIcon: customIcon,
        onPressed: () {
          _.setMute(!_.mute.value);
        },
      );
    });
  }
}
