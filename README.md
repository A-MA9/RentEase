# Rentease 🏠📱


## Badges

![Flutter Version](https://img.shields.io/badge/Flutter-3.16.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-orange.svg)
![Backend](https://img.shields.io/badge/Backend-FastAPI-009688.svg)
![Database](https://img.shields.io/badge/Database-AWS%20DynamoDB-FF9900.svg)

**Rentease** is a mobile app designed to simplify the search for rental properties like PGs, dorms, and houses. It connects seekers, owners, and even previous tenants in a smooth, interactive experience with modern UI, real-time chat, property listings, and smart search filters.

## 🚀 Features

### For Seekers:
- 🔍 Search properties by location, price, amenities, and property type
- 📍 Location-based recommendations
- 💬 Chat with owners in real-time
- 🗣️ **Chat with previous tenants** to get honest reviews and experiences
- 🖼️ **View both standard photos and immersive 3D panoramic room views**
- 🏷️ Transparent display of pricing, amenities (TV, AC, fan, etc.)

### For Owners:
- 🏡 List new properties with images and amenities
- ✏️ Edit or remove existing listings
- 📊 View responses and chat with potential seekers
- 🧭 Custom bottom navigation for easy access (Search, Properties, Home, Chat, Profile)

## 🛠 Tech Stack

- **Frontend**: Flutter
- **Backend**: FastAPI (Python)
- **Database**: AWS DynamoDB
- **Storage**: AWS S3 for images and media
- **Hosting**: Currently using **ngrok** for development; will shift to **EC2** for production
- **Media**: 
  - Multi-image picker for standard photos
  - `panorama_viewer` Flutter package for **3D panoramic room views**
- **Authentication**: Secure user login and registration system

## 📦 Download APK

👉 [Download Rentease APK](https://drive.google.com/file/d/1qfVJGNrQm5P3yGrd835gByfp6BDbj1gp/view?usp=sharing)
