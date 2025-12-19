import 'package:flutter/rendering.dart';

enum ScreenObjectHorizontalAlignment {
  left,
  right,
  center,
}

enum ScreenObjectVerticalAlignment {
  top,
  bottom,
  middle,
}

class VideoTrackScreenObject {
  final bool isVisible;
  final Size size;
  final EdgeInsets layoutMargin;
  final ScreenObjectHorizontalAlignment horizontalAlignment;
  final ScreenObjectVerticalAlignment verticalAlignment;
  final int track;

  VideoTrackScreenObject({
    required this.track,
    this.isVisible = true,
    this.size = const Size(0, 0),
    this.layoutMargin = EdgeInsets.zero,
    this.horizontalAlignment = ScreenObjectHorizontalAlignment.left,
    this.verticalAlignment = ScreenObjectVerticalAlignment.top,
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
          track == other.track);

  @override
  int get hashCode =>
      isVisible.hashCode ^
      size.hashCode ^
      layoutMargin.hashCode ^
      horizontalAlignment.hashCode ^
      verticalAlignment.hashCode ^
      track.hashCode;

  @override
  String toString() {
    return 'VideoTrackScreenObject{isVisible: $isVisible, size: $size, layoutMargin: $layoutMargin, horizontalAlignment: $horizontalAlignment, verticalAlignment: $verticalAlignment, track: $track}';
  }

  VideoTrackScreenObject copyWith({
    bool? isVisible,
    Size? size,
    EdgeInsets? layoutMargin,
    ScreenObjectHorizontalAlignment? horizontalAlignment,
    ScreenObjectVerticalAlignment? verticalAlignment,
    int? track,
  }) {
    return VideoTrackScreenObject(
      isVisible: isVisible ?? this.isVisible,
      size: size ?? this.size,
      layoutMargin: layoutMargin ?? this.layoutMargin,
      horizontalAlignment: horizontalAlignment ?? this.horizontalAlignment,
      verticalAlignment: verticalAlignment ?? this.verticalAlignment,
      track: track ?? this.track,
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
