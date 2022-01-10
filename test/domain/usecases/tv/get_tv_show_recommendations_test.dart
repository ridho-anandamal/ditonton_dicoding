import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_shows_recommendation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVShowsRecommendation usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetTVShowsRecommendation(repository: repository);
  });

  final tId = 1;
  final tTVShows = <TV>[];

  test('should get list of movie recommendations from the repository', () async{
    // arrange
    when(repository.getTVShowsRecommendation(tId)).thenAnswer((_) async => Right(tTVShows));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTVShows));
  });
}