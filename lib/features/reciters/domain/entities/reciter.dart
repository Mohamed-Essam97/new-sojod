import 'package:equatable/equatable.dart';

class Reciter extends Equatable {
  const Reciter({
    required this.id,
    required this.name,
    required this.nameAr,
    this.imageUrl,
    this.isPopular = false,
    this.bitrate,
  });

  final String id;
  final String name;
  final String nameAr;
  final String? imageUrl;
  final bool isPopular;
  final String? bitrate;

  @override
  List<Object?> get props => [id, name, nameAr, imageUrl, isPopular, bitrate];
}
