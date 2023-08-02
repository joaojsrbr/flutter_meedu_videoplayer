import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

typedef CustomBuildPage = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  MeeduVideoPlayer meeduVideoPlayer,
);

class PlayerViewRoute extends PopupRoute<PlayerViewRoute> {
  final MeeduPlayerController meeduPlayerController;
  final bool disposePlayer;
  final Color backgroundColor;
  final CustomBuildPage? _customBuildPage;
  final Duration? _customTransitionDuration;
  final double? _closedCaptionDistanceFromBottom;

  PlayerViewRoute({
    super.settings,
    required this.meeduPlayerController,
    required this.backgroundColor,
    required this.disposePlayer,
  })  : _customBuildPage = null,
        _customTransitionDuration = null,
        _closedCaptionDistanceFromBottom = null;

  PlayerViewRoute.custom({
    super.settings,
    required this.meeduPlayerController,
    required this.backgroundColor,
    required this.disposePlayer,
    double? closedCaptionDistanceFromBottom,
    Duration? transitionDuration,
    required CustomBuildPage customBuildPage,
  })  : _customBuildPage = customBuildPage,
        _closedCaptionDistanceFromBottom = closedCaptionDistanceFromBottom ?? 40,
        _customTransitionDuration = transitionDuration ?? const Duration(milliseconds: 750);

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'video_dismiss';

  @override
  bool didPop(PlayerViewRoute? result) {
    meeduPlayerController.customDebugPrint("disposed");
    if (disposePlayer) {
      meeduPlayerController.videoPlayerClosed();
    } else {
      meeduPlayerController.onFullscreenClose();
    }

    meeduPlayerController.launchedAsFullScreen = false;
    return super.didPop(result);
  }

  @override
  Future<RoutePopDisposition> willPop() async {
    final context = _meeduRouteKey.currentContext;
    if (meeduPlayerController.isInPipMode.value && context != null) {
      meeduPlayerController.closePip(context);
    }
    return super.willPop();
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  static final GlobalKey _meeduRouteKey = GlobalKey();

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final meeduVideoPlayer = MeeduVideoPlayer.route(
      key: _meeduRouteKey,
      closedCaptionDistanceFromBottom: _closedCaptionDistanceFromBottom ?? 40,
      backgroundColor: backgroundColor,
      controller: meeduPlayerController,
    );

    if (_customBuildPage != null) {
      return _customBuildPage!.call(context, animation, secondaryAnimation, meeduVideoPlayer);
    }
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final Animation<double> curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubicEmphasized,
          reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: Material(
            color: backgroundColor,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                meeduVideoPlayer,
                if (meeduPlayerController.stackWidget != null) meeduPlayerController.stackWidget!,
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Duration get transitionDuration => _customTransitionDuration ?? const Duration(milliseconds: 750);
}
