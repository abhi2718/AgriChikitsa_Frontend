import 'package:agriChikitsa/res/color.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoControls extends StatefulWidget {
  const VideoControls({
    required this.controller,
    required this.isMuted,
    required this.onMuteToggle,
    required this.onFullScreen,
  });

  final VideoPlayerController controller;
  final ValueNotifier<bool> isMuted;
  final VoidCallback onMuteToggle;
  final VoidCallback onFullScreen;

  @override
  State<VideoControls> createState() => VideoControlsState();
}

class VideoControlsState extends State<VideoControls> {
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () {
      if (mounted) setState(() {});
    };
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final position = controller.value.position;
    final duration = controller.value.duration;
    final isPlaying = controller.value.isPlaying;
    final progress = duration.inMilliseconds > 0
        ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black87],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Seekbar
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              trackHeight: 2,
              activeTrackColor: AppColor.darkColor,
              inactiveTrackColor: Colors.white38,
              thumbColor: AppColor.darkColor,
              overlayColor: AppColor.darkColor.withOpacity(0.2),
            ),
            child: Slider(
              value: progress.toDouble(),
              onChanged: (val) {
                final seekTo = Duration(
                  milliseconds: (val * duration.inMilliseconds).toInt(),
                );
                controller.seekTo(seekTo);
              },
            ),
          ),
          // Bottom row
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              children: [
                // Play/Pause
                GestureDetector(
                  onTap: () {
                    isPlaying ? controller.pause() : controller.play();
                  },
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 8),
                // Timer
                Text(
                  '${_format(position)} / ${_format(duration)}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                const Spacer(),
                // Mute
                ValueListenableBuilder<bool>(
                  valueListenable: widget.isMuted,
                  builder: (_, muted, __) => GestureDetector(
                    onTap: widget.onMuteToggle,
                    child: Icon(
                      muted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Fullscreen
                GestureDetector(
                  onTap: widget.onFullScreen,
                  child: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
