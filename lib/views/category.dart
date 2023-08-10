// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:wallpaperhub/views/data/data.dart';
import 'package:wallpaperhub/widgets/widgets.dart';

import '../model/wallpaper_model.dart';

class Category extends StatefulWidget {
final String categorieName;
  const Category({
    Key? key,
    required this.categorieName,
  }) : super(key: key);
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
    TextEditingController searchController = TextEditingController();

  
List<WallpaperModel> wallpaper =[];
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
    // TODO: implement initState
    getSearchWallpaper(widget.categorieName);
    super.initState();
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
      )
    );
  }
}