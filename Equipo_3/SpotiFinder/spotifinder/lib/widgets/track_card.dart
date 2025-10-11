import 'package:flutter/material.dart';
import '../models/track.dart';
import '../services/audio_manager.dart';

class TrackCard extends StatefulWidget {
  final Track track;

  const TrackCard({super.key, required this.track});

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  final AudioManager _audioManager = AudioManager();

  @override
  void initState() {
    super.initState();
    _audioManager.init(() {
      setState(() {}); // refresca la UI cuando termine
    });
  }

  void _togglePlay() async {
    if (widget.track.previewUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay preview disponible")),
      );
      return;
    }

    if (_audioManager.isPlaying(widget.track.id)) {
      await _audioManager.stop();
      setState(() {});
    } else {
      await _audioManager.play(widget.track.id, widget.track.previewUrl!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _audioManager.isPlaying(widget.track.id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: widget.track.imageUrl.isNotEmpty
            ? Image.network(widget.track.imageUrl, width: 50, height: 50)
            : const Icon(Icons.music_note),
        title: Text(widget.track.name),
        subtitle: Text(widget.track.artist),
        trailing: IconButton(
          icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
          onPressed: _togglePlay,
        ),
      ),
    );
  }
}
