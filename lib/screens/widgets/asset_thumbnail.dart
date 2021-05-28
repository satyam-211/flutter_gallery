import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

import '../image_screen.dart';
import '../video_screen.dart';

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    Key key,
    @required this.asset,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: asset.thumbData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;

        if (bytes == null) return CircularProgressIndicator();

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  if (asset.type == AssetType.image) {
                    return ImageScreen(imageFile: asset.file);
                  } else {
                    return VideoScreen(videoFile: asset.file);
                  }
                },
              ),
            );
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.memory(bytes, fit: BoxFit.cover),
              ),
              if (asset.type == AssetType.video)
                Center(
                  child: Container(
                    color: Colors.blue,
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
