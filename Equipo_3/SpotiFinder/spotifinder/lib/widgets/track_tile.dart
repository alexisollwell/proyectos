import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TrackTile extends StatefulWidget {
  final Map<String, dynamic> track;
  const TrackTile({super.key, required this.track});

  @override
  State<TrackTile> createState() => _TrackTileState();
}

class _TrackTileState extends State<TrackTile> {
  final AudioPlayer player = AudioPlayer();

  void playPreview() async {
    if (widget.track["preview_url"] == null) return;
    await player.stop();
    await player.play(UrlSource(widget.track["preview_url"]));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(widget.track["image"], width: 50, height: 50),
      title: Text(widget.track["name"]),
      subtitle: Text(widget.track["artist"]),
      trailing: IconButton(
        icon: const Icon(Icons.play_arrow),
        onPressed: playPreview,
      ),
    );
  }
}
