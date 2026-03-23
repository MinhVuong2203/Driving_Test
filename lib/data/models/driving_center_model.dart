class DrivingCenter {

  String name;
  String phone_number;
  String photo_url;
  String website;
  double rating;
  int review_count;
  String business_status;
  String address;
  String district;
  String city;
  String opening_status;

  DrivingCenter(
      this.name,
      this.phone_number,
      this.photo_url,
      this.website,
      this.rating,
      this.review_count,
      this.business_status,
      this.address,
      this.district,
      this.city,
      this.opening_status);

  factory DrivingCenter.fromJson(Map<String, dynamic> json) {
    String photoUrl = '';
    if (json['photos_sample'] != null && json['photos_sample'].length > 0) {
      photoUrl = json['photos_sample'][0]['photo_url'] ?? '';
    }

    return DrivingCenter(
      json['name'] ?? '',
      json['phone_number'] ?? '',
      photoUrl,
      json['website'] ?? '',
      (json['rating'] ?? 0).toDouble(),
      json['review_count'] ?? 0,
      json['business_status'] ?? '',
      json['address'] ?? '',
      json['district'] ?? '',
      json['city'] ?? '',
      json['opening_status'] ?? '',
    );
  }
}