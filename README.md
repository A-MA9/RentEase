# RentEase - Student Housing Made Easy

![RentEase Logo](assets/image.png)

## Overview

RentEase is a mobile application designed to bridge the gap between property owners and students/bachelors looking for rental accommodations. The platform provides a seamless experience for both property owners to list their rooms and seekers to find their perfect accommodation.

## Features

### For Property Owners

- Easy registration with email and phone verification
- Room listing with detailed information:
  - Location
  - Room size (1BHK, 2BHK, etc.)
  - Square footage
  - Room photos
  - Monthly rent
  - Minimum stay duration
  - Nearby amenities (stores, hospitals, etc.)
- Manage multiple property listings
- Track booking requests
- Secure payment collection

### For Room Seekers

- User-friendly registration process
- Location-based room search
- Advanced filtering options:
  - Price range
  - Room size
  - Amenities
  - Minimum stay duration
- Room booking with secure payment
- Save favorite listings
- View booking history

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Android Studio / VS Code
- Firebase account
- Google Maps API key

### Installation

1. Clone the repository

```bash
https://github.com/A-MA9/RentEase.git
```

2. Install dependencies

```bash
cd rentease
flutter pub get
```

3. Configure Firebase

- Create a new Firebase project
- Add Android and iOS apps
- Download and add configuration files
- Enable Authentication and Firestore

4. Set up environment variables

```bash
cp .env.example .env
# Add your configuration values
```

5. Run the app

```bash
flutter run
```

## Project Structure

```
lib/
├── models/          # Data models
├── screens/         # UI screens
├── services/        # Business logic
├── widgets/         # Reusable widgets
├── utils/          # Utility functions
└── main.dart       # Entry point
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- All contributors who have helped shape this project

## Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter)

Project Link: [https://github.com/yourusername/rentease](https://github.com/yourusername/rentease)

## Screenshots

[Add your app screenshots here]

---

Made with ❤️ by [Your Name]
