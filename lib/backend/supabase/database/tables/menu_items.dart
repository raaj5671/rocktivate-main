import '../database.dart';

class MenuItemsTable extends SupabaseTable<MenuItemsRow> {
  @override
  String get tableName => 'MenuItems';

  @override
  MenuItemsRow createRow(Map<String, dynamic> data) => MenuItemsRow(data);
}

class MenuItemsRow extends SupabaseDataRow {
  MenuItemsRow(super.data);

  @override
  SupabaseTable get table => MenuItemsTable();

  String get uuid => getField<String>('UUID')!;
  set uuid(String value) => setField<String>('UUID', value);

  int? get orderIndex => getField<int>('OrderIndex');
  set orderIndex(int? value) => setField<int>('OrderIndex', value);

  String? get title => getField<String>('Title');
  set title(String? value) => setField<String>('Title', value);

  String? get image => getField<String>('Image');
  set image(String? value) => setField<String>('Image', value);

  String? get gradient1 => getField<String>('Gradient1');
  set gradient1(String? value) => setField<String>('Gradient1', value);

  String? get gradient2 => getField<String>('Gradient2');
  set gradient2(String? value) => setField<String>('Gradient2', value);

  int? get gradientDegree => getField<int>('GradientDegree');
  set gradientDegree(int? value) => setField<int>('GradientDegree', value);

  bool? get enabled => getField<bool>('Enabled');
  set enabled(bool? value) => setField<bool>('Enabled', value);

  String? get subtitle => getField<String>('Subtitle');
  set subtitle(String? value) => setField<String>('Subtitle', value);
}
