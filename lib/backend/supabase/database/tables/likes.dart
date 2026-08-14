import '../database.dart';

class LikesTable extends SupabaseTable<LikesRow> {
  @override
  String get tableName => 'Likes';

  @override
  LikesRow createRow(Map<String, dynamic> data) => LikesRow(data);
}

class LikesRow extends SupabaseDataRow {
  LikesRow(super.data);

  @override
  SupabaseTable get table => LikesTable();

  String get uuid => getField<String>('UUID')!;
  set uuid(String value) => setField<String>('UUID', value);

  String? get postLink => getField<String>('PostLink');
  set postLink(String? value) => setField<String>('PostLink', value);

  String? get commentLink => getField<String>('CommentLink');
  set commentLink(String? value) => setField<String>('CommentLink', value);

  String? get personLink => getField<String>('PersonLink');
  set personLink(String? value) => setField<String>('PersonLink', value);
}
