enum SyncAction {
  insert,
  update,
  delete,
  pass,
  ;
}

interface class SupaSyncable {
  SyncAction get syncAction => SyncAction.pass;

  Future<void> onSync(SyncAction action) async {
    throw UnimplementedError();
  }
}
