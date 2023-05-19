import 'package:ai_2023_02_28_minmax_alphabeta/app/db/query/generator.query.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/table-field.db.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/types.db.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-status.util.dart';

class DbMatchStatus {
  static const DbTableField dbId = DbTableField('id', DbType.primaryKey);
  static const DbTableField dbStatus = DbTableField('status', DbType.text);
  static const String tableName = 'Match_Status';

  final int id;
  final String status;

  const DbMatchStatus(this.id, this.status);

  factory DbMatchStatus.fromMap(Map<String, dynamic> map) =>
      DbMatchStatus(map[dbId.name], map[dbStatus.name]);

  static String get createSql {
    StringBuffer builder = StringBuffer(QueryGenerator.createTable(
      tableName,
      [dbId, dbStatus],
    ));
    for (GameStatus status in GameStatus.values) {
      builder.write(QueryGenerator.insertRaw(
        tableName,
        [dbStatus],
        [status.status],
      ));
    }
    return builder.toString();
  }
}
