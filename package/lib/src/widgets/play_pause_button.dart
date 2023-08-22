import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class PlayPauseButton extends StatelessWidget {
  final double size;
  const PlayPauseButton({Key? key, this.size = 40}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerScope.controllerOf(context);
    return RxBuilder(
      //observables: [
      //  _.playerStatus.status,
      //  _.buffered,
      //  _.isBuffering,
      //  _.position
      //],
      (__) {
        // if (_.isBuffering.value) {

        //   return PlayerButton(
        //     onPressed: _.pause,
        //     customIcon: Container(
        //         width: size,
        //         height: size,
        //         padding: EdgeInsets.all(size * 0.25),
        //         child: _.loadingWidget!),
        //   );
        // }

        Widget customIcon = _.customIcons.repeat;
        if (_.playerStatus.playing) {
          customIcon = _.customIcons.pause;
        } else if (_.playerStatus.paused) {
          customIcon = _.customIcons.play;
        }
        return PlayerButton(
          onPressed: () {
            if (_.playerStatus.playing) {
              _.pause();
            } else if (_.playerStatus.paused) {
              _.play(hideControls: false);
            } else {
              _.play(repeat: true, hideControls: false);
            }
          },
          size: size,
          customIcon: customIcon,
        );
      },
    );
  }
}
