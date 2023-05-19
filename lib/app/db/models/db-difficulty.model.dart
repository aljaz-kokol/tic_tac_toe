import 'package:ai_2023_02_28_minmax_alphabeta/app/db/query/generator.query.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/types.db.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-difficulty.util.dart';
import '../types/table-field.db.dart';

class DbDifficulty {
  static const DbTableField dbId = DbTableField("id", DbType.primaryKey);
  static const DbTableField dbName = DbTableField("name", DbType.text);

  static const String tableName = "Difficulty";

  final int id;
  final String name;

  DbDifficulty(this.id, this.name);

  factory DbDifficulty.fromMap(Map<String, dynamic> map) =>
      DbDifficulty(map[dbId.name], map[dbName.name]);

  static String get createSql {
    StringBuffer builder = StringBuffer(QueryGenerator.createTable(
      tableName,
      [dbId, dbName],
    ));
    for (GameDifficulty diff in GameDifficulty.values) {
      builder.write(QueryGenerator.insertRaw(
        tableName,
        [dbName],
        [diff.name],
      ));
    }
    return builder.toString();
  }

}
