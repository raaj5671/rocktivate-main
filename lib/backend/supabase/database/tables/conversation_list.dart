import '../database.dart';

class ConversationListTable extends SupabaseTable<ConversationListRow> {
  @override
  String get tableName => 'conversation_list';

  @override
  ConversationListRow createRow(Map<String, dynamic> data) =>
      ConversationListRow(data);
}

class ConversationListRow extends SupabaseDataRow {
  ConversationListRow(super.data);

  @override
  SupabaseTable get table => ConversationListTable();

  String? get conversationId => getField<String>('conversation_id');
  set conversationId(String? value) =>
      setField<String>('conversation_id', value);

  String? get viewerId => getField<String>('viewer_id');
  set viewerId(String? value) => setField<String>('viewer_id', value);

  String? get otherUserId => getField<String>('other_user_id');
  set otherUserId(String? value) => setField<String>('other_user_id', value);

  String? get otherUserName => getField<String>('other_user_name');
  set otherUserName(String? value) =>
      setField<String>('other_user_name', value);

  String? get otherUserImage => getField<String>('other_user_image');
  set otherUserImage(String? value) =>
      setField<String>('other_user_image', value);

  String? get lastMessage => getField<String>('last_message');
  set lastMessage(String? value) => setField<String>('last_message', value);

  DateTime? get lastMessageAt => getField<DateTime>('last_message_at');
  set lastMessageAt(DateTime? value) =>
      setField<DateTime>('last_message_at', value);
}
