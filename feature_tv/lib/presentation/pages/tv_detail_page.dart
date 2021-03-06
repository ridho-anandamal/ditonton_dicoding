// ignore_for_file: constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:feature_tv/domain/entities/genre.dart';
import 'package:feature_tv/domain/entities/tv_detail.dart';
import 'package:feature_tv/presentation/blocs/detail_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/recommendation_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/watchlist_status_tv_cubit.dart';
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
    Future.microtask(() {
      context.read<DetailTVBloc>().add(FetchNowDetailTV(id: widget.id));
      context
          .read<RecommendationTVBloc>()
          .add(FetchNowRecommendationTV(id: widget.id));
      context.read<WatchlistStatusTVCubit>().loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DetailTVBloc, DetailTVState>(
          builder: (context, state) {
            if (state is DetailTVLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DetailTVHasDataState) {
              return DetailContentTVShow(tvDetail: state.result);
            } else if (state is DetailTVEmptyState) {
              return const Center(child: Text('Data Tidak Ditemukan'));
            } else if (state is DetailTVErrorState) {
              return Center(
                  key: const Key('error_message'),
                  child: Text(state.message.toString()));
            } else {
              return const Text('');
            }
          },
        ),
      ),
    );
  }
}

class DetailContentTVShow extends StatelessWidget {
  final TVDetail tvDetail;

  const DetailContentTVShow({Key? key, required this.tvDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvDetail.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
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
                            BlocBuilder<WatchlistStatusTVCubit,
                                    WatchlistStatusTVState>(
                                builder: (context, state) {
                              bool isAddedWatchlist = state.isAddedWatchlist;
                              return ElevatedButton(
                                onPressed: () async {
                                  if (isAddedWatchlist) {
                                    await context
                                        .read<WatchlistStatusTVCubit>()
                                        .removeFromWatchlistTV(tvDetail);
                                  } else {
                                    await context
                                        .read<WatchlistStatusTVCubit>()
                                        .addWatchlistTV(tvDetail);
                                  }
                                  final message = context
                                      .read<WatchlistStatusTVCubit>()
                                      .state
                                      .message;
                                  if (message ==
                                          WatchlistStatusTVCubit
                                              .watchlistAddSuccessMessage ||
                                      message ==
                                          WatchlistStatusTVCubit
                                              .watchlistRemoveSuccessMessage) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(message)));
                                  } else {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isAddedWatchlist
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.add),
                                    Text(isAddedWatchlist
                                        ? 'Remove Watchlist'
                                        : 'Add Watchlist'),
                                  ],
                                ),
                              );
                            }),
                            Text(
                              _showGenres(tvDetail.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvDetail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvDetail.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvDetail.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<RecommendationTVBloc,
                                    RecommendationTVState>(
                                builder: (context, state) {
                              if (state is RecommendationTVLoadingState) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state
                                  is RecommendationTVHasDataState) {
                                return SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final tv = state.result[index];
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
                                            borderRadius: const BorderRadius.all(
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
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: state.result.length,
                                  ),
                                );
                              } else if (state is RecommendationTVEmptyState) {
                                return const Center(
                                    child: Text('Data Tidak Ditemukan'));
                              } else if (state is RecommendationTVErrorState) {
                                return Center(
                                    key: const Key('error_message'),
                                    child: Text(state.message.toString()));
                              } else {
                                return const Text('');
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
              icon: const Icon(Icons.arrow_back),
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
