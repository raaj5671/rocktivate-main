import '../database.dart';

class CommunitiesTable extends SupabaseTable<CommunitiesRow> {
  @override
  String get tableName => 'Communities';

  @override
  CommunitiesRow createRow(Map<String, dynamic> data) => CommunitiesRow(data);
}

class CommunitiesRow extends SupabaseDataRow {
  CommunitiesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunitiesTable();

  String get uuid => getField<String>('UUID')!;
  set uuid(String value) => setField<String>('UUID', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);

  String? get title => getField<String>('Title');
  set title(String? value) => setField<String>('Title', value);

  String? get tileImage => getField<String>('TileImage');
  set tileImage(String? value) => setField<String>('TileImage', value);

  String? get headerImage => getField<String>('HeaderImage');
  set headerImage(String? value) => setField<String>('HeaderImage', value);

  bool? get isPrivate => getField<bool>('IsPrivate');
  set isPrivate(bool? value) => setField<bool>('IsPrivate', value);
}
