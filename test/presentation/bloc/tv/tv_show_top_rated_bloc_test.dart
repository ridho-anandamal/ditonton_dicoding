import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_shows.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_show_top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTVShows])
void main() {
  late MockGetTopRatedTVShows mockGetTopRatedTVShows;
  late TopRatedTVBloc topRatedTVBloc;

  setUp(() {
    mockGetTopRatedTVShows = MockGetTopRatedTVShows();
    topRatedTVBloc = TopRatedTVBloc(getTopRatedTVShows: mockGetTopRatedTVShows);
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

  group('Top Rated TV Shows', () {
    test('initialState should be Empty', () {
      expect(topRatedTVBloc.state, TopRatedTVEmptyState());
    });

    blocTest<TopRatedTVBloc, TopRatedTVState>(
      'Should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTVShows.execute())
            .thenAnswer((_) async => Right(tTVShowsList));
        return topRatedTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowTopRatedTVShows()),
      expect: () => [
        TopRatedTVLoadingState(),
        TopRatedTVHasDataState(result: tTVShowsList)
      ],
      verify: (bloc) => verify(mockGetTopRatedTVShows.execute()),
    );

    blocTest<TopRatedTVBloc, TopRatedTVState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTopRatedTVShows.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowTopRatedTVShows()),
      expect: () => [
        TopRatedTVLoadingState(),
        TopRatedTVErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(mockGetTopRatedTVShows.execute()),
    );
  });
}
