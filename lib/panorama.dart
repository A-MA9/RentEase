import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

class PanoramaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("360° Panorama View")),
      body: Panorama(child: Image.asset("assets/panoramic_room_1.jpg")),
    );
  }
}

void main() {
  runApp(MaterialApp(home: PanoramaView()));
}
