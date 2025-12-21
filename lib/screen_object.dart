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

  Map<String, dynamic> toMap() {
    return {
      'isVisible': isVisible,
      'size': size.toMap(),
      'layoutMargin': layoutMargin.toMap(),
      'horizontalAlignment': horizontalAlignment.name,
      'verticalAlignment': verticalAlignment.name,
      'track': track,
      'videoGravity': videoGravity.name,
    };
  }

  factory VideoTrackScreenObject.fromMap(Map<String, dynamic> map) {
    return VideoTrackScreenObject(
      isVisible: map['isVisible'] as bool,
      size:
          Size(map['size']['width'] as double, map['size']['height'] as double),
      layoutMargin: EdgeInsets.fromLTRB(
        map['layoutMargin']['left'] as double,
        map['layoutMargin']['top'] as double,
        map['layoutMargin']['right'] as double,
        map['layoutMargin']['bottom'] as double,
      ),
      horizontalAlignment: ScreenObjectHorizontalAlignment.values
          .byName(map['horizontalAlignment'] as String),
      verticalAlignment: ScreenObjectVerticalAlignment.values
          .byName(map['verticalAlignment'] as String),
      track: map['track'] as int,
      videoGravity: VideoTrackScreenObjectVideoGravity.values
          .byName(map['videoGravity'] as String),
    );
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
