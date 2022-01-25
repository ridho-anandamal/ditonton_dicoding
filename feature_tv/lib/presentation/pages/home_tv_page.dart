// ignore_for_file: constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:feature_about/feature_about.dart';
import 'package:feature_movie/feature_movie.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/presentation/blocs/on_the_air_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/popular_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/top_rated_tv_bloc.dart';
import 'package:feature_tv/presentation/pages/popular_tv_page.dart';
import 'package:feature_tv/presentation/pages/search_tv_page.dart';
import 'package:feature_tv/presentation/pages/top_rated_tv_page.dart';
import 'package:feature_tv/presentation/pages/tv_detail_page.dart';
import 'package:feature_tv/presentation/pages/watchlist_tv_page.dart';
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
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pushNamed(context, HomeMoviePage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist Movies'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('TV Shows'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist TV Shows'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTVPage.ROUTE_NAME);
              },
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('TV Shows'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTVPage.ROUTE_NAME);
            },
            icon: const Icon(Icons.search),
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is OnTheAirTVHasDataState) {
                  return TVList(state.result);
                } else if (state is OnTheAirTVEmptyState) {
                  return const Text('Data Tidak Ditemukan');
                } else if (state is OnTheAirTVErrorState) {
                  return Text(state.message);
                } else {
                  return const Text('Error Bloc');
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularTVHasDataState) {
                  return TVList(state.result);
                } else if (state is PopularTVEmptyState) {
                  return const Text('Data Tidak Ditemukan');
                } else if (state is PopularTVErrorState) {
                  return Text(state.message);
                } else {
                  return const Text('Error Bloc');
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedTVHasDataState) {
                  return TVList(state.result);
                } else if (state is TopRatedTVEmptyState) {
                  return const Text('Data Tidak Ditemukan');
                } else if (state is TopRatedTVErrorState) {
                  return Text(state.message);
                } else {
                  return const Text('Error Bloc');
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

  const TVList(this.tvShows, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  width: 120,
                  height: 150,
                  placeholder: (context, url) => Center(
                    child: Container(color: Colors.grey[800]),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
