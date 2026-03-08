import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class AudioState {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final double speed;
  final int loopMode; // 0 = no loop, 1 = loop ayah, 2 = loop surah
  final String? currentReciterId;
  final String? currentSurahId;
  final String? currentAyahId;
  
  AudioState({
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.speed = 1.0,
    this.loopMode = 0,
    this.currentReciterId,
    this.currentSurahId,
    this.currentAyahId,
  });

  AudioState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    double? speed,
    int? loopMode,
    String? currentReciterId,
    String? currentSurahId,
    String? currentAyahId,
  }) {
    return AudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
      loopMode: loopMode ?? this.loopMode,
      currentReciterId: currentReciterId ?? this.currentReciterId,
      currentSurahId: currentSurahId ?? this.currentSurahId,
      currentAyahId: currentAyahId ?? this.currentAyahId,
    );
  }
}

class AudioNotifier extends StateNotifier<AudioState> {
  final AudioPlayer _player = AudioPlayer();
  List<String> _playlistUrls = [];
  int _currentIndex = 0;

  AudioNotifier() : super(AudioState()) {
    _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      state = state.copyWith(isPlaying: isPlaying);

      // Auto-next logic when playback completes
      if (playerState.processingState == ProcessingState.completed) {
        _handlePlaybackCompleted();
      }
    });
    
    _player.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });

    _player.durationStream.listen((duration) {
      if (duration != null) {
        state = state.copyWith(duration: duration);
      }
    });

    // Default loop mode based on initial player state
    _player.setLoopMode(LoopMode.off);
  }

  void _handlePlaybackCompleted() {
    if (state.loopMode == 1) {
      // Loop single ayah handled automatically by JustAudio if configured
      // Or we manually replay:
      _player.seek(Duration.zero);
      _player.play();
      return;
    }

    // Auto next logic (simplified placeholder for now)
    // Real logic would calculate the next ayah and fetch its URL
  }

  Future<void> loadAndPlayAyah(int surahId, int ayahId, String reciterId) async {
    final surahStr = surahId.toString().padLeft(3, '0');
    final ayahStr = ayahId.toString().padLeft(3, '0');
    final audioUrl = 'https://everyayah.com/data/$reciterId/$surahStr$ayahStr.mp3';
    
    state = state.copyWith(
      currentReciterId: reciterId,
      currentSurahId: surahStr,
      currentAyahId: ayahStr,
    );

    try {
      await _player.setUrl(audioUrl);
      await _player.play();
    } catch (e) {
      print('Error playing audio: $e');
      // In a real app we would set an error state here
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }
  
  Future<void> resume() async {
    await _player.play();
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
    state = state.copyWith(speed: speed);
  }

  Future<void> toggleLoopMode() async {
    int nextMode = (state.loopMode + 1) % 3;
    state = state.copyWith(loopMode: nextMode);
    
    if (nextMode == 1) {
      await _player.setLoopMode(LoopMode.one);
    } else {
      await _player.setLoopMode(LoopMode.off);
    }
  }
  
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  return AudioNotifier();
});
