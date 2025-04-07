// import 'package:flutter/material.dart';
// import 'package:panorama_viewer/panorama_viewer.dart';

// class PanoramaView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("360° Room View")),
//       body: Center(
//         child: PanoramaViewer(
//           child: Image.asset("assets/panoramic_room_1.jpg"),
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(home: PanoramaView()));
// }

// panorama.dart

import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

class PanoramaView extends StatelessWidget {
  final String imageUrl;

  const PanoramaView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("3D View")),
      body: Panorama(child: Image.network(imageUrl)),
    );
  }
}
