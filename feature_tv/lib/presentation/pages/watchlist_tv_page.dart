// ignore_for_file: constant_identifier_names

import 'package:core/core.dart';
import 'package:feature_tv/presentation/blocs/watchlist_tv_bloc.dart';
import 'package:feature_tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';
  const WatchlistTVPage({Key? key}) : super(key: key);

  @override
  State<WatchlistTVPage> createState() => _WatchlistTVPageState();
}

class _WatchlistTVPageState extends State<WatchlistTVPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<WatchlistTVBloc>().add(FetchNowWatchlistTVShows()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTVBloc>().add(FetchNowWatchlistTVShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTVBloc, WatchlistTVState>(
            builder: (context, state) {
          if (state is WatchlistTVLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WatchlistTVHasDataState) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = state.result[index];
                return TVCard(tv: tv);
              },
              itemCount: state.result.length,
            );
          } else if (state is WatchlistTVEmptyState) {
            return const Text('Data Tidak Ditemukan');
          } else if (state is WatchlistTVErrorState) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return const Text('Error Bloc');
          }
        }),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
