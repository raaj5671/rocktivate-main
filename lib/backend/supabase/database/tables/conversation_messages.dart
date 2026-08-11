import '../database.dart';

class ConversationMessagesTable extends SupabaseTable<ConversationMessagesRow> {
  @override
  String get tableName => 'ConversationMessages';

  @override
  ConversationMessagesRow createRow(Map<String, dynamic> data) =>
      ConversationMessagesRow(data);
}

class ConversationMessagesRow extends SupabaseDataRow {
  ConversationMessagesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ConversationMessagesTable();

  String? get messageUUID => getField<String>('MessageUUID');
  set messageUUID(String? value) => setField<String>('MessageUUID', value);

  DateTime? get sentAt => getField<DateTime>('SentAt');
  set sentAt(DateTime? value) => setField<DateTime>('SentAt', value);

  String? get messageBody => getField<String>('MessageBody');
  set messageBody(String? value) => setField<String>('MessageBody', value);

  String? get sentBy => getField<String>('SentBy');
  set sentBy(String? value) => setField<String>('SentBy', value);

  String? get senderFullName => getField<String>('SenderFullName');
  set senderFullName(String? value) =>
      setField<String>('SenderFullName', value);

  String? get sentTo => getField<String>('SentTo');
  set sentTo(String? value) => setField<String>('SentTo', value);

  String? get recipientFullName => getField<String>('RecipientFullName');
  set recipientFullName(String? value) =>
      setField<String>('RecipientFullName', value);

  List<String> get participants => getListField<String>('Participants');
  set participants(List<String>? value) =>
      setListField<String>('Participants', value);
}
