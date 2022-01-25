import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import 'package:feature_tv/feature_tv.dart';
import 'package:feature_movie/feature_movie.dart';

final locator = GetIt.instance;

void init() {
  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => HttpSSLPinning.client);

  // TV Shows Injection
  // use case
  locator.registerLazySingleton(() => GetOnTheAirTVShows(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => GetPopularTVShows(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => GetTopRatedTVShows(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => GetTVShowDetail(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => GetTVShowsRecommendation(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => SearchTVShows(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => SaveWatchlistTV(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => RemoveWatchlistTV(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => GetWatchListStatusTV(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => GetWatchlistTVShows(
        repository: locator(),
      ));

  // repository
  locator.registerLazySingleton<TVRepository>(
    () => TVRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<TVRemoteDataSource>(
      () => TVRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TVLocalDataSource>(
      () => TVLocalDataSourceImpl(databaseHelper: locator()));

  // bloc movie
  locator.registerFactory(
      () => NowPlayingMovieBloc(getNowPlayingMovies: locator()));
  locator.registerFactory(() => PopularMovieBloc(getPopularMovies: locator()));
  locator
      .registerFactory(() => TopRatedMovieBloc(getTopRatedMovies: locator()));
  locator.registerFactory(() => SearchMovieBloc(searchMovies: locator()));
  locator.registerFactory(() => DetailMovieBloc(getMovieDetail: locator()));
  locator.registerFactory(
      () => RecommendationMovieBloc(getMovieRecommendations: locator()));
  locator.registerFactory(() => WatchlistStatusMovieCubit(
        getWatchListStatus: locator(),
        saveWatchlist: locator(),
        removeWatchlist: locator(),
      ));

  locator
      .registerFactory(() => WatchlistMovieBloc(getWatchlistMovies: locator()));

  // bloc tv
  locator.registerFactory(() => OnTheAirTVBloc(getOnTheAirTVShows: locator()));
  locator.registerFactory(() => PopularTVBloc(getPopularTVShows: locator()));
  locator.registerFactory(() => TopRatedTVBloc(getTopRatedTVShows: locator()));
  locator.registerFactory(() => SearchTVBloc(searchTVShows: locator()));
  locator.registerFactory(() => DetailTVBloc(getTVShowDetail: locator()));
  locator.registerFactory(
      () => RecommendationTVBloc(getTVShowsRecommendation: locator()));
  locator.registerFactory(() => WatchlistStatusTVCubit(
        getWatchListStatusTV: locator(),
        saveWatchlistTV: locator(),
        removeWatchlistTV: locator(),
      ));
  locator
      .registerFactory(() => WatchlistTVBloc(getWatchlistTVShows: locator()));
}
