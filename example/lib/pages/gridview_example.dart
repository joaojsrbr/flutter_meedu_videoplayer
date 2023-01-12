import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class GridViewExample extends StatefulWidget {
  GridViewExample({Key? key}) : super(key: key);

  @override
  _GridViewExampleState createState() => _GridViewExampleState();
}

class _GridViewExampleState extends State<GridViewExample>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 500,
            childAspectRatio: 16 / 9,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        itemBuilder: (_, index) => VideoItem(
          uniqueKey: "$index",
        ),
        itemCount: 6,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class VideoItem extends StatefulWidget {
  final String uniqueKey;
  VideoItem({Key? key, required this.uniqueKey}) : super(key: key);

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem>
    with AutomaticKeepAliveClientMixin {
  MeeduPlayerController _controller = MeeduPlayerController(
    screenManager: ScreenManager(orientations: [
      DeviceOrientation.portraitUp,
    ]),
  );

  ValueNotifier<bool> _visible = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _controller.setDataSource(
      DataSource(
        source:
            'https://movietrailers.apple.com/movies/paramount/the-spongebob-movie-sponge-on-the-run/the-spongebob-movie-sponge-on-the-run-big-game_h720p.mov',
        type: DataSourceType.network,
      ),
      autoplay: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    print("❌ dispose video player");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      key: Key(widget.uniqueKey),
      onVisibilityChanged: (info) {
        final visible = info.visibleFraction > 0;
        if (_visible.value != visible) {
          _visible.value = visible;
          if (!visible && _controller.videoPlayerController!.value.isPlaying) {
            _controller.pause();
          }
        }
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ValueListenableBuilder<bool>(
          valueListenable: _visible,
          builder: (_, visible, child) {
            return visible
                ? MeeduVideoPlayer(
                    controller: _controller,
                  )
                : child!;
          },
          child: Container(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}