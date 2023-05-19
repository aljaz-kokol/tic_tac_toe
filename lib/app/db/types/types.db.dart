enum DbType {
  int("INTEGER"),
  text("TEXT"),
  primaryKey("INTEGER PRIMARY KEY AUTOINCREMENT");

  final String name;
  const DbType(this.name);
}