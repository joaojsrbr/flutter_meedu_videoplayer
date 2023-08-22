import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:universal_platform/universal_platform.dart';

class LockButton extends StatelessWidget {
  final Responsive responsive;
  const LockButton({Key? key, required this.responsive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerScope.controllerOf(context);
    return RxBuilder(
        // observables: [
        //   _.lockAvailable,
        // ],
        (__) {
      _.lockedControls.value; // this is the value that the rxbuilder will listen to (for updates)
      if (UniversalPlatform.isDesktopOrWeb) return const SizedBox.shrink();
      Widget customIcon = _.customIcons.lock;
      if (!_.lockedControls.value) customIcon = _.customIcons.unlock;
      return PlayerButton(
        size: responsive.buttonSize(),
        circle: false,
        customIcon: customIcon,
        onPressed: () => _.lockedControls.value ? _.toggleLockScreenMobile() : _.toggleLockScreenMobile(),
      );
    });
  }
}
