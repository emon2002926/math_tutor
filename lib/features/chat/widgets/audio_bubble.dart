import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' show AudioPlayer, ProcessingState;


class AudioBubble extends StatefulWidget {
  final String? localPath;
  final String? remoteUrl;
  const AudioBubble({super.key, this.localPath, this.remoteUrl});

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  late final AudioPlayer _player;
  bool _isPlaying = false;
  bool _isLoading = true;   // true while audio source is being prepared
  bool _hasError = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();

    _player.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state.playing &&
            state.processingState != ProcessingState.completed;
        // Still buffering after source is set
        _isLoading = state.processingState == ProcessingState.loading ||
            state.processingState == ProcessingState.buffering;
      });
    });

    _player.durationStream.listen((d) {
      if (mounted) setState(() => _duration = d ?? Duration.zero);
    });

    _player.positionStream.listen((p) {
      if (mounted) setState(() => _position = p);
    });
  }

  Future<void> _initAudio() async {
    try {
      if (widget.localPath != null) {
        await _player.setFilePath(widget.localPath!);
      } else if (widget.remoteUrl != null) {
        final url = widget.remoteUrl!.startsWith('http')
            ? widget.remoteUrl!
            : 'https://mathapi.dsrt321.online${widget.remoteUrl}';
        await _player.setUrl(url);
      }
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _duration.inMilliseconds > 0
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2A44),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ── Play / Pause / Loading button ──────────────────────────
          GestureDetector(
            onTap: _isLoading || _hasError
                ? null
                : () async {
              if (_isPlaying) {
                await _player.pause();
              } else {
                if (_player.processingState ==
                    ProcessingState.completed) {
                  await _player.seek(Duration.zero);
                }
                await _player.play();
              }
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: _hasError
                  ? const Icon(Icons.error_outline,
                  color: Colors.redAccent, size: 18)
                  : _isLoading
                  ? Padding(
                padding: const EdgeInsets.all(9),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: const Color(0xFF1F2A44),
                ),
              )
                  : Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: const Color(0xFF1F2A44),
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ── Progress bar + timestamp ────────────────────────────────
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: _isLoading
                  // Indeterminate bar while loading
                      ? LinearProgressIndicator(
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white54),
                    minHeight: 3,
                  )
                      : LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white),
                    minHeight: 3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isLoading
                      ? 'Loading…'
                      : _hasError
                      ? 'Unavailable'
                      : '${_fmt(_position)} / ${_fmt(_duration)}',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}