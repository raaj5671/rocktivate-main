import '../database.dart';

class CommunityMembersTable extends SupabaseTable<CommunityMembersRow> {
  @override
  String get tableName => 'CommunityMembers';

  @override
  CommunityMembersRow createRow(Map<String, dynamic> data) =>
      CommunityMembersRow(data);
}

class CommunityMembersRow extends SupabaseDataRow {
  CommunityMembersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityMembersTable();

  String get uuid => getField<String>('UUID')!;
  set uuid(String value) => setField<String>('UUID', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get peopleLink => getField<String>('PeopleLink');
  set peopleLink(String? value) => setField<String>('PeopleLink', value);

  String? get communityLink => getField<String>('CommunityLink');
  set communityLink(String? value) => setField<String>('CommunityLink', value);
}
