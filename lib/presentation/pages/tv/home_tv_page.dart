import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/presentation/bloc/tv/on_the_air_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/search_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/widgets/sub_heading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-show';
  const HomeTVPage({Key? key}) : super(key: key);

  @override
  State<HomeTVPage> createState() => _HomeTVPageState();
}

class _HomeTVPageState extends State<HomeTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<OnTheAirTVBloc>().add(FetchNowOnTheAirTVShows()));
    Future.microtask(
        () => context.read<PopularTVBloc>().add(FetchNowPopularTVShows()));
    Future.microtask(
        () => context.read<TopRatedTVBloc>().add(FetchNowTopRatedTVShows()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pushNamed(context, HomeMoviePage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist Movies'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('TV Shows'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist TV Shows'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTVPage.ROUTE_NAME);
              },
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('TV Shows'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTVPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'On The Air Playing',
                style: kHeading6,
              ),
              BlocBuilder<OnTheAirTVBloc, OnTheAirTVState>(
                  builder: (context, state) {
                if (state is OnTheAirTVLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is OnTheAirTVHasDataState) {
                  return TVList(state.result);
                } else if (state is OnTheAirTVEmptyState) {
                  return Text('Data Tidak Ditemukan');
                } else if (state is OnTheAirTVErrorState) {
                  return Text(state.message);
                } else {
                  return Text('Error Bloc');
                }
              }),
              SubHeadingText(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTVPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularTVBloc, PopularTVState>(
                  builder: (context, state) {
                if (state is PopularTVLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularTVHasDataState) {
                  return TVList(state.result);
                } else if (state is PopularTVEmptyState) {
                  return Text('Data Tidak Ditemukan');
                } else if (state is PopularTVErrorState) {
                  return Text(state.message);
                } else {
                  return Text('Error Bloc');
                }
              }),
              SubHeadingText(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTVPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedTVBloc, TopRatedTVState>(
                  builder: (context, state) {
                if (state is TopRatedTVLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedTVHasDataState) {
                  return TVList(state.result);
                } else if (state is TopRatedTVEmptyState) {
                  return Text('Data Tidak Ditemukan');
                } else if (state is TopRatedTVErrorState) {
                  return Text(state.message);
                } else {
                  return Text('Error Bloc');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class TVList extends StatelessWidget {
  final List<TV> tvShows;

  TVList(this.tvShows);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvShows[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, TVDetailPage.ROUTE_NAME,
                    arguments: tv.id);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  width: 120,
                  height: 150,
                  placeholder: (context, url) => Center(
                    child: Container(color: Colors.grey[800]),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvShows.length,
      ),
    );
  }
}
