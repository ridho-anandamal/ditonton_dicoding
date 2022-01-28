import 'package:core/core.dart';
import 'package:feature_movie/presentation/blocs/detail_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/now_playing_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/popular_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/recommendation_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/search_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/top_rated_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/watchlist_movie_bloc.dart';
import 'package:feature_movie/presentation/blocs/watchlist_status_movie_cubit.dart';
import 'package:feature_movie/presentation/pages/home_movie_page.dart';
import 'package:feature_movie/presentation/pages/movie_detail_page.dart';
import 'package:feature_movie/presentation/pages/popular_movies_page.dart';
import 'package:feature_movie/presentation/pages/search_movie_page.dart';
import 'package:feature_movie/presentation/pages/top_rated_movies_page.dart';
import 'package:feature_movie/presentation/pages/watchlist_movies_page.dart';
import 'package:feature_tv/presentation/blocs/detail_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/on_the_air_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/popular_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/recommendation_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/search_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/top_rated_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/watchlist_status_tv_cubit.dart';
import 'package:feature_tv/presentation/blocs/watchlist_tv_bloc.dart';
import 'package:feature_tv/presentation/pages/home_tv_page.dart';
import 'package:feature_tv/presentation/pages/popular_tv_page.dart';
import 'package:feature_tv/presentation/pages/search_tv_page.dart';
import 'package:feature_tv/presentation/pages/top_rated_tv_page.dart';
import 'package:feature_tv/presentation/pages/tv_detail_page.dart';
import 'package:feature_tv/presentation/pages/watchlist_tv_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feature_about/feature_about.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HttpSSLPinning.init();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMovieBloc>(
          create: (_) => di.locator<NowPlayingMovieBloc>(),
        ),
        BlocProvider<PopularMovieBloc>(
          create: (_) => di.locator<PopularMovieBloc>(),
        ),
        BlocProvider<TopRatedMovieBloc>(
          create: (_) => di.locator<TopRatedMovieBloc>(),
        ),
        BlocProvider<SearchMovieBloc>(
          create: (_) => di.locator<SearchMovieBloc>(),
        ),
        BlocProvider<DetailMovieBloc>(
          create: (_) => di.locator<DetailMovieBloc>(),
        ),
        BlocProvider<RecommendationMovieBloc>(
          create: (_) => di.locator<RecommendationMovieBloc>(),
        ),
        BlocProvider<WatchlistStatusMovieCubit>(
          create: (_) => di.locator<WatchlistStatusMovieCubit>(),
        ),
        BlocProvider<WatchlistMovieBloc>(
          create: (_) => di.locator<WatchlistMovieBloc>(),
        ),
        BlocProvider<OnTheAirTVBloc>(
          create: (_) => di.locator<OnTheAirTVBloc>(),
        ),
        BlocProvider<PopularTVBloc>(
          create: (_) => di.locator<PopularTVBloc>(),
        ),
        BlocProvider<TopRatedTVBloc>(
          create: (_) => di.locator<TopRatedTVBloc>(),
        ),
        BlocProvider<SearchTVBloc>(
          create: (_) => di.locator<SearchTVBloc>(),
        ),
        BlocProvider<DetailTVBloc>(
          create: (_) => di.locator<DetailTVBloc>(),
        ),
        BlocProvider<RecommendationTVBloc>(
          create: (_) => di.locator<RecommendationTVBloc>(),
        ),
        BlocProvider<WatchlistStatusTVCubit>(
          create: (_) => di.locator<WatchlistStatusTVCubit>(),
        ),
        BlocProvider<WatchlistTVBloc>(
          create: (_) => di.locator<WatchlistTVBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          colorScheme: kColorScheme.copyWith(secondary: kMikadoYellow),
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchMoviePage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchMoviePage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case HomeTVPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeTVPage());
            case WatchlistTVPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTVPage());
            case TopRatedTVPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => TopRatedTVPage());
            case PopularTVPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => PopularTVPage());
            case TVDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVDetailPage(id: id),
                settings: settings,
              );
            case SearchTVPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => SearchTVPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
