// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WallpaperModel {
  String photographer;
  String photographer_url;
  int photographer_id;
  SrcModel src;

  WallpaperModel(this.photographer, this.photographer_id, this.photographer_url, this.src);

  factory WallpaperModel.fromMap(Map<String, dynamic> jsonData) {
    return WallpaperModel(
      jsonData["photographer"],
      jsonData["photographer_id"],
      jsonData["photographer_url"],
      SrcModel.fromMap(jsonData["src"]),
    );
  }
}

class SrcModel {
  String original;
  String small;
  String portrait;

  SrcModel({required this.original, required this.small, required this.portrait});

  factory SrcModel.fromMap(Map<String, dynamic> jsonData) {
    return SrcModel(
      original: jsonData["original"],
      small: jsonData["small"],
      portrait: jsonData["portrait"],
    );
  }
}
