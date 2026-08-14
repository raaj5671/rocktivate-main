import '../database.dart';

class CommunityRequestsTable extends SupabaseTable<CommunityRequestsRow> {
  @override
  String get tableName => 'CommunityRequests';

  @override
  CommunityRequestsRow createRow(Map<String, dynamic> data) =>
      CommunityRequestsRow(data);
}

class CommunityRequestsRow extends SupabaseDataRow {
  CommunityRequestsRow(super.data);

  @override
  SupabaseTable get table => CommunityRequestsTable();

  String get uuid => getField<String>('UUID')!;
  set uuid(String value) => setField<String>('UUID', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get peopleLink => getField<String>('PeopleLink');
  set peopleLink(String? value) => setField<String>('PeopleLink', value);

  String? get communityLink => getField<String>('CommunityLink');
  set communityLink(String? value) => setField<String>('CommunityLink', value);
}
