class Property {
  final String id;
  final String ownerId;
  final String title;
  final String propertyType;
  final String description;
  final String location;
  final double pricePerMonth;
  final int minStayMonths;
  final List<String> imageUrls;
  final List<String>? panoramicUrls;
  final bool isAvailable;
  final String createdAt;
  final String gender;
  final int roomsAvailable;
  final double? sizeSqft;
  
  // Amenities
  final bool tv;
  final bool fan;
  final bool ac;
  final bool chair;
  final bool ventilation;
  final bool ups;
  final bool sofa;
  final bool lamp;
  final int bath;
  
  // Optional owner info
  final String? ownerName;
  final String? ownerEmail;

  Property({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.propertyType,
    required this.description,
    required this.location,
    required this.pricePerMonth,
    required this.minStayMonths,
    required this.imageUrls,
    this.panoramicUrls,
    required this.isAvailable,
    required this.createdAt,
    required this.gender,
    required this.roomsAvailable,
    this.sizeSqft,
    required this.tv,
    required this.fan,
    required this.ac,
    required this.chair,
    required this.ventilation,
    required this.ups,
    required this.sofa,
    required this.lamp,
    required this.bath,
    this.ownerName,
    this.ownerEmail,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      ownerId: json['owner_id'],
      title: json['title'],
      propertyType: json['property_type'],
      description: json['description'] ?? '',
      location: json['location'],
      pricePerMonth: double.parse(json['price_per_month'].toString()),
      minStayMonths: json['min_stay_months'] ?? 1,
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      panoramicUrls: json['panoramic_urls'] != null 
          ? List<String>.from(json['panoramic_urls']) 
          : null,
      isAvailable: json['is_available'] ?? true,
      createdAt: json['created_at'],
      gender: json['gender'] ?? 'Both',
      roomsAvailable: json['rooms_available'] ?? 1,
      sizeSqft: json['size_sqft'] != null ? double.parse(json['size_sqft'].toString()) : null,
      tv: json['tv'] ?? false,
      fan: json['fan'] ?? false,
      ac: json['ac'] ?? false,
      chair: json['chair'] ?? false,
      ventilation: json['ventilation'] ?? false,
      ups: json['ups'] ?? false,
      sofa: json['sofa'] ?? false,
      lamp: json['lamp'] ?? false,
      bath: json['bath'] ?? 1,
      ownerName: json['owner_name'],
      ownerEmail: json['owner_email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'title': title,
      'property_type': propertyType,
      'description': description,
      'location': location,
      'price_per_month': pricePerMonth,
      'min_stay_months': minStayMonths,
      'image_urls': imageUrls,
      'panoramic_urls': panoramicUrls,
      'is_available': isAvailable,
      'created_at': createdAt,
      'gender': gender,
      'rooms_available': roomsAvailable,
      'size_sqft': sizeSqft,
      'tv': tv,
      'fan': fan,
      'ac': ac,
      'chair': chair,
      'ventilation': ventilation,
      'ups': ups,
      'sofa': sofa,
      'lamp': lamp,
      'bath': bath,
      if (ownerName != null) 'owner_name': ownerName,
      if (ownerEmail != null) 'owner_email': ownerEmail,
    };
  }
} 