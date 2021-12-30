import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/search_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:ditonton/presentation/widgets/sub_heading_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-show';
  const HomeTVPage({Key? key}) : super(key: key);

  @override
  State<HomeTVPage> createState() => _HomeTVPageState();
}

class _HomeTVPageState extends State<HomeTVPage> {
  // TODO: Step 10 -> Diinisialisasikan awal page
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<TVListNotifier>(context, listen: false)
      ..fetchNowOnTheAirTVShows()
      ..fetchNowPopularTVShows()
      ..fetchNowTopRatedTVShows());
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
                Navigator.pushNamed(context, WatchListTVPage.ROUTE_NAME);
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
              Consumer<TVListNotifier>(builder: (context, data, child) {
                final state = data.onTheAirState;
                switch (state) {
                  case RequestState.Loading:
                    return Center(child: CircularProgressIndicator());
                  case RequestState.Loaded:
                    return TVList(data.onTheAirTVShows);
                  case RequestState.Empty:
                    return Text('Data Tidak Ditemukan');
                  case RequestState.Error:
                    return Text(data.message.toString());
                }
              }),
              SubHeadingText(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTVPage.ROUTE_NAME),
              ),
              Consumer<TVListNotifier>(builder: (context, data, child) {
                final state = data.popularState;
                switch (state) {
                  case RequestState.Loading:
                    return Center(child: CircularProgressIndicator());
                  case RequestState.Loaded:
                    return TVList(data.popularTVSHows);
                  case RequestState.Empty:
                    return Text('Data Tidak Ditemukan');
                  case RequestState.Error:
                    return Text(data.message.toString());
                }
              }),
              SubHeadingText(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTVPage.ROUTE_NAME),
              ),
              Consumer<TVListNotifier>(builder: (context, data, child) {
                final state = data.topRatedState;
                switch (state) {
                  case RequestState.Loading:
                    return Center(child: CircularProgressIndicator());
                  case RequestState.Loaded:
                    return TVList(data.topRatedTVShows);
                  case RequestState.Empty:
                    return Text('Data Tidak Ditemukan');
                  case RequestState.Error:
                    return Text(data.message.toString());
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
