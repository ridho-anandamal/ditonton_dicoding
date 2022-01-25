import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/feature_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTVShowsRecommendation extends Mock
    implements GetTVShowsRecommendation {}

void main() {
  late MockGetTVShowsRecommendation mockGetTVShowsRecommendation;
  late RecommendationTVBloc recommendationTVBloc;

  setUp(() {
    mockGetTVShowsRecommendation = MockGetTVShowsRecommendation();
    recommendationTVBloc = RecommendationTVBloc(
        getTVShowsRecommendation: mockGetTVShowsRecommendation);
  });

  const tId = 1;
  final tTVShow = TV(
    backdropPath: 'backdropPath',
    firstAirDate: DateTime.parse("2021-05-23"),
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

  final tTVShowsList = <TV>[tTVShow];

  group('TV Bloc, Get Recommendation TV Shows:', () {
    test('initialState should be Empty', () {
      expect(recommendationTVBloc.state, RecommendationTVEmptyState());
    });

    blocTest<RecommendationTVBloc, RecommendationTVState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetTVShowsRecommendation.execute(tId))
            .thenAnswer((_) async => Right(tTVShowsList));
        return recommendationTVBloc;
      },
      act: (bloc) => bloc.add(const FetchNowRecommendationTV(id: tId)),
      expect: () => [
        RecommendationTVLoadingState(),
        RecommendationTVHasDataState(result: tTVShowsList)
      ],
      verify: (bloc) => verify(() => mockGetTVShowsRecommendation.execute(tId)),
    );

    blocTest<RecommendationTVBloc, RecommendationTVState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetTVShowsRecommendation.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return recommendationTVBloc;
      },
      act: (bloc) => bloc.add(const FetchNowRecommendationTV(id: tId)),
      expect: () => [
        RecommendationTVLoadingState(),
        const RecommendationTVErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetTVShowsRecommendation.execute(tId)),
    );
  });
}
