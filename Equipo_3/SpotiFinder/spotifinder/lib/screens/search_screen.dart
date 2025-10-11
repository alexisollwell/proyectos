import 'package:flutter/material.dart';
import '../services/spotify_service.dart';
import '../models/track.dart';
import '../widgets/track_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SpotifyService _spotifyService = SpotifyService();
  final TextEditingController _controller = TextEditingController();
  List<Track> _results = [];
  bool _loading = false;

  void _search() async {
    setState(() => _loading = true);
    try {
      final data = await _spotifyService.searchSpotify(_controller.text);
      setState(() => _results = data);
    } catch (e) {
      print("Error: $e");
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar en Spotify")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Ingresa artista o canción...",
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _search,
              child: const Text("Buscar"),
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        return TrackCard(track: _results[index]);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
