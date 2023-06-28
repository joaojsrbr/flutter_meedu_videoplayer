import 'package:flutter/widgets.dart';
import 'package:flutter_meedu_videoplayer/src/helpers/responsive.dart';

class VideoCoreForwardAndRewindLayout extends StatelessWidget {
  const VideoCoreForwardAndRewindLayout({Key? key, required this.rewind, required this.forward, required this.responsive}) : super(key: key);

  final Widget rewind;
  final Widget forward;
  final Responsive responsive;
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final portrait = orientation == Orientation.portrait;

    return Row(children: [
      Expanded(child: rewind),
      SizedBox(width: portrait ? responsive.width / 5 : responsive.width / 3.0),
      Expanded(child: forward),
    ]);
  }
}
