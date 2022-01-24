import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tv_shows.dart';
import 'package:ditonton/presentation/bloc/tv/on_the_air_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_show_on_the_air_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTVShows])
void main() {
  late MockGetOnTheAirTVShows mockGetOnTheAirTVShows;
  late OnTheAirTVBloc onTheAirTVBloc;

  setUp(() {
    mockGetOnTheAirTVShows = MockGetOnTheAirTVShows();
    onTheAirTVBloc = OnTheAirTVBloc(getOnTheAirTVShows: mockGetOnTheAirTVShows);
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

  group('On The Air TV Shows', () {
    test('initialState should be Empty', () {
      expect(onTheAirTVBloc.state, OnTheAirTVEmptyState());
    });

    blocTest<OnTheAirTVBloc, OnTheAirTVState>(
      'Should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetOnTheAirTVShows.execute())
            .thenAnswer((_) async => Right(tTVShowsList));
        return onTheAirTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowOnTheAirTVShows()),
      expect: () => [
        OnTheAirTVLoadingState(),
        OnTheAirTVHasDataState(result: tTVShowsList)
      ],
      verify: (bloc) => verify(mockGetOnTheAirTVShows.execute()),
    );

    blocTest<OnTheAirTVBloc, OnTheAirTVState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetOnTheAirTVShows.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return onTheAirTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowOnTheAirTVShows()),
      expect: () => [
        OnTheAirTVLoadingState(),
        OnTheAirTVErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(mockGetOnTheAirTVShows.execute()),
    );
  });
}
