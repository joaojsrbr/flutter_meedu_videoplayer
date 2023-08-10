import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

typedef CustomBuildPage = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  MeeduVideoPlayer meeduVideoPlayer,
);

class PlayerViewRoute<T> extends PageRoute<T> {
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
    super.allowSnapshotting,
    super.fullscreenDialog,
  })  : _customBuildPage = null,
        _customTransitionDuration = null,
        _closedCaptionDistanceFromBottom = null;

  PlayerViewRoute.custom({
    super.settings,
    required this.meeduPlayerController,
    required this.backgroundColor,
    required this.disposePlayer,
    super.allowSnapshotting,
    super.fullscreenDialog,
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
  String? get barrierLabel => 'meedu_dismiss';

  @override
  bool didPop(T? result) {
    if (disposePlayer) meeduPlayerController.customDebugPrint("disposed");
    Future.wait([
      if (disposePlayer) meeduPlayerController.videoPlayerClosed() else meeduPlayerController.onFullscreenClose(),
    ]).whenComplete(() => meeduPlayerController.launchedAsFullScreen = false);

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

  late final _meeduVideoPlayer = MeeduVideoPlayer.route(
    key: _meeduRouteKey,
    closedCaptionDistanceFromBottom: _closedCaptionDistanceFromBottom ?? 40,
    backgroundColor: backgroundColor,
    controller: meeduPlayerController,
  );

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    if (_customBuildPage != null) {
      return Material(
        child: _customBuildPage!.call(
          context,
          animation,
          secondaryAnimation,
          _meeduVideoPlayer,
        ),
      );
    }

    return Material(
      child: _meeduVideoPlayer,
    );
  }

  @override
  Duration get transitionDuration => _customTransitionDuration ?? const Duration(milliseconds: 300);
}
