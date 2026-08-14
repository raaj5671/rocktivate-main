import '../database.dart';

class FreebiesTable extends SupabaseTable<FreebiesRow> {
  @override
  String get tableName => 'Freebies';

  @override
  FreebiesRow createRow(Map<String, dynamic> data) => FreebiesRow(data);
}

class FreebiesRow extends SupabaseDataRow {
  FreebiesRow(super.data);

  @override
  SupabaseTable get table => FreebiesTable();

  String get uuid => getField<String>('UUID')!;
  set uuid(String value) => setField<String>('UUID', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);

  String? get title => getField<String>('Title');
  set title(String? value) => setField<String>('Title', value);

  String? get description => getField<String>('Description');
  set description(String? value) => setField<String>('Description', value);

  bool? get isAvailable => getField<bool>('isAvailable');
  set isAvailable(bool? value) => setField<bool>('isAvailable', value);

  List<String> get photos => getListField<String>('photos');
  set photos(List<String>? value) => setListField<String>('photos', value);
}
