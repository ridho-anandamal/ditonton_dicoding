import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_shows.dart';
import 'package:ditonton/presentation/provider/tv/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_show_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTVShows])
void main() {
  late TVSearchNotifier notifier;
  late MockSearchTVShows mockSearchTVShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTVShows = MockSearchTVShows();
    notifier = TVSearchNotifier(searchTVShows: mockSearchTVShows)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTVShowModel = TV(
    backdropPath: "/qJYUCO1Q8desX7iVDkwxWVnwacZ.jpg",
    firstAirDate: DateTime.parse("2010-09-17"),
    genreIds: [10759, 16],
    id: 32315,
    name: "Sym-Bionic Titan",
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Sym-Bionic Titan",
    overview:
        "Sym-Bionic Titan is an American animated action science fiction television series created by Genndy Tartakovsky, Paul Rudish, and Bryan Andrews for Cartoon Network. The series focuses on a trio made up of the alien princess Ilana, the rebellious soldier Lance, and the robot Octus; the three are able to combine to create the titular Sym-Bionic Titan. A preview of the series was first shown at the 2009 San Diego Comic-Con International, and further details were revealed at Cartoon Network's 2010 Upfront. The series premiered on September 17, 2010, and ended on April 9, 2011. The series is rated TV-PG-V. Cartoon Network initially ordered 20 episodes; Tartakovsky had hoped to expand on that, but the series was not renewed for another season, as the show 'did not have any toys connected to it.' Although Sym-Bionic Titan has never been released on DVD, All 20 episodes are available on iTunes. On October 7, 2012, reruns of Sym-Bionic Titan began airing on Adult Swim's Toonami block.",
    popularity: 9.693,
    posterPath: "/3UdrghLghvYnsVohWM160RHKPYQ.jpg",
    voteAverage: 8.8,
    voteCount: 85,
  );
  final tTVShowsList = [tTVShowModel];
  final tQuery = 'Titan';

  group('search tv shows', () {
    test('should change state to loading when usecase is called', () {
      // arrange
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Right(tTVShowsList));
      // act
      notifier.fetchTVSearch(tQuery);
      // assert
      expect(notifier.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully', () async {
      // arrange
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Right(tTVShowsList));
      // act
      await notifier.fetchTVSearch(tQuery);
      // assert
      expect(notifier.state, RequestState.Loaded);
      expect(notifier.searchResult, tTVShowsList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await notifier.fetchTVSearch(tQuery);
      // assert
      expect(notifier.state, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
