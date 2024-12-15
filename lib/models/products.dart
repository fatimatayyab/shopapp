class Product {
  final String title;
  final String thumbnail;
  final double price;
  final double rating;
  final String brand;
  final String category;
  final String? description;
  int? stock;
    List<dynamic>? images;
  

  Product( {
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.rating,
    required this.brand,
    required this.category,
    required this.description,
    required this.stock,
    required this.images,

  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'] ?? 'No Title', // Providing a fallback value
      thumbnail: json['thumbnail'] ?? '', // Fallback to an empty string if null
      price: json['price'] ?? 0.0, // Fallback to 0.0 if price is null
      rating: json['rating'] ?? 0.0, // Fallback to 0.0 if rating is null
      brand: json['brand'] ?? '',
      category: json['category'] ?? '',
          description : json['description'] ?? '',
          stock : json['stock'] ?? '',
          images : json['images'] ?? '',



    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'thumbnail': thumbnail,
      'price': price,
      'rating': rating,
      'brand': brand,
      'category': category,
      'description' : description,
      'stock' : stock,
      'images' : images
    };
  }
  //   @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;
  //   return other is Product &&
  //       other.title == title &&
  //       other.price == price &&
  //       other.rating == rating &&
  //       other.brand == brand &&
  //       other.thumbnail == thumbnail &&
  //       other.category == category;
  // }

  // @override
  // int get hashCode {
  //   return title.hashCode ^ price.hashCode ^ rating.hashCode ^ brand.hashCode ^ thumbnail.hashCode ^ category.hashCode;
  // }
}



class Dimensions {
  final double width;
  final double height;
  final double depth;

  Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
      depth: json['depth'].toDouble(),
    );
  }
}

class Review {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'],
      comment: json['comment'],
      date: json['date'],
      reviewerName: json['reviewerName'],
      reviewerEmail: json['reviewerEmail'],
    );
  }
  
}
