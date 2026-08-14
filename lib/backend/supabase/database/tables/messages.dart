import '../database.dart';

class MessagesTable extends SupabaseTable<MessagesRow> {
  @override
  String get tableName => 'Messages';

  @override
  MessagesRow createRow(Map<String, dynamic> data) => MessagesRow(data);
}

class MessagesRow extends SupabaseDataRow {
  MessagesRow(super.data);

  @override
  SupabaseTable get table => MessagesTable();

  String get uuid => getField<String>('UUID')!;
  set uuid(String value) => setField<String>('UUID', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get body => getField<String>('Body');
  set body(String? value) => setField<String>('Body', value);

  String? get sentBy => getField<String>('SentBy');
  set sentBy(String? value) => setField<String>('SentBy', value);

  String? get sentTo => getField<String>('SentTo');
  set sentTo(String? value) => setField<String>('SentTo', value);
}
