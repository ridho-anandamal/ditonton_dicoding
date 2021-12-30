import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TVTable extends Equatable {
  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;

  TVTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  factory TVTable.fromMap(Map<String, dynamic> map) => TVTable(
        id: map['id'],
        name: map['name'],
        posterPath: map['posterPath'],
        overview: map['overview'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'posterPath': posterPath,
        'overview': overview,
      };

  factory TVTable.fromEntity(TVDetail movie) => TVTable(
      id: movie.id,
      name: movie.name,
      posterPath: movie.posterPath,
      overview: movie.overview);

  @override
  List<Object?> get props => [id, name, posterPath, overview];
}
