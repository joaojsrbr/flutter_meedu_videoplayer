import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/controls_container.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/primary/primary_list_player_controls.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/primary/primary_player_controls.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/styles/secondary/secondary_player_controls.dart';

import '../helpers/shortcuts/intent_action_map.dart';

/// An ActionDispatcher that logs all the actions that it invokes.
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    // customDebugPrint('Action invoked: $action($intent) from $context');
    super.invokeAction(action, intent, context);

    return null;
  }
}

typedef CustomBuilder = Widget Function(BuildContext context, MeeduPlayerController controller, Responsive responsive);
typedef CustomIconsBuilder = CustomIcons Function(Responsive responsive);
typedef CaptionViewBuilder = Widget Function(BuildContext context, MeeduPlayerController controller, Responsive responsive, String text);
typedef VideoOverlayBuilder = Widget Function(BuildContext context, MeeduPlayerController controller, Responsive responsive);

class MeeduVideoPlayer extends StatefulWidget {
  final MeeduPlayerController controller;

  final FocusNode? focusNode;

  final CustomBuilder? header;

  final CustomBuilder? bottomRight;

  final CustomIconsBuilder? customIcons;

  ///[customControls] this only needed when controlsStyle is [ControlsStyle.custom]
  final CustomBuilder? customControls;

  ///[customCaptionView] when a custom view for the captions is needed
  final CaptionViewBuilder? customCaptionView;

  /// The distance from the bottom of the screen to the closed captions text.
  ///
  /// This value represents the vertical position of the closed captions display
  /// from the bottom of the screen. It is measured in logical pixels and can be
  /// used to adjust the positioning of the closed captions within the video player
  /// UI. A higher value will move the closed captions higher on the screen, while
  /// a lower value will move them closer to the bottom.
  ///
  /// By adjusting this distance, you can ensure that the closed captions are
  /// displayed at an optimal position that doesn't obstruct other important
  /// elements of the video player interface.
  final double closedCaptionDistanceFromBottom;

  ///[backgroundColor] video background color
  final Color backgroundColor;

  final bool _isRoute;

  ///[videoOverlay] can be used to wrap the player in any widget, to apply custom gestures, or apply custom watermarks
  final VideoOverlayBuilder? videoOverlay;

  const MeeduVideoPlayer({
    super.key,
    required this.controller,
    this.header,
    this.videoOverlay,
    this.focusNode,
    this.bottomRight,
    this.customIcons,
    this.customControls,
    this.customCaptionView,
    this.closedCaptionDistanceFromBottom = 40,
    this.backgroundColor = Colors.black,
  }) : _isRoute = false;

  const MeeduVideoPlayer.route({
    super.key,
    required this.controller,
    this.closedCaptionDistanceFromBottom = 40,
    this.backgroundColor = Colors.black,
  })  : _isRoute = true,
        focusNode = null,
        header = null,
        videoOverlay = null,
        customCaptionView = null,
        customControls = null,
        bottomRight = null,
        customIcons = null;

  @override
  State<MeeduVideoPlayer> createState() => _MeeduVideoPlayerState();
}

