import 'package:ditonton/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';
  const PopularTVPage({Key? key}) : super(key: key);

  @override
  State<PopularTVPage> createState() => _PopularTVPageState();
}

class _PopularTVPageState extends State<PopularTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<PopularTVBloc>().add(FetchNowPopularTVShows()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTVBloc, PopularTVState>(
            builder: (context, state) {
          if (state is PopularTVLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PopularTVHasDataState) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = state.result[index];
                return TVCard(tv: tv);
              },
              itemCount: state.result.length,
            );
          } else if (state is PopularTVEmptyState) {
            return Text('Data Tidak Ditemukan');
          } else if (state is PopularTVErrorState) {
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
