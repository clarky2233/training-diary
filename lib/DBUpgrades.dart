class DBUpgrade {
  int version;
  List<String> sqlUpgrades;

  DBUpgrade({this.version, this.sqlUpgrades});
}
