// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaperhub/views/data/data.dart';
import 'package:wallpaperhub/widgets/widgets.dart';
import 'package:http/http.dart' as http;

import '../model/category_model.dart';
import '../model/wallpaper_model.dart';

class Search extends StatefulWidget {
  const Search({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);
  final String searchQuery;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<WallpaperModel> wallpaper = [];
  TextEditingController searchController = TextEditingController();

  getSearchWallpaper(String query) async {
    var response = await http.get(
      Uri.parse("https://api.pexels.com/v1/search?query=$query"),
      headers: {"Authorization": apiKey},
    );
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> photos = jsonData["photos"];

    List<WallpaperModel> wallpapers = [];
    photos.forEach((photo) {
      WallpaperModel wallpaperModel = WallpaperModel.fromMap(photo);
      wallpapers.add(wallpaperModel);
    });

    // Update the state with the fetched wallpapers
    setState(() {
      wallpaper = wallpapers;
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the getSearchWallpaper method with the initial search query
    getSearchWallpaper(widget.searchQuery);
    searchController.text = widget.searchQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BrandName(),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24),
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "search wallpaper",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Fetch wallpapers when the search icon is tapped
                        getSearchWallpaper(searchController.text);
                      },
                      icon: Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              wallpapersList(wallpaper, context),
            ],
          ),
        ),
      ),
   
    );
  }}