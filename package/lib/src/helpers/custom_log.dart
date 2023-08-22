import 'dart:developer' as dev;

import 'package:flutter_meedu_videoplayer/meedu_player.dart';

void customDebugPrint(Object? object, {Object? error, StackTrace? stackTracer}) {
  if (MeeduPlayerController.showLogs) {
    dev.log(object.toString(), name: "flutter_meedu_videoplayer", stackTrace: stackTracer, error: error);
  }
}
