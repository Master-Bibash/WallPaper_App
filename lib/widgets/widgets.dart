import 'package:flutter/material.dart';
import 'package:wallpaperhub/model/image_view.dart';

import '../model/wallpaper_model.dart';

Widget BrandName() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      RichText(text: TextSpan(
        style: TextStyle(fontSize: 20),
        children: [
          TextSpan(text: "WallPaper",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)),
                TextSpan(text: "Hub",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.w500))

        ]
      )),
    ],
  );
}

Widget wallpapersList(List<WallpaperModel> wallpapers, context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: wallpapers.map((wallpaperItem) {
        return GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageView(imgUrl: wallpaperItem.src.portrait),
                ),
              );
            },
            child: Hero(
              tag: wallpaperItem.src.portrait,
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.network(
                    wallpaperItem.src.portrait,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

