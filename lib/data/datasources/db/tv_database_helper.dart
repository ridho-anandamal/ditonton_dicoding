// import 'package:ditonton/data/models/tv/tv_table.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelperTV {
//   static DatabaseHelperTV? _databaseHelperTV;
//   DatabaseHelperTV._instance() {
//     _databaseHelperTV = this;
//   }

//   factory DatabaseHelperTV() =>
//       _databaseHelperTV ?? DatabaseHelperTV._instance();

//   static Database? _database;
//   Future<Database?> get database async {
//     if (_database == null) return _database = await _initDb();

//     return _database;
//   }

//   static const String _tblWatchlist = 'watchlist';

//   Future<Database> _initDb(){
//     final path await getDatabasesPath();
//     final databasePath = '$path/tvwatch'
//   }
//   void _onCreate(Database db, int version);
//   Future<int> insertWatchList(TVTable tv);
// }
