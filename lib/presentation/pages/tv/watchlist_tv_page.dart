import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchListTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';
  const WatchListTVPage({Key? key}) : super(key: key);

  @override
  State<WatchListTVPage> createState() => _WatchListTVPageState();
}

class _WatchListTVPageState extends State<WatchListTVPage> with RouteAware {
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

  void didPopNext() {
    context.read<WatchlistTVBloc>().add(FetchNowWatchlistTVShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTVBloc, WatchlistTVState>(
            builder: (context, state) {
          if (state is WatchlistTVLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is WatchlistTVHasDataState) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = state.result[index];
                return TVCard(tv: tv);
              },
              itemCount: state.result.length,
            );
          } else if (state is WatchlistTVEmptyState) {
            return Text('Data Tidak Ditemukan');
          } else if (state is WatchlistTVErrorState) {
            return Center(
              key: Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return Text('Error Bloc');
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
