import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/audio_provider.dart';

class AudioPlayerBar extends ConsumerWidget {
  const AudioPlayerBar({Key? key}) : super(key: key);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);

    if (audioState.duration == Duration.zero && !audioState.isPlaying) {
      return const SizedBox.shrink(); // Don't show if nothing loaded/playing
    }

    final loopIcon = audioState.loopMode == 1 
      ? Icons.repeat_one 
      : (audioState.loopMode == 2 ? Icons.repeat : Icons.sync_disabled);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(_formatDuration(audioState.position)),
              Expanded(
                child: Slider(
                  value: audioState.position.inSeconds.toDouble().clamp(0.0, audioState.duration.inSeconds.toDouble()),
                  max: audioState.duration.inSeconds.toDouble() == 0 ? 1 : audioState.duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    ref.read(audioProvider.notifier).seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              Text(_formatDuration(audioState.duration)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Speed Control
              PopupMenuButton<double>(
                initialValue: audioState.speed,
                icon: const Icon(Icons.speed),
                onSelected: (speed) {
                  ref.read(audioProvider.notifier).setSpeed(speed);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 0.75, child: Text('0.75x')),
                  const PopupMenuItem(value: 1.0, child: Text('1.0x')),
                  const PopupMenuItem(value: 1.25, child: Text('1.25x')),
                  const PopupMenuItem(value: 1.5, child: Text('1.5x')),
                ],
              ),
              
              // Play/Pause
              IconButton(
                iconSize: 48,
                icon: Icon(audioState.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (audioState.isPlaying) {
                    ref.read(audioProvider.notifier).pause();
                  } else {
                    ref.read(audioProvider.notifier).resume();
                  }
                },
              ),

              // Repeat Control
              IconButton(
                icon: Icon(loopIcon),
                color: audioState.loopMode != 0 ? Theme.of(context).primaryColor : Colors.grey,
                onPressed: () {
                  ref.read(audioProvider.notifier).toggleLoopMode();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
