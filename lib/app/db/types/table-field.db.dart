import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/types.db.dart';

class DbTableField {
  final String name;
  final DbType type;
  final bool optional;
  final DbReferenceField? reference;

  const DbTableField(this.name, this.type, {this.optional = false, this.reference});

  @override
  String toString() {
    StringBuffer strBuilder = StringBuffer('$name ${type.name}');
    if (!optional && type != DbType.primaryKey) strBuilder.write(' NOT NULL');
    return strBuilder.toString();
  }
}


class DbReferenceField extends DbTableField {
  final String tableName;
  DbReferenceField(this.tableName, DbTableField refField): super(refField.name, refField.type);
}
