import 'package:ditonton/domain/entities/genre.dart';
import 'package:equatable/equatable.dart';

// TODO: Hapus komentar jika sudah selesai
class TVDetail extends Equatable {
  TVDetail({
    required this.backdropPath,
    // required this.createdBy,
    // required this.episodeRunTime,
    // required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    // required this.lastEpisodeToAir,
    required this.name,
    // required this.nextEpisodeToAir,
    // required this.networks,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    // required this.productionCountries,
    // required this.seasons,
    // required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  String? backdropPath;
  // List<dynamic> createdBy;
  // List<int> episodeRunTime;
  // DateTime firstAirDate;
  List<Genre> genres;
  String homepage;
  int id;
  bool inProduction;
  List<String> languages;
  DateTime lastAirDate;
  // LastEpisodeToAirModel lastEpisodeToAir;
  String name;
  // dynamic nextEpisodeToAir;
  // List<NetworkModel> networks;
  int numberOfEpisodes;
  int numberOfSeasons;
  List<String> originCountry;
  String originalLanguage;
  String originalName;
  String overview;
  double popularity;
  String posterPath;
  List<dynamic> productionCompanies;
  // List<ProductionCountryModel> productionCountries;
  // List<SeasonModel> seasons;
  // List<SpokenLanguageModel> spokenLanguages;
  String status;
  String tagline;
  String type;
  double voteAverage;
  double voteCount;

  @override
  List<Object?> get props => [
        backdropPath,
        // createdBy,
        // episodeRunTime,
        // firstAirDate,
        genres,
        homepage,
        id,
        inProduction,
        languages,
        lastAirDate,
        // lastEpisodeToAir,
        name,
        // nextEpisodeToAir,
        // List<NetworkModel> networks;
        numberOfEpisodes,
        numberOfSeasons,
        originCountry,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        productionCompanies,
        // productionCountries;
        // seasons;
        // spokenLanguages;
        status,
        tagline,
        type,
        voteAverage,
        voteCount,
      ];
}
