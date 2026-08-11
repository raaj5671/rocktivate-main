import '../database.dart';

class ConversationParticipantsTable
    extends SupabaseTable<ConversationParticipantsRow> {
  @override
  String get tableName => 'conversation_participants';

  @override
  ConversationParticipantsRow createRow(Map<String, dynamic> data) =>
      ConversationParticipantsRow(data);
}

class ConversationParticipantsRow extends SupabaseDataRow {
  ConversationParticipantsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ConversationParticipantsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get conversationId => getField<String>('conversation_id')!;
  set conversationId(String value) =>
      setField<String>('conversation_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime get joinedAt => getField<DateTime>('joined_at')!;
  set joinedAt(DateTime value) => setField<DateTime>('joined_at', value);

  DateTime? get lastReadAt => getField<DateTime>('last_read_at');
  set lastReadAt(DateTime? value) => setField<DateTime>('last_read_at', value);
}
