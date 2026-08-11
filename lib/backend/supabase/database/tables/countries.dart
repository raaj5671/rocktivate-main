import '../database.dart';

class CountriesTable extends SupabaseTable<CountriesRow> {
  @override
  String get tableName => 'Countries';

  @override
  CountriesRow createRow(Map<String, dynamic> data) => CountriesRow(data);
}

class CountriesRow extends SupabaseDataRow {
  CountriesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CountriesTable();

  String get uuid => getField<String>('UUID')!;
  set uuid(String value) => setField<String>('UUID', value);

  String get name => getField<String>('Name')!;
  set name(String value) => setField<String>('Name', value);

  String? get countryID => getField<String>('CountryID');
  set countryID(String? value) => setField<String>('CountryID', value);
}
