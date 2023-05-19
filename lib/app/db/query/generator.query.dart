import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/table-field.db.dart';

abstract class QueryGenerator {
  static String createTable(String tableName, List<DbTableField> fields) {
    StringBuffer sqlBuilder = StringBuffer('CREATE TABLE $tableName ( ');
    for (DbTableField field in fields) {
      sqlBuilder.write('$field');
      if (field.reference != null) {
        sqlBuilder.write(' REFERENCES ${field.reference!.tableName} (${field.reference!.name}) ON DELETE CASCADE');
      }
      if (fields.indexOf(field) < fields.length - 1) sqlBuilder.write(", ");
    }
    sqlBuilder.write(');');
    return sqlBuilder.toString();
  }

  static String insertRaw(
      String tableName, List<DbTableField> fields, List<dynamic> values) {
    StringBuffer sqlBuilder = StringBuffer('INSERT INTO $tableName (');
    for (DbTableField field in fields) {
      sqlBuilder.write(field.name);
      if (fields.indexOf(field) < fields.length - 1) sqlBuilder.write(', ');
    }
    sqlBuilder.write(') VALUES (');
    for (dynamic value in values) {
      sqlBuilder.write("'$value'");
      if (values.indexOf(value) < values.length - 1) sqlBuilder.write(', ');
    }
    sqlBuilder.write(');');
    return sqlBuilder.toString();
  }

  static String insertPrepare(
      String tableName, List<DbTableField> fields) {
    StringBuffer sqlBuilder = StringBuffer('INSERT INTO $tableName (');
    for (DbTableField field in fields) {
      sqlBuilder.write(field.name);
      if (fields.indexOf(field) < fields.length - 1) sqlBuilder.write(', ');
    }
    sqlBuilder.write(') VALUES (');
    for (DbTableField field in fields) {
      sqlBuilder.write('?');
      if (fields.indexOf(field) < fields.length - 1) sqlBuilder.write(', ');
    }
    sqlBuilder.write(');');
    return sqlBuilder.toString();
  }

  static String selectWhereUsingAnd(String tableName, List<DbTableField> fields) {
    StringBuffer sqlBuilder = StringBuffer('SELECT * FROM $tableName WHERE ');
    for (DbTableField field in fields) {
      sqlBuilder.write('${field.name} = ?');
      if (fields.indexOf(field) < fields.length - 1) sqlBuilder.write(' AND ');
    }
    sqlBuilder.write(';');
    return sqlBuilder.toString();
  }

  static String selectAll(String tableName) => 'SELECT * FROM $tableName;';
}
