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

class MeeduVideoPlayer extends StatelessWidget {
  final MeeduPlayerController controller;

  final FocusNode? focusNode;

  final Widget Function(
    BuildContext context,
    MeeduPlayerController controller,
    Responsive responsive,
  )? header;

  final Widget Function(
    BuildContext context,
    MeeduPlayerController controller,
    Responsive responsive,
  )? bottomRight;

  final CustomIcons Function(
    Responsive responsive,
  )? customIcons;

  ///[customControls] this only needed when controlsStyle is [ControlsStyle.custom]
  final Widget Function(
    BuildContext context,
    MeeduPlayerController controller,
    Responsive responsive,
  )? customControls;

  ///[customCaptionView] when a custom view for the captions is needed
  final Widget Function(BuildContext context, MeeduPlayerController controller, Responsive responsive, String text)? customCaptionView;

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
  const MeeduVideoPlayer(
      {Key? key,
      required this.controller,
      this.header,
      this.focusNode,
      this.bottomRight,
      this.customIcons,
      this.customControls,
      this.customCaptionView,
      this.closedCaptionDistanceFromBottom = 40})
      : super(key: key);

  double videoWidth(VideoPlayerController? controller) {
    double width = controller != null
        ? controller.value.size.width != 0
            ? controller.value.size.width
            : 640
        : 640;
    return width;
    // if (width < max) {
    //   return max;
    // } else {
    //   return width;
    // }
  }

  double videoHeight(VideoPlayerController? controller) {
    double height = controller != null
        ? controller.value.size.height != 0
            ? controller.value.size.height
            : 480
        : 480;
    return height;
    // if (height < max) {
    //   return max;
    // } else {
    //   return height;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: activatorsToCallBacks(controller, context),
      child: Focus(
        focusNode: focusNode,
        autofocus: true,
        child: MeeduPlayerProvider(
          controller: controller,
          child: DecoratedBox(
              decoration: const BoxDecoration(color: Colors.black),
              child: LayoutBuilder(
                builder: (ctx, constraints) {
                  MeeduPlayerController _ = controller;
                  if (_.controlsEnabled) {
                    _.responsive.setDimensions(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );
                  }

                  if (customIcons != null) {
                    _.customIcons = customIcons!(_.responsive);
                  }

                  if (header != null) {
                    _.header = header!(context, _, _.responsive);
                  }

                  if (bottomRight != null) {
                    _.bottomRight = bottomRight!(context, _, _.responsive);
                  }

                  if (customControls != null) {
                    _.customControls = customControls!(context, _, _.responsive);
                  }
                  return ExcludeFocus(
                    excluding: _.excludeFocus,
                    child: Stack(
                      // clipBehavior: Clip.hardEdge,
                      // fit: StackFit.,
                      alignment: Alignment.center,
                      children: [
                        RxBuilder(
                            //observables: [_.videoFit],
                            (__) {
                          _.dataStatus.status.value;
                          _.customDebugPrint("Fit is ${controller.videoFit.value}");
                          // customDebugPrint(
                          //     "constraints.maxWidth ${constraints.maxWidth}");
                          // _.customDebugPrint(
                          //     "width ${videoWidth(_.videoPlayerController, constraints.maxWidth)}");
                          // customDebugPrint(
                          //     "videoPlayerController ${_.videoPlayerController}");
                          return Positioned.fill(
                            child: FittedBox(
                              clipBehavior: Clip.hardEdge,
                              fit: controller.videoFit.value,
                              child: SizedBox(
                                width: videoWidth(
                                  _.videoPlayerController,
                                ),
                                height: videoHeight(
                                  _.videoPlayerController,
                                ),
                                // width: 640,
                                // height: 480,
                                child: _.videoPlayerController != null ? VideoPlayer(_.videoPlayerController!) : const SizedBox.shrink(),
                              ),
                            ),
                          );
                        }),
                        ClosedCaptionView(
                          responsive: _.responsive,
                          distanceFromBottom: closedCaptionDistanceFromBottom,
                          customCaptionView: customCaptionView,
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
              )),
        ),
      ),
    );
  }
}

class MeeduPlayerProvider extends InheritedWidget {
  final MeeduPlayerController controller;

  const MeeduPlayerProvider({
    Key? key,
    required Widget child,
    required this.controller,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
