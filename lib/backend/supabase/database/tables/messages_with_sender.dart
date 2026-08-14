import '../database.dart';

class MessagesWithSenderTable extends SupabaseTable<MessagesWithSenderRow> {
  @override
  String get tableName => 'MessagesWithSender';

  @override
  MessagesWithSenderRow createRow(Map<String, dynamic> data) =>
      MessagesWithSenderRow(data);
}

class MessagesWithSenderRow extends SupabaseDataRow {
  MessagesWithSenderRow(super.data);

  @override
  SupabaseTable get table => MessagesWithSenderTable();

  String? get messageUUID => getField<String>('MessageUUID');
  set messageUUID(String? value) => setField<String>('MessageUUID', value);

  DateTime? get sentAt => getField<DateTime>('SentAt');
  set sentAt(DateTime? value) => setField<DateTime>('SentAt', value);

  String? get messageBody => getField<String>('MessageBody');
  set messageBody(String? value) => setField<String>('MessageBody', value);

  String? get senderUUID => getField<String>('SenderUUID');
  set senderUUID(String? value) => setField<String>('SenderUUID', value);

  String? get senderFullName => getField<String>('SenderFullName');
  set senderFullName(String? value) =>
      setField<String>('SenderFullName', value);

  String? get senderProfileImage => getField<String>('SenderProfileImage');
  set senderProfileImage(String? value) =>
      setField<String>('SenderProfileImage', value);

  String? get recipientUUID => getField<String>('RecipientUUID');
  set recipientUUID(String? value) => setField<String>('RecipientUUID', value);

  String? get recipientFullName => getField<String>('RecipientFullName');
  set recipientFullName(String? value) =>
      setField<String>('RecipientFullName', value);

  String? get recipientProfileImage =>
      getField<String>('RecipientProfileImage');
  set recipientProfileImage(String? value) =>
      setField<String>('RecipientProfileImage', value);

  List<String> get participants => getListField<String>('Participants');
  set participants(List<String>? value) =>
      setListField<String>('Participants', value);
}
