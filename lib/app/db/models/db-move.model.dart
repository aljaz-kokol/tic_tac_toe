import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-match.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-player.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-position.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/query/generator.query.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/table-field.db.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/types.db.dart';

class DbMove {
  static const DbTableField dbId = DbTableField('id', DbType.primaryKey);
  static const DbTableField dbNumber = DbTableField('number', DbType.int);

  static final DbTableField dbMatchId = DbTableField('FK_match_id', DbType.int,
      reference: DbReferenceField(DbMatch.tableName, DbMatch.dbId));

  static final DbTableField dbPositionId = DbTableField(
      'FK_position_id', DbType.int,
      reference: DbReferenceField(DbPosition.tableName, DbPosition.dbId));

  static final DbTableField dbPlayerId = DbTableField(
      'FK_player_id', DbType.int,
      reference: DbReferenceField(DbPlayer.tableName, DbPlayer.dbId));

  static const String tableName = 'Move';

  final int id;
  final int number;
  final int matchId;
  final int positionId;
  final int playerId;

  const DbMove(
    this.id,
    this.number,
    this.matchId,
    this.positionId,
    this.playerId,
  );

  factory DbMove.fromMap(Map<String, dynamic> map) =>
      DbMove(
        map[dbId.name],
        map[dbNumber.name],
        map[dbMatchId.name],
        map[dbPositionId.name],
        map[dbPlayerId.name],
      );

  static String get createSql => QueryGenerator.createTable(
        tableName,
        [dbId, dbNumber, dbMatchId, dbPositionId, dbPlayerId],
      );
}
