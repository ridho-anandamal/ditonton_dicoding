// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class NetworkModel extends Equatable {
  NetworkModel({
    required this.name,
    required this.id,
    required this.logoPath,
    required this.originCountry,
  });

  String? name;
  int id;
  String? logoPath;
  String? originCountry;

  factory NetworkModel.fromJson(Map<String, dynamic> json) => NetworkModel(
        name: json["name"],
        id: json["id"],
        logoPath: json["logo_path"],
        originCountry: json["origin_country"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "logo_path": logoPath,
        "origin_country": originCountry,
      };

  @override
  List<Object?> get props => [
        name,
        id,
        logoPath,
        originCountry,
      ];
}
