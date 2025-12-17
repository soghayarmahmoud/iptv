import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';
import 'package:iptv/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class TvPlayerViewBody extends StatefulWidget {
  final String channelName;
  final String? streamUrl;
  final bool isLive;
  const TvPlayerViewBody({
    super.key,
    required this.channelName,
    this.streamUrl,
    this.isLive = false,
  });

  @override
  State<TvPlayerViewBody> createState() => _TvPlayerViewBodyState();
}

class _TvPlayerViewBodyState extends State<TvPlayerViewBody> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  String? _error;
  bool _wasFullscreen = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    // Force lock orientation to landscape
    _setLandscapeOrientation();

    if (widget.streamUrl != null && widget.streamUrl!.isNotEmpty) {
      _initPlayer(widget.streamUrl!, widget.isLive);
    } else {
      _error = 'No stream URL provided';
    }
  }

  void _setLandscapeOrientation() {
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _initPlayer(String url, bool isLive) async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
      _error = null;
    });

    try {
      // Dispose previous controllers
      await _disposeControllers();

      final bool isHls = url.toLowerCase().contains('.m3u8');

      // Android-specific: Add delay before initialization to allow system preparation
      await Future.delayed(const Duration(milliseconds: 300));

      // Create video controller with proper headers and options
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
        formatHint: isHls ? VideoFormat.hls : VideoFormat.other,
        httpHeaders: {
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36',
          'Accept': '*/*',
          'Connection': 'keep-alive',
          'Accept-Encoding': 'identity',
        },
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );

      // Add error listener
      controller.addListener(() {
        if (!mounted) return;
        final value = controller.value;
        if (value.hasError) {
          setState(() {
            _error = value.errorDescription ?? 'Failed to load stream';
            _isInitializing = false;
          });
        }
      });

      // Initialize with extended timeout
      await controller.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Stream initialization timeout');
        },
      );

      if (!mounted) {
        controller.dispose();
        return;
      }

      // Set volume to ensure audio session is configured
      await controller.setVolume(1.0);

      // Android-specific: Longer buffer wait for ExoPlayer
      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) {
        controller.dispose();
        return;
      }

      // Create Chewie controller
      final chewie = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        looping: false,
        autoInitialize: true,
        allowMuting: true,
        isLive: isHls && isLive,
        showControls: true,
        allowFullScreen: true,
        deviceOrientationsOnEnterFullScreen: const [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        deviceOrientationsAfterFullScreen: const [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        systemOverlaysOnEnterFullScreen: const [],
        cupertinoProgressColors: ChewieProgressColors(
          playedColor: Colors.yellow,
          handleColor: Colors.white,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white38,
        ),
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.yellowColor,
          handleColor: AppColors.whiteColor,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white38,
        ),
        errorBuilder: (context, message) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.subGreyColor,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  _error ?? 'Failed to load stream',
                  style: TextStyles.font14Medium(
                    context,
                  ).copyWith(color: AppColors.subGreyColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _retryCount < _maxRetries ? _retryPlayer : null,
                  child: Text(
                    _retryCount < _maxRetries
                        ? 'Retry (${_retryCount + 1}/$_maxRetries)'
                        : 'Max retries reached',
                    style: TextStyles.font14Medium(context).copyWith(
                      color: _retryCount < _maxRetries
                          ? AppColors.yellowColor
                          : AppColors.subGreyColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

      if (!mounted) {
        chewie.dispose();
        controller.dispose();
        return;
      }

      setState(() {
        _videoController = controller;
        _chewieController = chewie;
        _error = null;
        _retryCount = 0;
        _isInitializing = false;
      });

      // Enter fullscreen after ensuring video is playing
      _scheduleFullscreenEntry();
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _error = 'Connection timeout. Please check your internet connection.';
          _isInitializing = false;
        });
      }
    } on FormatException catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Invalid stream format: ${e.message}';
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load stream: ${e.toString()}';
          _isInitializing = false;
        });
      }
    }
  }

  void _scheduleFullscreenEntry() {
    // Wait for video to start playing before entering fullscreen
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_videoController != null &&
          _videoController!.value.isPlaying &&
          _chewieController != null) {
        timer.cancel();

        // Additional delay to ensure smooth transition
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && _chewieController != null) {
            _chewieController!.enterFullScreen();
            _wasFullscreen = true;
            _chewieController!.addListener(_handleFullscreenChange);
          }
        });
      }

      // Safety timeout after 5 seconds
      if (timer.tick > 25) {
        timer.cancel();
        if (mounted && _chewieController != null) {
          _chewieController!.enterFullScreen();
          _wasFullscreen = true;
          _chewieController!.addListener(_handleFullscreenChange);
        }
      }
    });
  }

  Future<void> _disposeControllers() async {
    if (_chewieController != null) {
      _chewieController!.removeListener(_handleFullscreenChange);
      _chewieController!.dispose();
      _chewieController = null;
    }
    if (_videoController != null) {
      await _videoController!.pause();
      _videoController!.dispose();
      _videoController = null;
    }
  }

  Future<void> _retryPlayer() async {
    if (_retryCount >= _maxRetries || _isInitializing) return;

    setState(() {
      _error = null;
      _retryCount++;
    });

    // Exponential backoff delay
    final delay = Duration(seconds: _retryCount * 2);
    await Future.delayed(delay);

    if (mounted) {
      await _initPlayer(widget.streamUrl!, widget.isLive);
    }
  }

  void _handleFullscreenChange() {
    final controller = _chewieController;
    if (controller == null) return;

    final bool isFull = controller.isFullScreen;

    if (_wasFullscreen && !isFull) {
      // User exited fullscreen - maintain landscape orientation until navigation completes
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]).then((_) {
        if (mounted) {
          Navigator.of(context).maybePop();
        }
      });
    }

    _wasFullscreen = isFull;
  }

  @override
  void dispose() {
    _chewieController?.exitFullScreen();
    _disposeControllers();

    // Restore default orientations and UI mode
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Builder(
            builder: (context) {
              // Show error state
              if (_error != null && !_isInitializing) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.subGreyColor,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          S.current.be_ready,
                          style: TextStyles.font14Medium(
                            context,
                          ).copyWith(color: AppColors.subGreyColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_retryCount < _maxRetries)
                        ElevatedButton.icon(
                          onPressed: _retryPlayer,
                          icon: const Icon(Icons.play_arrow),
                          label: Text(S.current.start),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.yellowColor,
                            foregroundColor: Colors.black,
                          ),
                        )
                      else
                        Text(
                          'Max retries reached',
                          style: TextStyles.font14Medium(
                            context,
                          ).copyWith(color: AppColors.subGreyColor),
                        ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          S.current.return_back,
                          style: TextStyles.font14Medium(
                            context,
                          ).copyWith(color: AppColors.yellowColor),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show loading state
              if (_chewieController == null || _isInitializing) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: AppColors.yellowColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${S.current.loading} ${widget.channelName}',
                        style: TextStyles.font14Medium(
                          context,
                        ).copyWith(color: AppColors.subGreyColor),
                      ),
                    ],
                  ),
                );
              }

              // Show player with remote key handlers
              return Focus(
                autofocus: true,
                onKeyEvent: (node, event) {
                  final key = event.logicalKey;
                  // Play/Pause
                  if (key == LogicalKeyboardKey.mediaPlayPause ||
                      key == LogicalKeyboardKey.select ||
                      key == LogicalKeyboardKey.enter ||
                      key == LogicalKeyboardKey.space) {
                    if (_videoController != null) {
                      if (_videoController!.value.isPlaying) {
                        _videoController!.pause();
                      } else {
                        _videoController!.play();
                      }
                      return KeyEventResult.handled;
                    }
                  }

                  // Seek right
                  if (key == LogicalKeyboardKey.arrowRight) {
                    if (_videoController != null) {
                      final pos = _videoController!.value.position;
                      _videoController!.seekTo(
                        pos + const Duration(seconds: 10),
                      );
                      return KeyEventResult.handled;
                    }
                  }

                  // Seek left
                  if (key == LogicalKeyboardKey.arrowLeft) {
                    if (_videoController != null) {
                      final pos = _videoController!.value.position;
                      final newPos = pos - const Duration(seconds: 10);
                      _videoController!.seekTo(
                        newPos >= Duration.zero ? newPos : Duration.zero,
                      );
                      return KeyEventResult.handled;
                    }
                  }

                  // Back / Exit fullscreen
                  if (key == LogicalKeyboardKey.escape ||
                      key == LogicalKeyboardKey.goBack) {
                    if (_chewieController != null &&
                        _chewieController!.isFullScreen) {
                      _chewieController!.exitFullScreen();
                      return KeyEventResult.handled;
                    }
                    Navigator.maybePop(context);
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: Chewie(controller: _chewieController!),
              );
            },
          ),
        ),
      ),
    );
  }
}

