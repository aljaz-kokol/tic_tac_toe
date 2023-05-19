import 'package:ai_2023_02_28_minmax_alphabeta/app/db/query/generator.query.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/table-field.db.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/types.db.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-symbol.util.dart';

class DbSymbol {
  static const DbTableField dbId = DbTableField('id', DbType.primaryKey);
  static const DbTableField dbSymbol = DbTableField('symbol', DbType.text);

  static const String tableName = 'Symbol';

  final int id;
  final GameSymbol symbol;

  const DbSymbol(this.id, this.symbol);

  DbSymbol.fromSymbolName(int id, String symbolName)
      : this(id, GameSymbol.fromName(symbolName));

  factory DbSymbol.fromMap(Map<String, dynamic> map) =>
      DbSymbol.fromSymbolName(
        map[dbId.name],
        map[dbSymbol.name],
      );

  static String get createSql {
    StringBuffer builder =
        StringBuffer(QueryGenerator.createTable(tableName, [dbId, dbSymbol]));
    for (GameSymbol gameSymbol in GameSymbol.values) {
      builder.write(
        QueryGenerator.insertRaw(
          tableName,
          [dbSymbol],
          [gameSymbol.toString()],
        ),
      );
    }
    return builder.toString();
  }
}
