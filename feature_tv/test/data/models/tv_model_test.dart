import 'package:feature_tv/data/models/tv_model.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTVModel = TVModel(
    adult: false,
    backdropPath: 'backdropPath',
    firstAirDate: DateTime.parse('2021-12-15'),
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: const ['en'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTV = TV(
    backdropPath: 'backdropPath',
    firstAirDate: DateTime.parse('2021-12-15'),
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: const ['en'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  group('TV Model, TV Model:', () {
    test('should be a subclass of TV entity', () async {
      final result = tTVModel.toEntity();
      expect(result, tTV);
    });
  });
}
