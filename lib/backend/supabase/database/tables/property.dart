import '../database.dart';

class PropertyTable extends SupabaseTable<PropertyRow> {
  @override
  String get tableName => 'Property';

  @override
  PropertyRow createRow(Map<String, dynamic> data) => PropertyRow(data);
}

class PropertyRow extends SupabaseDataRow {
  PropertyRow(super.data);

  @override
  SupabaseTable get table => PropertyTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String get propertyType => getField<String>('property_type')!;
  set propertyType(String value) => setField<String>('property_type', value);

  String get address => getField<String>('address')!;
  set address(String value) => setField<String>('address', value);

  String get city => getField<String>('city')!;
  set city(String value) => setField<String>('city', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get postcode => getField<String>('postcode');
  set postcode(String? value) => setField<String>('postcode', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  double get price => getField<double>('price')!;
  set price(double value) => setField<double>('price', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  int? get bedrooms => getField<int>('bedrooms');
  set bedrooms(int? value) => setField<int>('bedrooms', value);

  int? get bathrooms => getField<int>('bathrooms');
  set bathrooms(int? value) => setField<int>('bathrooms', value);

  int? get parkingSpaces => getField<int>('parking_spaces');
  set parkingSpaces(int? value) => setField<int>('parking_spaces', value);

  String? get mainImageUrl => getField<String>('main_image_url');
  set mainImageUrl(String? value) => setField<String>('main_image_url', value);

  List<String> get imageUrls => getListField<String>('image_urls');
  set imageUrls(List<String>? value) =>
      setListField<String>('image_urls', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