class _MeeduVideoPlayerState extends State<MeeduVideoPlayer> {
  final GlobalKey _layoutKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (!widget._isRoute) _onInit();
  }

  @override
  void didUpdateWidget(covariant MeeduVideoPlayer oldWidget) {
    if (!widget._isRoute) _didUpdate(oldWidget);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return MeeduPlayerScope(
      controller: widget.controller,
      child: CallbackShortcuts(
        bindings: activatorsToCallBacks(widget.controller, context),
        child: Focus(
          focusNode: widget.focusNode,
          autofocus: true,
          child: LayoutBuilder(
            key: _layoutKey,
            builder: (context, constraints) {
              final MeeduPlayerController _ = MeeduPlayerScope.controllerOf(context);
              if (_.controlsEnabled && _.responsive.setNewDimensions(constraints)) {
                customDebugPrint('setNewConstraints');
                _.responsive.setDimensions(constraints.maxWidth, constraints.maxHeight);
              }
              return ColoredBox(
                color: widget.backgroundColor,
                child: ExcludeFocus(
                  excluding: _.excludeFocus,
                  child: RxBuilder(
                    //observables: [_.videoFit],
                    (__) {
                      _.dataStatus.status.value;
                      customDebugPrint("Fit is ${widget.controller.videoFit.value}");
                      // customDebugPrint(
                      //     "constraints.maxWidth ${constraints.maxWidth}");
                      // _.customDebugPrint(
                      //     "width ${videoWidth(_.videoPlayerController, constraints.maxWidth)}");
                      // customDebugPrint(
                      //     "videoPlayerController ${_.videoPlayerController}");
                      Widget videoWidget = const SizedBox.shrink();

                      bool visible = true;

                      if (!widget._isRoute) visible = !_.fullscreen.value;

                      if (_.videoPlayerController != null) {
                        videoWidget = Visibility.maintain(
                          visible: visible,
                          child: Video(
                            aspectRatio: 16 / 9,
                            controls: (state) => Stack(
                              fit: StackFit.expand,
                              alignment: Alignment.center,
                              children: [
                                if (_.controlsEnabled && _.controlsStyle == ControlsStyle.primary)
                                  PrimaryVideoPlayerControls(responsive: _.responsive)
                                else if (_.controlsEnabled && _.controlsStyle == ControlsStyle.primaryList)
                                  PrimaryListVideoPlayerControls(responsive: _.responsive)
                                else if (_.controlsEnabled && _.controlsStyle == ControlsStyle.secondary)
                                  SecondaryVideoPlayerControls(responsive: _.responsive)
                                else if (_.controlsEnabled && _.controlsStyle == ControlsStyle.custom && _.customControls != null)
                                  ControlsContainer(responsive: _.responsive, child: _.customControls!),
                                if (_.videoOverlay != null) _.videoOverlay!,
                              ],
                            ),
                            pauseUponEnteringBackgroundMode: false,
                            fit: _.videoFit.value,
                            controller: _.videoPlayerController!,
                          ),
                        );
                      }

                      return SizedBox(
                        width: _.videoWidth,
                        height: _.videoHeight,
                        child: videoWidget,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onInit() {
    if (widget.customIcons != null) {
      widget.controller.customIcons = widget.customIcons!(widget.controller.responsive);
    }
    if (widget.header != null) {
      widget.controller.header = widget.header!(context, widget.controller, widget.controller.responsive);
    }
    if (widget.bottomRight != null) {
      widget.controller.bottomRight = widget.bottomRight!(context, widget.controller, widget.controller.responsive);
    }
    if (widget.videoOverlay != null) {
      widget.controller.videoOverlay = widget.videoOverlay!(context, widget.controller, widget.controller.responsive);
    }
    if (widget.customControls != null) {
      widget.controller.customControls = widget.customControls!(context, widget.controller, widget.controller.responsive);
    }
  }

  void _didUpdate(MeeduVideoPlayer oldWidget) {
    if (widget.customIcons != oldWidget.customControls) {
      widget.controller.customIcons = widget.customIcons!(widget.controller.responsive);
    }
    if (widget.header != oldWidget.header) {
      widget.controller.header = widget.header!(context, widget.controller, widget.controller.responsive);
    }
    if (widget.bottomRight != oldWidget.bottomRight) {
      widget.controller.bottomRight = widget.bottomRight!(context, widget.controller, widget.controller.responsive);
    }
    if (widget.videoOverlay != oldWidget.videoOverlay) {
      widget.controller.videoOverlay = widget.videoOverlay!(context, widget.controller, widget.controller.responsive);
    }
    if (widget.customControls != oldWidget.customControls) {
      widget.controller.customControls = widget.customControls!(context, widget.controller, widget.controller.responsive);
    }
  }
}

class MeeduPlayerScope extends InheritedWidget {
  final MeeduPlayerController controller;

  const MeeduPlayerScope({
    Key? key,
    required Widget child,
    required this.controller,
  }) : super(key: key, child: child);

  static MeeduPlayerScope? _maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MeeduPlayerScope>();
  }

  static MeeduPlayerController controllerOf(BuildContext context) {
    MeeduPlayerController? result = _maybeOf(context)?.controller;
    result ??= context.findAncestorStateOfType<_MeeduVideoPlayerState>()?.widget.controller;
    assert(result != null, 'No MeeduPlayerScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant MeeduPlayerScope oldWidget) => false;
}
