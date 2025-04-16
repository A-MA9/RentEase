# RentEase Loading Animations Guide

This guide demonstrates how to use the centralized loading animations in the RentEase app.

## Basic Usage

1. Import the loading animations utility:
```dart
import 'utils/loading_animations.dart';
```

2. Use the animations in your code:
```dart
// In a loading state
if (isLoading) {
  return Center(
    child: LoadingAnimations.primaryLoading(),
  );
}
```

## Available Animation Types

### Primary Loading (Full Screen)
```dart
LoadingAnimations.primaryLoading()
```
Use for main content loading or full-screen loading states.

### Secondary Loading (Small Components)
```dart
LoadingAnimations.secondaryLoading()
```
Use for loading smaller UI components.

### Button Loading
```dart
LoadingAnimations.buttonLoading()
```
Use inside buttons during form submission.

### Image Loading
```dart
LoadingAnimations.imageLoading()
```
Use when loading images.

### Profile Loading
```dart
LoadingAnimations.profileLoading()
```
Use when loading user profile data.

### Data Loading
```dart
LoadingAnimations.dataLoading()
```
Use when fetching data from APIs.

### Panorama Loading
```dart
LoadingAnimations.panoramaLoading()
```
Use when loading panorama or 3D content.

### Authentication Loading
```dart
LoadingAnimations.authLoading()
```
Use during login, signup, or authentication processes.

### Favorite Loading
```dart
LoadingAnimations.favoriteLoading()
```
Use when toggling favorites or similar actions.

### Search Loading
```dart
LoadingAnimations.searchLoading()
```
Use when performing search operations.

### Upload Loading
```dart
LoadingAnimations.uploadLoading()
```
Use when uploading files or content.

### Full Screen Loading Overlay
```dart
LoadingAnimations.fullScreenLoading(context)
```
Use to show a modal loading overlay.

## Customizing Animations

All animations accept optional parameters:
- `color`: Customize the animation color (default is brown for most animations)
- `size`: Customize the animation size

Example:
```dart
LoadingAnimations.primaryLoading(
  color: Colors.blue,
  size: 60.0,
)
```

## Animation Showcase

To see all animations in one screen, use the AnimationShowcasePage:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => AnimationShowcasePage())
);
```

This will display a grid with all available loading animations. 