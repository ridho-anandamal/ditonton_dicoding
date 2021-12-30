// TODO: Step 2 -> Buat data local untuk TV

import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/models/tv/tv_table.dart';

abstract class TVLocalDataSource{
  Future<String> insertWatchList(TVTable tv);
}