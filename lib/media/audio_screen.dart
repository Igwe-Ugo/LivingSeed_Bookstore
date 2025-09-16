import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:livingseed_bookstore/media/widget.dart';
import 'package:livingseed_bookstore/models/widget.dart';

class AudioScreen extends StatefulWidget {
  final AudioMessage audioSongs;
  const AudioScreen({super.key, required this.audioSongs});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController iconController;
  bool isPlaying = false;
  double iconSize = 30.0;
  final AudioPlayer messagePlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  final GlobalKey<DecibelNoiseMeterState> _decibelNoiseMeterKey =
      GlobalKey<DecibelNoiseMeterState>();

  // New variables for additional functionalities
  bool isShuffleOn = false;
  LoopMode loopMode = LoopMode.off;
  late ConcatenatingAudioSource playlist;

  @override
  void initState() {
    super.initState();
    iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    setupPlaylist();
    messagePlayer.durationStream.listen((d) {
      setState(() {
        duration = d ?? Duration.zero;
      });
    });
    messagePlayer.positionStream.listen((p) {
      setState(() {
        position = p;
      });
    });
  }

  void setupPlaylist() {
    // Assuming audioSongs is a list of AudioMessage objects
    playlist = ConcatenatingAudioSource(children: [
      AudioSource.uri(Uri.parse(widget.audioSongs.audioUrl)),
      // Add more AudioSource items if there are multiple songs
    ]);
    loadMusic();
  }

  Future<void> loadMusic() async {
    try {
      await messagePlayer.setAudioSource(playlist);
    } catch (e) {
      _showMessage("Error loading audio: $e");
    }
  }

  // New functions for additional features

  void toggleShuffle() {
    setState(() {
      isShuffleOn = !isShuffleOn;
      messagePlayer.setShuffleModeEnabled(isShuffleOn);
    });
    _showMessage(isShuffleOn ? "Shuffle on" : "Shuffle off");
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontFamily: 'Playfair'),
        ),
        backgroundColor: Colors.black38,
      ),
    );
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  void dispose() {
    iconController.dispose();
    messagePlayer.dispose();
    super.dispose();
  }

  void toggleLoopMode() {
    setState(() {
      switch (loopMode) {
        case LoopMode.off:
          loopMode = LoopMode.one;
          _showMessage("Looping current track");
          break;
        case LoopMode.one:
          loopMode = LoopMode.all;
          _showMessage("Looping all tracks");
          break;
        case LoopMode.all:
          loopMode = LoopMode.off;
          _showMessage("Loop off");
          break;
      }
      messagePlayer.setLoopMode(loopMode);
    });
  }

  void playNext() {
    if (messagePlayer.hasNext) {
      messagePlayer.seekToNext();
    } else {
      _showMessage("No next track available");
    }
  }

  void playPrevious() {
    if (messagePlayer.hasPrevious) {
      messagePlayer.seekToPrevious();
    } else {
      _showMessage("No previous track available");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 17,
            )),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            widget.audioSongs.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Playfair'),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(widget.audioSongs.audioImage, fit: BoxFit.cover),
          const _BackgroundFIlter(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DecibelNoiseMeter(key: _decibelNoiseMeterKey),
                const SizedBox(
                  height: 20,
                ),
                Slider(
                  min: 0,
                  max: duration.inMilliseconds.toDouble(),
                  value: position.inMilliseconds.toDouble(),
                  onChanged: (value) async {
                    await messagePlayer
                        .seek(Duration(milliseconds: value.toInt()));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatDuration(position)),
                      Text(formatDuration(duration - position)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(isShuffleOn
                          ? Icons.shuffle_on_outlined
                          : Icons.shuffle),
                      onPressed: toggleShuffle,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: playPrevious,
                    ),
                    FloatingActionButton(
                      onPressed: () => animateIcon(),
                      child: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: iconController,
                        size: iconSize,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.skip_next,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: playNext,
                    ),
                    IconButton(
                      icon: Icon(loopMode == LoopMode.off
                          ? Icons.repeat
                          : (loopMode == LoopMode.one
                              ? Icons.repeat_one
                              : Icons.repeat)),
                      onPressed: toggleLoopMode,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void animateIcon() async {
    if (widget.audioSongs.audioUrl.isNotEmpty) {
      bool isConnected = await checkInternetConnection();

      if (!isConnected) {
        _showMessage('No Internet Connection');
        return;
      }

      setState(() {
        isPlaying = !isPlaying;
      });

      if (isPlaying) {
        await iconController.forward();
        await messagePlayer.play();
        _decibelNoiseMeterKey.currentState?.startAnimation();
      } else {
        await iconController.reverse();
        await messagePlayer.pause();
        _decibelNoiseMeterKey.currentState?.stopAnimation();
      }
    } else {
      _showMessage('Audio File not found');
    }
  }
}

class _BackgroundFIlter extends StatelessWidget {
  const _BackgroundFIlter();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstOut,
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.0)
            ],
            stops: const [
              0.0,
              0.4,
              0.6
            ]).createShader(rect);
      },
      child: Container(
        color: Theme.of(context).dialogBackgroundColor.withOpacity(0.7),
      ),
    );
  }
}
