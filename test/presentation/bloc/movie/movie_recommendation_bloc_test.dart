import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie/recommendation_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../provider/movie_detail_notifier_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late RecommendationMovieBloc recommendationMovieBloc;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    recommendationMovieBloc = RecommendationMovieBloc(
        getMovieRecommendations: mockGetMovieRecommendations);
  });

  final tId = 1;
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  group('Get Recommendation Movie', () {
    test('initialState should be Empty', () {
      expect(recommendationMovieBloc.state, RecommendationMovieEmptyState());
    });

    blocTest<RecommendationMovieBloc, RecommendationMovieState>(
      'Should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return recommendationMovieBloc;
      },
      act: (bloc) => bloc.add(FetchNowRecommendationMovie(id: tId)),
      expect: () => [
        RecommendationMovieLoadingState(),
        RecommendationMovieHasDataState(result: tMovies)
      ],
      verify: (bloc) => verify(mockGetMovieRecommendations.execute(tId)),
    );

    blocTest<RecommendationMovieBloc, RecommendationMovieState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return recommendationMovieBloc;
      },
      act: (bloc) => bloc.add(FetchNowRecommendationMovie(id: tId)),
      expect: () => [
        RecommendationMovieLoadingState(),
        RecommendationMovieErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(mockGetMovieRecommendations.execute(tId)),
    );
  });
}
