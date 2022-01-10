import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTVShows usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = SearchTVShows(repository: repository);
  });

  final tQuery = 'Titan';
  final tTVShows = <TV>[];

  test('should get list of movies from the repository', () async{
    // arrange
    when(repository.searchTVShows(tQuery)).thenAnswer((_) async => Right(tTVShows));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTVShows));
  });
}