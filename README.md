# Rentease 🏠📱


## Badges

![Flutter Version](https://img.shields.io/badge/Flutter-3.16.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-orange.svg)
![Backend](https://img.shields.io/badge/Backend-FastAPI-009688.svg)
![Database](https://img.shields.io/badge/Database-AWS%20DynamoDB-FF9900.svg)

## 📦 Download APK

[![Download Rentease APK](https://www.playit.app/public/img/download_apk.fb5c471b.png)](https://drive.google.com/file/d/1qfVJGNrQm5P3yGrd835gByfp6BDbj1gp/view?usp=sharing)

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



## Acknowledgements

- [Flutter Team](https://flutter.dev)
- [FastAPI](https://fastapi.tiangolo.com)
- [AWS](https://aws.amazon.com)
- [Open Source Community](https://opensource.org)
- [Ngrok](https://ngrok.com)
- [Material Design](https://material.io)
- [Icons8](https://icons8.com)
- [Stack Overflow](https://stackoverflow.com)
- [GitHub](https://github.com)

## API Reference

#### Get All Properties

```http
GET /api/properties
```

| Parameter  | Type     | Description                          |
| :--------- | :------- | :----------------------------------- |
| `api_key`  | `string` | **Required**. Your API key for authentication. |
| `location` | `string` | **Optional**. Filter properties by location. |
| `type`     | `string` | **Optional**. Filter properties by type (e.g., apartment, house). |

#### Get Property Details

```http
GET /api/properties/${id}
```

| Parameter | Type     | Description                          |
| :-------- | :------- | :----------------------------------- |
| `id`      | `string` | **Required**. Id of the property to fetch details for. |

#### Add Property

```http
POST /api/properties
```

| Parameter      | Type     | Description                          |
| :------------- | :------- | :----------------------------------- |
| `api_key`      | `string` | **Required**. Your API key for authentication. |
| `title`        | `string` | **Required**. Title of the property. |
| `description`  | `string` | **Required**. Description of the property. |
| `price`        | `number` | **Required**. Price of the property. |
| `location`     | `string` | **Required**. Location of the property. |
| `images`       | `array`  | **Optional**. Array of image URLs for the property. |

#### Update Property

```http
PUT /api/properties/${id}
```

| Parameter | Type     | Description                          |
| :-------- | :------- | :----------------------------------- |
| `id`      | `string` | **Required**. Id of the property to update. |
| `api_key` | `string` | **Required**. Your API key for authentication. |
| `title`    | `string` | **Optional**. Updated title of the property. |
| `description` | `string` | **Optional**. Updated description of the property. |
| `price`    | `number` | **Optional**. Updated price of the property. |
| `location` | `string` | **Optional**. Updated location of the property. |

#### Delete Property

```http
DELETE /api/properties/${id}
```

| Parameter | Type     | Description                          |
| :-------- | :------- | :----------------------------------- |
| `id`      | `string` | **Required**. Id of the property to delete. |
| `api_key` | `string` | **Required**. Your API key for authentication. |

## Authors

- [@AnuragSuthar](https://github.com/AnuragSuthar)
- [@A-MA9](https://github.com/A-MA9)
- [@CodeGovindz](https://github.com/CodeGovindz)

