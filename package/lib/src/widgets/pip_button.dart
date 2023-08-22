import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class PipButton extends StatelessWidget {
  final Responsive responsive;
  const PipButton({Key? key, required this.responsive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerScope.controllerOf(context);
    return RxBuilder(
        // observables: [
        //   _.pipAvailable,
        //   _.fullscreen,
        // ],
        (__) {
      if (!_.pipAvailable.value) return const SizedBox.shrink();
      Widget customIcon = _.customIcons.pip;
      if (_.isInPipMode.value) customIcon = _.customIcons.exitPip;
      return PlayerButton(
        size: responsive.buttonSize(),
        circle: false,
        customIcon: customIcon,
        onPressed: () => _.isInPipMode.value ? _.closePip(context) : _.enterPip(context),
      );
    });
  }
}
