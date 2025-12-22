import 'dart:typed_data';

import 'package:flutter/rendering.dart';

/// The horizontal alignment for the screen object.
enum ScreenObjectHorizontalAlignment {
  /// A guide that marks the left edge of the screen object.
  left,

  /// A guide that marks the right edge of the screen object.
  right,

  /// A guide that marks the borizontal center of the screen object.
  center,
}

/// The vertical alignment for the screen object.
enum ScreenObjectVerticalAlignment {
  /// A guide that marks the top edge of the screen object.
  top,

  /// A guide that marks the bottom edge of the screen object.
  bottom,

  /// A guide that marks the vertical middle of the screen object.
  middle,
}

/// The ScreenObject class is the abstract class for all objects that are rendered on the screen.
abstract class ScreenObject {
  /// Specifies the visibility of the object.
  bool get isVisible;

  /// Specifies the size rectangle.
  ///
  /// Limitation: On Android, decimal points are truncated.
  Size get size;

  /// Specifies the default spacing to laying out content in the screen object.
  ///
  /// Limitation: On Android, decimal points are truncated.
  EdgeInsets get layoutMargin;

  /// Specifies the alignment position along the horizontal axis.
  ScreenObjectHorizontalAlignment get horizontalAlignment;

  /// Specifies the alignment position along the vertical axis.
  ScreenObjectVerticalAlignment get verticalAlignment;

  Map<String, dynamic> toMap();
}

class TextScreenObject implements ScreenObject {
  @override
  final bool isVisible;
  @override
  final Size size;
  @override
  final EdgeInsets layoutMargin;
  @override
  final ScreenObjectHorizontalAlignment horizontalAlignment;
  @override
  final ScreenObjectVerticalAlignment verticalAlignment;

  /// Specifies the text value.
  final String string;

  TextScreenObject({
    required this.string,
    this.isVisible = true,
    this.size = const Size(0, 0),
    this.layoutMargin = EdgeInsets.zero,
    this.horizontalAlignment = ScreenObjectHorizontalAlignment.left,
    this.verticalAlignment = ScreenObjectVerticalAlignment.top,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TextScreenObject &&
          runtimeType == other.runtimeType &&
          isVisible == other.isVisible &&
          size == other.size &&
          layoutMargin == other.layoutMargin &&
          horizontalAlignment == other.horizontalAlignment &&
          verticalAlignment == other.verticalAlignment &&
          string == other.string);

  @override
  int get hashCode =>
      isVisible.hashCode ^
      size.hashCode ^
      layoutMargin.hashCode ^
      horizontalAlignment.hashCode ^
      verticalAlignment.hashCode ^
      string.hashCode;

  @override
  String toString() {
    return 'TextScreenObject{isVisible: $isVisible, size: $size, layoutMargin: $layoutMargin, horizontalAlignment: $horizontalAlignment, verticalAlignment: $verticalAlignment, string: $string}';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'screenObjectType': 'TextScreenObject',
      'hashCode': hashCode,
      'isVisible': isVisible,
      'size': size.toMap(),
      'layoutMargin': layoutMargin.toMap(),
      'horizontalAlignment': horizontalAlignment.name,
      'verticalAlignment': verticalAlignment.name,
      'string': string,
    };
  }
}

abstract class _ImageSource {
  Map<String, dynamic> toMap();
}

class _ImageSourceFile implements _ImageSource {
  final String path;

  _ImageSourceFile({required this.path});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ImageSourceFile &&
          runtimeType == other.runtimeType &&
          path == other.path;

  @override
  int get hashCode => path.hashCode;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'file',
      'path': path,
    };
  }
}

class _ImageSourceNetwork implements _ImageSource {
  final String url;

  _ImageSourceNetwork({required this.url});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ImageSourceNetwork &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'network',
      'url': url,
    };
  }
}

class _ImageSourceMemory implements _ImageSource {
  final Uint8List bytes;

  _ImageSourceMemory({required this.bytes});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ImageSourceMemory &&
          runtimeType == other.runtimeType &&
          bytes == other.bytes;

  @override
  int get hashCode => bytes.hashCode;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'memory',
      'bytes': bytes,
    };
  }
}

class ImageScreenObject implements ScreenObject {
  @override
  final bool isVisible;
  @override
  final Size size;
  @override
  final EdgeInsets layoutMargin;
  @override
  final ScreenObjectHorizontalAlignment horizontalAlignment;
  @override
  final ScreenObjectVerticalAlignment verticalAlignment;

  /// Specifies the image value.
  final _ImageSource _image;

  ImageScreenObject.file({
    required String path,
    this.isVisible = true,
    this.size = const Size(0, 0),
    this.layoutMargin = EdgeInsets.zero,
    this.horizontalAlignment = ScreenObjectHorizontalAlignment.left,
    this.verticalAlignment = ScreenObjectVerticalAlignment.top,
  }) : _image = _ImageSourceFile(path: path);

  ImageScreenObject.network({
    required String url,
    this.isVisible = true,
    this.size = const Size(0, 0),
    this.layoutMargin = EdgeInsets.zero,
    this.horizontalAlignment = ScreenObjectHorizontalAlignment.left,
    this.verticalAlignment = ScreenObjectVerticalAlignment.top,
  }) : _image = _ImageSourceNetwork(url: url);

