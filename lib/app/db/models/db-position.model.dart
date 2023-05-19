import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-symbol.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/query/generator.query.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/table-field.db.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/types.db.dart';

class DbPosition {
  static const DbTableField dbId = DbTableField('id', DbType.primaryKey);
  static const DbTableField dbX = DbTableField('x', DbType.int);
  static const DbTableField dbY = DbTableField('y', DbType.int);

  static final DbTableField dbSymbolId = DbTableField(
      'FK_symbol_id', DbType.int,
      reference: DbReferenceField(DbSymbol.tableName, DbSymbol.dbId));

  static const String tableName = 'Position';

  final int id;
  final int x;
  final int y;
  final int symbolId;

  const DbPosition(this.id, this.x, this.y, this.symbolId);

  factory DbPosition.fromMap(Map<String, dynamic> map) =>
      DbPosition(
        map[dbId.name],
        map[dbX.name],
        map[dbY.name],
        map[dbSymbolId.name],
      );

  static String get createSql => QueryGenerator.createTable(
        tableName,
        [dbId, dbX, dbY, dbSymbolId],
      );
}
