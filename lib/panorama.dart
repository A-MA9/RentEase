import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class PanoramaView extends StatelessWidget {
  final String imageUrl;

  const PanoramaView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("3D View"),
        backgroundColor: Colors.blueGrey[800],
        elevation: 2,
      ),
      body: PanoramaViewer(
        sensorControl: SensorControl.none,
        interactive: true,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.error, color: Colors.red));
          },
        ),
      ),
    );
  }
}
