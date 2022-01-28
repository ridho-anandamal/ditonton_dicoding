import 'package:feature_movie/data/datasources/movie_local_data_source.dart';
import 'package:feature_movie/data/datasources/movie_remote_data_source.dart';
import 'package:feature_movie/data/repositories/movie_repository_impl.dart';
import 'package:feature_movie/domain/repositories/movie_repository.dart';
import 'package:feature_movie/domain/usecases/get_movie_detail.dart';
import 'package:feature_movie/domain/usecases/get_movie_recommendations.dart';
import 'package:feature_movie/domain/usecases/get_now_playing_movies.dart';
import 'package:feature_movie/domain/usecases/get_popular_movies.dart';
import 'package:feature_movie/domain/usecases/get_top_rated_movies.dart';
import 'package:feature_movie/domain/usecases/get_watchlist_movies.dart';
import 'package:feature_movie/domain/usecases/get_watchlist_status.dart';
import 'package:feature_movie/domain/usecases/remove_watchlist.dart';
import 'package:feature_movie/domain/usecases/save_watchlist.dart';
import 'package:feature_movie/domain/usecases/search_movies.dart';
import 'package:feature_movie/presentation/blocs/detail_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/now_playing_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/popular_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/recommendation_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/search_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/top_rated_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/watchlist_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/watchlist_status_movie_cubit.dart';
import 'package:feature_tv/data/datasources/tv_local_data_source.dart';
import 'package:feature_tv/data/datasources/tv_remote_data_source.dart';
import 'package:feature_tv/data/repositories/tv_repository_impl.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';
import 'package:feature_tv/domain/usecases/get_on_the_air_tv_shows.dart';
import 'package:feature_tv/domain/usecases/get_popular_tv_shows.dart';
import 'package:feature_tv/domain/usecases/get_top_rated_tv_shows.dart';
import 'package:feature_tv/domain/usecases/get_tv_show_detail.dart';
import 'package:feature_tv/domain/usecases/get_tv_shows_recommendation.dart';
import 'package:feature_tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:feature_tv/domain/usecases/get_watchlist_tv_shows.dart';
import 'package:feature_tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:feature_tv/domain/usecases/save_watchlist_tv.dart';
import 'package:feature_tv/domain/usecases/search_tv_shows.dart';
import 'package:feature_tv/presentation/blocs/detail_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/on_the_air_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/popular_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/recommendation_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/search_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/top_rated_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/watchlist_status_tv_cubit.dart';
import 'package:feature_tv/presentation/blocs/watchlist_tv_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart';

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
