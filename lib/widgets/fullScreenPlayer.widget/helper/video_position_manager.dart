class VideoPositionManager {
  VideoPositionManager._();
  static final VideoPositionManager instance = VideoPositionManager._();

  final Map<String, Duration> _positions = {};

  void save(String key, Duration position) {
    _positions[key] = position;
  }

  Duration get(String key) => _positions[key] ?? Duration.zero;

  void clear(String key) => _positions.remove(key);
}