  ImageScreenObject.memory({
    required Uint8List bytes,
    this.isVisible = true,
    this.size = const Size(0, 0),
    this.layoutMargin = EdgeInsets.zero,
    this.horizontalAlignment = ScreenObjectHorizontalAlignment.left,
    this.verticalAlignment = ScreenObjectVerticalAlignment.top,
  }) : _image = _ImageSourceMemory(bytes: bytes);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageScreenObject &&
          runtimeType == other.runtimeType &&
          isVisible == other.isVisible &&
          size == other.size &&
          layoutMargin == other.layoutMargin &&
          horizontalAlignment == other.horizontalAlignment &&
          verticalAlignment == other.verticalAlignment &&
          _image == other._image;

  @override
  int get hashCode =>
      isVisible.hashCode ^
      size.hashCode ^
      layoutMargin.hashCode ^
      horizontalAlignment.hashCode ^
      verticalAlignment.hashCode ^
      _image.hashCode;

  @override
  String toString() {
    return 'ImageScreenObject{isVisible: $isVisible, size: $size, layoutMargin: $layoutMargin, horizontalAlignment: $horizontalAlignment, verticalAlignment: $verticalAlignment, _image: $_image}';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'screenObjectType': 'ImageScreenObject',
      'hashCode': hashCode,
      'isVisible': isVisible,
      'size': size.toMap(),
      'layoutMargin': layoutMargin.toMap(),
      'horizontalAlignment': horizontalAlignment.name,
      'verticalAlignment': verticalAlignment.name,
      'image': _image.toMap(),
    };
  }
}

/// A enum that defines how a layer displays a player’s visual content within the layer’s bounds.
enum VideoTrackScreenObjectVideoGravity {
  /// The video stretches to fill the layer’s bounds.
  resize,

  /// The video preserves its aspect ratio and fits it within the layer’s bounds.
  resizeAspect,

  /// The video preserves its aspect ratio and fills the layer’s bounds.
  resizeAspectFill,
}

/// An object that manages offscreen rendering a video track source.
class VideoTrackScreenObject implements ScreenObject {
  @override
  final bool isVisible;
  @override
  final Size size;
  @override
  final EdgeInsets layoutMargin;
  @override
  final ScreenObjectHorizontalAlignment horizontalAlignment;
  @override
  final ScreenObjectVerticalAlignment verticalAlignment;

  /// Specifies the alignment position along the vertical axis.
  final int track;

  /// Specifies the videoGravity how the displays the visual content.
  final VideoTrackScreenObjectVideoGravity videoGravity;

  VideoTrackScreenObject({
    required this.track,
    this.isVisible = true,
    this.size = const Size(0, 0),
    this.layoutMargin = EdgeInsets.zero,
    this.horizontalAlignment = ScreenObjectHorizontalAlignment.left,
    this.verticalAlignment = ScreenObjectVerticalAlignment.top,
    this.videoGravity = VideoTrackScreenObjectVideoGravity.resizeAspect,
  }) : assert(track >= 0 && track <= 255);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoTrackScreenObject &&
          runtimeType == other.runtimeType &&
          isVisible == other.isVisible &&
          size == other.size &&
          layoutMargin == other.layoutMargin &&
          horizontalAlignment == other.horizontalAlignment &&
          verticalAlignment == other.verticalAlignment &&
          track == other.track &&
          videoGravity == other.videoGravity);

  @override
  int get hashCode =>
      isVisible.hashCode ^
      size.hashCode ^
      layoutMargin.hashCode ^
      horizontalAlignment.hashCode ^
      verticalAlignment.hashCode ^
      track.hashCode ^
      videoGravity.hashCode;

  @override
  String toString() {
    return 'VideoTrackScreenObject{isVisible: $isVisible, size: $size, layoutMargin: $layoutMargin, horizontalAlignment: $horizontalAlignment, verticalAlignment: $verticalAlignment, track: $track, videoGravity: $videoGravity}';
  }

  VideoTrackScreenObject copyWith({
    bool? isVisible,
    Size? size,
    EdgeInsets? layoutMargin,
    ScreenObjectHorizontalAlignment? horizontalAlignment,
    ScreenObjectVerticalAlignment? verticalAlignment,
    int? track,
    VideoTrackScreenObjectVideoGravity? videoGravity,
  }) {
    return VideoTrackScreenObject(
      isVisible: isVisible ?? this.isVisible,
      size: size ?? this.size,
      layoutMargin: layoutMargin ?? this.layoutMargin,
      horizontalAlignment: horizontalAlignment ?? this.horizontalAlignment,
      verticalAlignment: verticalAlignment ?? this.verticalAlignment,
      track: track ?? this.track,
      videoGravity: videoGravity ?? this.videoGravity,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'screenObjectType': 'VideoTrackScreenObject',
      'hashCode': hashCode,
      'isVisible': isVisible,
      'size': size.toMap(),
      'layoutMargin': layoutMargin.toMap(),
      'horizontalAlignment': horizontalAlignment.name,
      'verticalAlignment': verticalAlignment.name,
      'track': track,
      'videoGravity': videoGravity.name,
    };
  }
}

extension on Size {
  Map<String, double> toMap() {
    return {
      'width': width,
      'height': height,
    };
  }
}

extension on EdgeInsets {
  Map<String, double> toMap() {
    return {
      'left': left,
      'top': top,
      'right': right,
      'bottom': bottom,
    };
  }
}
