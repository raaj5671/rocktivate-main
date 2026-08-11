import '../database.dart';

class NeedsTable extends SupabaseTable<NeedsRow> {
  @override
  String get tableName => 'Needs';

  @override
  NeedsRow createRow(Map<String, dynamic> data) => NeedsRow(data);
}

class NeedsRow extends SupabaseDataRow {
  NeedsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => NeedsTable();

  int get uuid => getField<int>('UUID')!;
  set uuid(int value) => setField<int>('UUID', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);

  String? get title => getField<String>('Title');
  set title(String? value) => setField<String>('Title', value);

  String? get description => getField<String>('Description');
  set description(String? value) => setField<String>('Description', value);

  String? get fulfilled => getField<String>('Fulfilled');
  set fulfilled(String? value) => setField<String>('Fulfilled', value);
}
