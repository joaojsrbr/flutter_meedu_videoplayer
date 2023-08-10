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

  const MeeduVideoPlayer({
    super.key,
    required this.controller,
    this.header,
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
        customCaptionView = null,
        customControls = null,
        bottomRight = null,
        customIcons = null;

  @override
  State<MeeduVideoPlayer> createState() => _MeeduVideoPlayerState();
}

class _MeeduVideoPlayerState extends State<MeeduVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: activatorsToCallBacks(widget.controller, context),
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: true,
        child: MeeduPlayerScope(
          controller: widget.controller,
          child: ColoredBox(
            color: widget.backgroundColor,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final MeeduPlayerController _ = widget.controller;
                if (_.controlsEnabled) {
                  _.responsive.setDimensions(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                }

                if (widget.customIcons != null) {
                  _.customIcons = widget.customIcons!(_.responsive);
                }

                if (widget.header != null) {
                  _.header = widget.header!(context, _, _.responsive);
                }

                if (widget.bottomRight != null) {
                  _.bottomRight = widget.bottomRight!(context, _, _.responsive);
                }

                if (widget.customControls != null) {
                  _.customControls = widget.customControls!(context, _, _.responsive);
                }

                return ExcludeFocus(
                  excluding: _.excludeFocus,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      RxBuilder(
                        //observables: [_.videoFit],
                        (__) {
                          _.dataStatus.status.value;
                          _.customDebugPrint("Fit is ${widget.controller.videoFit.value}");
                          // customDebugPrint(
                          //     "constraints.maxWidth ${constraints.maxWidth}");
                          // _.customDebugPrint(
                          //     "width ${videoWidth(_.videoPlayerController, constraints.maxWidth)}");
                          // customDebugPrint(
                          //     "videoPlayerController ${_.videoPlayerController}");
                          Widget videoWidget = const SizedBox.shrink();

                          bool visible = true;

                          if (!widget._isRoute) {
                            visible = !_.fullscreen.value;
                          }

                          if (_.videoPlayerController != null) {
                            return Visibility.maintain(
                              visible: visible,
                              child: IgnorePointer(
                                child: Video(
                                  aspectRatio: 16 / 9,
                                  controls: (state) => const SizedBox.shrink(),
                                  pauseUponEnteringBackgroundMode: false,
                                  fit: _.videoFit.value,
                                  controller: _.videoPlayerController!,
                                ),
                              ),
                            );
                          }

                          return Positioned.fill(
                            child: SizedBox(
                              width: _.videoWidth,
                              height: _.videoHeight,
                              child: videoWidget,
                            ),
                          );
                        },
                      ),
                      if (_.controlsEnabled && _.controlsStyle == ControlsStyle.primary)
                        PrimaryVideoPlayerControls(responsive: _.responsive)
                      else if (_.controlsEnabled && _.controlsStyle == ControlsStyle.primaryList)
                        PrimaryListVideoPlayerControls(responsive: _.responsive)
                      else if (_.controlsEnabled && _.controlsStyle == ControlsStyle.secondary)
                        SecondaryVideoPlayerControls(responsive: _.responsive)
                      else if (_.controlsEnabled && _.controlsStyle == ControlsStyle.custom && _.customControls != null)
                        ControlsContainer(responsive: _.responsive, child: _.customControls!),
                      if (_.stackWidget != null) _.stackWidget!,
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MeeduPlayerScope extends InheritedWidget {
  final MeeduPlayerController controller;

  const MeeduPlayerScope({
    Key? key,
    required Widget child,
    required this.controller,
  }) : super(key: key, child: child);

  static MeeduPlayerScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MeeduPlayerScope>();
  }

  static MeeduPlayerScope of(BuildContext context) {
    final MeeduPlayerScope? result = maybeOf(context);
    assert(result != null, 'No MeeduPlayerScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant MeeduPlayerScope oldWidget) => false;
}
