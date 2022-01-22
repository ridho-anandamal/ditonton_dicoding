import 'package:ditonton/presentation/bloc/movie/popular_tv_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<PopularMovieBloc>().add(FetchNowPopularMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMovieBloc, PopularMovieState>(
            builder: (context, state) {
          if (state is PopularMovieLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PopularMovieHasDataState) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = state.result[index];
                return MovieCard(movie);
              },
              itemCount: state.result.length,
            );
          } else if (state is PopularMovieEmptyState) {
            return Text('Data Tidak Ditemukan');
          } else if (state is PopularMovieErrorState) {
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
