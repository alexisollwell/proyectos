class Track {
  final String id;
  final String name;
  final String artist;
  final String imageUrl;
  final String? previewUrl;

  Track({
    required this.id,
    required this.name,
    required this.artist,
    required this.imageUrl,
    this.previewUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json["id"],
      name: json["name"],
      artist: (json["artists"] as List).isNotEmpty
          ? json["artists"][0]["name"]
          : "Unknown Artist",
      imageUrl: (json["album"]["images"] as List).isNotEmpty
          ? json["album"]["images"][0]["url"]
          : "",
      previewUrl: json["preview_url"], // ⚠️
    );
  }
}