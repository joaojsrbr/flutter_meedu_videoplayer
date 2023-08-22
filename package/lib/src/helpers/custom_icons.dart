// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

/// this class help you to change the default player icons
abstract class CustomIcons {
  final Icon play, pause, repeat, rewind, fastForward, sound, mute, videoFit, pip, exitPip, minimize, fullscreen, lock, unlock, volume, brightness;

  CustomIcons({
    required this.play,
    required this.pause,
    required this.repeat,
    required this.rewind,
    required this.fastForward,
    required this.sound,
    required this.mute,
    required this.videoFit,
    required this.pip,
    required this.exitPip,
    required this.minimize,
    required this.fullscreen,
    required this.lock,
    required this.unlock,
    required this.volume,
    required this.brightness,
  });

  static const CustomIcons defaultIcons = _DefaultCustomIcons();
}

class _DefaultCustomIcons implements CustomIcons {
  const _DefaultCustomIcons();

  static const _defaultColor = Colors.white;

  @override
  Icon get brightness => const Icon(Icons.wb_sunny, color: _defaultColor);

  @override
  Icon get exitPip => const Icon(Icons.picture_in_picture_alt_outlined, color: _defaultColor);

  @override
  Icon get fastForward => const Icon(Icons.fast_forward, color: _defaultColor);

  @override
  Icon get fullscreen => const Icon(Icons.fullscreen, color: _defaultColor);

  @override
  Icon get lock => const Icon(Icons.lock, color: _defaultColor);

  @override
  Icon get minimize => const Icon(Icons.minimize, color: _defaultColor);

  @override
  Icon get mute => const Icon(Icons.volume_mute, color: _defaultColor);

  @override
  Icon get pause => const Icon(Icons.pause, color: _defaultColor);

  @override
  Icon get pip => const Icon(Icons.picture_in_picture_alt, color: _defaultColor);

  @override
  Icon get play => const Icon(Icons.play_arrow, color: _defaultColor);

  @override
  Icon get repeat => const Icon(Icons.repeat, color: _defaultColor);

  @override
  Icon get rewind => const Icon(Icons.fast_rewind, color: _defaultColor);

  @override
  Icon get sound => const Icon(Icons.volume_up_sharp, color: _defaultColor);

  @override
  Icon get unlock => const Icon(Icons.lock_open, color: _defaultColor);

  @override
  Icon get videoFit => const Icon(Icons.fit_screen, color: _defaultColor);

  @override
  Icon get volume => const Icon(Icons.music_note, color: _defaultColor);
}
