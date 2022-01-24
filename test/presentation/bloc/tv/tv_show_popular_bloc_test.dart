import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_shows.dart';
import 'package:ditonton/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_show_popular_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTVShows])
void main() {
  late MockGetPopularTVShows mockGetPopularTVShows;
  late PopularTVBloc popularTVBloc;

  setUp(() {
    mockGetPopularTVShows = MockGetPopularTVShows();
    popularTVBloc = PopularTVBloc(getPopularTVShows: mockGetPopularTVShows);
  });

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

  group('Popular TV Shows', () {
    test('initialState should be Empty', () {
      expect(popularTVBloc.state, PopularTVEmptyState());
    });

    blocTest<PopularTVBloc, PopularTVState>(
      'Should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetPopularTVShows.execute())
            .thenAnswer((_) async => Right(tTVShowsList));
        return popularTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowPopularTVShows()),
      expect: () => [
        PopularTVLoadingState(),
        PopularTVHasDataState(result: tTVShowsList)
      ],
      verify: (bloc) => verify(mockGetPopularTVShows.execute()),
    );

    blocTest<PopularTVBloc, PopularTVState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetPopularTVShows.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return popularTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowPopularTVShows()),
      expect: () => [
        PopularTVLoadingState(),
        PopularTVErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(mockGetPopularTVShows.execute()),
    );
  });
}
