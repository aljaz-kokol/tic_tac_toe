import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-difficulty.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-match.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-move.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-player.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-position.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-symbol.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/query/generator.query.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/models/player.game.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/models/position.game.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-difficulty.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-status.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-symbol.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/player-color.util.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/db-match-status.model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  late final Database _database;
  bool _didInit = false;

  DatabaseHelper._internal();

  static DatabaseHelper get get => _instance;

  Future<Database> _getDatabase() async {
    if (!_didInit) {
      await _initDatabase();
    }
    return _database;
  }

  Future<void> _initDatabase() async {
    final String dbPath = join(await getDatabasesPath(), "ai.db");
    // await databaseFactory.deleteDatabase(dbPath);
    List<String> createSqlList = [
      DbDifficulty.createSql,
      DbSymbol.createSql,
      DbPosition.createSql,
      DbPlayer.createSql,
      DbMatchStatus.createSql,
      DbMatch.createSql,
      DbMove.createSql,
    ];
    _database = await openDatabase(dbPath,
        version: 1,
        onCreate: (db, version) async {
          for (String createSql in createSqlList) {
            for (String query in createSql.split(';')) {
              if (query.trim().isNotEmpty) await db.execute(query);
            }
          }
        },
        onConfigure: (db) async => await db.execute("PRAGMA foreign_keys = ON"));
    _didInit = true;
  }

  Future<int> countMatchesWhereStatus(GameStatus status) async {
    Database db = await _getDatabase();
    var result = await db.rawQuery('''
        SELECT * FROM ${DbMatch.tableName}
        INNER JOIN ${DbMatchStatus.tableName} ON ${DbMatch.tableName}.${DbMatch.dbMatchStatusId.name} = ${DbMatchStatus.tableName}.${DbMatchStatus.dbId.name}
        WHERE ${DbMatchStatus.tableName}.${DbMatchStatus.dbStatus.name} = ?;''',
        [status.status]);
    return result.length;
  }

  Future<int> countMovesWhereMatchId(int matchId) async {
    Database db = await _getDatabase();
    String query = QueryGenerator.selectWhereUsingAnd(
        DbMove.tableName, [DbMove.dbMatchId]);
    var result = await db.rawQuery(query, [matchId]);
    return result.length;
  }

  Future<DbMatchStatus?> getMatchStatus(GameStatus status) async {
    Database db = await _getDatabase();
    String query = QueryGenerator.selectWhereUsingAnd(
        DbMatchStatus.tableName, [DbMatchStatus.dbStatus]);
    var result = await db.rawQuery(query, [status.status]);
    if (result.isNotEmpty) {
      return DbMatchStatus.fromMap(result.first);
    }
    return null;
  }

  Future<DbMatchStatus?> getMatchStatusFromId(int id) async {
    Database db = await _getDatabase();
    String query = QueryGenerator.selectWhereUsingAnd(
        DbMatchStatus.tableName, [DbMatchStatus.dbId]);
    var result = await db.rawQuery(query, [id]);
    if (result.isNotEmpty) {
      return DbMatchStatus.fromMap(result.first);
    }
    return null;
  }

  Future<DbDifficulty?> getDifficulty(GameDifficulty difficulty) async {
    Database db = await _getDatabase();
    String query = QueryGenerator.selectWhereUsingAnd(
        DbDifficulty.tableName, [DbDifficulty.dbName]);
    var result = await db.rawQuery(query, [difficulty.name]);
    if (result.isNotEmpty) {
      return DbDifficulty.fromMap(result.first);
    }
    return null;
  }

  Future<DbDifficulty?> getDifficultyFromId(int id) async {
    Database db = await _getDatabase();
    String query = QueryGenerator.selectWhereUsingAnd(
        DbDifficulty.tableName, [DbDifficulty.dbId]);
    var result = await db.rawQuery(query, [id]);
    if (result.isNotEmpty) {
      return DbDifficulty.fromMap(result.first);
    }
    return null;
  }

  Future<DbSymbol?> getSymbolFromGamePosition(GamePosition position) async {
    Database db = await _getDatabase();
    String query = QueryGenerator.selectWhereUsingAnd(
        DbSymbol.tableName, [DbSymbol.dbSymbol]);
    var result = await db.rawQuery(query, [position.player!.symbol.toString()]);
    if (result.isNotEmpty) {
      return DbSymbol.fromMap(result.first);
    }
    return null;
  }

  Future<DbPosition?> getPosition(GamePosition position) async {
    Database db = await _getDatabase();
    DbSymbol symbol = (await getSymbolFromGamePosition(position))!;
    String query = QueryGenerator.selectWhereUsingAnd(
      DbPosition.tableName,
      [DbPosition.dbSymbolId, DbPosition.dbX, DbPosition.dbY],
    );
    var result = await db.rawQuery(query, [symbol.id, position.x, position.y]);
    if (result.isNotEmpty) {
      return DbPosition.fromMap(result.first);
    }
    return null;
  }

  Future<DbPosition?> getPositionFromId(int id) async {
    Database db = await _getDatabase();
    String query = QueryGenerator.selectWhereUsingAnd(DbPosition.tableName, [DbPosition.dbId],);
    var result = await db.rawQuery(query, [id]);
    if (result.isNotEmpty) {
      return DbPosition.fromMap(result.first);
    }
    return null;
  }

  Future<DbSymbol?> getSymbolFromId(int id) async {
    Database db = await _getDatabase();
    String query = QueryGenerator.selectWhereUsingAnd(DbSymbol.tableName, [DbSymbol.dbId],);
    var result = await db.rawQuery(query, [id]);
    if (result.isNotEmpty) {
      return DbSymbol.fromMap(result.first);
    }
    return null;
  }

  Future<DbSymbol?> getSymbolFromGameSymbol(GameSymbol symbol) async {
    Database db = await _getDatabase();
    String query = QueryGenerator.selectWhereUsingAnd(DbSymbol.tableName, [DbSymbol.dbSymbol],);
    var result = await db.rawQuery(query, [symbol.toString()]);
    if (result.isNotEmpty) {
      return DbSymbol.fromMap(result.first);
    }
    return null;
  }

  Future<DbPlayer?> getPlayerByName(String name) async {
    Database db = await _getDatabase();
    String query = QueryGenerator.selectWhereUsingAnd(
        DbPlayer.tableName, [DbPlayer.dbName]);
    var result = await db.rawQuery(query, [name]);
    if (result.isNotEmpty) {
      return DbPlayer.fromMap(result.first);
    }
    return null;
  }

  Future<DbPlayer?> getPlayerFromId(int id) async {
    Database db = await _getDatabase();
    String query = QueryGenerator.selectWhereUsingAnd(
        DbPlayer.tableName, [DbPlayer.dbId]);
    var result = await db.rawQuery(query, [id]);
    if (result.isNotEmpty) {
      return DbPlayer.fromMap(result.first);
    }
    return null;
  }

  Future<List<DbMove>> getMovesFromMatchId(int matchId) async {
    List<DbMove> moves = [];
    Database db = await _getDatabase();
    String movesQuery = QueryGenerator.selectWhereUsingAnd(DbMove.tableName, [DbMove.dbMatchId]);
    var result = await db.rawQuery(movesQuery, [matchId]);
    for (var map in result) {
      moves.add(DbMove.fromMap(map));
    }
    return moves;
  }

  Future<GamePosition> getGamePositionFromMove(DbMove move) async {
    DbPosition dbPosition = (await getPositionFromId(move.positionId))!;
    GameSymbol symbol = (await getSymbolFromId(dbPosition.symbolId))!.symbol;
    DbPlayer dbPlayer = (await getPlayerFromId(move.playerId))!;
    PlayerColor color = dbPlayer.name == 'human' ? PlayerColor.human : PlayerColor.computer;
    GamePlayer player = GamePlayer(symbol, color.color);
    return GamePosition(dbPosition.x, dbPosition.y, player: player);
  }

  Future<int> insertPosition(GamePosition gamePosition) async {
    DbPosition? position = await getPosition(gamePosition);
    if (position != null) return position.id;
    Database db = await _getDatabase();
    DbSymbol symbol = (await getSymbolFromGamePosition(gamePosition))!;
    String query = QueryGenerator.insertPrepare(DbPosition.tableName,
        [DbPosition.dbSymbolId, DbPosition.dbX, DbPosition.dbY]);
    return await db
        .rawInsert(query, [symbol.id, gamePosition.x, gamePosition.y]);
  }

  Future<int> insertMatch(GameDifficulty difficulty, GameSymbol humanSymbol) async {
    Database db = await _getDatabase();
    DbMatchStatus matchStatus = (await getMatchStatus(GameStatus.ongoing))!;
    DbDifficulty matchDiff = (await getDifficulty(difficulty))!;
    DbSymbol symbol = (await getSymbolFromGameSymbol(humanSymbol))!;
    String query = QueryGenerator.insertPrepare(DbMatch.tableName, [
      DbMatch.dbHumanSymbolId,
      DbMatch.dbMatchStatusId,
      DbMatch.dbDifficultyId,
    ]);
    return await db.rawInsert(query, [symbol.id, matchStatus.id, matchDiff.id]);
  }

  Future<void> insertMove(
      int matchId, GamePosition position, bool isHuman) async {
    Database db = await _getDatabase();
    DbPlayer player = (await getPlayerByName(isHuman ? 'human' : 'computer'))!;
    int positionId = await insertPosition(position);
    int number = (await countMovesWhereMatchId(matchId)) + 1;

    String query = QueryGenerator.insertPrepare(DbMove.tableName, [
      DbMove.dbNumber,
      DbMove.dbMatchId,
      DbMove.dbPositionId,
      DbMove.dbPlayerId,
    ]);
    await db.rawInsert(query, [number, matchId, positionId, player.id]);
  }

  Future<void> updateMatchDifficulty(
      int matchId, GameDifficulty newDiff) async {
    Database db = await _getDatabase();
    DbDifficulty diff = (await getDifficulty(newDiff))!;
    String query =
        "UPDATE ${DbMatch.tableName} SET ${DbMatch.dbDifficultyId.name} = ? WHERE ${DbMatch.dbId.name} = ?;";
    await db.rawUpdate(query, [diff.id, matchId]);
  }

  Future<void> updateMatchStatus(int matchId, GameStatus newStatus) async {
    Database db = await _getDatabase();
    DbMatchStatus matchStatus = (await getMatchStatus(newStatus))!;
    String query =
        "UPDATE ${DbMatch.tableName} SET ${DbMatch.dbMatchStatusId.name} = ? WHERE ${DbMatch.dbId.name} = ?;";
    await db.rawUpdate(query, [matchStatus.id, matchId]);
  }

  Future<DbMatchDetail> getDetailedMatch(DbMatch match) async {
    String name = "Match ${match.id}";
    GameDifficulty difficulty = GameDifficulty.fromName((await getDifficultyFromId(match.difficultyId))!.name);
    GameStatus status = GameStatus.fromStatusName((await getMatchStatusFromId(match.matchStatusId))!.status);
    List<DbMove> dbMoves = await getMovesFromMatchId(match.id);
    List<GamePosition> positions = [];
    for (DbMove move in dbMoves) {
      positions.add(await getGamePositionFromMove(move));
    }
    GameSymbol humanSymbol = (await getSymbolFromId(match.humanSymbolId))!.symbol;
    GameSymbol computeSymbol = humanSymbol.oppositeSymbol;

    GamePlayer human = GamePlayer(humanSymbol, PlayerColor.human.color);
    GamePlayer computer = GamePlayer(computeSymbol, PlayerColor.computer.color);
    return DbMatchDetail(match.id, name, human, computer, difficulty, status, positions);
  }

  Stream<List<DbMatchDetail>> getDetailedMatchListStream() async* {
    Database db = await _getDatabase();
    var results = await db.rawQuery(QueryGenerator.selectAll(DbMatch.tableName));
    List<DbMatchDetail> matches = [];
    for (var result in results) {
      matches.add(await getDetailedMatch(DbMatch.fromMap(result)));
      yield matches;
    }
  }

  Future<void> deleteMatchById(int matchId) async {
    Database db = await _getDatabase();
    String query = "DELETE FROM ${DbMatch.tableName} WHERE ${DbMatch.dbId.name} = ?;";
    await db.rawDelete(query,  [matchId]);
  }
}
