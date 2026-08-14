import '../database.dart';

class PeopleTable extends SupabaseTable<PeopleRow> {
  @override
  String get tableName => 'People';

  @override
  PeopleRow createRow(Map<String, dynamic> data) => PeopleRow(data);
}

class PeopleRow extends SupabaseDataRow {
  PeopleRow(super.data);

  @override
  SupabaseTable get table => PeopleTable();

  String get uuid => getField<String>('UUID')!;
  set uuid(String value) => setField<String>('UUID', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get firstName => getField<String>('FirstName');
  set firstName(String? value) => setField<String>('FirstName', value);

  String? get lastName => getField<String>('LastName');
  set lastName(String? value) => setField<String>('LastName', value);

  String? get preferredName => getField<String>('PreferredName');
  set preferredName(String? value) => setField<String>('PreferredName', value);

  DateTime? get birthday => getField<DateTime>('Birthday');
  set birthday(DateTime? value) => setField<DateTime>('Birthday', value);

  String? get email => getField<String>('Email');
  set email(String? value) => setField<String>('Email', value);

  String? get userUUID => getField<String>('UserUUID');
  set userUUID(String? value) => setField<String>('UserUUID', value);

  String? get profileImage => getField<String>('ProfileImage');
  set profileImage(String? value) => setField<String>('ProfileImage', value);

  List<String> get gifts => getListField<String>('Gifts');
  set gifts(List<String>? value) => setListField<String>('Gifts', value);

  String? get country => getField<String>('Country');
  set country(String? value) => setField<String>('Country', value);

  String? get postCode => getField<String>('PostCode');
  set postCode(String? value) => setField<String>('PostCode', value);

  String? get gender => getField<String>('Gender');
  set gender(String? value) => setField<String>('Gender', value);

  bool? get hasCompletedOnboarding => getField<bool>('HasCompletedOnboarding');
  set hasCompletedOnboarding(bool? value) =>
      setField<bool>('HasCompletedOnboarding', value);

  String? get bio => getField<String>('Bio');
  set bio(String? value) => setField<String>('Bio', value);
}
