import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaperhub/model/category_model.dart';
import 'package:wallpaperhub/model/image_view.dart';
import 'package:wallpaperhub/model/wallpaper_model.dart';
import 'package:wallpaperhub/views/category.dart';
import 'package:wallpaperhub/views/data/data.dart';
import 'package:wallpaperhub/views/search.dart';
import 'package:wallpaperhub/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  

  List<CategorieModel> categories=[];
  List<WallpaperModel> wallpaper=[];

  TextEditingController searchQuery= TextEditingController();

getTrendingWallpapers() async {
  var response = await http.get(
    Uri.parse( "https://api.pexels.com/v1/curated?per_page=&page=1",),
    headers: {
      "Authorization": apiKey,
    },
  );
         

  
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> photos = jsonData["photos"];

    List<WallpaperModel> wallpapers = [];
    photos.forEach((photo) {
      WallpaperModel wallpaperModel = WallpaperModel.fromMap(photo);
      wallpapers.add(wallpaperModel);
    });

    setState(() {
        wallpaper = wallpapers;

    });
  } else {
    print("Failed to fetch data from the API.");
  }
}


  @override
  void initState() {
    categories=getCategory();
    getTrendingWallpapers();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: BrandName(),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.symmetric(horizontal: 24),
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchQuery,
                        decoration: InputDecoration(
                          hintText: "Search wallpaper",
                          border: InputBorder.none
                        ),
                      
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Search(searchQuery: searchQuery.text),));
                      },
                      child: Container(
                        child: Icon(Icons.search)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Container(
                height: 90,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                  
                  return CategoriesTile(
                    
                    imgUrl: categories[index].imgUrl.toString(),
                   title: categories[index].categorieName.toString());
                },
                itemCount: categories.length,),
              ),
              wallpapersList(wallpaper, context)
            ],
      
          ),
        ),
      ),

    );
  }
}
class CategoriesTile extends StatelessWidget {
  final String imgUrl,title;

  const CategoriesTile({super.key, required this.imgUrl, required this.title});

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Category(categorieName: title.toLowerCase()),));
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(imgUrl,height: 50,width: 100,fit: BoxFit.cover,),
            ),
            Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8)
    
              ),
              alignment: Alignment.center,
              child: Text(title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
            )
          ],
        ),
      ),
    );
  }
}