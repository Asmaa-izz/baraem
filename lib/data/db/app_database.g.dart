// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ContentSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ContentSource>($CategoriesTable.$convertersource);
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, orderIndex, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      source: $CategoriesTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ContentSource, String, String> $convertersource =
      const EnumNameConverter<ContentSource>(ContentSource.values);
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String name;
  final String icon;
  final int orderIndex;
  final ContentSource source;
  const CategoryRow({
    required this.id,
    required this.name,
    required this.icon,
    required this.orderIndex,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['order_index'] = Variable<int>(orderIndex);
    {
      map['source'] = Variable<String>(
        $CategoriesTable.$convertersource.toSql(source),
      );
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      orderIndex: Value(orderIndex),
      source: Value(source),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      source: $CategoriesTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'source': serializer.toJson<String>(
        $CategoriesTable.$convertersource.toJson(source),
      ),
    };
  }

  CategoryRow copyWith({
    String? id,
    String? name,
    String? icon,
    int? orderIndex,
    ContentSource? source,
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    orderIndex: orderIndex ?? this.orderIndex,
    source: source ?? this.source,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, orderIndex, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.orderIndex == this.orderIndex &&
          other.source == this.source);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> orderIndex;
  final Value<ContentSource> source;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    required String icon,
    required int orderIndex,
    required ContentSource source,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       icon = Value(icon),
       orderIndex = Value(orderIndex),
       source = Value(source);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? orderIndex,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (orderIndex != null) 'order_index': orderIndex,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<int>? orderIndex,
    Value<ContentSource>? source,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      orderIndex: orderIndex ?? this.orderIndex,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $CategoriesTable.$convertersource.toSql(source.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, ItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _speechMeta = const VerificationMeta('speech');
  @override
  late final GeneratedColumn<String> speech = GeneratedColumn<String>(
    'speech',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ContentSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ContentSource>($ItemsTable.$convertersource);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    categoryId,
    speech,
    audioPath,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('speech')) {
      context.handle(
        _speechMeta,
        speech.isAcceptableOrUnknown(data['speech']!, _speechMeta),
      );
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      speech: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}speech'],
      ),
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
      source: $ItemsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ContentSource, String, String> $convertersource =
      const EnumNameConverter<ContentSource>(ContentSource.values);
}

class ItemRow extends DataClass implements Insertable<ItemRow> {
  final String id;
  final String label;
  final String categoryId;

  /// Vocalized (diacritized) form for clearer TTS; null falls back to [label].
  final String? speech;

  /// Per-item audio: a bundled asset (system) or a recorded file (user); null
  /// falls back to TTS.
  final String? audioPath;
  final ContentSource source;
  const ItemRow({
    required this.id,
    required this.label,
    required this.categoryId,
    this.speech,
    this.audioPath,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || speech != null) {
      map['speech'] = Variable<String>(speech);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    {
      map['source'] = Variable<String>(
        $ItemsTable.$convertersource.toSql(source),
      );
    }
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      label: Value(label),
      categoryId: Value(categoryId),
      speech: speech == null && nullToAbsent
          ? const Value.absent()
          : Value(speech),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      source: Value(source),
    );
  }

  factory ItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemRow(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      speech: serializer.fromJson<String?>(json['speech']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      source: $ItemsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'categoryId': serializer.toJson<String>(categoryId),
      'speech': serializer.toJson<String?>(speech),
      'audioPath': serializer.toJson<String?>(audioPath),
      'source': serializer.toJson<String>(
        $ItemsTable.$convertersource.toJson(source),
      ),
    };
  }

  ItemRow copyWith({
    String? id,
    String? label,
    String? categoryId,
    Value<String?> speech = const Value.absent(),
    Value<String?> audioPath = const Value.absent(),
    ContentSource? source,
  }) => ItemRow(
    id: id ?? this.id,
    label: label ?? this.label,
    categoryId: categoryId ?? this.categoryId,
    speech: speech.present ? speech.value : this.speech,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
    source: source ?? this.source,
  );
  ItemRow copyWithCompanion(ItemsCompanion data) {
    return ItemRow(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      speech: data.speech.present ? data.speech.value : this.speech,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemRow(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('categoryId: $categoryId, ')
          ..write('speech: $speech, ')
          ..write('audioPath: $audioPath, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, label, categoryId, speech, audioPath, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemRow &&
          other.id == this.id &&
          other.label == this.label &&
          other.categoryId == this.categoryId &&
          other.speech == this.speech &&
          other.audioPath == this.audioPath &&
          other.source == this.source);
}

class ItemsCompanion extends UpdateCompanion<ItemRow> {
  final Value<String> id;
  final Value<String> label;
  final Value<String> categoryId;
  final Value<String?> speech;
  final Value<String?> audioPath;
  final Value<ContentSource> source;
  final Value<int> rowid;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.speech = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemsCompanion.insert({
    required String id,
    required String label,
    required String categoryId,
    this.speech = const Value.absent(),
    this.audioPath = const Value.absent(),
    required ContentSource source,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       categoryId = Value(categoryId),
       source = Value(source);
  static Insertable<ItemRow> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? categoryId,
    Expression<String>? speech,
    Expression<String>? audioPath,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (categoryId != null) 'category_id': categoryId,
      if (speech != null) 'speech': speech,
      if (audioPath != null) 'audio_path': audioPath,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String>? categoryId,
    Value<String?>? speech,
    Value<String?>? audioPath,
    Value<ContentSource>? source,
    Value<int>? rowid,
  }) {
    return ItemsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      categoryId: categoryId ?? this.categoryId,
      speech: speech ?? this.speech,
      audioPath: audioPath ?? this.audioPath,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (speech.present) {
      map['speech'] = Variable<String>(speech.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $ItemsTable.$convertersource.toSql(source.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('categoryId: $categoryId, ')
          ..write('speech: $speech, ')
          ..write('audioPath: $audioPath, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExemplarsTable extends Exemplars
    with TableInfo<$ExemplarsTable, ExemplarRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExemplarsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hasImageMeta = const VerificationMeta(
    'hasImage',
  );
  @override
  late final GeneratedColumn<bool> hasImage = GeneratedColumn<bool>(
    'has_image',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_image" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ContentSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ContentSource>($ExemplarsTable.$convertersource);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    imagePath,
    audioPath,
    orderIndex,
    hasImage,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exemplars';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExemplarRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    if (data.containsKey('has_image')) {
      context.handle(
        _hasImageMeta,
        hasImage.isAcceptableOrUnknown(data['has_image']!, _hasImageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExemplarRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExemplarRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      hasImage: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_image'],
      )!,
      source: $ExemplarsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
    );
  }

  @override
  $ExemplarsTable createAlias(String alias) {
    return $ExemplarsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ContentSource, String, String> $convertersource =
      const EnumNameConverter<ContentSource>(ContentSource.values);
}

class ExemplarRow extends DataClass implements Insertable<ExemplarRow> {
  final String id;
  final String itemId;
  final String imagePath;
  final String? audioPath;
  final int orderIndex;

  /// Whether the image asset actually shipped (set at seed via AssetManifest).
  final bool hasImage;
  final ContentSource source;
  const ExemplarRow({
    required this.id,
    required this.itemId,
    required this.imagePath,
    this.audioPath,
    required this.orderIndex,
    required this.hasImage,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    map['image_path'] = Variable<String>(imagePath);
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    map['order_index'] = Variable<int>(orderIndex);
    map['has_image'] = Variable<bool>(hasImage);
    {
      map['source'] = Variable<String>(
        $ExemplarsTable.$convertersource.toSql(source),
      );
    }
    return map;
  }

  ExemplarsCompanion toCompanion(bool nullToAbsent) {
    return ExemplarsCompanion(
      id: Value(id),
      itemId: Value(itemId),
      imagePath: Value(imagePath),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      orderIndex: Value(orderIndex),
      hasImage: Value(hasImage),
      source: Value(source),
    );
  }

  factory ExemplarRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExemplarRow(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      hasImage: serializer.fromJson<bool>(json['hasImage']),
      source: $ExemplarsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'imagePath': serializer.toJson<String>(imagePath),
      'audioPath': serializer.toJson<String?>(audioPath),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'hasImage': serializer.toJson<bool>(hasImage),
      'source': serializer.toJson<String>(
        $ExemplarsTable.$convertersource.toJson(source),
      ),
    };
  }

  ExemplarRow copyWith({
    String? id,
    String? itemId,
    String? imagePath,
    Value<String?> audioPath = const Value.absent(),
    int? orderIndex,
    bool? hasImage,
    ContentSource? source,
  }) => ExemplarRow(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    imagePath: imagePath ?? this.imagePath,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
    orderIndex: orderIndex ?? this.orderIndex,
    hasImage: hasImage ?? this.hasImage,
    source: source ?? this.source,
  );
  ExemplarRow copyWithCompanion(ExemplarsCompanion data) {
    return ExemplarRow(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      hasImage: data.hasImage.present ? data.hasImage.value : this.hasImage,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExemplarRow(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('imagePath: $imagePath, ')
          ..write('audioPath: $audioPath, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('hasImage: $hasImage, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemId,
    imagePath,
    audioPath,
    orderIndex,
    hasImage,
    source,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExemplarRow &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.imagePath == this.imagePath &&
          other.audioPath == this.audioPath &&
          other.orderIndex == this.orderIndex &&
          other.hasImage == this.hasImage &&
          other.source == this.source);
}

class ExemplarsCompanion extends UpdateCompanion<ExemplarRow> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<String> imagePath;
  final Value<String?> audioPath;
  final Value<int> orderIndex;
  final Value<bool> hasImage;
  final Value<ContentSource> source;
  final Value<int> rowid;
  const ExemplarsCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.hasImage = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExemplarsCompanion.insert({
    required String id,
    required String itemId,
    required String imagePath,
    this.audioPath = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.hasImage = const Value.absent(),
    required ContentSource source,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemId = Value(itemId),
       imagePath = Value(imagePath),
       source = Value(source);
  static Insertable<ExemplarRow> custom({
    Expression<String>? id,
    Expression<String>? itemId,
    Expression<String>? imagePath,
    Expression<String>? audioPath,
    Expression<int>? orderIndex,
    Expression<bool>? hasImage,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (imagePath != null) 'image_path': imagePath,
      if (audioPath != null) 'audio_path': audioPath,
      if (orderIndex != null) 'order_index': orderIndex,
      if (hasImage != null) 'has_image': hasImage,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExemplarsCompanion copyWith({
    Value<String>? id,
    Value<String>? itemId,
    Value<String>? imagePath,
    Value<String?>? audioPath,
    Value<int>? orderIndex,
    Value<bool>? hasImage,
    Value<ContentSource>? source,
    Value<int>? rowid,
  }) {
    return ExemplarsCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      imagePath: imagePath ?? this.imagePath,
      audioPath: audioPath ?? this.audioPath,
      orderIndex: orderIndex ?? this.orderIndex,
      hasImage: hasImage ?? this.hasImage,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (hasImage.present) {
      map['has_image'] = Variable<bool>(hasImage.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $ExemplarsTable.$convertersource.toSql(source.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExemplarsCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('imagePath: $imagePath, ')
          ..write('audioPath: $audioPath, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('hasImage: $hasImage, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChildProfilesTable extends ChildProfiles
    with TableInfo<$ChildProfilesTable, ChildProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChildProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
    'avatar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ProfileMode, String> mode =
      GeneratedColumn<String>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ProfileMode>($ChildProfilesTable.$convertermode);
  static const VerificationMeta _choicesCountMeta = const VerificationMeta(
    'choicesCount',
  );
  @override
  late final GeneratedColumn<int> choicesCount = GeneratedColumn<int>(
    'choices_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _sessionLengthMeta = const VerificationMeta(
    'sessionLength',
  );
  @override
  late final GeneratedColumn<int> sessionLength = GeneratedColumn<int>(
    'session_length',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(12),
  );
  static const VerificationMeta _activeWindowSizeMeta = const VerificationMeta(
    'activeWindowSize',
  );
  @override
  late final GeneratedColumn<int> activeWindowSize = GeneratedColumn<int>(
    'active_window_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _masteryThresholdMeta = const VerificationMeta(
    'masteryThreshold',
  );
  @override
  late final GeneratedColumn<int> masteryThreshold = GeneratedColumn<int>(
    'mastery_threshold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    avatar,
    mode,
    choicesCount,
    sessionLength,
    activeWindowSize,
    masteryThreshold,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'child_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChildProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    } else if (isInserting) {
      context.missing(_avatarMeta);
    }
    if (data.containsKey('choices_count')) {
      context.handle(
        _choicesCountMeta,
        choicesCount.isAcceptableOrUnknown(
          data['choices_count']!,
          _choicesCountMeta,
        ),
      );
    }
    if (data.containsKey('session_length')) {
      context.handle(
        _sessionLengthMeta,
        sessionLength.isAcceptableOrUnknown(
          data['session_length']!,
          _sessionLengthMeta,
        ),
      );
    }
    if (data.containsKey('active_window_size')) {
      context.handle(
        _activeWindowSizeMeta,
        activeWindowSize.isAcceptableOrUnknown(
          data['active_window_size']!,
          _activeWindowSizeMeta,
        ),
      );
    }
    if (data.containsKey('mastery_threshold')) {
      context.handle(
        _masteryThresholdMeta,
        masteryThreshold.isAcceptableOrUnknown(
          data['mastery_threshold']!,
          _masteryThresholdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChildProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChildProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      )!,
      mode: $ChildProfilesTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mode'],
        )!,
      ),
      choicesCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}choices_count'],
      )!,
      sessionLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_length'],
      )!,
      activeWindowSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_window_size'],
      )!,
      masteryThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mastery_threshold'],
      )!,
    );
  }

  @override
  $ChildProfilesTable createAlias(String alias) {
    return $ChildProfilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ProfileMode, String, String> $convertermode =
      const EnumNameConverter<ProfileMode>(ProfileMode.values);
}

class ChildProfileRow extends DataClass implements Insertable<ChildProfileRow> {
  final String id;
  final String name;
  final String avatar;
  final ProfileMode mode;
  final int choicesCount;
  final int sessionLength;
  final int activeWindowSize;
  final int masteryThreshold;
  const ChildProfileRow({
    required this.id,
    required this.name,
    required this.avatar,
    required this.mode,
    required this.choicesCount,
    required this.sessionLength,
    required this.activeWindowSize,
    required this.masteryThreshold,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['avatar'] = Variable<String>(avatar);
    {
      map['mode'] = Variable<String>(
        $ChildProfilesTable.$convertermode.toSql(mode),
      );
    }
    map['choices_count'] = Variable<int>(choicesCount);
    map['session_length'] = Variable<int>(sessionLength);
    map['active_window_size'] = Variable<int>(activeWindowSize);
    map['mastery_threshold'] = Variable<int>(masteryThreshold);
    return map;
  }

  ChildProfilesCompanion toCompanion(bool nullToAbsent) {
    return ChildProfilesCompanion(
      id: Value(id),
      name: Value(name),
      avatar: Value(avatar),
      mode: Value(mode),
      choicesCount: Value(choicesCount),
      sessionLength: Value(sessionLength),
      activeWindowSize: Value(activeWindowSize),
      masteryThreshold: Value(masteryThreshold),
    );
  }

  factory ChildProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChildProfileRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatar: serializer.fromJson<String>(json['avatar']),
      mode: $ChildProfilesTable.$convertermode.fromJson(
        serializer.fromJson<String>(json['mode']),
      ),
      choicesCount: serializer.fromJson<int>(json['choicesCount']),
      sessionLength: serializer.fromJson<int>(json['sessionLength']),
      activeWindowSize: serializer.fromJson<int>(json['activeWindowSize']),
      masteryThreshold: serializer.fromJson<int>(json['masteryThreshold']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatar': serializer.toJson<String>(avatar),
      'mode': serializer.toJson<String>(
        $ChildProfilesTable.$convertermode.toJson(mode),
      ),
      'choicesCount': serializer.toJson<int>(choicesCount),
      'sessionLength': serializer.toJson<int>(sessionLength),
      'activeWindowSize': serializer.toJson<int>(activeWindowSize),
      'masteryThreshold': serializer.toJson<int>(masteryThreshold),
    };
  }

  ChildProfileRow copyWith({
    String? id,
    String? name,
    String? avatar,
    ProfileMode? mode,
    int? choicesCount,
    int? sessionLength,
    int? activeWindowSize,
    int? masteryThreshold,
  }) => ChildProfileRow(
    id: id ?? this.id,
    name: name ?? this.name,
    avatar: avatar ?? this.avatar,
    mode: mode ?? this.mode,
    choicesCount: choicesCount ?? this.choicesCount,
    sessionLength: sessionLength ?? this.sessionLength,
    activeWindowSize: activeWindowSize ?? this.activeWindowSize,
    masteryThreshold: masteryThreshold ?? this.masteryThreshold,
  );
  ChildProfileRow copyWithCompanion(ChildProfilesCompanion data) {
    return ChildProfileRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      mode: data.mode.present ? data.mode.value : this.mode,
      choicesCount: data.choicesCount.present
          ? data.choicesCount.value
          : this.choicesCount,
      sessionLength: data.sessionLength.present
          ? data.sessionLength.value
          : this.sessionLength,
      activeWindowSize: data.activeWindowSize.present
          ? data.activeWindowSize.value
          : this.activeWindowSize,
      masteryThreshold: data.masteryThreshold.present
          ? data.masteryThreshold.value
          : this.masteryThreshold,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChildProfileRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('mode: $mode, ')
          ..write('choicesCount: $choicesCount, ')
          ..write('sessionLength: $sessionLength, ')
          ..write('activeWindowSize: $activeWindowSize, ')
          ..write('masteryThreshold: $masteryThreshold')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    avatar,
    mode,
    choicesCount,
    sessionLength,
    activeWindowSize,
    masteryThreshold,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildProfileRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatar == this.avatar &&
          other.mode == this.mode &&
          other.choicesCount == this.choicesCount &&
          other.sessionLength == this.sessionLength &&
          other.activeWindowSize == this.activeWindowSize &&
          other.masteryThreshold == this.masteryThreshold);
}

class ChildProfilesCompanion extends UpdateCompanion<ChildProfileRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> avatar;
  final Value<ProfileMode> mode;
  final Value<int> choicesCount;
  final Value<int> sessionLength;
  final Value<int> activeWindowSize;
  final Value<int> masteryThreshold;
  final Value<int> rowid;
  const ChildProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatar = const Value.absent(),
    this.mode = const Value.absent(),
    this.choicesCount = const Value.absent(),
    this.sessionLength = const Value.absent(),
    this.activeWindowSize = const Value.absent(),
    this.masteryThreshold = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChildProfilesCompanion.insert({
    required String id,
    required String name,
    required String avatar,
    required ProfileMode mode,
    this.choicesCount = const Value.absent(),
    this.sessionLength = const Value.absent(),
    this.activeWindowSize = const Value.absent(),
    this.masteryThreshold = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       avatar = Value(avatar),
       mode = Value(mode);
  static Insertable<ChildProfileRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? avatar,
    Expression<String>? mode,
    Expression<int>? choicesCount,
    Expression<int>? sessionLength,
    Expression<int>? activeWindowSize,
    Expression<int>? masteryThreshold,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
      if (mode != null) 'mode': mode,
      if (choicesCount != null) 'choices_count': choicesCount,
      if (sessionLength != null) 'session_length': sessionLength,
      if (activeWindowSize != null) 'active_window_size': activeWindowSize,
      if (masteryThreshold != null) 'mastery_threshold': masteryThreshold,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChildProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? avatar,
    Value<ProfileMode>? mode,
    Value<int>? choicesCount,
    Value<int>? sessionLength,
    Value<int>? activeWindowSize,
    Value<int>? masteryThreshold,
    Value<int>? rowid,
  }) {
    return ChildProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      mode: mode ?? this.mode,
      choicesCount: choicesCount ?? this.choicesCount,
      sessionLength: sessionLength ?? this.sessionLength,
      activeWindowSize: activeWindowSize ?? this.activeWindowSize,
      masteryThreshold: masteryThreshold ?? this.masteryThreshold,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(
        $ChildProfilesTable.$convertermode.toSql(mode.value),
      );
    }
    if (choicesCount.present) {
      map['choices_count'] = Variable<int>(choicesCount.value);
    }
    if (sessionLength.present) {
      map['session_length'] = Variable<int>(sessionLength.value);
    }
    if (activeWindowSize.present) {
      map['active_window_size'] = Variable<int>(activeWindowSize.value);
    }
    if (masteryThreshold.present) {
      map['mastery_threshold'] = Variable<int>(masteryThreshold.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChildProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('mode: $mode, ')
          ..write('choicesCount: $choicesCount, ')
          ..write('sessionLength: $sessionLength, ')
          ..write('activeWindowSize: $activeWindowSize, ')
          ..write('masteryThreshold: $masteryThreshold, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LearningStatesTable extends LearningStates
    with TableInfo<$LearningStatesTable, LearningStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearningStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES child_profiles (id)',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ItemStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ItemStatus>($LearningStatesTable.$converterstatus);
  static const VerificationMeta _leitnerBoxMeta = const VerificationMeta(
    'leitnerBox',
  );
  @override
  late final GeneratedColumn<int> leitnerBox = GeneratedColumn<int>(
    'leitner_box',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _consecutiveCorrectMeta =
      const VerificationMeta('consecutiveCorrect');
  @override
  late final GeneratedColumn<int> consecutiveCorrect = GeneratedColumn<int>(
    'consecutive_correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _timesSeenMeta = const VerificationMeta(
    'timesSeen',
  );
  @override
  late final GeneratedColumn<int> timesSeen = GeneratedColumn<int>(
    'times_seen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSeenMeta = const VerificationMeta(
    'lastSeen',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeen = GeneratedColumn<DateTime>(
    'last_seen',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextDueMeta = const VerificationMeta(
    'nextDue',
  );
  @override
  late final GeneratedColumn<DateTime> nextDue = GeneratedColumn<DateTime>(
    'next_due',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastExemplarIdMeta = const VerificationMeta(
    'lastExemplarId',
  );
  @override
  late final GeneratedColumn<String> lastExemplarId = GeneratedColumn<String>(
    'last_exemplar_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _admittedAtMeta = const VerificationMeta(
    'admittedAt',
  );
  @override
  late final GeneratedColumn<DateTime> admittedAt = GeneratedColumn<DateTime>(
    'admitted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    childId,
    itemId,
    status,
    leitnerBox,
    consecutiveCorrect,
    timesSeen,
    lastSeen,
    nextDue,
    lastExemplarId,
    admittedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learning_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearningStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('leitner_box')) {
      context.handle(
        _leitnerBoxMeta,
        leitnerBox.isAcceptableOrUnknown(data['leitner_box']!, _leitnerBoxMeta),
      );
    }
    if (data.containsKey('consecutive_correct')) {
      context.handle(
        _consecutiveCorrectMeta,
        consecutiveCorrect.isAcceptableOrUnknown(
          data['consecutive_correct']!,
          _consecutiveCorrectMeta,
        ),
      );
    }
    if (data.containsKey('times_seen')) {
      context.handle(
        _timesSeenMeta,
        timesSeen.isAcceptableOrUnknown(data['times_seen']!, _timesSeenMeta),
      );
    }
    if (data.containsKey('last_seen')) {
      context.handle(
        _lastSeenMeta,
        lastSeen.isAcceptableOrUnknown(data['last_seen']!, _lastSeenMeta),
      );
    }
    if (data.containsKey('next_due')) {
      context.handle(
        _nextDueMeta,
        nextDue.isAcceptableOrUnknown(data['next_due']!, _nextDueMeta),
      );
    }
    if (data.containsKey('last_exemplar_id')) {
      context.handle(
        _lastExemplarIdMeta,
        lastExemplarId.isAcceptableOrUnknown(
          data['last_exemplar_id']!,
          _lastExemplarIdMeta,
        ),
      );
    }
    if (data.containsKey('admitted_at')) {
      context.handle(
        _admittedAtMeta,
        admittedAt.isAcceptableOrUnknown(data['admitted_at']!, _admittedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LearningStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearningStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      status: $LearningStatesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      leitnerBox: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}leitner_box'],
      )!,
      consecutiveCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}consecutive_correct'],
      )!,
      timesSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_seen'],
      )!,
      lastSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen'],
      ),
      nextDue: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_due'],
      ),
      lastExemplarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_exemplar_id'],
      ),
      admittedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}admitted_at'],
      ),
    );
  }

  @override
  $LearningStatesTable createAlias(String alias) {
    return $LearningStatesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ItemStatus, String, String> $converterstatus =
      const EnumNameConverter<ItemStatus>(ItemStatus.values);
}

class LearningStateRow extends DataClass
    implements Insertable<LearningStateRow> {
  final String id;
  final String childId;
  final String itemId;
  final ItemStatus status;
  final int leitnerBox;
  final int consecutiveCorrect;
  final int timesSeen;
  final DateTime? lastSeen;
  final DateTime? nextDue;
  final String? lastExemplarId;
  final DateTime? admittedAt;
  const LearningStateRow({
    required this.id,
    required this.childId,
    required this.itemId,
    required this.status,
    required this.leitnerBox,
    required this.consecutiveCorrect,
    required this.timesSeen,
    this.lastSeen,
    this.nextDue,
    this.lastExemplarId,
    this.admittedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['child_id'] = Variable<String>(childId);
    map['item_id'] = Variable<String>(itemId);
    {
      map['status'] = Variable<String>(
        $LearningStatesTable.$converterstatus.toSql(status),
      );
    }
    map['leitner_box'] = Variable<int>(leitnerBox);
    map['consecutive_correct'] = Variable<int>(consecutiveCorrect);
    map['times_seen'] = Variable<int>(timesSeen);
    if (!nullToAbsent || lastSeen != null) {
      map['last_seen'] = Variable<DateTime>(lastSeen);
    }
    if (!nullToAbsent || nextDue != null) {
      map['next_due'] = Variable<DateTime>(nextDue);
    }
    if (!nullToAbsent || lastExemplarId != null) {
      map['last_exemplar_id'] = Variable<String>(lastExemplarId);
    }
    if (!nullToAbsent || admittedAt != null) {
      map['admitted_at'] = Variable<DateTime>(admittedAt);
    }
    return map;
  }

  LearningStatesCompanion toCompanion(bool nullToAbsent) {
    return LearningStatesCompanion(
      id: Value(id),
      childId: Value(childId),
      itemId: Value(itemId),
      status: Value(status),
      leitnerBox: Value(leitnerBox),
      consecutiveCorrect: Value(consecutiveCorrect),
      timesSeen: Value(timesSeen),
      lastSeen: lastSeen == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeen),
      nextDue: nextDue == null && nullToAbsent
          ? const Value.absent()
          : Value(nextDue),
      lastExemplarId: lastExemplarId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastExemplarId),
      admittedAt: admittedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(admittedAt),
    );
  }

  factory LearningStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearningStateRow(
      id: serializer.fromJson<String>(json['id']),
      childId: serializer.fromJson<String>(json['childId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      status: $LearningStatesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      leitnerBox: serializer.fromJson<int>(json['leitnerBox']),
      consecutiveCorrect: serializer.fromJson<int>(json['consecutiveCorrect']),
      timesSeen: serializer.fromJson<int>(json['timesSeen']),
      lastSeen: serializer.fromJson<DateTime?>(json['lastSeen']),
      nextDue: serializer.fromJson<DateTime?>(json['nextDue']),
      lastExemplarId: serializer.fromJson<String?>(json['lastExemplarId']),
      admittedAt: serializer.fromJson<DateTime?>(json['admittedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'childId': serializer.toJson<String>(childId),
      'itemId': serializer.toJson<String>(itemId),
      'status': serializer.toJson<String>(
        $LearningStatesTable.$converterstatus.toJson(status),
      ),
      'leitnerBox': serializer.toJson<int>(leitnerBox),
      'consecutiveCorrect': serializer.toJson<int>(consecutiveCorrect),
      'timesSeen': serializer.toJson<int>(timesSeen),
      'lastSeen': serializer.toJson<DateTime?>(lastSeen),
      'nextDue': serializer.toJson<DateTime?>(nextDue),
      'lastExemplarId': serializer.toJson<String?>(lastExemplarId),
      'admittedAt': serializer.toJson<DateTime?>(admittedAt),
    };
  }

  LearningStateRow copyWith({
    String? id,
    String? childId,
    String? itemId,
    ItemStatus? status,
    int? leitnerBox,
    int? consecutiveCorrect,
    int? timesSeen,
    Value<DateTime?> lastSeen = const Value.absent(),
    Value<DateTime?> nextDue = const Value.absent(),
    Value<String?> lastExemplarId = const Value.absent(),
    Value<DateTime?> admittedAt = const Value.absent(),
  }) => LearningStateRow(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    itemId: itemId ?? this.itemId,
    status: status ?? this.status,
    leitnerBox: leitnerBox ?? this.leitnerBox,
    consecutiveCorrect: consecutiveCorrect ?? this.consecutiveCorrect,
    timesSeen: timesSeen ?? this.timesSeen,
    lastSeen: lastSeen.present ? lastSeen.value : this.lastSeen,
    nextDue: nextDue.present ? nextDue.value : this.nextDue,
    lastExemplarId: lastExemplarId.present
        ? lastExemplarId.value
        : this.lastExemplarId,
    admittedAt: admittedAt.present ? admittedAt.value : this.admittedAt,
  );
  LearningStateRow copyWithCompanion(LearningStatesCompanion data) {
    return LearningStateRow(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      status: data.status.present ? data.status.value : this.status,
      leitnerBox: data.leitnerBox.present
          ? data.leitnerBox.value
          : this.leitnerBox,
      consecutiveCorrect: data.consecutiveCorrect.present
          ? data.consecutiveCorrect.value
          : this.consecutiveCorrect,
      timesSeen: data.timesSeen.present ? data.timesSeen.value : this.timesSeen,
      lastSeen: data.lastSeen.present ? data.lastSeen.value : this.lastSeen,
      nextDue: data.nextDue.present ? data.nextDue.value : this.nextDue,
      lastExemplarId: data.lastExemplarId.present
          ? data.lastExemplarId.value
          : this.lastExemplarId,
      admittedAt: data.admittedAt.present
          ? data.admittedAt.value
          : this.admittedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearningStateRow(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('itemId: $itemId, ')
          ..write('status: $status, ')
          ..write('leitnerBox: $leitnerBox, ')
          ..write('consecutiveCorrect: $consecutiveCorrect, ')
          ..write('timesSeen: $timesSeen, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('nextDue: $nextDue, ')
          ..write('lastExemplarId: $lastExemplarId, ')
          ..write('admittedAt: $admittedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    childId,
    itemId,
    status,
    leitnerBox,
    consecutiveCorrect,
    timesSeen,
    lastSeen,
    nextDue,
    lastExemplarId,
    admittedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearningStateRow &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.itemId == this.itemId &&
          other.status == this.status &&
          other.leitnerBox == this.leitnerBox &&
          other.consecutiveCorrect == this.consecutiveCorrect &&
          other.timesSeen == this.timesSeen &&
          other.lastSeen == this.lastSeen &&
          other.nextDue == this.nextDue &&
          other.lastExemplarId == this.lastExemplarId &&
          other.admittedAt == this.admittedAt);
}

class LearningStatesCompanion extends UpdateCompanion<LearningStateRow> {
  final Value<String> id;
  final Value<String> childId;
  final Value<String> itemId;
  final Value<ItemStatus> status;
  final Value<int> leitnerBox;
  final Value<int> consecutiveCorrect;
  final Value<int> timesSeen;
  final Value<DateTime?> lastSeen;
  final Value<DateTime?> nextDue;
  final Value<String?> lastExemplarId;
  final Value<DateTime?> admittedAt;
  final Value<int> rowid;
  const LearningStatesCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.status = const Value.absent(),
    this.leitnerBox = const Value.absent(),
    this.consecutiveCorrect = const Value.absent(),
    this.timesSeen = const Value.absent(),
    this.lastSeen = const Value.absent(),
    this.nextDue = const Value.absent(),
    this.lastExemplarId = const Value.absent(),
    this.admittedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearningStatesCompanion.insert({
    required String id,
    required String childId,
    required String itemId,
    required ItemStatus status,
    this.leitnerBox = const Value.absent(),
    this.consecutiveCorrect = const Value.absent(),
    this.timesSeen = const Value.absent(),
    this.lastSeen = const Value.absent(),
    this.nextDue = const Value.absent(),
    this.lastExemplarId = const Value.absent(),
    this.admittedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       childId = Value(childId),
       itemId = Value(itemId),
       status = Value(status);
  static Insertable<LearningStateRow> custom({
    Expression<String>? id,
    Expression<String>? childId,
    Expression<String>? itemId,
    Expression<String>? status,
    Expression<int>? leitnerBox,
    Expression<int>? consecutiveCorrect,
    Expression<int>? timesSeen,
    Expression<DateTime>? lastSeen,
    Expression<DateTime>? nextDue,
    Expression<String>? lastExemplarId,
    Expression<DateTime>? admittedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (itemId != null) 'item_id': itemId,
      if (status != null) 'status': status,
      if (leitnerBox != null) 'leitner_box': leitnerBox,
      if (consecutiveCorrect != null) 'consecutive_correct': consecutiveCorrect,
      if (timesSeen != null) 'times_seen': timesSeen,
      if (lastSeen != null) 'last_seen': lastSeen,
      if (nextDue != null) 'next_due': nextDue,
      if (lastExemplarId != null) 'last_exemplar_id': lastExemplarId,
      if (admittedAt != null) 'admitted_at': admittedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearningStatesCompanion copyWith({
    Value<String>? id,
    Value<String>? childId,
    Value<String>? itemId,
    Value<ItemStatus>? status,
    Value<int>? leitnerBox,
    Value<int>? consecutiveCorrect,
    Value<int>? timesSeen,
    Value<DateTime?>? lastSeen,
    Value<DateTime?>? nextDue,
    Value<String?>? lastExemplarId,
    Value<DateTime?>? admittedAt,
    Value<int>? rowid,
  }) {
    return LearningStatesCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      itemId: itemId ?? this.itemId,
      status: status ?? this.status,
      leitnerBox: leitnerBox ?? this.leitnerBox,
      consecutiveCorrect: consecutiveCorrect ?? this.consecutiveCorrect,
      timesSeen: timesSeen ?? this.timesSeen,
      lastSeen: lastSeen ?? this.lastSeen,
      nextDue: nextDue ?? this.nextDue,
      lastExemplarId: lastExemplarId ?? this.lastExemplarId,
      admittedAt: admittedAt ?? this.admittedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $LearningStatesTable.$converterstatus.toSql(status.value),
      );
    }
    if (leitnerBox.present) {
      map['leitner_box'] = Variable<int>(leitnerBox.value);
    }
    if (consecutiveCorrect.present) {
      map['consecutive_correct'] = Variable<int>(consecutiveCorrect.value);
    }
    if (timesSeen.present) {
      map['times_seen'] = Variable<int>(timesSeen.value);
    }
    if (lastSeen.present) {
      map['last_seen'] = Variable<DateTime>(lastSeen.value);
    }
    if (nextDue.present) {
      map['next_due'] = Variable<DateTime>(nextDue.value);
    }
    if (lastExemplarId.present) {
      map['last_exemplar_id'] = Variable<String>(lastExemplarId.value);
    }
    if (admittedAt.present) {
      map['admitted_at'] = Variable<DateTime>(admittedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearningStatesCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('itemId: $itemId, ')
          ..write('status: $status, ')
          ..write('leitnerBox: $leitnerBox, ')
          ..write('consecutiveCorrect: $consecutiveCorrect, ')
          ..write('timesSeen: $timesSeen, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('nextDue: $nextDue, ')
          ..write('lastExemplarId: $lastExemplarId, ')
          ..write('admittedAt: $admittedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions
    with TableInfo<$SessionsTable, SessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES child_profiles (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemsSeenMeta = const VerificationMeta(
    'itemsSeen',
  );
  @override
  late final GeneratedColumn<int> itemsSeen = GeneratedColumn<int>(
    'items_seen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctCountMeta = const VerificationMeta(
    'correctCount',
  );
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
    'correct_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    childId,
    startedAt,
    endedAt,
    itemsSeen,
    correctCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('items_seen')) {
      context.handle(
        _itemsSeenMeta,
        itemsSeen.isAcceptableOrUnknown(data['items_seen']!, _itemsSeenMeta),
      );
    }
    if (data.containsKey('correct_count')) {
      context.handle(
        _correctCountMeta,
        correctCount.isAcceptableOrUnknown(
          data['correct_count']!,
          _correctCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      itemsSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}items_seen'],
      )!,
      correctCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_count'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class SessionRow extends DataClass implements Insertable<SessionRow> {
  final String id;
  final String childId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int itemsSeen;
  final int correctCount;
  const SessionRow({
    required this.id,
    required this.childId,
    required this.startedAt,
    this.endedAt,
    required this.itemsSeen,
    required this.correctCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['child_id'] = Variable<String>(childId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['items_seen'] = Variable<int>(itemsSeen);
    map['correct_count'] = Variable<int>(correctCount);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      childId: Value(childId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      itemsSeen: Value(itemsSeen),
      correctCount: Value(correctCount),
    );
  }

  factory SessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionRow(
      id: serializer.fromJson<String>(json['id']),
      childId: serializer.fromJson<String>(json['childId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      itemsSeen: serializer.fromJson<int>(json['itemsSeen']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'childId': serializer.toJson<String>(childId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'itemsSeen': serializer.toJson<int>(itemsSeen),
      'correctCount': serializer.toJson<int>(correctCount),
    };
  }

  SessionRow copyWith({
    String? id,
    String? childId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? itemsSeen,
    int? correctCount,
  }) => SessionRow(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    itemsSeen: itemsSeen ?? this.itemsSeen,
    correctCount: correctCount ?? this.correctCount,
  );
  SessionRow copyWithCompanion(SessionsCompanion data) {
    return SessionRow(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      itemsSeen: data.itemsSeen.present ? data.itemsSeen.value : this.itemsSeen,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionRow(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('itemsSeen: $itemsSeen, ')
          ..write('correctCount: $correctCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, childId, startedAt, endedAt, itemsSeen, correctCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionRow &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.itemsSeen == this.itemsSeen &&
          other.correctCount == this.correctCount);
}

class SessionsCompanion extends UpdateCompanion<SessionRow> {
  final Value<String> id;
  final Value<String> childId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> itemsSeen;
  final Value<int> correctCount;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.itemsSeen = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String childId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.itemsSeen = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       childId = Value(childId),
       startedAt = Value(startedAt);
  static Insertable<SessionRow> custom({
    Expression<String>? id,
    Expression<String>? childId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? itemsSeen,
    Expression<int>? correctCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (itemsSeen != null) 'items_seen': itemsSeen,
      if (correctCount != null) 'correct_count': correctCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? childId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? itemsSeen,
    Value<int>? correctCount,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      itemsSeen: itemsSeen ?? this.itemsSeen,
      correctCount: correctCount ?? this.correctCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (itemsSeen.present) {
      map['items_seen'] = Variable<int>(itemsSeen.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('itemsSeen: $itemsSeen, ')
          ..write('correctCount: $correctCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrialLogsTable extends TrialLogs
    with TableInfo<$TrialLogsTable, TrialLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrialLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES child_profiles (id)',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  static const VerificationMeta _chosenItemIdMeta = const VerificationMeta(
    'chosenItemId',
  );
  @override
  late final GeneratedColumn<String> chosenItemId = GeneratedColumn<String>(
    'chosen_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exemplarIdMeta = const VerificationMeta(
    'exemplarId',
  );
  @override
  late final GeneratedColumn<String> exemplarId = GeneratedColumn<String>(
    'exemplar_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _choicesCountMeta = const VerificationMeta(
    'choicesCount',
  );
  @override
  late final GeneratedColumn<int> choicesCount = GeneratedColumn<int>(
    'choices_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _isRetryMeta = const VerificationMeta(
    'isRetry',
  );
  @override
  late final GeneratedColumn<bool> isRetry = GeneratedColumn<bool>(
    'is_retry',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_retry" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    childId,
    sessionId,
    itemId,
    chosenItemId,
    correct,
    timestamp,
    exemplarId,
    choicesCount,
    isRetry,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trial_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrialLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('chosen_item_id')) {
      context.handle(
        _chosenItemIdMeta,
        chosenItemId.isAcceptableOrUnknown(
          data['chosen_item_id']!,
          _chosenItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chosenItemIdMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('exemplar_id')) {
      context.handle(
        _exemplarIdMeta,
        exemplarId.isAcceptableOrUnknown(data['exemplar_id']!, _exemplarIdMeta),
      );
    }
    if (data.containsKey('choices_count')) {
      context.handle(
        _choicesCountMeta,
        choicesCount.isAcceptableOrUnknown(
          data['choices_count']!,
          _choicesCountMeta,
        ),
      );
    }
    if (data.containsKey('is_retry')) {
      context.handle(
        _isRetryMeta,
        isRetry.isAcceptableOrUnknown(data['is_retry']!, _isRetryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrialLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrialLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      chosenItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chosen_item_id'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}correct'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      exemplarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exemplar_id'],
      ),
      choicesCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}choices_count'],
      )!,
      isRetry: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_retry'],
      )!,
    );
  }

  @override
  $TrialLogsTable createAlias(String alias) {
    return $TrialLogsTable(attachedDatabase, alias);
  }
}

class TrialLogRow extends DataClass implements Insertable<TrialLogRow> {
  final String id;
  final String childId;
  final String sessionId;
  final String itemId;
  final String chosenItemId;
  final bool correct;
  final DateTime timestamp;
  final String? exemplarId;
  final int choicesCount;
  final bool isRetry;
  const TrialLogRow({
    required this.id,
    required this.childId,
    required this.sessionId,
    required this.itemId,
    required this.chosenItemId,
    required this.correct,
    required this.timestamp,
    this.exemplarId,
    required this.choicesCount,
    required this.isRetry,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['child_id'] = Variable<String>(childId);
    map['session_id'] = Variable<String>(sessionId);
    map['item_id'] = Variable<String>(itemId);
    map['chosen_item_id'] = Variable<String>(chosenItemId);
    map['correct'] = Variable<bool>(correct);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || exemplarId != null) {
      map['exemplar_id'] = Variable<String>(exemplarId);
    }
    map['choices_count'] = Variable<int>(choicesCount);
    map['is_retry'] = Variable<bool>(isRetry);
    return map;
  }

  TrialLogsCompanion toCompanion(bool nullToAbsent) {
    return TrialLogsCompanion(
      id: Value(id),
      childId: Value(childId),
      sessionId: Value(sessionId),
      itemId: Value(itemId),
      chosenItemId: Value(chosenItemId),
      correct: Value(correct),
      timestamp: Value(timestamp),
      exemplarId: exemplarId == null && nullToAbsent
          ? const Value.absent()
          : Value(exemplarId),
      choicesCount: Value(choicesCount),
      isRetry: Value(isRetry),
    );
  }

  factory TrialLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrialLogRow(
      id: serializer.fromJson<String>(json['id']),
      childId: serializer.fromJson<String>(json['childId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      chosenItemId: serializer.fromJson<String>(json['chosenItemId']),
      correct: serializer.fromJson<bool>(json['correct']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      exemplarId: serializer.fromJson<String?>(json['exemplarId']),
      choicesCount: serializer.fromJson<int>(json['choicesCount']),
      isRetry: serializer.fromJson<bool>(json['isRetry']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'childId': serializer.toJson<String>(childId),
      'sessionId': serializer.toJson<String>(sessionId),
      'itemId': serializer.toJson<String>(itemId),
      'chosenItemId': serializer.toJson<String>(chosenItemId),
      'correct': serializer.toJson<bool>(correct),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'exemplarId': serializer.toJson<String?>(exemplarId),
      'choicesCount': serializer.toJson<int>(choicesCount),
      'isRetry': serializer.toJson<bool>(isRetry),
    };
  }

  TrialLogRow copyWith({
    String? id,
    String? childId,
    String? sessionId,
    String? itemId,
    String? chosenItemId,
    bool? correct,
    DateTime? timestamp,
    Value<String?> exemplarId = const Value.absent(),
    int? choicesCount,
    bool? isRetry,
  }) => TrialLogRow(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    sessionId: sessionId ?? this.sessionId,
    itemId: itemId ?? this.itemId,
    chosenItemId: chosenItemId ?? this.chosenItemId,
    correct: correct ?? this.correct,
    timestamp: timestamp ?? this.timestamp,
    exemplarId: exemplarId.present ? exemplarId.value : this.exemplarId,
    choicesCount: choicesCount ?? this.choicesCount,
    isRetry: isRetry ?? this.isRetry,
  );
  TrialLogRow copyWithCompanion(TrialLogsCompanion data) {
    return TrialLogRow(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      chosenItemId: data.chosenItemId.present
          ? data.chosenItemId.value
          : this.chosenItemId,
      correct: data.correct.present ? data.correct.value : this.correct,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      exemplarId: data.exemplarId.present
          ? data.exemplarId.value
          : this.exemplarId,
      choicesCount: data.choicesCount.present
          ? data.choicesCount.value
          : this.choicesCount,
      isRetry: data.isRetry.present ? data.isRetry.value : this.isRetry,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrialLogRow(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('sessionId: $sessionId, ')
          ..write('itemId: $itemId, ')
          ..write('chosenItemId: $chosenItemId, ')
          ..write('correct: $correct, ')
          ..write('timestamp: $timestamp, ')
          ..write('exemplarId: $exemplarId, ')
          ..write('choicesCount: $choicesCount, ')
          ..write('isRetry: $isRetry')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    childId,
    sessionId,
    itemId,
    chosenItemId,
    correct,
    timestamp,
    exemplarId,
    choicesCount,
    isRetry,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrialLogRow &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.sessionId == this.sessionId &&
          other.itemId == this.itemId &&
          other.chosenItemId == this.chosenItemId &&
          other.correct == this.correct &&
          other.timestamp == this.timestamp &&
          other.exemplarId == this.exemplarId &&
          other.choicesCount == this.choicesCount &&
          other.isRetry == this.isRetry);
}

class TrialLogsCompanion extends UpdateCompanion<TrialLogRow> {
  final Value<String> id;
  final Value<String> childId;
  final Value<String> sessionId;
  final Value<String> itemId;
  final Value<String> chosenItemId;
  final Value<bool> correct;
  final Value<DateTime> timestamp;
  final Value<String?> exemplarId;
  final Value<int> choicesCount;
  final Value<bool> isRetry;
  final Value<int> rowid;
  const TrialLogsCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.chosenItemId = const Value.absent(),
    this.correct = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.exemplarId = const Value.absent(),
    this.choicesCount = const Value.absent(),
    this.isRetry = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrialLogsCompanion.insert({
    required String id,
    required String childId,
    required String sessionId,
    required String itemId,
    required String chosenItemId,
    required bool correct,
    required DateTime timestamp,
    this.exemplarId = const Value.absent(),
    this.choicesCount = const Value.absent(),
    this.isRetry = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       childId = Value(childId),
       sessionId = Value(sessionId),
       itemId = Value(itemId),
       chosenItemId = Value(chosenItemId),
       correct = Value(correct),
       timestamp = Value(timestamp);
  static Insertable<TrialLogRow> custom({
    Expression<String>? id,
    Expression<String>? childId,
    Expression<String>? sessionId,
    Expression<String>? itemId,
    Expression<String>? chosenItemId,
    Expression<bool>? correct,
    Expression<DateTime>? timestamp,
    Expression<String>? exemplarId,
    Expression<int>? choicesCount,
    Expression<bool>? isRetry,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (sessionId != null) 'session_id': sessionId,
      if (itemId != null) 'item_id': itemId,
      if (chosenItemId != null) 'chosen_item_id': chosenItemId,
      if (correct != null) 'correct': correct,
      if (timestamp != null) 'timestamp': timestamp,
      if (exemplarId != null) 'exemplar_id': exemplarId,
      if (choicesCount != null) 'choices_count': choicesCount,
      if (isRetry != null) 'is_retry': isRetry,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrialLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? childId,
    Value<String>? sessionId,
    Value<String>? itemId,
    Value<String>? chosenItemId,
    Value<bool>? correct,
    Value<DateTime>? timestamp,
    Value<String?>? exemplarId,
    Value<int>? choicesCount,
    Value<bool>? isRetry,
    Value<int>? rowid,
  }) {
    return TrialLogsCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      sessionId: sessionId ?? this.sessionId,
      itemId: itemId ?? this.itemId,
      chosenItemId: chosenItemId ?? this.chosenItemId,
      correct: correct ?? this.correct,
      timestamp: timestamp ?? this.timestamp,
      exemplarId: exemplarId ?? this.exemplarId,
      choicesCount: choicesCount ?? this.choicesCount,
      isRetry: isRetry ?? this.isRetry,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (chosenItemId.present) {
      map['chosen_item_id'] = Variable<String>(chosenItemId.value);
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (exemplarId.present) {
      map['exemplar_id'] = Variable<String>(exemplarId.value);
    }
    if (choicesCount.present) {
      map['choices_count'] = Variable<int>(choicesCount.value);
    }
    if (isRetry.present) {
      map['is_retry'] = Variable<bool>(isRetry.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrialLogsCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('sessionId: $sessionId, ')
          ..write('itemId: $itemId, ')
          ..write('chosenItemId: $chosenItemId, ')
          ..write('correct: $correct, ')
          ..write('timestamp: $timestamp, ')
          ..write('exemplarId: $exemplarId, ')
          ..write('choicesCount: $choicesCount, ')
          ..write('isRetry: $isRetry, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _settingKeyMeta = const VerificationMeta(
    'settingKey',
  );
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
    'setting_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingValueMeta = const VerificationMeta(
    'settingValue',
  );
  @override
  late final GeneratedColumn<String> settingValue = GeneratedColumn<String>(
    'setting_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [settingKey, settingValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('setting_key')) {
      context.handle(
        _settingKeyMeta,
        settingKey.isAcceptableOrUnknown(data['setting_key']!, _settingKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('setting_value')) {
      context.handle(
        _settingValueMeta,
        settingValue.isAcceptableOrUnknown(
          data['setting_value']!,
          _settingValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_settingValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {settingKey};
  @override
  AppSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRow(
      settingKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_key'],
      )!,
      settingValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingRow extends DataClass implements Insertable<AppSettingRow> {
  final String settingKey;
  final String settingValue;
  const AppSettingRow({required this.settingKey, required this.settingValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['setting_key'] = Variable<String>(settingKey);
    map['setting_value'] = Variable<String>(settingValue);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      settingKey: Value(settingKey),
      settingValue: Value(settingValue),
    );
  }

  factory AppSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRow(
      settingKey: serializer.fromJson<String>(json['settingKey']),
      settingValue: serializer.fromJson<String>(json['settingValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'settingKey': serializer.toJson<String>(settingKey),
      'settingValue': serializer.toJson<String>(settingValue),
    };
  }

  AppSettingRow copyWith({String? settingKey, String? settingValue}) =>
      AppSettingRow(
        settingKey: settingKey ?? this.settingKey,
        settingValue: settingValue ?? this.settingValue,
      );
  AppSettingRow copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingRow(
      settingKey: data.settingKey.present
          ? data.settingKey.value
          : this.settingKey,
      settingValue: data.settingValue.present
          ? data.settingValue.value
          : this.settingValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRow(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(settingKey, settingValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRow &&
          other.settingKey == this.settingKey &&
          other.settingValue == this.settingValue);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingRow> {
  final Value<String> settingKey;
  final Value<String> settingValue;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.settingKey = const Value.absent(),
    this.settingValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String settingKey,
    required String settingValue,
    this.rowid = const Value.absent(),
  }) : settingKey = Value(settingKey),
       settingValue = Value(settingValue);
  static Insertable<AppSettingRow> custom({
    Expression<String>? settingKey,
    Expression<String>? settingValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (settingKey != null) 'setting_key': settingKey,
      if (settingValue != null) 'setting_value': settingValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? settingKey,
    Value<String>? settingValue,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      settingKey: settingKey ?? this.settingKey,
      settingValue: settingValue ?? this.settingValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (settingKey.present) {
      map['setting_key'] = Variable<String>(settingKey.value);
    }
    if (settingValue.present) {
      map['setting_value'] = Variable<String>(settingValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PraisesTable extends Praises with TableInfo<$PraisesTable, PraiseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PraisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ContentSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ContentSource>($PraisesTable.$convertersource);
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, label, audioPath, source, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'praises';
  @override
  VerificationContext validateIntegrity(
    Insertable<PraiseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    } else if (isInserting) {
      context.missing(_audioPathMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PraiseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PraiseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      )!,
      source: $PraisesTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $PraisesTable createAlias(String alias) {
    return $PraisesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ContentSource, String, String> $convertersource =
      const EnumNameConverter<ContentSource>(ContentSource.values);
}

class PraiseRow extends DataClass implements Insertable<PraiseRow> {
  final String id;
  final String label;
  final String audioPath;
  final ContentSource source;
  final bool enabled;
  const PraiseRow({
    required this.id,
    required this.label,
    required this.audioPath,
    required this.source,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['audio_path'] = Variable<String>(audioPath);
    {
      map['source'] = Variable<String>(
        $PraisesTable.$convertersource.toSql(source),
      );
    }
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  PraisesCompanion toCompanion(bool nullToAbsent) {
    return PraisesCompanion(
      id: Value(id),
      label: Value(label),
      audioPath: Value(audioPath),
      source: Value(source),
      enabled: Value(enabled),
    );
  }

  factory PraiseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PraiseRow(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      audioPath: serializer.fromJson<String>(json['audioPath']),
      source: $PraisesTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'audioPath': serializer.toJson<String>(audioPath),
      'source': serializer.toJson<String>(
        $PraisesTable.$convertersource.toJson(source),
      ),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  PraiseRow copyWith({
    String? id,
    String? label,
    String? audioPath,
    ContentSource? source,
    bool? enabled,
  }) => PraiseRow(
    id: id ?? this.id,
    label: label ?? this.label,
    audioPath: audioPath ?? this.audioPath,
    source: source ?? this.source,
    enabled: enabled ?? this.enabled,
  );
  PraiseRow copyWithCompanion(PraisesCompanion data) {
    return PraiseRow(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      source: data.source.present ? data.source.value : this.source,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PraiseRow(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('audioPath: $audioPath, ')
          ..write('source: $source, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, audioPath, source, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PraiseRow &&
          other.id == this.id &&
          other.label == this.label &&
          other.audioPath == this.audioPath &&
          other.source == this.source &&
          other.enabled == this.enabled);
}

class PraisesCompanion extends UpdateCompanion<PraiseRow> {
  final Value<String> id;
  final Value<String> label;
  final Value<String> audioPath;
  final Value<ContentSource> source;
  final Value<bool> enabled;
  final Value<int> rowid;
  const PraisesCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.source = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PraisesCompanion.insert({
    required String id,
    required String label,
    required String audioPath,
    required ContentSource source,
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       audioPath = Value(audioPath),
       source = Value(source);
  static Insertable<PraiseRow> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? audioPath,
    Expression<String>? source,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (audioPath != null) 'audio_path': audioPath,
      if (source != null) 'source': source,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PraisesCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String>? audioPath,
    Value<ContentSource>? source,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return PraisesCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      audioPath: audioPath ?? this.audioPath,
      source: source ?? this.source,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $PraisesTable.$convertersource.toSql(source.value),
      );
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PraisesCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('audioPath: $audioPath, ')
          ..write('source: $source, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $ExemplarsTable exemplars = $ExemplarsTable(this);
  late final $ChildProfilesTable childProfiles = $ChildProfilesTable(this);
  late final $LearningStatesTable learningStates = $LearningStatesTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $TrialLogsTable trialLogs = $TrialLogsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $PraisesTable praises = $PraisesTable(this);
  late final Index idxExemplarItem = Index(
    'idx_exemplar_item',
    'CREATE INDEX idx_exemplar_item ON exemplars (item_id)',
  );
  late final Index idxLsChildItem = Index(
    'idx_ls_child_item',
    'CREATE UNIQUE INDEX idx_ls_child_item ON learning_states (child_id, item_id)',
  );
  late final Index idxLsDue = Index(
    'idx_ls_due',
    'CREATE INDEX idx_ls_due ON learning_states (child_id, status, next_due)',
  );
  late final Index idxSessionChild = Index(
    'idx_session_child',
    'CREATE INDEX idx_session_child ON sessions (child_id, started_at)',
  );
  late final Index idxTrialChildTime = Index(
    'idx_trial_child_time',
    'CREATE INDEX idx_trial_child_time ON trial_logs (child_id, timestamp)',
  );
  late final Index idxTrialSession = Index(
    'idx_trial_session',
    'CREATE INDEX idx_trial_session ON trial_logs (session_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    items,
    exemplars,
    childProfiles,
    learningStates,
    sessions,
    trialLogs,
    appSettings,
    praises,
    idxExemplarItem,
    idxLsChildItem,
    idxLsDue,
    idxSessionChild,
    idxTrialChildTime,
    idxTrialSession,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      required String icon,
      required int orderIndex,
      required ContentSource source,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> icon,
      Value<int> orderIndex,
      Value<ContentSource> source,
      Value<int> rowid,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItemsTable, List<ItemRow>> _itemsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.items,
    aliasName: 'categories__id__items__category_id',
  );

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ContentSource, ContentSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  Expression<bool> itemsRefs(
    Expression<bool> Function($$ItemsTableFilterComposer f) f,
  ) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ContentSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  Expression<T> itemsRefs<T extends Object>(
    Expression<T> Function($$ItemsTableAnnotationComposer a) f,
  ) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryRow, $$CategoriesTableReferences),
          CategoryRow,
          PrefetchHooks Function({bool itemsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<ContentSource> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                icon: icon,
                orderIndex: orderIndex,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String icon,
                required int orderIndex,
                required ContentSource source,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                orderIndex: orderIndex,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itemsRefs) db.items],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemsRefs)
                    await $_getPrefetchedData<
                      CategoryRow,
                      $CategoriesTable,
                      ItemRow
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._itemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(db, table, p0).itemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryRow, $$CategoriesTableReferences),
      CategoryRow,
      PrefetchHooks Function({bool itemsRefs})
    >;
typedef $$ItemsTableCreateCompanionBuilder =
    ItemsCompanion Function({
      required String id,
      required String label,
      required String categoryId,
      Value<String?> speech,
      Value<String?> audioPath,
      required ContentSource source,
      Value<int> rowid,
    });
typedef $$ItemsTableUpdateCompanionBuilder =
    ItemsCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<String> categoryId,
      Value<String?> speech,
      Value<String?> audioPath,
      Value<ContentSource> source,
      Value<int> rowid,
    });

final class $$ItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsTable, ItemRow> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('items__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExemplarsTable, List<ExemplarRow>>
  _exemplarsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.exemplars,
    aliasName: 'items__id__exemplars__item_id',
  );

  $$ExemplarsTableProcessedTableManager get exemplarsRefs {
    final manager = $$ExemplarsTableTableManager(
      $_db,
      $_db.exemplars,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_exemplarsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LearningStatesTable, List<LearningStateRow>>
  _learningStatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.learningStates,
    aliasName: 'items__id__learning_states__item_id',
  );

  $$LearningStatesTableProcessedTableManager get learningStatesRefs {
    final manager = $$LearningStatesTableTableManager(
      $_db,
      $_db.learningStates,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_learningStatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speech => $composableBuilder(
    column: $table.speech,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ContentSource, ContentSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> exemplarsRefs(
    Expression<bool> Function($$ExemplarsTableFilterComposer f) f,
  ) {
    final $$ExemplarsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exemplars,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExemplarsTableFilterComposer(
            $db: $db,
            $table: $db.exemplars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> learningStatesRefs(
    Expression<bool> Function($$LearningStatesTableFilterComposer f) f,
  ) {
    final $$LearningStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.learningStates,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearningStatesTableFilterComposer(
            $db: $db,
            $table: $db.learningStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speech => $composableBuilder(
    column: $table.speech,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get speech =>
      $composableBuilder(column: $table.speech, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ContentSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> exemplarsRefs<T extends Object>(
    Expression<T> Function($$ExemplarsTableAnnotationComposer a) f,
  ) {
    final $$ExemplarsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exemplars,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExemplarsTableAnnotationComposer(
            $db: $db,
            $table: $db.exemplars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> learningStatesRefs<T extends Object>(
    Expression<T> Function($$LearningStatesTableAnnotationComposer a) f,
  ) {
    final $$LearningStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.learningStates,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearningStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.learningStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemsTable,
          ItemRow,
          $$ItemsTableFilterComposer,
          $$ItemsTableOrderingComposer,
          $$ItemsTableAnnotationComposer,
          $$ItemsTableCreateCompanionBuilder,
          $$ItemsTableUpdateCompanionBuilder,
          (ItemRow, $$ItemsTableReferences),
          ItemRow,
          PrefetchHooks Function({
            bool categoryId,
            bool exemplarsRefs,
            bool learningStatesRefs,
          })
        > {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String?> speech = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<ContentSource> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemsCompanion(
                id: id,
                label: label,
                categoryId: categoryId,
                speech: speech,
                audioPath: audioPath,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                required String categoryId,
                Value<String?> speech = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                required ContentSource source,
                Value<int> rowid = const Value.absent(),
              }) => ItemsCompanion.insert(
                id: id,
                label: label,
                categoryId: categoryId,
                speech: speech,
                audioPath: audioPath,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ItemsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                exemplarsRefs = false,
                learningStatesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (exemplarsRefs) db.exemplars,
                    if (learningStatesRefs) db.learningStates,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable: $$ItemsTableReferences
                                        ._categoryIdTable(db),
                                    referencedColumn: $$ItemsTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (exemplarsRefs)
                        await $_getPrefetchedData<
                          ItemRow,
                          $ItemsTable,
                          ExemplarRow
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._exemplarsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).exemplarsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (learningStatesRefs)
                        await $_getPrefetchedData<
                          ItemRow,
                          $ItemsTable,
                          LearningStateRow
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._learningStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).learningStatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemsTable,
      ItemRow,
      $$ItemsTableFilterComposer,
      $$ItemsTableOrderingComposer,
      $$ItemsTableAnnotationComposer,
      $$ItemsTableCreateCompanionBuilder,
      $$ItemsTableUpdateCompanionBuilder,
      (ItemRow, $$ItemsTableReferences),
      ItemRow,
      PrefetchHooks Function({
        bool categoryId,
        bool exemplarsRefs,
        bool learningStatesRefs,
      })
    >;
typedef $$ExemplarsTableCreateCompanionBuilder =
    ExemplarsCompanion Function({
      required String id,
      required String itemId,
      required String imagePath,
      Value<String?> audioPath,
      Value<int> orderIndex,
      Value<bool> hasImage,
      required ContentSource source,
      Value<int> rowid,
    });
typedef $$ExemplarsTableUpdateCompanionBuilder =
    ExemplarsCompanion Function({
      Value<String> id,
      Value<String> itemId,
      Value<String> imagePath,
      Value<String?> audioPath,
      Value<int> orderIndex,
      Value<bool> hasImage,
      Value<ContentSource> source,
      Value<int> rowid,
    });

final class $$ExemplarsTableReferences
    extends BaseReferences<_$AppDatabase, $ExemplarsTable, ExemplarRow> {
  $$ExemplarsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('exemplars__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExemplarsTableFilterComposer
    extends Composer<_$AppDatabase, $ExemplarsTable> {
  $$ExemplarsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasImage => $composableBuilder(
    column: $table.hasImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ContentSource, ContentSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExemplarsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExemplarsTable> {
  $$ExemplarsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasImage => $composableBuilder(
    column: $table.hasImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExemplarsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExemplarsTable> {
  $$ExemplarsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasImage =>
      $composableBuilder(column: $table.hasImage, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ContentSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExemplarsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExemplarsTable,
          ExemplarRow,
          $$ExemplarsTableFilterComposer,
          $$ExemplarsTableOrderingComposer,
          $$ExemplarsTableAnnotationComposer,
          $$ExemplarsTableCreateCompanionBuilder,
          $$ExemplarsTableUpdateCompanionBuilder,
          (ExemplarRow, $$ExemplarsTableReferences),
          ExemplarRow,
          PrefetchHooks Function({bool itemId})
        > {
  $$ExemplarsTableTableManager(_$AppDatabase db, $ExemplarsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExemplarsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExemplarsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExemplarsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<bool> hasImage = const Value.absent(),
                Value<ContentSource> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExemplarsCompanion(
                id: id,
                itemId: itemId,
                imagePath: imagePath,
                audioPath: audioPath,
                orderIndex: orderIndex,
                hasImage: hasImage,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String itemId,
                required String imagePath,
                Value<String?> audioPath = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<bool> hasImage = const Value.absent(),
                required ContentSource source,
                Value<int> rowid = const Value.absent(),
              }) => ExemplarsCompanion.insert(
                id: id,
                itemId: itemId,
                imagePath: imagePath,
                audioPath: audioPath,
                orderIndex: orderIndex,
                hasImage: hasImage,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExemplarsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.itemId,
                                referencedTable: $$ExemplarsTableReferences
                                    ._itemIdTable(db),
                                referencedColumn: $$ExemplarsTableReferences
                                    ._itemIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExemplarsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExemplarsTable,
      ExemplarRow,
      $$ExemplarsTableFilterComposer,
      $$ExemplarsTableOrderingComposer,
      $$ExemplarsTableAnnotationComposer,
      $$ExemplarsTableCreateCompanionBuilder,
      $$ExemplarsTableUpdateCompanionBuilder,
      (ExemplarRow, $$ExemplarsTableReferences),
      ExemplarRow,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$ChildProfilesTableCreateCompanionBuilder =
    ChildProfilesCompanion Function({
      required String id,
      required String name,
      required String avatar,
      required ProfileMode mode,
      Value<int> choicesCount,
      Value<int> sessionLength,
      Value<int> activeWindowSize,
      Value<int> masteryThreshold,
      Value<int> rowid,
    });
typedef $$ChildProfilesTableUpdateCompanionBuilder =
    ChildProfilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> avatar,
      Value<ProfileMode> mode,
      Value<int> choicesCount,
      Value<int> sessionLength,
      Value<int> activeWindowSize,
      Value<int> masteryThreshold,
      Value<int> rowid,
    });

final class $$ChildProfilesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ChildProfilesTable, ChildProfileRow> {
  $$ChildProfilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$LearningStatesTable, List<LearningStateRow>>
  _learningStatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.learningStates,
    aliasName: 'child_profiles__id__learning_states__child_id',
  );

  $$LearningStatesTableProcessedTableManager get learningStatesRefs {
    final manager = $$LearningStatesTableTableManager(
      $_db,
      $_db.learningStates,
    ).filter((f) => f.childId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_learningStatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionsTable, List<SessionRow>>
  _sessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'child_profiles__id__sessions__child_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.childId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrialLogsTable, List<TrialLogRow>>
  _trialLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trialLogs,
    aliasName: 'child_profiles__id__trial_logs__child_id',
  );

  $$TrialLogsTableProcessedTableManager get trialLogsRefs {
    final manager = $$TrialLogsTableTableManager(
      $_db,
      $_db.trialLogs,
    ).filter((f) => f.childId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trialLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChildProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ChildProfilesTable> {
  $$ChildProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ProfileMode, ProfileMode, String> get mode =>
      $composableBuilder(
        column: $table.mode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get choicesCount => $composableBuilder(
    column: $table.choicesCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionLength => $composableBuilder(
    column: $table.sessionLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeWindowSize => $composableBuilder(
    column: $table.activeWindowSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get masteryThreshold => $composableBuilder(
    column: $table.masteryThreshold,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> learningStatesRefs(
    Expression<bool> Function($$LearningStatesTableFilterComposer f) f,
  ) {
    final $$LearningStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.learningStates,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearningStatesTableFilterComposer(
            $db: $db,
            $table: $db.learningStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trialLogsRefs(
    Expression<bool> Function($$TrialLogsTableFilterComposer f) f,
  ) {
    final $$TrialLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trialLogs,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrialLogsTableFilterComposer(
            $db: $db,
            $table: $db.trialLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChildProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChildProfilesTable> {
  $$ChildProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get choicesCount => $composableBuilder(
    column: $table.choicesCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionLength => $composableBuilder(
    column: $table.sessionLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeWindowSize => $composableBuilder(
    column: $table.activeWindowSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get masteryThreshold => $composableBuilder(
    column: $table.masteryThreshold,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChildProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChildProfilesTable> {
  $$ChildProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ProfileMode, String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get choicesCount => $composableBuilder(
    column: $table.choicesCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessionLength => $composableBuilder(
    column: $table.sessionLength,
    builder: (column) => column,
  );

  GeneratedColumn<int> get activeWindowSize => $composableBuilder(
    column: $table.activeWindowSize,
    builder: (column) => column,
  );

  GeneratedColumn<int> get masteryThreshold => $composableBuilder(
    column: $table.masteryThreshold,
    builder: (column) => column,
  );

  Expression<T> learningStatesRefs<T extends Object>(
    Expression<T> Function($$LearningStatesTableAnnotationComposer a) f,
  ) {
    final $$LearningStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.learningStates,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearningStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.learningStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> trialLogsRefs<T extends Object>(
    Expression<T> Function($$TrialLogsTableAnnotationComposer a) f,
  ) {
    final $$TrialLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trialLogs,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrialLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.trialLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChildProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChildProfilesTable,
          ChildProfileRow,
          $$ChildProfilesTableFilterComposer,
          $$ChildProfilesTableOrderingComposer,
          $$ChildProfilesTableAnnotationComposer,
          $$ChildProfilesTableCreateCompanionBuilder,
          $$ChildProfilesTableUpdateCompanionBuilder,
          (ChildProfileRow, $$ChildProfilesTableReferences),
          ChildProfileRow,
          PrefetchHooks Function({
            bool learningStatesRefs,
            bool sessionsRefs,
            bool trialLogsRefs,
          })
        > {
  $$ChildProfilesTableTableManager(_$AppDatabase db, $ChildProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChildProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChildProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChildProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> avatar = const Value.absent(),
                Value<ProfileMode> mode = const Value.absent(),
                Value<int> choicesCount = const Value.absent(),
                Value<int> sessionLength = const Value.absent(),
                Value<int> activeWindowSize = const Value.absent(),
                Value<int> masteryThreshold = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChildProfilesCompanion(
                id: id,
                name: name,
                avatar: avatar,
                mode: mode,
                choicesCount: choicesCount,
                sessionLength: sessionLength,
                activeWindowSize: activeWindowSize,
                masteryThreshold: masteryThreshold,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String avatar,
                required ProfileMode mode,
                Value<int> choicesCount = const Value.absent(),
                Value<int> sessionLength = const Value.absent(),
                Value<int> activeWindowSize = const Value.absent(),
                Value<int> masteryThreshold = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChildProfilesCompanion.insert(
                id: id,
                name: name,
                avatar: avatar,
                mode: mode,
                choicesCount: choicesCount,
                sessionLength: sessionLength,
                activeWindowSize: activeWindowSize,
                masteryThreshold: masteryThreshold,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChildProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                learningStatesRefs = false,
                sessionsRefs = false,
                trialLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (learningStatesRefs) db.learningStates,
                    if (sessionsRefs) db.sessions,
                    if (trialLogsRefs) db.trialLogs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (learningStatesRefs)
                        await $_getPrefetchedData<
                          ChildProfileRow,
                          $ChildProfilesTable,
                          LearningStateRow
                        >(
                          currentTable: table,
                          referencedTable: $$ChildProfilesTableReferences
                              ._learningStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).learningStatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionsRefs)
                        await $_getPrefetchedData<
                          ChildProfileRow,
                          $ChildProfilesTable,
                          SessionRow
                        >(
                          currentTable: table,
                          referencedTable: $$ChildProfilesTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (trialLogsRefs)
                        await $_getPrefetchedData<
                          ChildProfileRow,
                          $ChildProfilesTable,
                          TrialLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$ChildProfilesTableReferences
                              ._trialLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChildProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).trialLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.childId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ChildProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChildProfilesTable,
      ChildProfileRow,
      $$ChildProfilesTableFilterComposer,
      $$ChildProfilesTableOrderingComposer,
      $$ChildProfilesTableAnnotationComposer,
      $$ChildProfilesTableCreateCompanionBuilder,
      $$ChildProfilesTableUpdateCompanionBuilder,
      (ChildProfileRow, $$ChildProfilesTableReferences),
      ChildProfileRow,
      PrefetchHooks Function({
        bool learningStatesRefs,
        bool sessionsRefs,
        bool trialLogsRefs,
      })
    >;
typedef $$LearningStatesTableCreateCompanionBuilder =
    LearningStatesCompanion Function({
      required String id,
      required String childId,
      required String itemId,
      required ItemStatus status,
      Value<int> leitnerBox,
      Value<int> consecutiveCorrect,
      Value<int> timesSeen,
      Value<DateTime?> lastSeen,
      Value<DateTime?> nextDue,
      Value<String?> lastExemplarId,
      Value<DateTime?> admittedAt,
      Value<int> rowid,
    });
typedef $$LearningStatesTableUpdateCompanionBuilder =
    LearningStatesCompanion Function({
      Value<String> id,
      Value<String> childId,
      Value<String> itemId,
      Value<ItemStatus> status,
      Value<int> leitnerBox,
      Value<int> consecutiveCorrect,
      Value<int> timesSeen,
      Value<DateTime?> lastSeen,
      Value<DateTime?> nextDue,
      Value<String?> lastExemplarId,
      Value<DateTime?> admittedAt,
      Value<int> rowid,
    });

final class $$LearningStatesTableReferences
    extends
        BaseReferences<_$AppDatabase, $LearningStatesTable, LearningStateRow> {
  $$LearningStatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ChildProfilesTable _childIdTable(_$AppDatabase db) => db.childProfiles
      .createAlias('learning_states__child_id__child_profiles__id');

  $$ChildProfilesTableProcessedTableManager get childId {
    final $_column = $_itemColumn<String>('child_id')!;

    final manager = $$ChildProfilesTableTableManager(
      $_db,
      $_db.childProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('learning_states__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LearningStatesTableFilterComposer
    extends Composer<_$AppDatabase, $LearningStatesTable> {
  $$LearningStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ItemStatus, ItemStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get leitnerBox => $composableBuilder(
    column: $table.leitnerBox,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get consecutiveCorrect => $composableBuilder(
    column: $table.consecutiveCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesSeen => $composableBuilder(
    column: $table.timesSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextDue => $composableBuilder(
    column: $table.nextDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastExemplarId => $composableBuilder(
    column: $table.lastExemplarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get admittedAt => $composableBuilder(
    column: $table.admittedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ChildProfilesTableFilterComposer get childId {
    final $$ChildProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableFilterComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LearningStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $LearningStatesTable> {
  $$LearningStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leitnerBox => $composableBuilder(
    column: $table.leitnerBox,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get consecutiveCorrect => $composableBuilder(
    column: $table.consecutiveCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesSeen => $composableBuilder(
    column: $table.timesSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextDue => $composableBuilder(
    column: $table.nextDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastExemplarId => $composableBuilder(
    column: $table.lastExemplarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get admittedAt => $composableBuilder(
    column: $table.admittedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChildProfilesTableOrderingComposer get childId {
    final $$ChildProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LearningStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearningStatesTable> {
  $$LearningStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ItemStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get leitnerBox => $composableBuilder(
    column: $table.leitnerBox,
    builder: (column) => column,
  );

  GeneratedColumn<int> get consecutiveCorrect => $composableBuilder(
    column: $table.consecutiveCorrect,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesSeen =>
      $composableBuilder(column: $table.timesSeen, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeen =>
      $composableBuilder(column: $table.lastSeen, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDue =>
      $composableBuilder(column: $table.nextDue, builder: (column) => column);

  GeneratedColumn<String> get lastExemplarId => $composableBuilder(
    column: $table.lastExemplarId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get admittedAt => $composableBuilder(
    column: $table.admittedAt,
    builder: (column) => column,
  );

  $$ChildProfilesTableAnnotationComposer get childId {
    final $$ChildProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LearningStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LearningStatesTable,
          LearningStateRow,
          $$LearningStatesTableFilterComposer,
          $$LearningStatesTableOrderingComposer,
          $$LearningStatesTableAnnotationComposer,
          $$LearningStatesTableCreateCompanionBuilder,
          $$LearningStatesTableUpdateCompanionBuilder,
          (LearningStateRow, $$LearningStatesTableReferences),
          LearningStateRow,
          PrefetchHooks Function({bool childId, bool itemId})
        > {
  $$LearningStatesTableTableManager(
    _$AppDatabase db,
    $LearningStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearningStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearningStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearningStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> childId = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<ItemStatus> status = const Value.absent(),
                Value<int> leitnerBox = const Value.absent(),
                Value<int> consecutiveCorrect = const Value.absent(),
                Value<int> timesSeen = const Value.absent(),
                Value<DateTime?> lastSeen = const Value.absent(),
                Value<DateTime?> nextDue = const Value.absent(),
                Value<String?> lastExemplarId = const Value.absent(),
                Value<DateTime?> admittedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearningStatesCompanion(
                id: id,
                childId: childId,
                itemId: itemId,
                status: status,
                leitnerBox: leitnerBox,
                consecutiveCorrect: consecutiveCorrect,
                timesSeen: timesSeen,
                lastSeen: lastSeen,
                nextDue: nextDue,
                lastExemplarId: lastExemplarId,
                admittedAt: admittedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String childId,
                required String itemId,
                required ItemStatus status,
                Value<int> leitnerBox = const Value.absent(),
                Value<int> consecutiveCorrect = const Value.absent(),
                Value<int> timesSeen = const Value.absent(),
                Value<DateTime?> lastSeen = const Value.absent(),
                Value<DateTime?> nextDue = const Value.absent(),
                Value<String?> lastExemplarId = const Value.absent(),
                Value<DateTime?> admittedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearningStatesCompanion.insert(
                id: id,
                childId: childId,
                itemId: itemId,
                status: status,
                leitnerBox: leitnerBox,
                consecutiveCorrect: consecutiveCorrect,
                timesSeen: timesSeen,
                lastSeen: lastSeen,
                nextDue: nextDue,
                lastExemplarId: lastExemplarId,
                admittedAt: admittedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LearningStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({childId = false, itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (childId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.childId,
                                referencedTable: $$LearningStatesTableReferences
                                    ._childIdTable(db),
                                referencedColumn:
                                    $$LearningStatesTableReferences
                                        ._childIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (itemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.itemId,
                                referencedTable: $$LearningStatesTableReferences
                                    ._itemIdTable(db),
                                referencedColumn:
                                    $$LearningStatesTableReferences
                                        ._itemIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LearningStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LearningStatesTable,
      LearningStateRow,
      $$LearningStatesTableFilterComposer,
      $$LearningStatesTableOrderingComposer,
      $$LearningStatesTableAnnotationComposer,
      $$LearningStatesTableCreateCompanionBuilder,
      $$LearningStatesTableUpdateCompanionBuilder,
      (LearningStateRow, $$LearningStatesTableReferences),
      LearningStateRow,
      PrefetchHooks Function({bool childId, bool itemId})
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      required String id,
      required String childId,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int> itemsSeen,
      Value<int> correctCount,
      Value<int> rowid,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<String> id,
      Value<String> childId,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> itemsSeen,
      Value<int> correctCount,
      Value<int> rowid,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, SessionRow> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChildProfilesTable _childIdTable(_$AppDatabase db) =>
      db.childProfiles.createAlias('sessions__child_id__child_profiles__id');

  $$ChildProfilesTableProcessedTableManager get childId {
    final $_column = $_itemColumn<String>('child_id')!;

    final manager = $$ChildProfilesTableTableManager(
      $_db,
      $_db.childProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TrialLogsTable, List<TrialLogRow>>
  _trialLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trialLogs,
    aliasName: 'sessions__id__trial_logs__session_id',
  );

  $$TrialLogsTableProcessedTableManager get trialLogsRefs {
    final manager = $$TrialLogsTableTableManager(
      $_db,
      $_db.trialLogs,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trialLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemsSeen => $composableBuilder(
    column: $table.itemsSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnFilters(column),
  );

  $$ChildProfilesTableFilterComposer get childId {
    final $$ChildProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableFilterComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> trialLogsRefs(
    Expression<bool> Function($$TrialLogsTableFilterComposer f) f,
  ) {
    final $$TrialLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trialLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrialLogsTableFilterComposer(
            $db: $db,
            $table: $db.trialLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemsSeen => $composableBuilder(
    column: $table.itemsSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChildProfilesTableOrderingComposer get childId {
    final $$ChildProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get itemsSeen =>
      $composableBuilder(column: $table.itemsSeen, builder: (column) => column);

  GeneratedColumn<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => column,
  );

  $$ChildProfilesTableAnnotationComposer get childId {
    final $$ChildProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> trialLogsRefs<T extends Object>(
    Expression<T> Function($$TrialLogsTableAnnotationComposer a) f,
  ) {
    final $$TrialLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trialLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrialLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.trialLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          SessionRow,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (SessionRow, $$SessionsTableReferences),
          SessionRow,
          PrefetchHooks Function({bool childId, bool trialLogsRefs})
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> childId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> itemsSeen = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                childId: childId,
                startedAt: startedAt,
                endedAt: endedAt,
                itemsSeen: itemsSeen,
                correctCount: correctCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String childId,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> itemsSeen = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                childId: childId,
                startedAt: startedAt,
                endedAt: endedAt,
                itemsSeen: itemsSeen,
                correctCount: correctCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({childId = false, trialLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (trialLogsRefs) db.trialLogs],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (childId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.childId,
                                referencedTable: $$SessionsTableReferences
                                    ._childIdTable(db),
                                referencedColumn: $$SessionsTableReferences
                                    ._childIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (trialLogsRefs)
                    await $_getPrefetchedData<
                      SessionRow,
                      $SessionsTable,
                      TrialLogRow
                    >(
                      currentTable: table,
                      referencedTable: $$SessionsTableReferences
                          ._trialLogsRefsTable(db),
                      managerFromTypedResult: (p0) => $$SessionsTableReferences(
                        db,
                        table,
                        p0,
                      ).trialLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      SessionRow,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (SessionRow, $$SessionsTableReferences),
      SessionRow,
      PrefetchHooks Function({bool childId, bool trialLogsRefs})
    >;
typedef $$TrialLogsTableCreateCompanionBuilder =
    TrialLogsCompanion Function({
      required String id,
      required String childId,
      required String sessionId,
      required String itemId,
      required String chosenItemId,
      required bool correct,
      required DateTime timestamp,
      Value<String?> exemplarId,
      Value<int> choicesCount,
      Value<bool> isRetry,
      Value<int> rowid,
    });
typedef $$TrialLogsTableUpdateCompanionBuilder =
    TrialLogsCompanion Function({
      Value<String> id,
      Value<String> childId,
      Value<String> sessionId,
      Value<String> itemId,
      Value<String> chosenItemId,
      Value<bool> correct,
      Value<DateTime> timestamp,
      Value<String?> exemplarId,
      Value<int> choicesCount,
      Value<bool> isRetry,
      Value<int> rowid,
    });

final class $$TrialLogsTableReferences
    extends BaseReferences<_$AppDatabase, $TrialLogsTable, TrialLogRow> {
  $$TrialLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChildProfilesTable _childIdTable(_$AppDatabase db) =>
      db.childProfiles.createAlias('trial_logs__child_id__child_profiles__id');

  $$ChildProfilesTableProcessedTableManager get childId {
    final $_column = $_itemColumn<String>('child_id')!;

    final manager = $$ChildProfilesTableTableManager(
      $_db,
      $_db.childProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('trial_logs__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('trial_logs__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ItemsTable _chosenItemIdTable(_$AppDatabase db) =>
      db.items.createAlias('trial_logs__chosen_item_id__items__id');

  $$ItemsTableProcessedTableManager get chosenItemId {
    final $_column = $_itemColumn<String>('chosen_item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chosenItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrialLogsTableFilterComposer
    extends Composer<_$AppDatabase, $TrialLogsTable> {
  $$TrialLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exemplarId => $composableBuilder(
    column: $table.exemplarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get choicesCount => $composableBuilder(
    column: $table.choicesCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRetry => $composableBuilder(
    column: $table.isRetry,
    builder: (column) => ColumnFilters(column),
  );

  $$ChildProfilesTableFilterComposer get childId {
    final $$ChildProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableFilterComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableFilterComposer get chosenItemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chosenItemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrialLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrialLogsTable> {
  $$TrialLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exemplarId => $composableBuilder(
    column: $table.exemplarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get choicesCount => $composableBuilder(
    column: $table.choicesCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRetry => $composableBuilder(
    column: $table.isRetry,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChildProfilesTableOrderingComposer get childId {
    final $$ChildProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableOrderingComposer get chosenItemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chosenItemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrialLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrialLogsTable> {
  $$TrialLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get exemplarId => $composableBuilder(
    column: $table.exemplarId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get choicesCount => $composableBuilder(
    column: $table.choicesCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRetry =>
      $composableBuilder(column: $table.isRetry, builder: (column) => column);

  $$ChildProfilesTableAnnotationComposer get childId {
    final $$ChildProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.childProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChildProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.childProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableAnnotationComposer get chosenItemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chosenItemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrialLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrialLogsTable,
          TrialLogRow,
          $$TrialLogsTableFilterComposer,
          $$TrialLogsTableOrderingComposer,
          $$TrialLogsTableAnnotationComposer,
          $$TrialLogsTableCreateCompanionBuilder,
          $$TrialLogsTableUpdateCompanionBuilder,
          (TrialLogRow, $$TrialLogsTableReferences),
          TrialLogRow,
          PrefetchHooks Function({
            bool childId,
            bool sessionId,
            bool itemId,
            bool chosenItemId,
          })
        > {
  $$TrialLogsTableTableManager(_$AppDatabase db, $TrialLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrialLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrialLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrialLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> childId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String> chosenItemId = const Value.absent(),
                Value<bool> correct = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> exemplarId = const Value.absent(),
                Value<int> choicesCount = const Value.absent(),
                Value<bool> isRetry = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrialLogsCompanion(
                id: id,
                childId: childId,
                sessionId: sessionId,
                itemId: itemId,
                chosenItemId: chosenItemId,
                correct: correct,
                timestamp: timestamp,
                exemplarId: exemplarId,
                choicesCount: choicesCount,
                isRetry: isRetry,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String childId,
                required String sessionId,
                required String itemId,
                required String chosenItemId,
                required bool correct,
                required DateTime timestamp,
                Value<String?> exemplarId = const Value.absent(),
                Value<int> choicesCount = const Value.absent(),
                Value<bool> isRetry = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrialLogsCompanion.insert(
                id: id,
                childId: childId,
                sessionId: sessionId,
                itemId: itemId,
                chosenItemId: chosenItemId,
                correct: correct,
                timestamp: timestamp,
                exemplarId: exemplarId,
                choicesCount: choicesCount,
                isRetry: isRetry,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrialLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                childId = false,
                sessionId = false,
                itemId = false,
                chosenItemId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (childId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.childId,
                                    referencedTable: $$TrialLogsTableReferences
                                        ._childIdTable(db),
                                    referencedColumn: $$TrialLogsTableReferences
                                        ._childIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable: $$TrialLogsTableReferences
                                        ._sessionIdTable(db),
                                    referencedColumn: $$TrialLogsTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (itemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.itemId,
                                    referencedTable: $$TrialLogsTableReferences
                                        ._itemIdTable(db),
                                    referencedColumn: $$TrialLogsTableReferences
                                        ._itemIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (chosenItemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.chosenItemId,
                                    referencedTable: $$TrialLogsTableReferences
                                        ._chosenItemIdTable(db),
                                    referencedColumn: $$TrialLogsTableReferences
                                        ._chosenItemIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TrialLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrialLogsTable,
      TrialLogRow,
      $$TrialLogsTableFilterComposer,
      $$TrialLogsTableOrderingComposer,
      $$TrialLogsTableAnnotationComposer,
      $$TrialLogsTableCreateCompanionBuilder,
      $$TrialLogsTableUpdateCompanionBuilder,
      (TrialLogRow, $$TrialLogsTableReferences),
      TrialLogRow,
      PrefetchHooks Function({
        bool childId,
        bool sessionId,
        bool itemId,
        bool chosenItemId,
      })
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String settingKey,
      required String settingValue,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> settingKey,
      Value<String> settingValue,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSettingRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSettingRow,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>,
          ),
          AppSettingRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> settingKey = const Value.absent(),
                Value<String> settingValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String settingKey,
                required String settingValue,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSettingRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSettingRow,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>,
      ),
      AppSettingRow,
      PrefetchHooks Function()
    >;
typedef $$PraisesTableCreateCompanionBuilder =
    PraisesCompanion Function({
      required String id,
      required String label,
      required String audioPath,
      required ContentSource source,
      Value<bool> enabled,
      Value<int> rowid,
    });
typedef $$PraisesTableUpdateCompanionBuilder =
    PraisesCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<String> audioPath,
      Value<ContentSource> source,
      Value<bool> enabled,
      Value<int> rowid,
    });

class $$PraisesTableFilterComposer
    extends Composer<_$AppDatabase, $PraisesTable> {
  $$PraisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ContentSource, ContentSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PraisesTableOrderingComposer
    extends Composer<_$AppDatabase, $PraisesTable> {
  $$PraisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PraisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PraisesTable> {
  $$PraisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ContentSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
}

class $$PraisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PraisesTable,
          PraiseRow,
          $$PraisesTableFilterComposer,
          $$PraisesTableOrderingComposer,
          $$PraisesTableAnnotationComposer,
          $$PraisesTableCreateCompanionBuilder,
          $$PraisesTableUpdateCompanionBuilder,
          (PraiseRow, BaseReferences<_$AppDatabase, $PraisesTable, PraiseRow>),
          PraiseRow,
          PrefetchHooks Function()
        > {
  $$PraisesTableTableManager(_$AppDatabase db, $PraisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PraisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PraisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PraisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> audioPath = const Value.absent(),
                Value<ContentSource> source = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PraisesCompanion(
                id: id,
                label: label,
                audioPath: audioPath,
                source: source,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                required String audioPath,
                required ContentSource source,
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PraisesCompanion.insert(
                id: id,
                label: label,
                audioPath: audioPath,
                source: source,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PraisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PraisesTable,
      PraiseRow,
      $$PraisesTableFilterComposer,
      $$PraisesTableOrderingComposer,
      $$PraisesTableAnnotationComposer,
      $$PraisesTableCreateCompanionBuilder,
      $$PraisesTableUpdateCompanionBuilder,
      (PraiseRow, BaseReferences<_$AppDatabase, $PraisesTable, PraiseRow>),
      PraiseRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$ExemplarsTableTableManager get exemplars =>
      $$ExemplarsTableTableManager(_db, _db.exemplars);
  $$ChildProfilesTableTableManager get childProfiles =>
      $$ChildProfilesTableTableManager(_db, _db.childProfiles);
  $$LearningStatesTableTableManager get learningStates =>
      $$LearningStatesTableTableManager(_db, _db.learningStates);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$TrialLogsTableTableManager get trialLogs =>
      $$TrialLogsTableTableManager(_db, _db.trialLogs);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$PraisesTableTableManager get praises =>
      $$PraisesTableTableManager(_db, _db.praises);
}
