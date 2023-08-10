import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;

  const ImageView({
    Key? key,
    required this.imgUrl,
  }) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.imgUrl,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2,
                      color: Color(0xff1c1B1B).withOpacity(0.8),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.075,
                      width: MediaQuery.of(context).size.width / 2,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white60, width: 1),
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            Color(0x36FFFFFF),
                            Color(0x0FFFFFFF),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: _save,
                        child: Column(
                          children: [
                            Text(
                              "Set Wallpaper",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              "Image will be saved in gallery",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          )
        ],
      ),
    );
  }

  _save() async {
    await _askPermission();
    var response = await Dio().get(
      widget.imgUrl,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: "wallpaper_${DateTime.now().millisecondsSinceEpoch}.png");
    print(result);
    Navigator.pop(context);
  }

 _askPermission() async {
    if (Platform.isIOS) {
      /*Map<PermissionGroup, PermissionStatus> permissions =
          */await PermissionHandler()
              .requestPermissions([PermissionGroup.photos]);
    } else {
     /* PermissionStatus permission = */await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }
  }
}
