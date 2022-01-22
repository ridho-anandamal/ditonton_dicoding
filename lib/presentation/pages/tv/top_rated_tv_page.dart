import 'package:ditonton/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
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
        title: Text('Top Rated TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTVBloc, TopRatedTVState>(
            builder: (context, state) {
          if (state is TopRatedTVLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TopRatedTVHasDataState) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = state.result[index];
                return TVCard(tv: tv);
              },
              itemCount: state.result.length,
            );
          } else if (state is TopRatedTVEmptyState) {
            return Text('Data Tidak Ditemukan');
          } else if (state is TopRatedTVErrorState) {
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
}
