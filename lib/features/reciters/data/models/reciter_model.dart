import '../../domain/entities/reciter.dart';

class ReciterModel extends Reciter {
  const ReciterModel({
    required super.id,
    required super.name,
    required super.nameAr,
    super.imageUrl,
    super.isPopular,
    super.bitrate,
  });

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    return ReciterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
      imageUrl: json['imageUrl'] as String?,
      isPopular: json['isPopular'] as bool? ?? false,
      bitrate: json['bitrate'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameAr': nameAr,
        'imageUrl': imageUrl,
        'isPopular': isPopular,
        'bitrate': bitrate,
      };
}
