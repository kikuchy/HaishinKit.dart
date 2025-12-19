import 'package:haishin_kit/screen_object.dart';

abstract class Screen {
  Future<void> addChild(VideoTrackScreenObject child) {
    throw UnimplementedError();
  }
}
