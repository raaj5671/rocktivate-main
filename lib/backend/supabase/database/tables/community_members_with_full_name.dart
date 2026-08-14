import '../database.dart';

class CommunityMembersWithFullNameTable
    extends SupabaseTable<CommunityMembersWithFullNameRow> {
  @override
  String get tableName => 'CommunityMembersWithFullName';

  @override
  CommunityMembersWithFullNameRow createRow(Map<String, dynamic> data) =>
      CommunityMembersWithFullNameRow(data);
}

class CommunityMembersWithFullNameRow extends SupabaseDataRow {
  CommunityMembersWithFullNameRow(super.data);

  @override
  SupabaseTable get table => CommunityMembersWithFullNameTable();

  String? get communityMemberUUID => getField<String>('CommunityMemberUUID');
  set communityMemberUUID(String? value) =>
      setField<String>('CommunityMemberUUID', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get peopleLink => getField<String>('PeopleLink');
  set peopleLink(String? value) => setField<String>('PeopleLink', value);

  String? get communityLink => getField<String>('CommunityLink');
  set communityLink(String? value) => setField<String>('CommunityLink', value);

  String? get fullName => getField<String>('FullName');
  set fullName(String? value) => setField<String>('FullName', value);

  String? get email => getField<String>('Email');
  set email(String? value) => setField<String>('Email', value);

  String? get profileImage => getField<String>('ProfileImage');
  set profileImage(String? value) => setField<String>('ProfileImage', value);
}
