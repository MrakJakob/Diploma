enum RecordingStatus {
  idle,
  recording,
  paused;

  String get recordingStatus {
    switch (this) {
      case RecordingStatus.idle:
        return 'idle';
      case RecordingStatus.recording:
        return 'recording';
      case RecordingStatus.paused:
        return 'paused';
      default:
        return 'idle';
    }
  }
}
