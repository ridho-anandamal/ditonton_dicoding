import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/presentation/bloc/tv/detail_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TVDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv';

  final int id;
  const TVDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _TVDetailPageState createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<DetailTVBloc>().add(FetchNowDetailTV(id: widget.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DetailTVBloc, DetailTVState>(
          builder: (context, state) {
            if (state is DetailTVLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DetailTVHasDataState) {
              return DetailContentTVShow(
                tvDetail: state.resultDetail,
                recommendations: state.resultRecommendation,
                isAddedWatchlist: state.isAddedToWatchlist,
              );
            } else if (state is DetailTVEmptyState) {
              return Center(child: Text('Data Tidak Ditemukan'));
            } else if (state is DetailTVErrorState) {
              return Center(child: Text(state.message.toString()));
            } else {
              return Text('');
            }
          },
        ),
      ),
    );
  }
}

class DetailContentTVShow extends StatelessWidget {
  final TVDetail tvDetail;
  final List<TV> recommendations;
  final bool isAddedWatchlist;

  DetailContentTVShow({
    required this.tvDetail,
    required this.recommendations,
    required this.isAddedWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvDetail.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvDetail.name,
                              style: kHeading5,
                            ),
                            BlocBuilder<DetailTVBloc, DetailTVState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: () async {
                                    if (!isAddedWatchlist) {
                                      context.read<DetailTVBloc>().add(
                                          ActionAddWatchlistTV(tv: tvDetail));
                                      context.read<DetailTVBloc>().add(
                                          FetchNowDetailTV(id: tvDetail.id));
                                    } else {
                                      context.read<DetailTVBloc>().add(
                                          ActionRemoveFromWatchlistTV(
                                              tv: tvDetail));
                                      context.read<DetailTVBloc>().add(
                                          FetchNowDetailTV(id: tvDetail.id));
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      isAddedWatchlist
                                          ? Icon(Icons.check)
                                          : Icon(Icons.add),
                                      Text(isAddedWatchlist
                                          ? 'Remove Watchlist'
                                          : 'Add Watchlist'),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Text(
                              _showGenres(tvDetail.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvDetail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvDetail.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvDetail.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<DetailTVBloc, DetailTVState>(
                                builder: (context, state) {
                              if (state is DetailTVLoadingState) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is DetailTVHasDataState) {
                                return Container(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final tv =
                                          state.resultRecommendation[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              TVDetailPage.ROUTE_NAME,
                                              arguments: tv.id,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                              width: 100,
                                              placeholder: (context, url) =>
                                                  Center(
                                                child: Container(
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount:
                                        state.resultRecommendation.length,
                                  ),
                                );
                              } else if (state is DetailTVEmptyState) {
                                return Center(
                                    child: Text('Data Tidak Ditemukan'));
                              } else if (state is DetailTVErrorState) {
                                return Center(
                                    child: Text(state.message.toString()));
                              } else {
                                return Text('');
                              }
                            })
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
