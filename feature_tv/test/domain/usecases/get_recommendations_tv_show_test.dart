import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';
import 'package:feature_tv/domain/usecases/get_tv_shows_recommendation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late GetTVShowsRecommendation usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetTVShowsRecommendation(repository: repository);
  });

  const tId = 1;
  final tTVShows = <TV>[];

  group('TV Use Cases, Get TV Recommendation:', () {
    test('should get list of movie recommendations from the repository',
        () async {
      // arrange
      when(() => repository.getTVShowsRecommendation(tId))
          .thenAnswer((_) async => Right(tTVShows));
      // act
      final result = await usecase.execute(tId);
      // assert
      expect(result, Right(tTVShows));
    });
  });
}
