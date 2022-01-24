import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_shows_recommendation.dart';
import 'package:ditonton/presentation/bloc/tv/recommendation_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../provider/tv/tv_show_detail_notifier_test.mocks.dart';

@GenerateMocks([GetTVShowsRecommendation])
void main() {
  late MockGetTVShowsRecommendation mockGetTVShowsRecommendation;
  late RecommendationTVBloc recommendationTVBloc;

  setUp(() {
    mockGetTVShowsRecommendation = MockGetTVShowsRecommendation();
    recommendationTVBloc = RecommendationTVBloc(
        getTVShowsRecommendation: mockGetTVShowsRecommendation);
  });

  final tId = 1;
  final tTVShow = TV(
    backdropPath: 'backdropPath',
    firstAirDate: DateTime.parse("2021-05-23"),
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['en'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTVShowsList = <TV>[tTVShow];

  group('Get Recommendation TV Shows', () {
    test('initialState should be Empty', () {
      expect(recommendationTVBloc.state, RecommendationTVEmptyState());
    });

    blocTest<RecommendationTVBloc, RecommendationTVState>(
      'Should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTVShowsRecommendation.execute(tId))
            .thenAnswer((_) async => Right(tTVShowsList));
        return recommendationTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowRecommendationTV(id: tId)),
      expect: () => [
        RecommendationTVLoadingState(),
        RecommendationTVHasDataState(result: tTVShowsList)
      ],
      verify: (bloc) => verify(mockGetTVShowsRecommendation.execute(tId)),
    );

    blocTest<RecommendationTVBloc, RecommendationTVState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTVShowsRecommendation.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return recommendationTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowRecommendationTV(id: tId)),
      expect: () => [
        RecommendationTVLoadingState(),
        RecommendationTVErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(mockGetTVShowsRecommendation.execute(tId)),
    );
  });
}
