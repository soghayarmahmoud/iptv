import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';

class MediaTvPlayerViewBody extends StatefulWidget {
  final String channelName;
  final String? streamUrl;
  final bool isLive;

  const MediaTvPlayerViewBody({
    super.key,
    required this.channelName,
    this.streamUrl,
    this.isLive = false,
  });

  @override
  State<MediaTvPlayerViewBody> createState() => _MediaTvPlayerViewBodyState();
}

class _MediaTvPlayerViewBodyState extends State<MediaTvPlayerViewBody> {
  late final Player _player;
  late final VideoController _videoController;
  String? _error;
  bool _isInitialized = false;
  bool _isPlaying = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _player = Player(
      configuration: PlayerConfiguration(
        title: widget.channelName,
        // Fix audio issues
        vo: 'gpu',
        // Suppress audio error logs
        logLevel: MPVLogLevel.error,
      ),
    );
    _videoController = VideoController(_player);

    if (widget.streamUrl != null && widget.streamUrl!.isNotEmpty) {
      _initPlayer(widget.streamUrl!);
    } else {
      _error = 'No stream URL provided';
    }

    // Listen to player errors (filter out audio device warnings)
    _player.stream.error.listen((error) {
      if (mounted) {
        final errorMsg = error.toString();
        // Ignore audio device initialization errors (they don't affect playback)
        if (!errorMsg.contains('audio device') &&
            !errorMsg.contains('no sound')) {
          setState(() {
            _error = 'Failed to load stream: $errorMsg';
          });
        }
      }
    });

    // Listen to player state
    _player.stream.buffering.listen((buffering) {
      if (mounted && !buffering && !_isInitialized) {
        setState(() {
          _isInitialized = true;
          _error = null;
          _retryCount = 0;
        });
      }
    });

    // Listen to playing state for play/pause toggle
    _player.stream.playing.listen((playing) {
      if (mounted) {
        setState(() {
          _isPlaying = playing;
        });
      }
    });
  }

  Future<void> _initPlayer(String url) async {
    if (!mounted) return;

    setState(() {
      _error = null;
      _isInitialized = false;
    });

    try {
      await _player.open(
        Media(
          url,
          httpHeaders: {
            'User-Agent':
                'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36',
            'Referer': 'https://api.beeplayer1.com/',
            'Origin': 'https://api.beeplayer1.com',
            'Accept': '*/*',
          },
        ),
        play: true,
      );

      // Set audio output configuration to fix audio device errors
      await _player.setAudioDevice(AudioDevice.auto());

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load stream: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _retryPlayer() async {
    if (_retryCount >= _maxRetries) return;

    setState(() {
      _error = null;
      _retryCount++;
    });

    final delay = Duration(seconds: _retryCount * 2);
    await Future.delayed(delay);

    if (mounted && widget.streamUrl != null) {
      await _initPlayer(widget.streamUrl!);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Builder(
        builder: (context) {
          if (_error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _error!,
                      style: TextStyles.font14Medium(
                        context,
                      ).copyWith(color: AppColors.subGreyColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_retryCount < _maxRetries)
                    TextButton(
                      onPressed: _retryPlayer,
                      child: Text(
                        'Retry (${_retryCount + 1}/$_maxRetries)',
                        style: TextStyles.font14Medium(
                          context,
                        ).copyWith(color: AppColors.yellowColor),
                      ),
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Return Back',
                      style: TextStyles.font14Medium(
                        context,
                      ).copyWith(color: AppColors.yellowColor),
                    ),
                  ),
                ],
              ),
            );
          }

          return Focus(
            autofocus: true,
            onKeyEvent: (node, event) {
              final key = event.logicalKey;
              // Play / Pause toggle
              if (key == LogicalKeyboardKey.mediaPlayPause ||
                  key == LogicalKeyboardKey.enter ||
                  key == LogicalKeyboardKey.select ||
                  key == LogicalKeyboardKey.space) {
                if (_isInitialized) {
                  if (_isPlaying) {
                    _player.pause();
                  } else {
                    _player.play();
                  }
                  return KeyEventResult.handled;
                }
              }

              // Back
              if (key == LogicalKeyboardKey.escape ||
                  key == LogicalKeyboardKey.goBack) {
                Navigator.maybePop(context);
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Video(
                      controller: _videoController,
                      controls: MaterialVideoControls,
                    ),
                  ),
                ),
                if (!_isInitialized)
                  Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.yellowColor,
                      ),
                    ),
                  ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: SafeArea(
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
