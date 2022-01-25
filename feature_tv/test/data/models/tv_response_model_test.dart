import 'dart:convert';

import 'package:feature_tv/feature_tv.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper/json_reader.dart';

void main() {
  final tTVModel = TVModel(
    adult: null,
    backdropPath: "/path.jpg",
    firstAirDate: DateTime.parse('2021-12-15'),
    genreIds: const [1, 2, 3, 4],
    id: 1,
    name: "Name",
    originCountry: const ["US"],
    originalLanguage: "en",
    originalName: "Original Name",
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTVResponseModel = TVResponse(tvList: <TVModel>[tTVModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final dataJson = readJson('helper/dummy_data/on_the_air.json');
      // act
      final result = TVResponse.fromJson(json.decode(dataJson));
      // assert
      expect(result, tTVResponseModel);
    });
  });

  group('TV Model, TV Response Model:', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('helper/dummy_data/on_the_air.json'));
      // act
      final result = TVResponse.fromJson(jsonMap);
      // assert
      expect(result, tTVResponseModel);
    });

    test('should return a JSON map containing proper data', () {
      // arrange

      // act
      final result = tTVResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": null,
            "backdrop_path": '/path.jpg',
            "first_air_date": '2021-12-15',
            "genre_ids": [1, 2, 3, 4],
            "id": 1,
            "name": "Name",
            "origin_country": ["US"],
            "original_language": "en",
            "original_name": "Original Name",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "vote_average": 1.0,
            "vote_count": 1,
          }
        ]
      };
      expect(result, expectedJsonMap);
    });
  });
}
