/// Android の `MediaRecorder.AudioSource` 相当の入力種別。
///
/// iOS/macOS では無視されます（`deviceId` を使用）。
enum AndroidAudioSource {
  /// `MediaRecorder.AudioSource.MIC`
  mic,

  /// `MediaRecorder.AudioSource.CAMCORDER`
  camcorder,

  /// `MediaRecorder.AudioSource.VOICE_COMMUNICATION`
  voiceCommunication,

  /// `MediaRecorder.AudioSource.VOICE_RECOGNITION`
  voiceRecognition,

  /// `MediaRecorder.AudioSource.UNPROCESSED` (API 24+)
  unprocessed,

  /// `MediaRecorder.AudioSource.VOICE_PERFORMANCE` (API 29+)
  voicePerformance,
}

/// 音声入力ソース。
///
/// - **Android**: `androidSource` により AudioRecord の入力種別を選択します。
/// - **iOS/macOS**: `deviceId`（`AVCaptureDevice.uniqueID`）により入力デバイスを選択します。
class AudioSource {
  /// Android の入力種別。
  final AndroidAudioSource? androidSource;

  /// iOS/macOS の入力デバイスID（`AVCaptureDevice.uniqueID`）。
  final String? deviceId;

  const AudioSource({
    this.androidSource,
    this.deviceId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioSource &&
          runtimeType == other.runtimeType &&
          androidSource == other.androidSource &&
          deviceId == other.deviceId);

  @override
  int get hashCode => Object.hash(androidSource, deviceId);

  @override
  String toString() {
    return 'AudioSource{androidSource: $androidSource, deviceId: $deviceId}';
  }

  AudioSource copyWith({
    AndroidAudioSource? androidSource,
    String? deviceId,
  }) {
    return AudioSource(
      androidSource: androidSource ?? this.androidSource,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (androidSource != null) {
      map['androidSource'] = androidSource!.name;
    }
    if (deviceId != null) {
      map['deviceId'] = deviceId;
    }
    return map;
  }

  factory AudioSource.fromMap(Map<String, dynamic> map) {
    final androidSourceName = map['androidSource'] as String?;
    return AudioSource(
      androidSource: androidSourceName == null
          ? null
          : AndroidAudioSource.values.byName(androidSourceName),
      deviceId: map['deviceId'] as String?,
    );
  }
}
