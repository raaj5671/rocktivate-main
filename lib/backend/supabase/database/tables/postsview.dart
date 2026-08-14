import '../database.dart';

class PostsviewTable extends SupabaseTable<PostsviewRow> {
  @override
  String get tableName => 'postsview';

  @override
  PostsviewRow createRow(Map<String, dynamic> data) => PostsviewRow(data);
}

class PostsviewRow extends SupabaseDataRow {
  PostsviewRow(super.data);

  @override
  SupabaseTable get table => PostsviewTable();

  String? get uuid => getField<String>('UUID');
  set uuid(String? value) => setField<String>('UUID', value);

  String? get description => getField<String>('Description');
  set description(String? value) => setField<String>('Description', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  bool? get isGroupPost => getField<bool>('isGroupPost');
  set isGroupPost(bool? value) => setField<bool>('isGroupPost', value);

  String? get groupLink => getField<String>('GroupLink');
  set groupLink(String? value) => setField<String>('GroupLink', value);

  String? get fullname => getField<String>('fullname');
  set fullname(String? value) => setField<String>('fullname', value);

  int? get commentscount => getField<int>('commentscount');
  set commentscount(int? value) => setField<int>('commentscount', value);

  int? get reactioncount => getField<int>('reactioncount');
  set reactioncount(int? value) => setField<int>('reactioncount', value);

  String? get profileImage => getField<String>('ProfileImage');
  set profileImage(String? value) => setField<String>('ProfileImage', value);

  List<String> get photos => getListField<String>('photos');
  set photos(List<String>? value) => setListField<String>('photos', value);
}
