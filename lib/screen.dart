import 'package:haishin_kit/screen_object.dart';

abstract class Screen {
  Future<void> addChild(ScreenObject child) {
    throw UnimplementedError();
  }
}
