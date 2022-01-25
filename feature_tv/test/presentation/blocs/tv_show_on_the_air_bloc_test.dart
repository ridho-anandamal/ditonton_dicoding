import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/feature_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetOnTheAirTVShows extends Mock implements GetOnTheAirTVShows {}

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

  group('TV Bloc, On The Air TV Shows:', () {
    test('initialState should be Empty', () {
      expect(onTheAirTVBloc.state, OnTheAirTVEmptyState());
    });

    blocTest<OnTheAirTVBloc, OnTheAirTVState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetOnTheAirTVShows.execute())
            .thenAnswer((_) async => Right(tTVShowsList));
        return onTheAirTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowOnTheAirTVShows()),
      expect: () => [
        OnTheAirTVLoadingState(),
        OnTheAirTVHasDataState(result: tTVShowsList)
      ],
      verify: (bloc) => verify(() => mockGetOnTheAirTVShows.execute()),
    );

    blocTest<OnTheAirTVBloc, OnTheAirTVState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetOnTheAirTVShows.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return onTheAirTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowOnTheAirTVShows()),
      expect: () => [
        OnTheAirTVLoadingState(),
        const OnTheAirTVErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetOnTheAirTVShows.execute()),
    );
  });
}
