import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetailPage extends StatefulWidget {
  final String youtubeUrl;
  final VoidCallback onFinished;

  const VideoDetailPage({
    Key? key,
    required this.youtubeUrl,
    required this.onFinished,
  }) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late YoutubePlayerController _controller;
  bool _isVideoEnded = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        enableCaption: true,
        hideControls: false,
        controlsVisibleAtStart: true,
      ),
    )..addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller.value.isReady &&
        !_controller.value.isPlaying &&
        _controller.value.position >= _controller.metadata.duration &&
        !_isVideoEnded) {
      _isVideoEnded = true;
      widget.onFinished();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.pause(); // Hindari error Android platform view
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blue,
        onReady: () => debugPrint('Youtube Player is ready'),
        onEnded: (_) {
          if (!_isVideoEnded) {
            _isVideoEnded = true;
            widget.onFinished();
          }
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Video Materi"),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Video Player
                Card(
                  margin: const EdgeInsets.all(16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: player,
                  ),
                ),

                // Button Finish
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text('Selesai Menonton'),
                    onPressed: () {
                      if (!_isVideoEnded) {
                        widget.onFinished();
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
