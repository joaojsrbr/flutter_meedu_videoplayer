//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<auto_orientation/AutoOrientationPlugin.h>)
#import <auto_orientation/AutoOrientationPlugin.h>
#else
@import auto_orientation;
#endif

#if __has_include(<file_picker/FilePickerPlugin.h>)
#import <file_picker/FilePickerPlugin.h>
#else
@import file_picker;
#endif

#if __has_include(<flutter_meedu_videoplayer/FlutterMeeduVideoplayerPlugin.h>)
#import <flutter_meedu_videoplayer/FlutterMeeduVideoplayerPlugin.h>
#else
@import flutter_meedu_videoplayer;
#endif

#if __has_include(<media_kit_video/MediaKitVideoPlugin.h>)
#import <media_kit_video/MediaKitVideoPlugin.h>
#else
@import media_kit_video;
#endif

#if __has_include(<native_device_orientation/NativeDeviceOrientationPlugin.h>)
#import <native_device_orientation/NativeDeviceOrientationPlugin.h>
#else
@import native_device_orientation;
#endif

#if __has_include(<package_info_plus/FLTPackageInfoPlusPlugin.h>)
#import <package_info_plus/FLTPackageInfoPlusPlugin.h>
#else
@import package_info_plus;
#endif

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

#if __has_include(<screen_brightness_ios/ScreenBrightnessIosPlugin.h>)
#import <screen_brightness_ios/ScreenBrightnessIosPlugin.h>
#else
@import screen_brightness_ios;
#endif

#if __has_include(<shared_preferences_foundation/SharedPreferencesPlugin.h>)
#import <shared_preferences_foundation/SharedPreferencesPlugin.h>
#else
@import shared_preferences_foundation;
#endif

#if __has_include(<video_player_avfoundation/FLTVideoPlayerPlugin.h>)
#import <video_player_avfoundation/FLTVideoPlayerPlugin.h>
#else
@import video_player_avfoundation;
#endif

#if __has_include(<volume_controller/VolumeControllerPlugin.h>)
#import <volume_controller/VolumeControllerPlugin.h>
#else
@import volume_controller;
#endif

#if __has_include(<wakelock_plus/WakelockPlusPlugin.h>)
#import <wakelock_plus/WakelockPlusPlugin.h>
#else
@import wakelock_plus;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AutoOrientationPlugin registerWithRegistrar:[registry registrarForPlugin:@"AutoOrientationPlugin"]];
  [FilePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FilePickerPlugin"]];
  [FlutterMeeduVideoplayerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterMeeduVideoplayerPlugin"]];
  [MediaKitVideoPlugin registerWithRegistrar:[registry registrarForPlugin:@"MediaKitVideoPlugin"]];
  [NativeDeviceOrientationPlugin registerWithRegistrar:[registry registrarForPlugin:@"NativeDeviceOrientationPlugin"]];
  [FLTPackageInfoPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPackageInfoPlusPlugin"]];
  [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
  [ScreenBrightnessIosPlugin registerWithRegistrar:[registry registrarForPlugin:@"ScreenBrightnessIosPlugin"]];
  [SharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferencesPlugin"]];
  [FLTVideoPlayerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTVideoPlayerPlugin"]];
  [VolumeControllerPlugin registerWithRegistrar:[registry registrarForPlugin:@"VolumeControllerPlugin"]];
  [WakelockPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"WakelockPlusPlugin"]];
}

@end
