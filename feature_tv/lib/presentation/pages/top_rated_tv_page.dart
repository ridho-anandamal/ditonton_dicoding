// ignore_for_file: constant_identifier_names

import 'package:feature_tv/presentation/blocs/top_rated_tv_bloc.dart';
import 'package:feature_tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';
  const TopRatedTVPage({Key? key}) : super(key: key);

  @override
  State<TopRatedTVPage> createState() => _TopRatedTVPageState();
}

class _TopRatedTVPageState extends State<TopRatedTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<TopRatedTVBloc>().add(FetchNowTopRatedTVShows()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTVBloc, TopRatedTVState>(
            builder: (context, state) {
          if (state is TopRatedTVLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TopRatedTVHasDataState) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = state.result[index];
                return TVCard(tv: tv);
              },
              itemCount: state.result.length,
            );
          } else if (state is TopRatedTVEmptyState) {
            return const Text('Data Tidak Ditemukan');
          } else if (state is TopRatedTVErrorState) {
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
}
