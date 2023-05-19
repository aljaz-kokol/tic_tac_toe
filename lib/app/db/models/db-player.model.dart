import 'package:ai_2023_02_28_minmax_alphabeta/app/db/query/generator.query.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/table-field.db.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/types.db.dart';

class DbPlayer {
  static const DbTableField dbId = DbTableField('id', DbType.primaryKey);
  static const DbTableField dbName = DbTableField('name', DbType.text);

  static const String tableName = 'Player';

  final int id;
  final String name;

  const DbPlayer(this.id, this.name);

  factory DbPlayer.fromMap(Map<String, dynamic> map) =>
      DbPlayer(
        map[dbId.name],
        map[dbName.name],
      );

  static String get createSql {
    StringBuffer builder = StringBuffer(QueryGenerator.createTable(
      tableName,
      [dbId, dbName],
    ));
    builder.write(QueryGenerator.insertRaw(tableName, [dbName], ['human']));
    builder.write(QueryGenerator.insertRaw(tableName, [dbName], ['computer']));
    return builder.toString();
  }
}
