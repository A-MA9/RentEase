import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// A utility class that provides standardized loading animations for the app.
/// This centralizes all animations in one place for consistency and easy updates.
class LoadingAnimations {
  // Primary loading animation for full screen/main content loading
  static Widget primaryLoading({Color? color, double size = 50.0}) {
    return SpinKitDoubleBounce(
      color: color ?? Colors.brown,
      size: size,
    );
  }

  // Secondary loading animation for smaller components or inline loading
  static Widget secondaryLoading({Color? color, double size = 24.0}) {
    return SpinKitThreeBounce(
      color: color ?? Colors.brown,
      size: size,
    );
  }

  // Loading animation for buttons or small components
  static Widget buttonLoading({Color? color, double size = 24.0}) {
    return SpinKitThreeBounce(
      color: color ?? Colors.white,
      size: size,
    );
  }

  // Loading animation for image loading
  static Widget imageLoading({Color? color, double size = 40.0}) {
    return SpinKitPulse(
      color: color ?? Colors.brown,
      size: size,
    );
  }

  // Loading animation for profile or user data loading
  static Widget profileLoading({Color? color, double size = 50.0}) {
    return SpinKitFoldingCube(
      color: color ?? Colors.brown,
      size: size,
    );
  }

  // Loading animation for data fetching or API calls
  static Widget dataLoading({Color? color, double size = 40.0}) {
    return SpinKitWave(
      color: color ?? Colors.brown,
      size: size,
      itemCount: 5,
    );
  }

  // Loading animation for panorama or 3D content
  static Widget panoramaLoading({Color? color, double size = 50.0}) {
    return SpinKitRing(
      color: color ?? Colors.brown,
      size: size,
      lineWidth: 4.0,
    );
  }

  // Loading animation for authentication or security-related operations
  static Widget authLoading({Color? color, double size = 35.0}) {
    return SpinKitPouringHourGlass(
      color: color ?? Colors.brown,
      size: size,
    );
  }

  // Loading animation for favorites or like-related operations
  static Widget favoriteLoading({Color? color, double size = 24.0}) {
    return SpinKitFadingCircle(
      color: color ?? Colors.grey,
      size: size,
    );
  }

  // Loading animation for searching or filtering operations
  static Widget searchLoading({Color? color, double size = 40.0}) {
    return SpinKitCircle(
      color: color ?? Colors.brown,
      size: size,
    );
  }
  
  // Loading animation for uploading content
  static Widget uploadLoading({Color? color, double size = 40.0}) {
    return SpinKitCubeGrid(
      color: color ?? Colors.brown,
      size: size,
    );
  }

  // Show full screen loading overlay
  static Widget fullScreenLoading(BuildContext context, {Color? color}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black54,
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitFadingCube(
                  color: color ?? Colors.brown,
                  size: 50.0,
                ),
                const SizedBox(height: 16),
                Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Demo widget that shows all available animations
  static Widget animationShowcase() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loading Animation Showcase"),
        backgroundColor: Colors.brown,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        padding: EdgeInsets.all(16.0),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: [
          _showcaseItem("Primary", primaryLoading()),
          _showcaseItem("Secondary", secondaryLoading()),
          _showcaseItem("Button", buttonLoading(color: Colors.brown)),
          _showcaseItem("Image", imageLoading()),
          _showcaseItem("Profile", profileLoading()),
          _showcaseItem("Data", dataLoading()),
          _showcaseItem("Panorama", panoramaLoading()),
          _showcaseItem("Auth", authLoading()),
          _showcaseItem("Favorite", favoriteLoading()),
          _showcaseItem("Search", searchLoading()),
          _showcaseItem("Upload", uploadLoading()),
        ],
      ),
    );
  }

  static Widget _showcaseItem(String title, Widget animation) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          animation,
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
} 