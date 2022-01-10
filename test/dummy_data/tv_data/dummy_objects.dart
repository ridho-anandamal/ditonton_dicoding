import 'package:ditonton/data/models/tv/tv_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';

final testTVShow = TV(
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

final testTVShowsList = [testTVShow];

final testTVShowDetail = TVDetail(
  backdropPath: "/path.jpg",
  genres: [Genre(id: 1, name: "Action")],
  homepage: "https://google.com",
  id: 1,
  inProduction: true,
  languages: ["en"],
  lastAirDate: DateTime.parse("2021-09-03"),
  name: "Name",
  numberOfEpisodes: 1,
  numberOfSeasons: 1,
  originCountry: ["US"],
  originalLanguage: "en",
  originalName: "Original Name",
  overview: "Overview",
  popularity: 1.0,
  posterPath: "/path.jpg",
  productionCompanies: [
    {
      "id": 1,
      "logo_path": "/path.png",
      "name": "Overview Company",
      "origin_country": "US"
    },
    {
      "id": 1,
      "logo_path": null,
      "name": "Company",
      "origin_country": "US",
    },
  ],
  status: "Status",
  tagline: "Tagline",
  type: "Action",
  voteAverage: 1.0,
  voteCount: 1,
);

final testWatchlistTV = TV.watchlist(
  id: 1,
  overview: "Overview",
  posterPath: "/path.jpg",
  name: "Name",
);

final testTVTable = TVTable(
  id: 1,
  name: "Name",
  posterPath: "/path.jpg",
  overview: "Overview",
);

final testTVMap = {
  "id": 1,
  "overview": "Overview",
  "posterPath": "/path.jpg",
  "name": "Name",
};
