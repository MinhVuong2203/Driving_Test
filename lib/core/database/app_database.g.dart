// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TopicsTable extends Topics with TableInfo<$TopicsTable, Topic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TopicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _fullnameMeta = const VerificationMeta(
    'fullname',
  );
  @override
  late final GeneratedColumn<String> fullname = GeneratedColumn<String>(
    'fullname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, fullname, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'topics';
  @override
  VerificationContext validateIntegrity(
    Insertable<Topic> instance, {
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
    if (data.containsKey('fullname')) {
      context.handle(
        _fullnameMeta,
        fullname.isAcceptableOrUnknown(data['fullname']!, _fullnameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullnameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Topic map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Topic(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      fullname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fullname'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $TopicsTable createAlias(String alias) {
    return $TopicsTable(attachedDatabase, alias);
  }
}

class Topic extends DataClass implements Insertable<Topic> {
  final int id;
  final String name;
  final String fullname;
  final String? description;
  const Topic({
    required this.id,
    required this.name,
    required this.fullname,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['fullname'] = Variable<String>(fullname);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  TopicsCompanion toCompanion(bool nullToAbsent) {
    return TopicsCompanion(
      id: Value(id),
      name: Value(name),
      fullname: Value(fullname),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Topic.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Topic(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      fullname: serializer.fromJson<String>(json['fullname']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'fullname': serializer.toJson<String>(fullname),
      'description': serializer.toJson<String?>(description),
    };
  }

  Topic copyWith({
    int? id,
    String? name,
    String? fullname,
    Value<String?> description = const Value.absent(),
  }) => Topic(
    id: id ?? this.id,
    name: name ?? this.name,
    fullname: fullname ?? this.fullname,
    description: description.present ? description.value : this.description,
  );
  Topic copyWithCompanion(TopicsCompanion data) {
    return Topic(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      fullname: data.fullname.present ? data.fullname.value : this.fullname,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Topic(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fullname: $fullname, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, fullname, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Topic &&
          other.id == this.id &&
          other.name == this.name &&
          other.fullname == this.fullname &&
          other.description == this.description);
}

class TopicsCompanion extends UpdateCompanion<Topic> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> fullname;
  final Value<String?> description;
  final Value<int> rowid;
  const TopicsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.fullname = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TopicsCompanion.insert({
    required int id,
    required String name,
    required String fullname,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       fullname = Value(fullname);
  static Insertable<Topic> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? fullname,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (fullname != null) 'fullname': fullname,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TopicsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? fullname,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return TopicsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      fullname: fullname ?? this.fullname,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (fullname.present) {
      map['fullname'] = Variable<String>(fullname.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TopicsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fullname: $fullname, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<int> topicId = GeneratedColumn<int>(
    'topic_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES topics (id)',
    ),
  );
  static const VerificationMeta _questionMeta = const VerificationMeta(
    'question',
  );
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
    'question',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _answerAMeta = const VerificationMeta(
    'answerA',
  );
  @override
  late final GeneratedColumn<String> answerA = GeneratedColumn<String>(
    'answer_a',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _answerBMeta = const VerificationMeta(
    'answerB',
  );
  @override
  late final GeneratedColumn<String> answerB = GeneratedColumn<String>(
    'answer_b',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _answerCMeta = const VerificationMeta(
    'answerC',
  );
  @override
  late final GeneratedColumn<String> answerC = GeneratedColumn<String>(
    'answer_c',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _answerDMeta = const VerificationMeta(
    'answerD',
  );
  @override
  late final GeneratedColumn<String> answerD = GeneratedColumn<String>(
    'answer_d',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ofRankAMeta = const VerificationMeta(
    'ofRankA',
  );
  @override
  late final GeneratedColumn<int> ofRankA = GeneratedColumn<int>(
    'of_rank_a',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ofRankB1Meta = const VerificationMeta(
    'ofRankB1',
  );
  @override
  late final GeneratedColumn<int> ofRankB1 = GeneratedColumn<int>(
    'of_rank_b1',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctAnswerMeta = const VerificationMeta(
    'correctAnswer',
  );
  @override
  late final GeneratedColumn<String> correctAnswer = GeneratedColumn<String>(
    'correct_answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCriticalMeta = const VerificationMeta(
    'isCritical',
  );
  @override
  late final GeneratedColumn<int> isCritical = GeneratedColumn<int>(
    'is_critical',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    topicId,
    question,
    imageUrl,
    answerA,
    answerB,
    answerC,
    answerD,
    ofRankA,
    ofRankB1,
    correctAnswer,
    explanation,
    isCritical,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Question> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    }
    if (data.containsKey('question')) {
      context.handle(
        _questionMeta,
        question.isAcceptableOrUnknown(data['question']!, _questionMeta),
      );
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('answer_a')) {
      context.handle(
        _answerAMeta,
        answerA.isAcceptableOrUnknown(data['answer_a']!, _answerAMeta),
      );
    }
    if (data.containsKey('answer_b')) {
      context.handle(
        _answerBMeta,
        answerB.isAcceptableOrUnknown(data['answer_b']!, _answerBMeta),
      );
    }
    if (data.containsKey('answer_c')) {
      context.handle(
        _answerCMeta,
        answerC.isAcceptableOrUnknown(data['answer_c']!, _answerCMeta),
      );
    }
    if (data.containsKey('answer_d')) {
      context.handle(
        _answerDMeta,
        answerD.isAcceptableOrUnknown(data['answer_d']!, _answerDMeta),
      );
    }
    if (data.containsKey('of_rank_a')) {
      context.handle(
        _ofRankAMeta,
        ofRankA.isAcceptableOrUnknown(data['of_rank_a']!, _ofRankAMeta),
      );
    }
    if (data.containsKey('of_rank_b1')) {
      context.handle(
        _ofRankB1Meta,
        ofRankB1.isAcceptableOrUnknown(data['of_rank_b1']!, _ofRankB1Meta),
      );
    }
    if (data.containsKey('correct_answer')) {
      context.handle(
        _correctAnswerMeta,
        correctAnswer.isAcceptableOrUnknown(
          data['correct_answer']!,
          _correctAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctAnswerMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    }
    if (data.containsKey('is_critical')) {
      context.handle(
        _isCriticalMeta,
        isCritical.isAcceptableOrUnknown(data['is_critical']!, _isCriticalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}topic_id'],
      ),
      question: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      answerA: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_a'],
      ),
      answerB: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_b'],
      ),
      answerC: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_c'],
      ),
      answerD: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_d'],
      ),
      ofRankA: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}of_rank_a'],
      )!,
      ofRankB1: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}of_rank_b1'],
      )!,
      correctAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correct_answer'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      ),
      isCritical: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_critical'],
      )!,
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class Question extends DataClass implements Insertable<Question> {
  final int id;
  final int? topicId;
  final String question;
  final String? imageUrl;
  final String? answerA;
  final String? answerB;
  final String? answerC;
  final String? answerD;
  final int ofRankA;
  final int ofRankB1;
  final String correctAnswer;
  final String? explanation;
  final int isCritical;
  const Question({
    required this.id,
    this.topicId,
    required this.question,
    this.imageUrl,
    this.answerA,
    this.answerB,
    this.answerC,
    this.answerD,
    required this.ofRankA,
    required this.ofRankB1,
    required this.correctAnswer,
    this.explanation,
    required this.isCritical,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || topicId != null) {
      map['topic_id'] = Variable<int>(topicId);
    }
    map['question'] = Variable<String>(question);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || answerA != null) {
      map['answer_a'] = Variable<String>(answerA);
    }
    if (!nullToAbsent || answerB != null) {
      map['answer_b'] = Variable<String>(answerB);
    }
    if (!nullToAbsent || answerC != null) {
      map['answer_c'] = Variable<String>(answerC);
    }
    if (!nullToAbsent || answerD != null) {
      map['answer_d'] = Variable<String>(answerD);
    }
    map['of_rank_a'] = Variable<int>(ofRankA);
    map['of_rank_b1'] = Variable<int>(ofRankB1);
    map['correct_answer'] = Variable<String>(correctAnswer);
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    map['is_critical'] = Variable<int>(isCritical);
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      topicId: topicId == null && nullToAbsent
          ? const Value.absent()
          : Value(topicId),
      question: Value(question),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      answerA: answerA == null && nullToAbsent
          ? const Value.absent()
          : Value(answerA),
      answerB: answerB == null && nullToAbsent
          ? const Value.absent()
          : Value(answerB),
      answerC: answerC == null && nullToAbsent
          ? const Value.absent()
          : Value(answerC),
      answerD: answerD == null && nullToAbsent
          ? const Value.absent()
          : Value(answerD),
      ofRankA: Value(ofRankA),
      ofRankB1: Value(ofRankB1),
      correctAnswer: Value(correctAnswer),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
      isCritical: Value(isCritical),
    );
  }

  factory Question.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<int>(json['id']),
      topicId: serializer.fromJson<int?>(json['topicId']),
      question: serializer.fromJson<String>(json['question']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      answerA: serializer.fromJson<String?>(json['answerA']),
      answerB: serializer.fromJson<String?>(json['answerB']),
      answerC: serializer.fromJson<String?>(json['answerC']),
      answerD: serializer.fromJson<String?>(json['answerD']),
      ofRankA: serializer.fromJson<int>(json['ofRankA']),
      ofRankB1: serializer.fromJson<int>(json['ofRankB1']),
      correctAnswer: serializer.fromJson<String>(json['correctAnswer']),
      explanation: serializer.fromJson<String?>(json['explanation']),
      isCritical: serializer.fromJson<int>(json['isCritical']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'topicId': serializer.toJson<int?>(topicId),
      'question': serializer.toJson<String>(question),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'answerA': serializer.toJson<String?>(answerA),
      'answerB': serializer.toJson<String?>(answerB),
      'answerC': serializer.toJson<String?>(answerC),
      'answerD': serializer.toJson<String?>(answerD),
      'ofRankA': serializer.toJson<int>(ofRankA),
      'ofRankB1': serializer.toJson<int>(ofRankB1),
      'correctAnswer': serializer.toJson<String>(correctAnswer),
      'explanation': serializer.toJson<String?>(explanation),
      'isCritical': serializer.toJson<int>(isCritical),
    };
  }

  Question copyWith({
    int? id,
    Value<int?> topicId = const Value.absent(),
    String? question,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> answerA = const Value.absent(),
    Value<String?> answerB = const Value.absent(),
    Value<String?> answerC = const Value.absent(),
    Value<String?> answerD = const Value.absent(),
    int? ofRankA,
    int? ofRankB1,
    String? correctAnswer,
    Value<String?> explanation = const Value.absent(),
    int? isCritical,
  }) => Question(
    id: id ?? this.id,
    topicId: topicId.present ? topicId.value : this.topicId,
    question: question ?? this.question,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    answerA: answerA.present ? answerA.value : this.answerA,
    answerB: answerB.present ? answerB.value : this.answerB,
    answerC: answerC.present ? answerC.value : this.answerC,
    answerD: answerD.present ? answerD.value : this.answerD,
    ofRankA: ofRankA ?? this.ofRankA,
    ofRankB1: ofRankB1 ?? this.ofRankB1,
    correctAnswer: correctAnswer ?? this.correctAnswer,
    explanation: explanation.present ? explanation.value : this.explanation,
    isCritical: isCritical ?? this.isCritical,
  );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      question: data.question.present ? data.question.value : this.question,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      answerA: data.answerA.present ? data.answerA.value : this.answerA,
      answerB: data.answerB.present ? data.answerB.value : this.answerB,
      answerC: data.answerC.present ? data.answerC.value : this.answerC,
      answerD: data.answerD.present ? data.answerD.value : this.answerD,
      ofRankA: data.ofRankA.present ? data.ofRankA.value : this.ofRankA,
      ofRankB1: data.ofRankB1.present ? data.ofRankB1.value : this.ofRankB1,
      correctAnswer: data.correctAnswer.present
          ? data.correctAnswer.value
          : this.correctAnswer,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      isCritical: data.isCritical.present
          ? data.isCritical.value
          : this.isCritical,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('question: $question, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('answerA: $answerA, ')
          ..write('answerB: $answerB, ')
          ..write('answerC: $answerC, ')
          ..write('answerD: $answerD, ')
          ..write('ofRankA: $ofRankA, ')
          ..write('ofRankB1: $ofRankB1, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('explanation: $explanation, ')
          ..write('isCritical: $isCritical')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    topicId,
    question,
    imageUrl,
    answerA,
    answerB,
    answerC,
    answerD,
    ofRankA,
    ofRankB1,
    correctAnswer,
    explanation,
    isCritical,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.topicId == this.topicId &&
          other.question == this.question &&
          other.imageUrl == this.imageUrl &&
          other.answerA == this.answerA &&
          other.answerB == this.answerB &&
          other.answerC == this.answerC &&
          other.answerD == this.answerD &&
          other.ofRankA == this.ofRankA &&
          other.ofRankB1 == this.ofRankB1 &&
          other.correctAnswer == this.correctAnswer &&
          other.explanation == this.explanation &&
          other.isCritical == this.isCritical);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<int> id;
  final Value<int?> topicId;
  final Value<String> question;
  final Value<String?> imageUrl;
  final Value<String?> answerA;
  final Value<String?> answerB;
  final Value<String?> answerC;
  final Value<String?> answerD;
  final Value<int> ofRankA;
  final Value<int> ofRankB1;
  final Value<String> correctAnswer;
  final Value<String?> explanation;
  final Value<int> isCritical;
  final Value<int> rowid;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.topicId = const Value.absent(),
    this.question = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.answerA = const Value.absent(),
    this.answerB = const Value.absent(),
    this.answerC = const Value.absent(),
    this.answerD = const Value.absent(),
    this.ofRankA = const Value.absent(),
    this.ofRankB1 = const Value.absent(),
    this.correctAnswer = const Value.absent(),
    this.explanation = const Value.absent(),
    this.isCritical = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionsCompanion.insert({
    required int id,
    this.topicId = const Value.absent(),
    required String question,
    this.imageUrl = const Value.absent(),
    this.answerA = const Value.absent(),
    this.answerB = const Value.absent(),
    this.answerC = const Value.absent(),
    this.answerD = const Value.absent(),
    this.ofRankA = const Value.absent(),
    this.ofRankB1 = const Value.absent(),
    required String correctAnswer,
    this.explanation = const Value.absent(),
    this.isCritical = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       question = Value(question),
       correctAnswer = Value(correctAnswer);
  static Insertable<Question> custom({
    Expression<int>? id,
    Expression<int>? topicId,
    Expression<String>? question,
    Expression<String>? imageUrl,
    Expression<String>? answerA,
    Expression<String>? answerB,
    Expression<String>? answerC,
    Expression<String>? answerD,
    Expression<int>? ofRankA,
    Expression<int>? ofRankB1,
    Expression<String>? correctAnswer,
    Expression<String>? explanation,
    Expression<int>? isCritical,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (topicId != null) 'topic_id': topicId,
      if (question != null) 'question': question,
      if (imageUrl != null) 'image_url': imageUrl,
      if (answerA != null) 'answer_a': answerA,
      if (answerB != null) 'answer_b': answerB,
      if (answerC != null) 'answer_c': answerC,
      if (answerD != null) 'answer_d': answerD,
      if (ofRankA != null) 'of_rank_a': ofRankA,
      if (ofRankB1 != null) 'of_rank_b1': ofRankB1,
      if (correctAnswer != null) 'correct_answer': correctAnswer,
      if (explanation != null) 'explanation': explanation,
      if (isCritical != null) 'is_critical': isCritical,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionsCompanion copyWith({
    Value<int>? id,
    Value<int?>? topicId,
    Value<String>? question,
    Value<String?>? imageUrl,
    Value<String?>? answerA,
    Value<String?>? answerB,
    Value<String?>? answerC,
    Value<String?>? answerD,
    Value<int>? ofRankA,
    Value<int>? ofRankB1,
    Value<String>? correctAnswer,
    Value<String?>? explanation,
    Value<int>? isCritical,
    Value<int>? rowid,
  }) {
    return QuestionsCompanion(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      question: question ?? this.question,
      imageUrl: imageUrl ?? this.imageUrl,
      answerA: answerA ?? this.answerA,
      answerB: answerB ?? this.answerB,
      answerC: answerC ?? this.answerC,
      answerD: answerD ?? this.answerD,
      ofRankA: ofRankA ?? this.ofRankA,
      ofRankB1: ofRankB1 ?? this.ofRankB1,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      isCritical: isCritical ?? this.isCritical,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<int>(topicId.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (answerA.present) {
      map['answer_a'] = Variable<String>(answerA.value);
    }
    if (answerB.present) {
      map['answer_b'] = Variable<String>(answerB.value);
    }
    if (answerC.present) {
      map['answer_c'] = Variable<String>(answerC.value);
    }
    if (answerD.present) {
      map['answer_d'] = Variable<String>(answerD.value);
    }
    if (ofRankA.present) {
      map['of_rank_a'] = Variable<int>(ofRankA.value);
    }
    if (ofRankB1.present) {
      map['of_rank_b1'] = Variable<int>(ofRankB1.value);
    }
    if (correctAnswer.present) {
      map['correct_answer'] = Variable<String>(correctAnswer.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (isCritical.present) {
      map['is_critical'] = Variable<int>(isCritical.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('question: $question, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('answerA: $answerA, ')
          ..write('answerB: $answerB, ')
          ..write('answerC: $answerC, ')
          ..write('answerD: $answerD, ')
          ..write('ofRankA: $ofRankA, ')
          ..write('ofRankB1: $ofRankB1, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('explanation: $explanation, ')
          ..write('isCritical: $isCritical, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExamGroupsTable extends ExamGroups
    with TableInfo<$ExamGroupsTable, ExamGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _examGroupsIdMeta = const VerificationMeta(
    'examGroupsId',
  );
  @override
  late final GeneratedColumn<int> examGroupsId = GeneratedColumn<int>(
    'exam_groups_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [examGroupsId, name, totalQuestions];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('exam_groups_id')) {
      context.handle(
        _examGroupsIdMeta,
        examGroupsId.isAcceptableOrUnknown(
          data['exam_groups_id']!,
          _examGroupsIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {examGroupsId};
  @override
  ExamGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamGroup(
      examGroupsId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exam_groups_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      ),
    );
  }

  @override
  $ExamGroupsTable createAlias(String alias) {
    return $ExamGroupsTable(attachedDatabase, alias);
  }
}

class ExamGroup extends DataClass implements Insertable<ExamGroup> {
  final int examGroupsId;
  final String? name;
  final int? totalQuestions;
  const ExamGroup({required this.examGroupsId, this.name, this.totalQuestions});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['exam_groups_id'] = Variable<int>(examGroupsId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || totalQuestions != null) {
      map['total_questions'] = Variable<int>(totalQuestions);
    }
    return map;
  }

  ExamGroupsCompanion toCompanion(bool nullToAbsent) {
    return ExamGroupsCompanion(
      examGroupsId: Value(examGroupsId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      totalQuestions: totalQuestions == null && nullToAbsent
          ? const Value.absent()
          : Value(totalQuestions),
    );
  }

  factory ExamGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamGroup(
      examGroupsId: serializer.fromJson<int>(json['examGroupsId']),
      name: serializer.fromJson<String?>(json['name']),
      totalQuestions: serializer.fromJson<int?>(json['totalQuestions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'examGroupsId': serializer.toJson<int>(examGroupsId),
      'name': serializer.toJson<String?>(name),
      'totalQuestions': serializer.toJson<int?>(totalQuestions),
    };
  }

  ExamGroup copyWith({
    int? examGroupsId,
    Value<String?> name = const Value.absent(),
    Value<int?> totalQuestions = const Value.absent(),
  }) => ExamGroup(
    examGroupsId: examGroupsId ?? this.examGroupsId,
    name: name.present ? name.value : this.name,
    totalQuestions: totalQuestions.present
        ? totalQuestions.value
        : this.totalQuestions,
  );
  ExamGroup copyWithCompanion(ExamGroupsCompanion data) {
    return ExamGroup(
      examGroupsId: data.examGroupsId.present
          ? data.examGroupsId.value
          : this.examGroupsId,
      name: data.name.present ? data.name.value : this.name,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamGroup(')
          ..write('examGroupsId: $examGroupsId, ')
          ..write('name: $name, ')
          ..write('totalQuestions: $totalQuestions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(examGroupsId, name, totalQuestions);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamGroup &&
          other.examGroupsId == this.examGroupsId &&
          other.name == this.name &&
          other.totalQuestions == this.totalQuestions);
}

class ExamGroupsCompanion extends UpdateCompanion<ExamGroup> {
  final Value<int> examGroupsId;
  final Value<String?> name;
  final Value<int?> totalQuestions;
  const ExamGroupsCompanion({
    this.examGroupsId = const Value.absent(),
    this.name = const Value.absent(),
    this.totalQuestions = const Value.absent(),
  });
  ExamGroupsCompanion.insert({
    this.examGroupsId = const Value.absent(),
    this.name = const Value.absent(),
    this.totalQuestions = const Value.absent(),
  });
  static Insertable<ExamGroup> custom({
    Expression<int>? examGroupsId,
    Expression<String>? name,
    Expression<int>? totalQuestions,
  }) {
    return RawValuesInsertable({
      if (examGroupsId != null) 'exam_groups_id': examGroupsId,
      if (name != null) 'name': name,
      if (totalQuestions != null) 'total_questions': totalQuestions,
    });
  }

  ExamGroupsCompanion copyWith({
    Value<int>? examGroupsId,
    Value<String?>? name,
    Value<int?>? totalQuestions,
  }) {
    return ExamGroupsCompanion(
      examGroupsId: examGroupsId ?? this.examGroupsId,
      name: name ?? this.name,
      totalQuestions: totalQuestions ?? this.totalQuestions,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (examGroupsId.present) {
      map['exam_groups_id'] = Variable<int>(examGroupsId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamGroupsCompanion(')
          ..write('examGroupsId: $examGroupsId, ')
          ..write('name: $name, ')
          ..write('totalQuestions: $totalQuestions')
          ..write(')'))
        .toString();
  }
}

class $RanksTable extends Ranks with TableInfo<$RanksTable, Rank> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RanksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rankIdMeta = const VerificationMeta('rankId');
  @override
  late final GeneratedColumn<String> rankId = GeneratedColumn<String>(
    'rank_id',
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalExamMeta = const VerificationMeta(
    'totalExam',
  );
  @override
  late final GeneratedColumn<int> totalExam = GeneratedColumn<int>(
    'total_exam',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalPassMeta = const VerificationMeta(
    'totalPass',
  );
  @override
  late final GeneratedColumn<int> totalPass = GeneratedColumn<int>(
    'total_pass',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
    'time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _examGroupsIdMeta = const VerificationMeta(
    'examGroupsId',
  );
  @override
  late final GeneratedColumn<int> examGroupsId = GeneratedColumn<int>(
    'exam_groups_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exam_groups (exam_groups_id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rankId,
    name,
    description,
    totalQuestions,
    totalExam,
    totalPass,
    time,
    examGroupsId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ranks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Rank> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('rank_id')) {
      context.handle(
        _rankIdMeta,
        rankId.isAcceptableOrUnknown(data['rank_id']!, _rankIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rankIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    }
    if (data.containsKey('total_exam')) {
      context.handle(
        _totalExamMeta,
        totalExam.isAcceptableOrUnknown(data['total_exam']!, _totalExamMeta),
      );
    }
    if (data.containsKey('total_pass')) {
      context.handle(
        _totalPassMeta,
        totalPass.isAcceptableOrUnknown(data['total_pass']!, _totalPassMeta),
      );
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    }
    if (data.containsKey('exam_groups_id')) {
      context.handle(
        _examGroupsIdMeta,
        examGroupsId.isAcceptableOrUnknown(
          data['exam_groups_id']!,
          _examGroupsIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rankId};
  @override
  Rank map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rank(
      rankId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rank_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      ),
      totalExam: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_exam'],
      ),
      totalPass: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_pass'],
      ),
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time'],
      ),
      examGroupsId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exam_groups_id'],
      ),
    );
  }

  @override
  $RanksTable createAlias(String alias) {
    return $RanksTable(attachedDatabase, alias);
  }
}

class Rank extends DataClass implements Insertable<Rank> {
  final String rankId;
  final String name;
  final String? description;
  final int? totalQuestions;
  final int? totalExam;
  final int? totalPass;
  final int? time;
  final int? examGroupsId;
  const Rank({
    required this.rankId,
    required this.name,
    this.description,
    this.totalQuestions,
    this.totalExam,
    this.totalPass,
    this.time,
    this.examGroupsId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rank_id'] = Variable<String>(rankId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || totalQuestions != null) {
      map['total_questions'] = Variable<int>(totalQuestions);
    }
    if (!nullToAbsent || totalExam != null) {
      map['total_exam'] = Variable<int>(totalExam);
    }
    if (!nullToAbsent || totalPass != null) {
      map['total_pass'] = Variable<int>(totalPass);
    }
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<int>(time);
    }
    if (!nullToAbsent || examGroupsId != null) {
      map['exam_groups_id'] = Variable<int>(examGroupsId);
    }
    return map;
  }

  RanksCompanion toCompanion(bool nullToAbsent) {
    return RanksCompanion(
      rankId: Value(rankId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      totalQuestions: totalQuestions == null && nullToAbsent
          ? const Value.absent()
          : Value(totalQuestions),
      totalExam: totalExam == null && nullToAbsent
          ? const Value.absent()
          : Value(totalExam),
      totalPass: totalPass == null && nullToAbsent
          ? const Value.absent()
          : Value(totalPass),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      examGroupsId: examGroupsId == null && nullToAbsent
          ? const Value.absent()
          : Value(examGroupsId),
    );
  }

  factory Rank.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rank(
      rankId: serializer.fromJson<String>(json['rankId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      totalQuestions: serializer.fromJson<int?>(json['totalQuestions']),
      totalExam: serializer.fromJson<int?>(json['totalExam']),
      totalPass: serializer.fromJson<int?>(json['totalPass']),
      time: serializer.fromJson<int?>(json['time']),
      examGroupsId: serializer.fromJson<int?>(json['examGroupsId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rankId': serializer.toJson<String>(rankId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'totalQuestions': serializer.toJson<int?>(totalQuestions),
      'totalExam': serializer.toJson<int?>(totalExam),
      'totalPass': serializer.toJson<int?>(totalPass),
      'time': serializer.toJson<int?>(time),
      'examGroupsId': serializer.toJson<int?>(examGroupsId),
    };
  }

  Rank copyWith({
    String? rankId,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<int?> totalQuestions = const Value.absent(),
    Value<int?> totalExam = const Value.absent(),
    Value<int?> totalPass = const Value.absent(),
    Value<int?> time = const Value.absent(),
    Value<int?> examGroupsId = const Value.absent(),
  }) => Rank(
    rankId: rankId ?? this.rankId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    totalQuestions: totalQuestions.present
        ? totalQuestions.value
        : this.totalQuestions,
    totalExam: totalExam.present ? totalExam.value : this.totalExam,
    totalPass: totalPass.present ? totalPass.value : this.totalPass,
    time: time.present ? time.value : this.time,
    examGroupsId: examGroupsId.present ? examGroupsId.value : this.examGroupsId,
  );
  Rank copyWithCompanion(RanksCompanion data) {
    return Rank(
      rankId: data.rankId.present ? data.rankId.value : this.rankId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      totalExam: data.totalExam.present ? data.totalExam.value : this.totalExam,
      totalPass: data.totalPass.present ? data.totalPass.value : this.totalPass,
      time: data.time.present ? data.time.value : this.time,
      examGroupsId: data.examGroupsId.present
          ? data.examGroupsId.value
          : this.examGroupsId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rank(')
          ..write('rankId: $rankId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('totalExam: $totalExam, ')
          ..write('totalPass: $totalPass, ')
          ..write('time: $time, ')
          ..write('examGroupsId: $examGroupsId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rankId,
    name,
    description,
    totalQuestions,
    totalExam,
    totalPass,
    time,
    examGroupsId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rank &&
          other.rankId == this.rankId &&
          other.name == this.name &&
          other.description == this.description &&
          other.totalQuestions == this.totalQuestions &&
          other.totalExam == this.totalExam &&
          other.totalPass == this.totalPass &&
          other.time == this.time &&
          other.examGroupsId == this.examGroupsId);
}

class RanksCompanion extends UpdateCompanion<Rank> {
  final Value<String> rankId;
  final Value<String> name;
  final Value<String?> description;
  final Value<int?> totalQuestions;
  final Value<int?> totalExam;
  final Value<int?> totalPass;
  final Value<int?> time;
  final Value<int?> examGroupsId;
  final Value<int> rowid;
  const RanksCompanion({
    this.rankId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.totalExam = const Value.absent(),
    this.totalPass = const Value.absent(),
    this.time = const Value.absent(),
    this.examGroupsId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RanksCompanion.insert({
    required String rankId,
    required String name,
    this.description = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.totalExam = const Value.absent(),
    this.totalPass = const Value.absent(),
    this.time = const Value.absent(),
    this.examGroupsId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : rankId = Value(rankId),
       name = Value(name);
  static Insertable<Rank> custom({
    Expression<String>? rankId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? totalQuestions,
    Expression<int>? totalExam,
    Expression<int>? totalPass,
    Expression<int>? time,
    Expression<int>? examGroupsId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rankId != null) 'rank_id': rankId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (totalExam != null) 'total_exam': totalExam,
      if (totalPass != null) 'total_pass': totalPass,
      if (time != null) 'time': time,
      if (examGroupsId != null) 'exam_groups_id': examGroupsId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RanksCompanion copyWith({
    Value<String>? rankId,
    Value<String>? name,
    Value<String?>? description,
    Value<int?>? totalQuestions,
    Value<int?>? totalExam,
    Value<int?>? totalPass,
    Value<int?>? time,
    Value<int?>? examGroupsId,
    Value<int>? rowid,
  }) {
    return RanksCompanion(
      rankId: rankId ?? this.rankId,
      name: name ?? this.name,
      description: description ?? this.description,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      totalExam: totalExam ?? this.totalExam,
      totalPass: totalPass ?? this.totalPass,
      time: time ?? this.time,
      examGroupsId: examGroupsId ?? this.examGroupsId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rankId.present) {
      map['rank_id'] = Variable<String>(rankId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (totalExam.present) {
      map['total_exam'] = Variable<int>(totalExam.value);
    }
    if (totalPass.present) {
      map['total_pass'] = Variable<int>(totalPass.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (examGroupsId.present) {
      map['exam_groups_id'] = Variable<int>(examGroupsId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RanksCompanion(')
          ..write('rankId: $rankId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('totalExam: $totalExam, ')
          ..write('totalPass: $totalPass, ')
          ..write('time: $time, ')
          ..write('examGroupsId: $examGroupsId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExamSetsTable extends ExamSets with TableInfo<$ExamSetsTable, ExamSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _examGroupsIdMeta = const VerificationMeta(
    'examGroupsId',
  );
  @override
  late final GeneratedColumn<int> examGroupsId = GeneratedColumn<int>(
    'exam_groups_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exam_groups (exam_groups_id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, examGroupsId, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exam_groups_id')) {
      context.handle(
        _examGroupsIdMeta,
        examGroupsId.isAcceptableOrUnknown(
          data['exam_groups_id']!,
          _examGroupsIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examGroupsIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      examGroupsId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exam_groups_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExamSetsTable createAlias(String alias) {
    return $ExamSetsTable(attachedDatabase, alias);
  }
}

class ExamSet extends DataClass implements Insertable<ExamSet> {
  final int id;
  final int examGroupsId;
  final String? name;
  final DateTime createdAt;
  const ExamSet({
    required this.id,
    required this.examGroupsId,
    this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exam_groups_id'] = Variable<int>(examGroupsId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExamSetsCompanion toCompanion(bool nullToAbsent) {
    return ExamSetsCompanion(
      id: Value(id),
      examGroupsId: Value(examGroupsId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory ExamSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamSet(
      id: serializer.fromJson<int>(json['id']),
      examGroupsId: serializer.fromJson<int>(json['examGroupsId']),
      name: serializer.fromJson<String?>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'examGroupsId': serializer.toJson<int>(examGroupsId),
      'name': serializer.toJson<String?>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExamSet copyWith({
    int? id,
    int? examGroupsId,
    Value<String?> name = const Value.absent(),
    DateTime? createdAt,
  }) => ExamSet(
    id: id ?? this.id,
    examGroupsId: examGroupsId ?? this.examGroupsId,
    name: name.present ? name.value : this.name,
    createdAt: createdAt ?? this.createdAt,
  );
  ExamSet copyWithCompanion(ExamSetsCompanion data) {
    return ExamSet(
      id: data.id.present ? data.id.value : this.id,
      examGroupsId: data.examGroupsId.present
          ? data.examGroupsId.value
          : this.examGroupsId,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamSet(')
          ..write('id: $id, ')
          ..write('examGroupsId: $examGroupsId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, examGroupsId, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamSet &&
          other.id == this.id &&
          other.examGroupsId == this.examGroupsId &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class ExamSetsCompanion extends UpdateCompanion<ExamSet> {
  final Value<int> id;
  final Value<int> examGroupsId;
  final Value<String?> name;
  final Value<DateTime> createdAt;
  const ExamSetsCompanion({
    this.id = const Value.absent(),
    this.examGroupsId = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExamSetsCompanion.insert({
    this.id = const Value.absent(),
    required int examGroupsId,
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : examGroupsId = Value(examGroupsId);
  static Insertable<ExamSet> custom({
    Expression<int>? id,
    Expression<int>? examGroupsId,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examGroupsId != null) 'exam_groups_id': examGroupsId,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExamSetsCompanion copyWith({
    Value<int>? id,
    Value<int>? examGroupsId,
    Value<String?>? name,
    Value<DateTime>? createdAt,
  }) {
    return ExamSetsCompanion(
      id: id ?? this.id,
      examGroupsId: examGroupsId ?? this.examGroupsId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (examGroupsId.present) {
      map['exam_groups_id'] = Variable<int>(examGroupsId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamSetsCompanion(')
          ..write('id: $id, ')
          ..write('examGroupsId: $examGroupsId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExamSetQuestionsTable extends ExamSetQuestions
    with TableInfo<$ExamSetQuestionsTable, ExamSetQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamSetQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _examSetIdMeta = const VerificationMeta(
    'examSetId',
  );
  @override
  late final GeneratedColumn<int> examSetId = GeneratedColumn<int>(
    'exam_set_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exam_sets (id)',
    ),
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<int> questionId = GeneratedColumn<int>(
    'question_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES questions (id)',
    ),
  );
  static const VerificationMeta _questionOrderMeta = const VerificationMeta(
    'questionOrder',
  );
  @override
  late final GeneratedColumn<int> questionOrder = GeneratedColumn<int>(
    'question_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [examSetId, questionId, questionOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_set_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamSetQuestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('exam_set_id')) {
      context.handle(
        _examSetIdMeta,
        examSetId.isAcceptableOrUnknown(data['exam_set_id']!, _examSetIdMeta),
      );
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    }
    if (data.containsKey('question_order')) {
      context.handle(
        _questionOrderMeta,
        questionOrder.isAcceptableOrUnknown(
          data['question_order']!,
          _questionOrderMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {examSetId, questionId};
  @override
  ExamSetQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamSetQuestion(
      examSetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exam_set_id'],
      ),
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_id'],
      ),
      questionOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_order'],
      ),
    );
  }

  @override
  $ExamSetQuestionsTable createAlias(String alias) {
    return $ExamSetQuestionsTable(attachedDatabase, alias);
  }
}

class ExamSetQuestion extends DataClass implements Insertable<ExamSetQuestion> {
  final int? examSetId;
  final int? questionId;
  final int? questionOrder;
  const ExamSetQuestion({this.examSetId, this.questionId, this.questionOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || examSetId != null) {
      map['exam_set_id'] = Variable<int>(examSetId);
    }
    if (!nullToAbsent || questionId != null) {
      map['question_id'] = Variable<int>(questionId);
    }
    if (!nullToAbsent || questionOrder != null) {
      map['question_order'] = Variable<int>(questionOrder);
    }
    return map;
  }

  ExamSetQuestionsCompanion toCompanion(bool nullToAbsent) {
    return ExamSetQuestionsCompanion(
      examSetId: examSetId == null && nullToAbsent
          ? const Value.absent()
          : Value(examSetId),
      questionId: questionId == null && nullToAbsent
          ? const Value.absent()
          : Value(questionId),
      questionOrder: questionOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(questionOrder),
    );
  }

  factory ExamSetQuestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamSetQuestion(
      examSetId: serializer.fromJson<int?>(json['examSetId']),
      questionId: serializer.fromJson<int?>(json['questionId']),
      questionOrder: serializer.fromJson<int?>(json['questionOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'examSetId': serializer.toJson<int?>(examSetId),
      'questionId': serializer.toJson<int?>(questionId),
      'questionOrder': serializer.toJson<int?>(questionOrder),
    };
  }

  ExamSetQuestion copyWith({
    Value<int?> examSetId = const Value.absent(),
    Value<int?> questionId = const Value.absent(),
    Value<int?> questionOrder = const Value.absent(),
  }) => ExamSetQuestion(
    examSetId: examSetId.present ? examSetId.value : this.examSetId,
    questionId: questionId.present ? questionId.value : this.questionId,
    questionOrder: questionOrder.present
        ? questionOrder.value
        : this.questionOrder,
  );
  ExamSetQuestion copyWithCompanion(ExamSetQuestionsCompanion data) {
    return ExamSetQuestion(
      examSetId: data.examSetId.present ? data.examSetId.value : this.examSetId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      questionOrder: data.questionOrder.present
          ? data.questionOrder.value
          : this.questionOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamSetQuestion(')
          ..write('examSetId: $examSetId, ')
          ..write('questionId: $questionId, ')
          ..write('questionOrder: $questionOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(examSetId, questionId, questionOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamSetQuestion &&
          other.examSetId == this.examSetId &&
          other.questionId == this.questionId &&
          other.questionOrder == this.questionOrder);
}

class ExamSetQuestionsCompanion extends UpdateCompanion<ExamSetQuestion> {
  final Value<int?> examSetId;
  final Value<int?> questionId;
  final Value<int?> questionOrder;
  final Value<int> rowid;
  const ExamSetQuestionsCompanion({
    this.examSetId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.questionOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExamSetQuestionsCompanion.insert({
    this.examSetId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.questionOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<ExamSetQuestion> custom({
    Expression<int>? examSetId,
    Expression<int>? questionId,
    Expression<int>? questionOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (examSetId != null) 'exam_set_id': examSetId,
      if (questionId != null) 'question_id': questionId,
      if (questionOrder != null) 'question_order': questionOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExamSetQuestionsCompanion copyWith({
    Value<int?>? examSetId,
    Value<int?>? questionId,
    Value<int?>? questionOrder,
    Value<int>? rowid,
  }) {
    return ExamSetQuestionsCompanion(
      examSetId: examSetId ?? this.examSetId,
      questionId: questionId ?? this.questionId,
      questionOrder: questionOrder ?? this.questionOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (examSetId.present) {
      map['exam_set_id'] = Variable<int>(examSetId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<int>(questionId.value);
    }
    if (questionOrder.present) {
      map['question_order'] = Variable<int>(questionOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamSetQuestionsCompanion(')
          ..write('examSetId: $examSetId, ')
          ..write('questionId: $questionId, ')
          ..write('questionOrder: $questionOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PracticeSessionsTable extends PracticeSessions
    with TableInfo<$PracticeSessionsTable, PracticeSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PracticeSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<int> topicId = GeneratedColumn<int>(
    'topic_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES topics (id)',
    ),
  );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _correctAnswersMeta = const VerificationMeta(
    'correctAnswers',
  );
  @override
  late final GeneratedColumn<int> correctAnswers = GeneratedColumn<int>(
    'correct_answers',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mode,
    topicId,
    totalQuestions,
    correctAnswers,
    score,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'practice_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PracticeSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    }
    if (data.containsKey('correct_answers')) {
      context.handle(
        _correctAnswersMeta,
        correctAnswers.isAcceptableOrUnknown(
          data['correct_answers']!,
          _correctAnswersMeta,
        ),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PracticeSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PracticeSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      ),
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}topic_id'],
      ),
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      ),
      correctAnswers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_answers'],
      ),
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PracticeSessionsTable createAlias(String alias) {
    return $PracticeSessionsTable(attachedDatabase, alias);
  }
}

class PracticeSession extends DataClass implements Insertable<PracticeSession> {
  final int id;
  final String? mode;
  final int? topicId;
  final int? totalQuestions;
  final int? correctAnswers;
  final int? score;
  final DateTime createdAt;
  const PracticeSession({
    required this.id,
    this.mode,
    this.topicId,
    this.totalQuestions,
    this.correctAnswers,
    this.score,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || mode != null) {
      map['mode'] = Variable<String>(mode);
    }
    if (!nullToAbsent || topicId != null) {
      map['topic_id'] = Variable<int>(topicId);
    }
    if (!nullToAbsent || totalQuestions != null) {
      map['total_questions'] = Variable<int>(totalQuestions);
    }
    if (!nullToAbsent || correctAnswers != null) {
      map['correct_answers'] = Variable<int>(correctAnswers);
    }
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PracticeSessionsCompanion toCompanion(bool nullToAbsent) {
    return PracticeSessionsCompanion(
      id: Value(id),
      mode: mode == null && nullToAbsent ? const Value.absent() : Value(mode),
      topicId: topicId == null && nullToAbsent
          ? const Value.absent()
          : Value(topicId),
      totalQuestions: totalQuestions == null && nullToAbsent
          ? const Value.absent()
          : Value(totalQuestions),
      correctAnswers: correctAnswers == null && nullToAbsent
          ? const Value.absent()
          : Value(correctAnswers),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      createdAt: Value(createdAt),
    );
  }

  factory PracticeSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PracticeSession(
      id: serializer.fromJson<int>(json['id']),
      mode: serializer.fromJson<String?>(json['mode']),
      topicId: serializer.fromJson<int?>(json['topicId']),
      totalQuestions: serializer.fromJson<int?>(json['totalQuestions']),
      correctAnswers: serializer.fromJson<int?>(json['correctAnswers']),
      score: serializer.fromJson<int?>(json['score']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mode': serializer.toJson<String?>(mode),
      'topicId': serializer.toJson<int?>(topicId),
      'totalQuestions': serializer.toJson<int?>(totalQuestions),
      'correctAnswers': serializer.toJson<int?>(correctAnswers),
      'score': serializer.toJson<int?>(score),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PracticeSession copyWith({
    int? id,
    Value<String?> mode = const Value.absent(),
    Value<int?> topicId = const Value.absent(),
    Value<int?> totalQuestions = const Value.absent(),
    Value<int?> correctAnswers = const Value.absent(),
    Value<int?> score = const Value.absent(),
    DateTime? createdAt,
  }) => PracticeSession(
    id: id ?? this.id,
    mode: mode.present ? mode.value : this.mode,
    topicId: topicId.present ? topicId.value : this.topicId,
    totalQuestions: totalQuestions.present
        ? totalQuestions.value
        : this.totalQuestions,
    correctAnswers: correctAnswers.present
        ? correctAnswers.value
        : this.correctAnswers,
    score: score.present ? score.value : this.score,
    createdAt: createdAt ?? this.createdAt,
  );
  PracticeSession copyWithCompanion(PracticeSessionsCompanion data) {
    return PracticeSession(
      id: data.id.present ? data.id.value : this.id,
      mode: data.mode.present ? data.mode.value : this.mode,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      correctAnswers: data.correctAnswers.present
          ? data.correctAnswers.value
          : this.correctAnswers,
      score: data.score.present ? data.score.value : this.score,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PracticeSession(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('topicId: $topicId, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('score: $score, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mode,
    topicId,
    totalQuestions,
    correctAnswers,
    score,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PracticeSession &&
          other.id == this.id &&
          other.mode == this.mode &&
          other.topicId == this.topicId &&
          other.totalQuestions == this.totalQuestions &&
          other.correctAnswers == this.correctAnswers &&
          other.score == this.score &&
          other.createdAt == this.createdAt);
}

class PracticeSessionsCompanion extends UpdateCompanion<PracticeSession> {
  final Value<int> id;
  final Value<String?> mode;
  final Value<int?> topicId;
  final Value<int?> totalQuestions;
  final Value<int?> correctAnswers;
  final Value<int?> score;
  final Value<DateTime> createdAt;
  const PracticeSessionsCompanion({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.topicId = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.correctAnswers = const Value.absent(),
    this.score = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PracticeSessionsCompanion.insert({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.topicId = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.correctAnswers = const Value.absent(),
    this.score = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<PracticeSession> custom({
    Expression<int>? id,
    Expression<String>? mode,
    Expression<int>? topicId,
    Expression<int>? totalQuestions,
    Expression<int>? correctAnswers,
    Expression<int>? score,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mode != null) 'mode': mode,
      if (topicId != null) 'topic_id': topicId,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (correctAnswers != null) 'correct_answers': correctAnswers,
      if (score != null) 'score': score,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PracticeSessionsCompanion copyWith({
    Value<int>? id,
    Value<String?>? mode,
    Value<int?>? topicId,
    Value<int?>? totalQuestions,
    Value<int?>? correctAnswers,
    Value<int?>? score,
    Value<DateTime>? createdAt,
  }) {
    return PracticeSessionsCompanion(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      topicId: topicId ?? this.topicId,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      score: score ?? this.score,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<int>(topicId.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (correctAnswers.present) {
      map['correct_answers'] = Variable<int>(correctAnswers.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PracticeSessionsCompanion(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('topicId: $topicId, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('score: $score, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserAnswersTable extends UserAnswers
    with TableInfo<$UserAnswersTable, UserAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES practice_sessions (id)',
    ),
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<int> questionId = GeneratedColumn<int>(
    'question_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES questions (id)',
    ),
  );
  static const VerificationMeta _selectedAnswerMeta = const VerificationMeta(
    'selectedAnswer',
  );
  @override
  late final GeneratedColumn<String> selectedAnswer = GeneratedColumn<String>(
    'selected_answer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<int> isCorrect = GeneratedColumn<int>(
    'is_correct',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    questionId,
    selectedAnswer,
    isCorrect,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserAnswer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    }
    if (data.containsKey('selected_answer')) {
      context.handle(
        _selectedAnswerMeta,
        selectedAnswer.isAcceptableOrUnknown(
          data['selected_answer']!,
          _selectedAnswerMeta,
        ),
      );
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserAnswer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      ),
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_id'],
      ),
      selectedAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_answer'],
      ),
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_correct'],
      ),
    );
  }

  @override
  $UserAnswersTable createAlias(String alias) {
    return $UserAnswersTable(attachedDatabase, alias);
  }
}

class UserAnswer extends DataClass implements Insertable<UserAnswer> {
  final int id;
  final int? sessionId;
  final int? questionId;
  final String? selectedAnswer;
  final int? isCorrect;
  const UserAnswer({
    required this.id,
    this.sessionId,
    this.questionId,
    this.selectedAnswer,
    this.isCorrect,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<int>(sessionId);
    }
    if (!nullToAbsent || questionId != null) {
      map['question_id'] = Variable<int>(questionId);
    }
    if (!nullToAbsent || selectedAnswer != null) {
      map['selected_answer'] = Variable<String>(selectedAnswer);
    }
    if (!nullToAbsent || isCorrect != null) {
      map['is_correct'] = Variable<int>(isCorrect);
    }
    return map;
  }

  UserAnswersCompanion toCompanion(bool nullToAbsent) {
    return UserAnswersCompanion(
      id: Value(id),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      questionId: questionId == null && nullToAbsent
          ? const Value.absent()
          : Value(questionId),
      selectedAnswer: selectedAnswer == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedAnswer),
      isCorrect: isCorrect == null && nullToAbsent
          ? const Value.absent()
          : Value(isCorrect),
    );
  }

  factory UserAnswer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserAnswer(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int?>(json['sessionId']),
      questionId: serializer.fromJson<int?>(json['questionId']),
      selectedAnswer: serializer.fromJson<String?>(json['selectedAnswer']),
      isCorrect: serializer.fromJson<int?>(json['isCorrect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int?>(sessionId),
      'questionId': serializer.toJson<int?>(questionId),
      'selectedAnswer': serializer.toJson<String?>(selectedAnswer),
      'isCorrect': serializer.toJson<int?>(isCorrect),
    };
  }

  UserAnswer copyWith({
    int? id,
    Value<int?> sessionId = const Value.absent(),
    Value<int?> questionId = const Value.absent(),
    Value<String?> selectedAnswer = const Value.absent(),
    Value<int?> isCorrect = const Value.absent(),
  }) => UserAnswer(
    id: id ?? this.id,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    questionId: questionId.present ? questionId.value : this.questionId,
    selectedAnswer: selectedAnswer.present
        ? selectedAnswer.value
        : this.selectedAnswer,
    isCorrect: isCorrect.present ? isCorrect.value : this.isCorrect,
  );
  UserAnswer copyWithCompanion(UserAnswersCompanion data) {
    return UserAnswer(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      selectedAnswer: data.selectedAnswer.present
          ? data.selectedAnswer.value
          : this.selectedAnswer,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserAnswer(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('questionId: $questionId, ')
          ..write('selectedAnswer: $selectedAnswer, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, questionId, selectedAnswer, isCorrect);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserAnswer &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.questionId == this.questionId &&
          other.selectedAnswer == this.selectedAnswer &&
          other.isCorrect == this.isCorrect);
}

class UserAnswersCompanion extends UpdateCompanion<UserAnswer> {
  final Value<int> id;
  final Value<int?> sessionId;
  final Value<int?> questionId;
  final Value<String?> selectedAnswer;
  final Value<int?> isCorrect;
  const UserAnswersCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.selectedAnswer = const Value.absent(),
    this.isCorrect = const Value.absent(),
  });
  UserAnswersCompanion.insert({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.selectedAnswer = const Value.absent(),
    this.isCorrect = const Value.absent(),
  });
  static Insertable<UserAnswer> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? questionId,
    Expression<String>? selectedAnswer,
    Expression<int>? isCorrect,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (questionId != null) 'question_id': questionId,
      if (selectedAnswer != null) 'selected_answer': selectedAnswer,
      if (isCorrect != null) 'is_correct': isCorrect,
    });
  }

  UserAnswersCompanion copyWith({
    Value<int>? id,
    Value<int?>? sessionId,
    Value<int?>? questionId,
    Value<String?>? selectedAnswer,
    Value<int?>? isCorrect,
  }) {
    return UserAnswersCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      questionId: questionId ?? this.questionId,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<int>(questionId.value);
    }
    if (selectedAnswer.present) {
      map['selected_answer'] = Variable<String>(selectedAnswer.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<int>(isCorrect.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserAnswersCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('questionId: $questionId, ')
          ..write('selectedAnswer: $selectedAnswer, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }
}

class $WrongQuestionsTable extends WrongQuestions
    with TableInfo<$WrongQuestionsTable, WrongQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WrongQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<int> questionId = GeneratedColumn<int>(
    'question_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES questions (id)',
    ),
  );
  static const VerificationMeta _wrongCountMeta = const VerificationMeta(
    'wrongCount',
  );
  @override
  late final GeneratedColumn<int> wrongCount = GeneratedColumn<int>(
    'wrong_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _lastWrongAtMeta = const VerificationMeta(
    'lastWrongAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastWrongAt = GeneratedColumn<DateTime>(
    'last_wrong_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    questionId,
    wrongCount,
    lastWrongAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wrong_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WrongQuestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    }
    if (data.containsKey('wrong_count')) {
      context.handle(
        _wrongCountMeta,
        wrongCount.isAcceptableOrUnknown(data['wrong_count']!, _wrongCountMeta),
      );
    }
    if (data.containsKey('last_wrong_at')) {
      context.handle(
        _lastWrongAtMeta,
        lastWrongAt.isAcceptableOrUnknown(
          data['last_wrong_at']!,
          _lastWrongAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WrongQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WrongQuestion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_id'],
      ),
      wrongCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wrong_count'],
      )!,
      lastWrongAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_wrong_at'],
      )!,
    );
  }

  @override
  $WrongQuestionsTable createAlias(String alias) {
    return $WrongQuestionsTable(attachedDatabase, alias);
  }
}

class WrongQuestion extends DataClass implements Insertable<WrongQuestion> {
  final int id;
  final int? questionId;
  final int wrongCount;
  final DateTime lastWrongAt;
  const WrongQuestion({
    required this.id,
    this.questionId,
    required this.wrongCount,
    required this.lastWrongAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || questionId != null) {
      map['question_id'] = Variable<int>(questionId);
    }
    map['wrong_count'] = Variable<int>(wrongCount);
    map['last_wrong_at'] = Variable<DateTime>(lastWrongAt);
    return map;
  }

  WrongQuestionsCompanion toCompanion(bool nullToAbsent) {
    return WrongQuestionsCompanion(
      id: Value(id),
      questionId: questionId == null && nullToAbsent
          ? const Value.absent()
          : Value(questionId),
      wrongCount: Value(wrongCount),
      lastWrongAt: Value(lastWrongAt),
    );
  }

  factory WrongQuestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WrongQuestion(
      id: serializer.fromJson<int>(json['id']),
      questionId: serializer.fromJson<int?>(json['questionId']),
      wrongCount: serializer.fromJson<int>(json['wrongCount']),
      lastWrongAt: serializer.fromJson<DateTime>(json['lastWrongAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'questionId': serializer.toJson<int?>(questionId),
      'wrongCount': serializer.toJson<int>(wrongCount),
      'lastWrongAt': serializer.toJson<DateTime>(lastWrongAt),
    };
  }

  WrongQuestion copyWith({
    int? id,
    Value<int?> questionId = const Value.absent(),
    int? wrongCount,
    DateTime? lastWrongAt,
  }) => WrongQuestion(
    id: id ?? this.id,
    questionId: questionId.present ? questionId.value : this.questionId,
    wrongCount: wrongCount ?? this.wrongCount,
    lastWrongAt: lastWrongAt ?? this.lastWrongAt,
  );
  WrongQuestion copyWithCompanion(WrongQuestionsCompanion data) {
    return WrongQuestion(
      id: data.id.present ? data.id.value : this.id,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      wrongCount: data.wrongCount.present
          ? data.wrongCount.value
          : this.wrongCount,
      lastWrongAt: data.lastWrongAt.present
          ? data.lastWrongAt.value
          : this.lastWrongAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WrongQuestion(')
          ..write('id: $id, ')
          ..write('questionId: $questionId, ')
          ..write('wrongCount: $wrongCount, ')
          ..write('lastWrongAt: $lastWrongAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, questionId, wrongCount, lastWrongAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WrongQuestion &&
          other.id == this.id &&
          other.questionId == this.questionId &&
          other.wrongCount == this.wrongCount &&
          other.lastWrongAt == this.lastWrongAt);
}

class WrongQuestionsCompanion extends UpdateCompanion<WrongQuestion> {
  final Value<int> id;
  final Value<int?> questionId;
  final Value<int> wrongCount;
  final Value<DateTime> lastWrongAt;
  const WrongQuestionsCompanion({
    this.id = const Value.absent(),
    this.questionId = const Value.absent(),
    this.wrongCount = const Value.absent(),
    this.lastWrongAt = const Value.absent(),
  });
  WrongQuestionsCompanion.insert({
    this.id = const Value.absent(),
    this.questionId = const Value.absent(),
    this.wrongCount = const Value.absent(),
    this.lastWrongAt = const Value.absent(),
  });
  static Insertable<WrongQuestion> custom({
    Expression<int>? id,
    Expression<int>? questionId,
    Expression<int>? wrongCount,
    Expression<DateTime>? lastWrongAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questionId != null) 'question_id': questionId,
      if (wrongCount != null) 'wrong_count': wrongCount,
      if (lastWrongAt != null) 'last_wrong_at': lastWrongAt,
    });
  }

  WrongQuestionsCompanion copyWith({
    Value<int>? id,
    Value<int?>? questionId,
    Value<int>? wrongCount,
    Value<DateTime>? lastWrongAt,
  }) {
    return WrongQuestionsCompanion(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      wrongCount: wrongCount ?? this.wrongCount,
      lastWrongAt: lastWrongAt ?? this.lastWrongAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<int>(questionId.value);
    }
    if (wrongCount.present) {
      map['wrong_count'] = Variable<int>(wrongCount.value);
    }
    if (lastWrongAt.present) {
      map['last_wrong_at'] = Variable<DateTime>(lastWrongAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WrongQuestionsCompanion(')
          ..write('id: $id, ')
          ..write('questionId: $questionId, ')
          ..write('wrongCount: $wrongCount, ')
          ..write('lastWrongAt: $lastWrongAt')
          ..write(')'))
        .toString();
  }
}

class $ExamHistoryTable extends ExamHistory
    with TableInfo<$ExamHistoryTable, ExamHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _licenseTypeMeta = const VerificationMeta(
    'licenseType',
  );
  @override
  late final GeneratedColumn<String> licenseType = GeneratedColumn<String>(
    'license_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _correctAnswersMeta = const VerificationMeta(
    'correctAnswers',
  );
  @override
  late final GeneratedColumn<int> correctAnswers = GeneratedColumn<int>(
    'correct_answers',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPassedMeta = const VerificationMeta(
    'isPassed',
  );
  @override
  late final GeneratedColumn<int> isPassed = GeneratedColumn<int>(
    'is_passed',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeSpentMeta = const VerificationMeta(
    'timeSpent',
  );
  @override
  late final GeneratedColumn<int> timeSpent = GeneratedColumn<int>(
    'time_spent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    licenseType,
    totalQuestions,
    correctAnswers,
    isPassed,
    timeSpent,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('license_type')) {
      context.handle(
        _licenseTypeMeta,
        licenseType.isAcceptableOrUnknown(
          data['license_type']!,
          _licenseTypeMeta,
        ),
      );
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    }
    if (data.containsKey('correct_answers')) {
      context.handle(
        _correctAnswersMeta,
        correctAnswers.isAcceptableOrUnknown(
          data['correct_answers']!,
          _correctAnswersMeta,
        ),
      );
    }
    if (data.containsKey('is_passed')) {
      context.handle(
        _isPassedMeta,
        isPassed.isAcceptableOrUnknown(data['is_passed']!, _isPassedMeta),
      );
    }
    if (data.containsKey('time_spent')) {
      context.handle(
        _timeSpentMeta,
        timeSpent.isAcceptableOrUnknown(data['time_spent']!, _timeSpentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      licenseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_type'],
      ),
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      ),
      correctAnswers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_answers'],
      ),
      isPassed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_passed'],
      ),
      timeSpent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_spent'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExamHistoryTable createAlias(String alias) {
    return $ExamHistoryTable(attachedDatabase, alias);
  }
}

class ExamHistoryData extends DataClass implements Insertable<ExamHistoryData> {
  final int id;
  final String? licenseType;
  final int? totalQuestions;
  final int? correctAnswers;
  final int? isPassed;
  final int? timeSpent;
  final DateTime createdAt;
  const ExamHistoryData({
    required this.id,
    this.licenseType,
    this.totalQuestions,
    this.correctAnswers,
    this.isPassed,
    this.timeSpent,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || licenseType != null) {
      map['license_type'] = Variable<String>(licenseType);
    }
    if (!nullToAbsent || totalQuestions != null) {
      map['total_questions'] = Variable<int>(totalQuestions);
    }
    if (!nullToAbsent || correctAnswers != null) {
      map['correct_answers'] = Variable<int>(correctAnswers);
    }
    if (!nullToAbsent || isPassed != null) {
      map['is_passed'] = Variable<int>(isPassed);
    }
    if (!nullToAbsent || timeSpent != null) {
      map['time_spent'] = Variable<int>(timeSpent);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExamHistoryCompanion toCompanion(bool nullToAbsent) {
    return ExamHistoryCompanion(
      id: Value(id),
      licenseType: licenseType == null && nullToAbsent
          ? const Value.absent()
          : Value(licenseType),
      totalQuestions: totalQuestions == null && nullToAbsent
          ? const Value.absent()
          : Value(totalQuestions),
      correctAnswers: correctAnswers == null && nullToAbsent
          ? const Value.absent()
          : Value(correctAnswers),
      isPassed: isPassed == null && nullToAbsent
          ? const Value.absent()
          : Value(isPassed),
      timeSpent: timeSpent == null && nullToAbsent
          ? const Value.absent()
          : Value(timeSpent),
      createdAt: Value(createdAt),
    );
  }

  factory ExamHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamHistoryData(
      id: serializer.fromJson<int>(json['id']),
      licenseType: serializer.fromJson<String?>(json['licenseType']),
      totalQuestions: serializer.fromJson<int?>(json['totalQuestions']),
      correctAnswers: serializer.fromJson<int?>(json['correctAnswers']),
      isPassed: serializer.fromJson<int?>(json['isPassed']),
      timeSpent: serializer.fromJson<int?>(json['timeSpent']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'licenseType': serializer.toJson<String?>(licenseType),
      'totalQuestions': serializer.toJson<int?>(totalQuestions),
      'correctAnswers': serializer.toJson<int?>(correctAnswers),
      'isPassed': serializer.toJson<int?>(isPassed),
      'timeSpent': serializer.toJson<int?>(timeSpent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExamHistoryData copyWith({
    int? id,
    Value<String?> licenseType = const Value.absent(),
    Value<int?> totalQuestions = const Value.absent(),
    Value<int?> correctAnswers = const Value.absent(),
    Value<int?> isPassed = const Value.absent(),
    Value<int?> timeSpent = const Value.absent(),
    DateTime? createdAt,
  }) => ExamHistoryData(
    id: id ?? this.id,
    licenseType: licenseType.present ? licenseType.value : this.licenseType,
    totalQuestions: totalQuestions.present
        ? totalQuestions.value
        : this.totalQuestions,
    correctAnswers: correctAnswers.present
        ? correctAnswers.value
        : this.correctAnswers,
    isPassed: isPassed.present ? isPassed.value : this.isPassed,
    timeSpent: timeSpent.present ? timeSpent.value : this.timeSpent,
    createdAt: createdAt ?? this.createdAt,
  );
  ExamHistoryData copyWithCompanion(ExamHistoryCompanion data) {
    return ExamHistoryData(
      id: data.id.present ? data.id.value : this.id,
      licenseType: data.licenseType.present
          ? data.licenseType.value
          : this.licenseType,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      correctAnswers: data.correctAnswers.present
          ? data.correctAnswers.value
          : this.correctAnswers,
      isPassed: data.isPassed.present ? data.isPassed.value : this.isPassed,
      timeSpent: data.timeSpent.present ? data.timeSpent.value : this.timeSpent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamHistoryData(')
          ..write('id: $id, ')
          ..write('licenseType: $licenseType, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('isPassed: $isPassed, ')
          ..write('timeSpent: $timeSpent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    licenseType,
    totalQuestions,
    correctAnswers,
    isPassed,
    timeSpent,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamHistoryData &&
          other.id == this.id &&
          other.licenseType == this.licenseType &&
          other.totalQuestions == this.totalQuestions &&
          other.correctAnswers == this.correctAnswers &&
          other.isPassed == this.isPassed &&
          other.timeSpent == this.timeSpent &&
          other.createdAt == this.createdAt);
}

class ExamHistoryCompanion extends UpdateCompanion<ExamHistoryData> {
  final Value<int> id;
  final Value<String?> licenseType;
  final Value<int?> totalQuestions;
  final Value<int?> correctAnswers;
  final Value<int?> isPassed;
  final Value<int?> timeSpent;
  final Value<DateTime> createdAt;
  const ExamHistoryCompanion({
    this.id = const Value.absent(),
    this.licenseType = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.correctAnswers = const Value.absent(),
    this.isPassed = const Value.absent(),
    this.timeSpent = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExamHistoryCompanion.insert({
    this.id = const Value.absent(),
    this.licenseType = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.correctAnswers = const Value.absent(),
    this.isPassed = const Value.absent(),
    this.timeSpent = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<ExamHistoryData> custom({
    Expression<int>? id,
    Expression<String>? licenseType,
    Expression<int>? totalQuestions,
    Expression<int>? correctAnswers,
    Expression<int>? isPassed,
    Expression<int>? timeSpent,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (licenseType != null) 'license_type': licenseType,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (correctAnswers != null) 'correct_answers': correctAnswers,
      if (isPassed != null) 'is_passed': isPassed,
      if (timeSpent != null) 'time_spent': timeSpent,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExamHistoryCompanion copyWith({
    Value<int>? id,
    Value<String?>? licenseType,
    Value<int?>? totalQuestions,
    Value<int?>? correctAnswers,
    Value<int?>? isPassed,
    Value<int?>? timeSpent,
    Value<DateTime>? createdAt,
  }) {
    return ExamHistoryCompanion(
      id: id ?? this.id,
      licenseType: licenseType ?? this.licenseType,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      isPassed: isPassed ?? this.isPassed,
      timeSpent: timeSpent ?? this.timeSpent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (licenseType.present) {
      map['license_type'] = Variable<String>(licenseType.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (correctAnswers.present) {
      map['correct_answers'] = Variable<int>(correctAnswers.value);
    }
    if (isPassed.present) {
      map['is_passed'] = Variable<int>(isPassed.value);
    }
    if (timeSpent.present) {
      map['time_spent'] = Variable<int>(timeSpent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamHistoryCompanion(')
          ..write('id: $id, ')
          ..write('licenseType: $licenseType, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('isPassed: $isPassed, ')
          ..write('timeSpent: $timeSpent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TrafficSignsTable extends TrafficSigns
    with TableInfo<$TrafficSignsTable, TrafficSign> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrafficSignsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _signIdMeta = const VerificationMeta('signId');
  @override
  late final GeneratedColumn<String> signId = GeneratedColumn<String>(
    'sign_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    signId,
    category,
    name,
    description,
    imageUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'traffic_signs';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrafficSign> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sign_id')) {
      context.handle(
        _signIdMeta,
        signId.isAcceptableOrUnknown(data['sign_id']!, _signIdMeta),
      );
    } else if (isInserting) {
      context.missing(_signIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {signId};
  @override
  TrafficSign map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrafficSign(
      signId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sign_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
    );
  }

  @override
  $TrafficSignsTable createAlias(String alias) {
    return $TrafficSignsTable(attachedDatabase, alias);
  }
}

class TrafficSign extends DataClass implements Insertable<TrafficSign> {
  final String signId;
  final String category;
  final String name;
  final String? description;
  final String? imageUrl;
  const TrafficSign({
    required this.signId,
    required this.category,
    required this.name,
    this.description,
    this.imageUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sign_id'] = Variable<String>(signId);
    map['category'] = Variable<String>(category);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    return map;
  }

  TrafficSignsCompanion toCompanion(bool nullToAbsent) {
    return TrafficSignsCompanion(
      signId: Value(signId),
      category: Value(category),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
    );
  }

  factory TrafficSign.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrafficSign(
      signId: serializer.fromJson<String>(json['signId']),
      category: serializer.fromJson<String>(json['category']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'signId': serializer.toJson<String>(signId),
      'category': serializer.toJson<String>(category),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'imageUrl': serializer.toJson<String?>(imageUrl),
    };
  }

  TrafficSign copyWith({
    String? signId,
    String? category,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
  }) => TrafficSign(
    signId: signId ?? this.signId,
    category: category ?? this.category,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
  );
  TrafficSign copyWithCompanion(TrafficSignsCompanion data) {
    return TrafficSign(
      signId: data.signId.present ? data.signId.value : this.signId,
      category: data.category.present ? data.category.value : this.category,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrafficSign(')
          ..write('signId: $signId, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(signId, category, name, description, imageUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrafficSign &&
          other.signId == this.signId &&
          other.category == this.category &&
          other.name == this.name &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl);
}

class TrafficSignsCompanion extends UpdateCompanion<TrafficSign> {
  final Value<String> signId;
  final Value<String> category;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> imageUrl;
  final Value<int> rowid;
  const TrafficSignsCompanion({
    this.signId = const Value.absent(),
    this.category = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrafficSignsCompanion.insert({
    required String signId,
    required String category,
    required String name,
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : signId = Value(signId),
       category = Value(category),
       name = Value(name);
  static Insertable<TrafficSign> custom({
    Expression<String>? signId,
    Expression<String>? category,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (signId != null) 'sign_id': signId,
      if (category != null) 'category': category,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrafficSignsCompanion copyWith({
    Value<String>? signId,
    Value<String>? category,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? imageUrl,
    Value<int>? rowid,
  }) {
    return TrafficSignsCompanion(
      signId: signId ?? this.signId,
      category: category ?? this.category,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (signId.present) {
      map['sign_id'] = Variable<String>(signId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrafficSignsCompanion(')
          ..write('signId: $signId, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingTable extends Setting with TableInfo<$SettingTable, SettingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _SettingIdMeta = const VerificationMeta(
    'SettingId',
  );
  @override
  late final GeneratedColumn<int> SettingId = GeneratedColumn<int>(
    'setting_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rankIdMeta = const VerificationMeta('rankId');
  @override
  late final GeneratedColumn<String> rankId = GeneratedColumn<String>(
    'rank_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant("A1"),
  );
  static const VerificationMeta _modelsMeta = const VerificationMeta('models');
  @override
  late final GeneratedColumn<int> models = GeneratedColumn<int>(
    'models',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<int> mode = GeneratedColumn<int>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _vibrationMeta = const VerificationMeta(
    'vibration',
  );
  @override
  late final GeneratedColumn<int> vibration = GeneratedColumn<int>(
    'vibration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    SettingId,
    rankId,
    models,
    mode,
    vibration,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'setting';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('setting_id')) {
      context.handle(
        _SettingIdMeta,
        SettingId.isAcceptableOrUnknown(data['setting_id']!, _SettingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_SettingIdMeta);
    }
    if (data.containsKey('rank_id')) {
      context.handle(
        _rankIdMeta,
        rankId.isAcceptableOrUnknown(data['rank_id']!, _rankIdMeta),
      );
    }
    if (data.containsKey('models')) {
      context.handle(
        _modelsMeta,
        models.isAcceptableOrUnknown(data['models']!, _modelsMeta),
      );
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('vibration')) {
      context.handle(
        _vibrationMeta,
        vibration.isAcceptableOrUnknown(data['vibration']!, _vibrationMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  SettingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingData(
      SettingId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}setting_id'],
      )!,
      rankId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rank_id'],
      )!,
      models: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}models'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mode'],
      )!,
      vibration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vibration'],
      )!,
    );
  }

  @override
  $SettingTable createAlias(String alias) {
    return $SettingTable(attachedDatabase, alias);
  }
}

class SettingData extends DataClass implements Insertable<SettingData> {
  final int SettingId;
  final String rankId;
  final int models;
  final int mode;
  final int vibration;
  const SettingData({
    required this.SettingId,
    required this.rankId,
    required this.models,
    required this.mode,
    required this.vibration,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['setting_id'] = Variable<int>(SettingId);
    map['rank_id'] = Variable<String>(rankId);
    map['models'] = Variable<int>(models);
    map['mode'] = Variable<int>(mode);
    map['vibration'] = Variable<int>(vibration);
    return map;
  }

  SettingCompanion toCompanion(bool nullToAbsent) {
    return SettingCompanion(
      SettingId: Value(SettingId),
      rankId: Value(rankId),
      models: Value(models),
      mode: Value(mode),
      vibration: Value(vibration),
    );
  }

  factory SettingData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingData(
      SettingId: serializer.fromJson<int>(json['SettingId']),
      rankId: serializer.fromJson<String>(json['rankId']),
      models: serializer.fromJson<int>(json['models']),
      mode: serializer.fromJson<int>(json['mode']),
      vibration: serializer.fromJson<int>(json['vibration']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'SettingId': serializer.toJson<int>(SettingId),
      'rankId': serializer.toJson<String>(rankId),
      'models': serializer.toJson<int>(models),
      'mode': serializer.toJson<int>(mode),
      'vibration': serializer.toJson<int>(vibration),
    };
  }

  SettingData copyWith({
    int? SettingId,
    String? rankId,
    int? models,
    int? mode,
    int? vibration,
  }) => SettingData(
    SettingId: SettingId ?? this.SettingId,
    rankId: rankId ?? this.rankId,
    models: models ?? this.models,
    mode: mode ?? this.mode,
    vibration: vibration ?? this.vibration,
  );
  SettingData copyWithCompanion(SettingCompanion data) {
    return SettingData(
      SettingId: data.SettingId.present ? data.SettingId.value : this.SettingId,
      rankId: data.rankId.present ? data.rankId.value : this.rankId,
      models: data.models.present ? data.models.value : this.models,
      mode: data.mode.present ? data.mode.value : this.mode,
      vibration: data.vibration.present ? data.vibration.value : this.vibration,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingData(')
          ..write('SettingId: $SettingId, ')
          ..write('rankId: $rankId, ')
          ..write('models: $models, ')
          ..write('mode: $mode, ')
          ..write('vibration: $vibration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(SettingId, rankId, models, mode, vibration);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingData &&
          other.SettingId == this.SettingId &&
          other.rankId == this.rankId &&
          other.models == this.models &&
          other.mode == this.mode &&
          other.vibration == this.vibration);
}

class SettingCompanion extends UpdateCompanion<SettingData> {
  final Value<int> SettingId;
  final Value<String> rankId;
  final Value<int> models;
  final Value<int> mode;
  final Value<int> vibration;
  final Value<int> rowid;
  const SettingCompanion({
    this.SettingId = const Value.absent(),
    this.rankId = const Value.absent(),
    this.models = const Value.absent(),
    this.mode = const Value.absent(),
    this.vibration = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingCompanion.insert({
    required int SettingId,
    this.rankId = const Value.absent(),
    this.models = const Value.absent(),
    this.mode = const Value.absent(),
    this.vibration = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : SettingId = Value(SettingId);
  static Insertable<SettingData> custom({
    Expression<int>? SettingId,
    Expression<String>? rankId,
    Expression<int>? models,
    Expression<int>? mode,
    Expression<int>? vibration,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (SettingId != null) 'setting_id': SettingId,
      if (rankId != null) 'rank_id': rankId,
      if (models != null) 'models': models,
      if (mode != null) 'mode': mode,
      if (vibration != null) 'vibration': vibration,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingCompanion copyWith({
    Value<int>? SettingId,
    Value<String>? rankId,
    Value<int>? models,
    Value<int>? mode,
    Value<int>? vibration,
    Value<int>? rowid,
  }) {
    return SettingCompanion(
      SettingId: SettingId ?? this.SettingId,
      rankId: rankId ?? this.rankId,
      models: models ?? this.models,
      mode: mode ?? this.mode,
      vibration: vibration ?? this.vibration,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (SettingId.present) {
      map['setting_id'] = Variable<int>(SettingId.value);
    }
    if (rankId.present) {
      map['rank_id'] = Variable<String>(rankId.value);
    }
    if (models.present) {
      map['models'] = Variable<int>(models.value);
    }
    if (mode.present) {
      map['mode'] = Variable<int>(mode.value);
    }
    if (vibration.present) {
      map['vibration'] = Variable<int>(vibration.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingCompanion(')
          ..write('SettingId: $SettingId, ')
          ..write('rankId: $rankId, ')
          ..write('models: $models, ')
          ..write('mode: $mode, ')
          ..write('vibration: $vibration, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecognitionHistoryTableTable extends RecognitionHistoryTable
    with TableInfo<$RecognitionHistoryTableTable, RecognitionHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecognitionHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
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
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signNameMeta = const VerificationMeta(
    'signName',
  );
  @override
  late final GeneratedColumn<String> signName = GeneratedColumn<String>(
    'sign_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signTypeMeta = const VerificationMeta(
    'signType',
  );
  @override
  late final GeneratedColumn<String> signType = GeneratedColumn<String>(
    'sign_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    imagePath,
    result,
    signName,
    signType,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recognition_history_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecognitionHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('sign_name')) {
      context.handle(
        _signNameMeta,
        signName.isAcceptableOrUnknown(data['sign_name']!, _signNameMeta),
      );
    }
    if (data.containsKey('sign_type')) {
      context.handle(
        _signTypeMeta,
        signType.isAcceptableOrUnknown(data['sign_type']!, _signTypeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecognitionHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecognitionHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      )!,
      signName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sign_name'],
      ),
      signType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sign_type'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RecognitionHistoryTableTable createAlias(String alias) {
    return $RecognitionHistoryTableTable(attachedDatabase, alias);
  }
}

class RecognitionHistoryData extends DataClass
    implements Insertable<RecognitionHistoryData> {
  final int id;
  final String imagePath;
  final String result;
  final String? signName;
  final String? signType;
  final DateTime createdAt;
  const RecognitionHistoryData({
    required this.id,
    required this.imagePath,
    required this.result,
    this.signName,
    this.signType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['image_path'] = Variable<String>(imagePath);
    map['result'] = Variable<String>(result);
    if (!nullToAbsent || signName != null) {
      map['sign_name'] = Variable<String>(signName);
    }
    if (!nullToAbsent || signType != null) {
      map['sign_type'] = Variable<String>(signType);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecognitionHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return RecognitionHistoryTableCompanion(
      id: Value(id),
      imagePath: Value(imagePath),
      result: Value(result),
      signName: signName == null && nullToAbsent
          ? const Value.absent()
          : Value(signName),
      signType: signType == null && nullToAbsent
          ? const Value.absent()
          : Value(signType),
      createdAt: Value(createdAt),
    );
  }

  factory RecognitionHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecognitionHistoryData(
      id: serializer.fromJson<int>(json['id']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      result: serializer.fromJson<String>(json['result']),
      signName: serializer.fromJson<String?>(json['signName']),
      signType: serializer.fromJson<String?>(json['signType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'imagePath': serializer.toJson<String>(imagePath),
      'result': serializer.toJson<String>(result),
      'signName': serializer.toJson<String?>(signName),
      'signType': serializer.toJson<String?>(signType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RecognitionHistoryData copyWith({
    int? id,
    String? imagePath,
    String? result,
    Value<String?> signName = const Value.absent(),
    Value<String?> signType = const Value.absent(),
    DateTime? createdAt,
  }) => RecognitionHistoryData(
    id: id ?? this.id,
    imagePath: imagePath ?? this.imagePath,
    result: result ?? this.result,
    signName: signName.present ? signName.value : this.signName,
    signType: signType.present ? signType.value : this.signType,
    createdAt: createdAt ?? this.createdAt,
  );
  RecognitionHistoryData copyWithCompanion(
    RecognitionHistoryTableCompanion data,
  ) {
    return RecognitionHistoryData(
      id: data.id.present ? data.id.value : this.id,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      result: data.result.present ? data.result.value : this.result,
      signName: data.signName.present ? data.signName.value : this.signName,
      signType: data.signType.present ? data.signType.value : this.signType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecognitionHistoryData(')
          ..write('id: $id, ')
          ..write('imagePath: $imagePath, ')
          ..write('result: $result, ')
          ..write('signName: $signName, ')
          ..write('signType: $signType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, imagePath, result, signName, signType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecognitionHistoryData &&
          other.id == this.id &&
          other.imagePath == this.imagePath &&
          other.result == this.result &&
          other.signName == this.signName &&
          other.signType == this.signType &&
          other.createdAt == this.createdAt);
}

class RecognitionHistoryTableCompanion
    extends UpdateCompanion<RecognitionHistoryData> {
  final Value<int> id;
  final Value<String> imagePath;
  final Value<String> result;
  final Value<String?> signName;
  final Value<String?> signType;
  final Value<DateTime> createdAt;
  const RecognitionHistoryTableCompanion({
    this.id = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.result = const Value.absent(),
    this.signName = const Value.absent(),
    this.signType = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RecognitionHistoryTableCompanion.insert({
    this.id = const Value.absent(),
    required String imagePath,
    required String result,
    this.signName = const Value.absent(),
    this.signType = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : imagePath = Value(imagePath),
       result = Value(result);
  static Insertable<RecognitionHistoryData> custom({
    Expression<int>? id,
    Expression<String>? imagePath,
    Expression<String>? result,
    Expression<String>? signName,
    Expression<String>? signType,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (imagePath != null) 'image_path': imagePath,
      if (result != null) 'result': result,
      if (signName != null) 'sign_name': signName,
      if (signType != null) 'sign_type': signType,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RecognitionHistoryTableCompanion copyWith({
    Value<int>? id,
    Value<String>? imagePath,
    Value<String>? result,
    Value<String?>? signName,
    Value<String?>? signType,
    Value<DateTime>? createdAt,
  }) {
    return RecognitionHistoryTableCompanion(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      result: result ?? this.result,
      signName: signName ?? this.signName,
      signType: signType ?? this.signType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (signName.present) {
      map['sign_name'] = Variable<String>(signName.value);
    }
    if (signType.present) {
      map['sign_type'] = Variable<String>(signType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecognitionHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('imagePath: $imagePath, ')
          ..write('result: $result, ')
          ..write('signName: $signName, ')
          ..write('signType: $signType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TopicsTable topics = $TopicsTable(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $ExamGroupsTable examGroups = $ExamGroupsTable(this);
  late final $RanksTable ranks = $RanksTable(this);
  late final $ExamSetsTable examSets = $ExamSetsTable(this);
  late final $ExamSetQuestionsTable examSetQuestions = $ExamSetQuestionsTable(
    this,
  );
  late final $PracticeSessionsTable practiceSessions = $PracticeSessionsTable(
    this,
  );
  late final $UserAnswersTable userAnswers = $UserAnswersTable(this);
  late final $WrongQuestionsTable wrongQuestions = $WrongQuestionsTable(this);
  late final $ExamHistoryTable examHistory = $ExamHistoryTable(this);
  late final $TrafficSignsTable trafficSigns = $TrafficSignsTable(this);
  late final $SettingTable setting = $SettingTable(this);
  late final $RecognitionHistoryTableTable recognitionHistoryTable =
      $RecognitionHistoryTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    topics,
    questions,
    examGroups,
    ranks,
    examSets,
    examSetQuestions,
    practiceSessions,
    userAnswers,
    wrongQuestions,
    examHistory,
    trafficSigns,
    setting,
    recognitionHistoryTable,
  ];
}

typedef $$TopicsTableCreateCompanionBuilder =
    TopicsCompanion Function({
      required int id,
      required String name,
      required String fullname,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$TopicsTableUpdateCompanionBuilder =
    TopicsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> fullname,
      Value<String?> description,
      Value<int> rowid,
    });

final class $$TopicsTableReferences
    extends BaseReferences<_$AppDatabase, $TopicsTable, Topic> {
  $$TopicsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$QuestionsTable, List<Question>>
  _questionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.questions,
    aliasName: $_aliasNameGenerator(db.topics.id, db.questions.topicId),
  );

  $$QuestionsTableProcessedTableManager get questionsRefs {
    final manager = $$QuestionsTableTableManager(
      $_db,
      $_db.questions,
    ).filter((f) => f.topicId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_questionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PracticeSessionsTable, List<PracticeSession>>
  _practiceSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.practiceSessions,
    aliasName: $_aliasNameGenerator(db.topics.id, db.practiceSessions.topicId),
  );

  $$PracticeSessionsTableProcessedTableManager get practiceSessionsRefs {
    final manager = $$PracticeSessionsTableTableManager(
      $_db,
      $_db.practiceSessions,
    ).filter((f) => f.topicId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _practiceSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TopicsTableFilterComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullname => $composableBuilder(
    column: $table.fullname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> questionsRefs(
    Expression<bool> Function($$QuestionsTableFilterComposer f) f,
  ) {
    final $$QuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableFilterComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> practiceSessionsRefs(
    Expression<bool> Function($$PracticeSessionsTableFilterComposer f) f,
  ) {
    final $$PracticeSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.practiceSessions,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PracticeSessionsTableFilterComposer(
            $db: $db,
            $table: $db.practiceSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TopicsTableOrderingComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullname => $composableBuilder(
    column: $table.fullname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TopicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get fullname =>
      $composableBuilder(column: $table.fullname, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> questionsRefs<T extends Object>(
    Expression<T> Function($$QuestionsTableAnnotationComposer a) f,
  ) {
    final $$QuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> practiceSessionsRefs<T extends Object>(
    Expression<T> Function($$PracticeSessionsTableAnnotationComposer a) f,
  ) {
    final $$PracticeSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.practiceSessions,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PracticeSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.practiceSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TopicsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TopicsTable,
          Topic,
          $$TopicsTableFilterComposer,
          $$TopicsTableOrderingComposer,
          $$TopicsTableAnnotationComposer,
          $$TopicsTableCreateCompanionBuilder,
          $$TopicsTableUpdateCompanionBuilder,
          (Topic, $$TopicsTableReferences),
          Topic,
          PrefetchHooks Function({
            bool questionsRefs,
            bool practiceSessionsRefs,
          })
        > {
  $$TopicsTableTableManager(_$AppDatabase db, $TopicsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TopicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TopicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TopicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> fullname = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TopicsCompanion(
                id: id,
                name: name,
                fullname: fullname,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int id,
                required String name,
                required String fullname,
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TopicsCompanion.insert(
                id: id,
                name: name,
                fullname: fullname,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TopicsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({questionsRefs = false, practiceSessionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (questionsRefs) db.questions,
                    if (practiceSessionsRefs) db.practiceSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (questionsRefs)
                        await $_getPrefetchedData<
                          Topic,
                          $TopicsTable,
                          Question
                        >(
                          currentTable: table,
                          referencedTable: $$TopicsTableReferences
                              ._questionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TopicsTableReferences(
                                db,
                                table,
                                p0,
                              ).questionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.topicId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (practiceSessionsRefs)
                        await $_getPrefetchedData<
                          Topic,
                          $TopicsTable,
                          PracticeSession
                        >(
                          currentTable: table,
                          referencedTable: $$TopicsTableReferences
                              ._practiceSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TopicsTableReferences(
                                db,
                                table,
                                p0,
                              ).practiceSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.topicId == item.id,
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

typedef $$TopicsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TopicsTable,
      Topic,
      $$TopicsTableFilterComposer,
      $$TopicsTableOrderingComposer,
      $$TopicsTableAnnotationComposer,
      $$TopicsTableCreateCompanionBuilder,
      $$TopicsTableUpdateCompanionBuilder,
      (Topic, $$TopicsTableReferences),
      Topic,
      PrefetchHooks Function({bool questionsRefs, bool practiceSessionsRefs})
    >;
typedef $$QuestionsTableCreateCompanionBuilder =
    QuestionsCompanion Function({
      required int id,
      Value<int?> topicId,
      required String question,
      Value<String?> imageUrl,
      Value<String?> answerA,
      Value<String?> answerB,
      Value<String?> answerC,
      Value<String?> answerD,
      Value<int> ofRankA,
      Value<int> ofRankB1,
      required String correctAnswer,
      Value<String?> explanation,
      Value<int> isCritical,
      Value<int> rowid,
    });
typedef $$QuestionsTableUpdateCompanionBuilder =
    QuestionsCompanion Function({
      Value<int> id,
      Value<int?> topicId,
      Value<String> question,
      Value<String?> imageUrl,
      Value<String?> answerA,
      Value<String?> answerB,
      Value<String?> answerC,
      Value<String?> answerD,
      Value<int> ofRankA,
      Value<int> ofRankB1,
      Value<String> correctAnswer,
      Value<String?> explanation,
      Value<int> isCritical,
      Value<int> rowid,
    });

final class $$QuestionsTableReferences
    extends BaseReferences<_$AppDatabase, $QuestionsTable, Question> {
  $$QuestionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TopicsTable _topicIdTable(_$AppDatabase db) => db.topics.createAlias(
    $_aliasNameGenerator(db.questions.topicId, db.topics.id),
  );

  $$TopicsTableProcessedTableManager? get topicId {
    final $_column = $_itemColumn<int>('topic_id');
    if ($_column == null) return null;
    final manager = $$TopicsTableTableManager(
      $_db,
      $_db.topics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_topicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExamSetQuestionsTable, List<ExamSetQuestion>>
  _examSetQuestionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.examSetQuestions,
    aliasName: $_aliasNameGenerator(
      db.questions.id,
      db.examSetQuestions.questionId,
    ),
  );

  $$ExamSetQuestionsTableProcessedTableManager get examSetQuestionsRefs {
    final manager = $$ExamSetQuestionsTableTableManager(
      $_db,
      $_db.examSetQuestions,
    ).filter((f) => f.questionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _examSetQuestionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UserAnswersTable, List<UserAnswer>>
  _userAnswersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userAnswers,
    aliasName: $_aliasNameGenerator(db.questions.id, db.userAnswers.questionId),
  );

  $$UserAnswersTableProcessedTableManager get userAnswersRefs {
    final manager = $$UserAnswersTableTableManager(
      $_db,
      $_db.userAnswers,
    ).filter((f) => f.questionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userAnswersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WrongQuestionsTable, List<WrongQuestion>>
  _wrongQuestionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.wrongQuestions,
    aliasName: $_aliasNameGenerator(
      db.questions.id,
      db.wrongQuestions.questionId,
    ),
  );

  $$WrongQuestionsTableProcessedTableManager get wrongQuestionsRefs {
    final manager = $$WrongQuestionsTableTableManager(
      $_db,
      $_db.wrongQuestions,
    ).filter((f) => f.questionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_wrongQuestionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerA => $composableBuilder(
    column: $table.answerA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerB => $composableBuilder(
    column: $table.answerB,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerC => $composableBuilder(
    column: $table.answerC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerD => $composableBuilder(
    column: $table.answerD,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ofRankA => $composableBuilder(
    column: $table.ofRankA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ofRankB1 => $composableBuilder(
    column: $table.ofRankB1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isCritical => $composableBuilder(
    column: $table.isCritical,
    builder: (column) => ColumnFilters(column),
  );

  $$TopicsTableFilterComposer get topicId {
    final $$TopicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableFilterComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> examSetQuestionsRefs(
    Expression<bool> Function($$ExamSetQuestionsTableFilterComposer f) f,
  ) {
    final $$ExamSetQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examSetQuestions,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamSetQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.examSetQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userAnswersRefs(
    Expression<bool> Function($$UserAnswersTableFilterComposer f) f,
  ) {
    final $$UserAnswersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userAnswers,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserAnswersTableFilterComposer(
            $db: $db,
            $table: $db.userAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> wrongQuestionsRefs(
    Expression<bool> Function($$WrongQuestionsTableFilterComposer f) f,
  ) {
    final $$WrongQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wrongQuestions,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WrongQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.wrongQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerA => $composableBuilder(
    column: $table.answerA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerB => $composableBuilder(
    column: $table.answerB,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerC => $composableBuilder(
    column: $table.answerC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerD => $composableBuilder(
    column: $table.answerD,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ofRankA => $composableBuilder(
    column: $table.ofRankA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ofRankB1 => $composableBuilder(
    column: $table.ofRankB1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isCritical => $composableBuilder(
    column: $table.isCritical,
    builder: (column) => ColumnOrderings(column),
  );

  $$TopicsTableOrderingComposer get topicId {
    final $$TopicsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableOrderingComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get answerA =>
      $composableBuilder(column: $table.answerA, builder: (column) => column);

  GeneratedColumn<String> get answerB =>
      $composableBuilder(column: $table.answerB, builder: (column) => column);

  GeneratedColumn<String> get answerC =>
      $composableBuilder(column: $table.answerC, builder: (column) => column);

  GeneratedColumn<String> get answerD =>
      $composableBuilder(column: $table.answerD, builder: (column) => column);

  GeneratedColumn<int> get ofRankA =>
      $composableBuilder(column: $table.ofRankA, builder: (column) => column);

  GeneratedColumn<int> get ofRankB1 =>
      $composableBuilder(column: $table.ofRankB1, builder: (column) => column);

  GeneratedColumn<String> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isCritical => $composableBuilder(
    column: $table.isCritical,
    builder: (column) => column,
  );

  $$TopicsTableAnnotationComposer get topicId {
    final $$TopicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableAnnotationComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> examSetQuestionsRefs<T extends Object>(
    Expression<T> Function($$ExamSetQuestionsTableAnnotationComposer a) f,
  ) {
    final $$ExamSetQuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examSetQuestions,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamSetQuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.examSetQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> userAnswersRefs<T extends Object>(
    Expression<T> Function($$UserAnswersTableAnnotationComposer a) f,
  ) {
    final $$UserAnswersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userAnswers,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserAnswersTableAnnotationComposer(
            $db: $db,
            $table: $db.userAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> wrongQuestionsRefs<T extends Object>(
    Expression<T> Function($$WrongQuestionsTableAnnotationComposer a) f,
  ) {
    final $$WrongQuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wrongQuestions,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WrongQuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.wrongQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionsTable,
          Question,
          $$QuestionsTableFilterComposer,
          $$QuestionsTableOrderingComposer,
          $$QuestionsTableAnnotationComposer,
          $$QuestionsTableCreateCompanionBuilder,
          $$QuestionsTableUpdateCompanionBuilder,
          (Question, $$QuestionsTableReferences),
          Question,
          PrefetchHooks Function({
            bool topicId,
            bool examSetQuestionsRefs,
            bool userAnswersRefs,
            bool wrongQuestionsRefs,
          })
        > {
  $$QuestionsTableTableManager(_$AppDatabase db, $QuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> topicId = const Value.absent(),
                Value<String> question = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> answerA = const Value.absent(),
                Value<String?> answerB = const Value.absent(),
                Value<String?> answerC = const Value.absent(),
                Value<String?> answerD = const Value.absent(),
                Value<int> ofRankA = const Value.absent(),
                Value<int> ofRankB1 = const Value.absent(),
                Value<String> correctAnswer = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
                Value<int> isCritical = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionsCompanion(
                id: id,
                topicId: topicId,
                question: question,
                imageUrl: imageUrl,
                answerA: answerA,
                answerB: answerB,
                answerC: answerC,
                answerD: answerD,
                ofRankA: ofRankA,
                ofRankB1: ofRankB1,
                correctAnswer: correctAnswer,
                explanation: explanation,
                isCritical: isCritical,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int id,
                Value<int?> topicId = const Value.absent(),
                required String question,
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> answerA = const Value.absent(),
                Value<String?> answerB = const Value.absent(),
                Value<String?> answerC = const Value.absent(),
                Value<String?> answerD = const Value.absent(),
                Value<int> ofRankA = const Value.absent(),
                Value<int> ofRankB1 = const Value.absent(),
                required String correctAnswer,
                Value<String?> explanation = const Value.absent(),
                Value<int> isCritical = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionsCompanion.insert(
                id: id,
                topicId: topicId,
                question: question,
                imageUrl: imageUrl,
                answerA: answerA,
                answerB: answerB,
                answerC: answerC,
                answerD: answerD,
                ofRankA: ofRankA,
                ofRankB1: ofRankB1,
                correctAnswer: correctAnswer,
                explanation: explanation,
                isCritical: isCritical,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                topicId = false,
                examSetQuestionsRefs = false,
                userAnswersRefs = false,
                wrongQuestionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (examSetQuestionsRefs) db.examSetQuestions,
                    if (userAnswersRefs) db.userAnswers,
                    if (wrongQuestionsRefs) db.wrongQuestions,
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
                        if (topicId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.topicId,
                                    referencedTable: $$QuestionsTableReferences
                                        ._topicIdTable(db),
                                    referencedColumn: $$QuestionsTableReferences
                                        ._topicIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (examSetQuestionsRefs)
                        await $_getPrefetchedData<
                          Question,
                          $QuestionsTable,
                          ExamSetQuestion
                        >(
                          currentTable: table,
                          referencedTable: $$QuestionsTableReferences
                              ._examSetQuestionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuestionsTableReferences(
                                db,
                                table,
                                p0,
                              ).examSetQuestionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.questionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userAnswersRefs)
                        await $_getPrefetchedData<
                          Question,
                          $QuestionsTable,
                          UserAnswer
                        >(
                          currentTable: table,
                          referencedTable: $$QuestionsTableReferences
                              ._userAnswersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuestionsTableReferences(
                                db,
                                table,
                                p0,
                              ).userAnswersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.questionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (wrongQuestionsRefs)
                        await $_getPrefetchedData<
                          Question,
                          $QuestionsTable,
                          WrongQuestion
                        >(
                          currentTable: table,
                          referencedTable: $$QuestionsTableReferences
                              ._wrongQuestionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuestionsTableReferences(
                                db,
                                table,
                                p0,
                              ).wrongQuestionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.questionId == item.id,
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

typedef $$QuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionsTable,
      Question,
      $$QuestionsTableFilterComposer,
      $$QuestionsTableOrderingComposer,
      $$QuestionsTableAnnotationComposer,
      $$QuestionsTableCreateCompanionBuilder,
      $$QuestionsTableUpdateCompanionBuilder,
      (Question, $$QuestionsTableReferences),
      Question,
      PrefetchHooks Function({
        bool topicId,
        bool examSetQuestionsRefs,
        bool userAnswersRefs,
        bool wrongQuestionsRefs,
      })
    >;
typedef $$ExamGroupsTableCreateCompanionBuilder =
    ExamGroupsCompanion Function({
      Value<int> examGroupsId,
      Value<String?> name,
      Value<int?> totalQuestions,
    });
typedef $$ExamGroupsTableUpdateCompanionBuilder =
    ExamGroupsCompanion Function({
      Value<int> examGroupsId,
      Value<String?> name,
      Value<int?> totalQuestions,
    });

final class $$ExamGroupsTableReferences
    extends BaseReferences<_$AppDatabase, $ExamGroupsTable, ExamGroup> {
  $$ExamGroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RanksTable, List<Rank>> _ranksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ranks,
    aliasName: $_aliasNameGenerator(
      db.examGroups.examGroupsId,
      db.ranks.examGroupsId,
    ),
  );

  $$RanksTableProcessedTableManager get ranksRefs {
    final manager = $$RanksTableTableManager($_db, $_db.ranks).filter(
      (f) => f.examGroupsId.examGroupsId.sqlEquals(
        $_itemColumn<int>('exam_groups_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_ranksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExamSetsTable, List<ExamSet>> _examSetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.examSets,
    aliasName: $_aliasNameGenerator(
      db.examGroups.examGroupsId,
      db.examSets.examGroupsId,
    ),
  );

  $$ExamSetsTableProcessedTableManager get examSetsRefs {
    final manager = $$ExamSetsTableTableManager($_db, $_db.examSets).filter(
      (f) => f.examGroupsId.examGroupsId.sqlEquals(
        $_itemColumn<int>('exam_groups_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_examSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExamGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $ExamGroupsTable> {
  $$ExamGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get examGroupsId => $composableBuilder(
    column: $table.examGroupsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ranksRefs(
    Expression<bool> Function($$RanksTableFilterComposer f) f,
  ) {
    final $$RanksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examGroupsId,
      referencedTable: $db.ranks,
      getReferencedColumn: (t) => t.examGroupsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RanksTableFilterComposer(
            $db: $db,
            $table: $db.ranks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> examSetsRefs(
    Expression<bool> Function($$ExamSetsTableFilterComposer f) f,
  ) {
    final $$ExamSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examGroupsId,
      referencedTable: $db.examSets,
      getReferencedColumn: (t) => t.examGroupsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamSetsTableFilterComposer(
            $db: $db,
            $table: $db.examSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExamGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamGroupsTable> {
  $$ExamGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get examGroupsId => $composableBuilder(
    column: $table.examGroupsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExamGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamGroupsTable> {
  $$ExamGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get examGroupsId => $composableBuilder(
    column: $table.examGroupsId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  Expression<T> ranksRefs<T extends Object>(
    Expression<T> Function($$RanksTableAnnotationComposer a) f,
  ) {
    final $$RanksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examGroupsId,
      referencedTable: $db.ranks,
      getReferencedColumn: (t) => t.examGroupsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RanksTableAnnotationComposer(
            $db: $db,
            $table: $db.ranks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> examSetsRefs<T extends Object>(
    Expression<T> Function($$ExamSetsTableAnnotationComposer a) f,
  ) {
    final $$ExamSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examGroupsId,
      referencedTable: $db.examSets,
      getReferencedColumn: (t) => t.examGroupsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.examSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExamGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamGroupsTable,
          ExamGroup,
          $$ExamGroupsTableFilterComposer,
          $$ExamGroupsTableOrderingComposer,
          $$ExamGroupsTableAnnotationComposer,
          $$ExamGroupsTableCreateCompanionBuilder,
          $$ExamGroupsTableUpdateCompanionBuilder,
          (ExamGroup, $$ExamGroupsTableReferences),
          ExamGroup,
          PrefetchHooks Function({bool ranksRefs, bool examSetsRefs})
        > {
  $$ExamGroupsTableTableManager(_$AppDatabase db, $ExamGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> examGroupsId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int?> totalQuestions = const Value.absent(),
              }) => ExamGroupsCompanion(
                examGroupsId: examGroupsId,
                name: name,
                totalQuestions: totalQuestions,
              ),
          createCompanionCallback:
              ({
                Value<int> examGroupsId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int?> totalQuestions = const Value.absent(),
              }) => ExamGroupsCompanion.insert(
                examGroupsId: examGroupsId,
                name: name,
                totalQuestions: totalQuestions,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExamGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ranksRefs = false, examSetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ranksRefs) db.ranks,
                if (examSetsRefs) db.examSets,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ranksRefs)
                    await $_getPrefetchedData<
                      ExamGroup,
                      $ExamGroupsTable,
                      Rank
                    >(
                      currentTable: table,
                      referencedTable: $$ExamGroupsTableReferences
                          ._ranksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ExamGroupsTableReferences(db, table, p0).ranksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.examGroupsId == item.examGroupsId,
                          ),
                      typedResults: items,
                    ),
                  if (examSetsRefs)
                    await $_getPrefetchedData<
                      ExamGroup,
                      $ExamGroupsTable,
                      ExamSet
                    >(
                      currentTable: table,
                      referencedTable: $$ExamGroupsTableReferences
                          ._examSetsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ExamGroupsTableReferences(
                            db,
                            table,
                            p0,
                          ).examSetsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.examGroupsId == item.examGroupsId,
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

typedef $$ExamGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamGroupsTable,
      ExamGroup,
      $$ExamGroupsTableFilterComposer,
      $$ExamGroupsTableOrderingComposer,
      $$ExamGroupsTableAnnotationComposer,
      $$ExamGroupsTableCreateCompanionBuilder,
      $$ExamGroupsTableUpdateCompanionBuilder,
      (ExamGroup, $$ExamGroupsTableReferences),
      ExamGroup,
      PrefetchHooks Function({bool ranksRefs, bool examSetsRefs})
    >;
typedef $$RanksTableCreateCompanionBuilder =
    RanksCompanion Function({
      required String rankId,
      required String name,
      Value<String?> description,
      Value<int?> totalQuestions,
      Value<int?> totalExam,
      Value<int?> totalPass,
      Value<int?> time,
      Value<int?> examGroupsId,
      Value<int> rowid,
    });
typedef $$RanksTableUpdateCompanionBuilder =
    RanksCompanion Function({
      Value<String> rankId,
      Value<String> name,
      Value<String?> description,
      Value<int?> totalQuestions,
      Value<int?> totalExam,
      Value<int?> totalPass,
      Value<int?> time,
      Value<int?> examGroupsId,
      Value<int> rowid,
    });

final class $$RanksTableReferences
    extends BaseReferences<_$AppDatabase, $RanksTable, Rank> {
  $$RanksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExamGroupsTable _examGroupsIdTable(_$AppDatabase db) =>
      db.examGroups.createAlias(
        $_aliasNameGenerator(db.ranks.examGroupsId, db.examGroups.examGroupsId),
      );

  $$ExamGroupsTableProcessedTableManager? get examGroupsId {
    final $_column = $_itemColumn<int>('exam_groups_id');
    if ($_column == null) return null;
    final manager = $$ExamGroupsTableTableManager(
      $_db,
      $_db.examGroups,
    ).filter((f) => f.examGroupsId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examGroupsIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RanksTableFilterComposer extends Composer<_$AppDatabase, $RanksTable> {
  $$RanksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get rankId => $composableBuilder(
    column: $table.rankId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalExam => $composableBuilder(
    column: $table.totalExam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPass => $composableBuilder(
    column: $table.totalPass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  $$ExamGroupsTableFilterComposer get examGroupsId {
    final $$ExamGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examGroupsId,
      referencedTable: $db.examGroups,
      getReferencedColumn: (t) => t.examGroupsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamGroupsTableFilterComposer(
            $db: $db,
            $table: $db.examGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RanksTableOrderingComposer
    extends Composer<_$AppDatabase, $RanksTable> {
  $$RanksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get rankId => $composableBuilder(
    column: $table.rankId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalExam => $composableBuilder(
    column: $table.totalExam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPass => $composableBuilder(
    column: $table.totalPass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExamGroupsTableOrderingComposer get examGroupsId {
    final $$ExamGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examGroupsId,
      referencedTable: $db.examGroups,
      getReferencedColumn: (t) => t.examGroupsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.examGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RanksTableAnnotationComposer
    extends Composer<_$AppDatabase, $RanksTable> {
  $$RanksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get rankId =>
      $composableBuilder(column: $table.rankId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalExam =>
      $composableBuilder(column: $table.totalExam, builder: (column) => column);

  GeneratedColumn<int> get totalPass =>
      $composableBuilder(column: $table.totalPass, builder: (column) => column);

  GeneratedColumn<int> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  $$ExamGroupsTableAnnotationComposer get examGroupsId {
    final $$ExamGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examGroupsId,
      referencedTable: $db.examGroups,
      getReferencedColumn: (t) => t.examGroupsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.examGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RanksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RanksTable,
          Rank,
          $$RanksTableFilterComposer,
          $$RanksTableOrderingComposer,
          $$RanksTableAnnotationComposer,
          $$RanksTableCreateCompanionBuilder,
          $$RanksTableUpdateCompanionBuilder,
          (Rank, $$RanksTableReferences),
          Rank,
          PrefetchHooks Function({bool examGroupsId})
        > {
  $$RanksTableTableManager(_$AppDatabase db, $RanksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RanksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RanksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RanksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> rankId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int?> totalQuestions = const Value.absent(),
                Value<int?> totalExam = const Value.absent(),
                Value<int?> totalPass = const Value.absent(),
                Value<int?> time = const Value.absent(),
                Value<int?> examGroupsId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RanksCompanion(
                rankId: rankId,
                name: name,
                description: description,
                totalQuestions: totalQuestions,
                totalExam: totalExam,
                totalPass: totalPass,
                time: time,
                examGroupsId: examGroupsId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String rankId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int?> totalQuestions = const Value.absent(),
                Value<int?> totalExam = const Value.absent(),
                Value<int?> totalPass = const Value.absent(),
                Value<int?> time = const Value.absent(),
                Value<int?> examGroupsId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RanksCompanion.insert(
                rankId: rankId,
                name: name,
                description: description,
                totalQuestions: totalQuestions,
                totalExam: totalExam,
                totalPass: totalPass,
                time: time,
                examGroupsId: examGroupsId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$RanksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({examGroupsId = false}) {
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
                    if (examGroupsId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.examGroupsId,
                                referencedTable: $$RanksTableReferences
                                    ._examGroupsIdTable(db),
                                referencedColumn: $$RanksTableReferences
                                    ._examGroupsIdTable(db)
                                    .examGroupsId,
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

typedef $$RanksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RanksTable,
      Rank,
      $$RanksTableFilterComposer,
      $$RanksTableOrderingComposer,
      $$RanksTableAnnotationComposer,
      $$RanksTableCreateCompanionBuilder,
      $$RanksTableUpdateCompanionBuilder,
      (Rank, $$RanksTableReferences),
      Rank,
      PrefetchHooks Function({bool examGroupsId})
    >;
typedef $$ExamSetsTableCreateCompanionBuilder =
    ExamSetsCompanion Function({
      Value<int> id,
      required int examGroupsId,
      Value<String?> name,
      Value<DateTime> createdAt,
    });
typedef $$ExamSetsTableUpdateCompanionBuilder =
    ExamSetsCompanion Function({
      Value<int> id,
      Value<int> examGroupsId,
      Value<String?> name,
      Value<DateTime> createdAt,
    });

final class $$ExamSetsTableReferences
    extends BaseReferences<_$AppDatabase, $ExamSetsTable, ExamSet> {
  $$ExamSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExamGroupsTable _examGroupsIdTable(_$AppDatabase db) =>
      db.examGroups.createAlias(
        $_aliasNameGenerator(
          db.examSets.examGroupsId,
          db.examGroups.examGroupsId,
        ),
      );

  $$ExamGroupsTableProcessedTableManager get examGroupsId {
    final $_column = $_itemColumn<int>('exam_groups_id')!;

    final manager = $$ExamGroupsTableTableManager(
      $_db,
      $_db.examGroups,
    ).filter((f) => f.examGroupsId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examGroupsIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExamSetQuestionsTable, List<ExamSetQuestion>>
  _examSetQuestionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.examSetQuestions,
    aliasName: $_aliasNameGenerator(
      db.examSets.id,
      db.examSetQuestions.examSetId,
    ),
  );

  $$ExamSetQuestionsTableProcessedTableManager get examSetQuestionsRefs {
    final manager = $$ExamSetQuestionsTableTableManager(
      $_db,
      $_db.examSetQuestions,
    ).filter((f) => f.examSetId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _examSetQuestionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExamSetsTableFilterComposer
    extends Composer<_$AppDatabase, $ExamSetsTable> {
  $$ExamSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ExamGroupsTableFilterComposer get examGroupsId {
    final $$ExamGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examGroupsId,
      referencedTable: $db.examGroups,
      getReferencedColumn: (t) => t.examGroupsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamGroupsTableFilterComposer(
            $db: $db,
            $table: $db.examGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> examSetQuestionsRefs(
    Expression<bool> Function($$ExamSetQuestionsTableFilterComposer f) f,
  ) {
    final $$ExamSetQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examSetQuestions,
      getReferencedColumn: (t) => t.examSetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamSetQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.examSetQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExamSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamSetsTable> {
  $$ExamSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExamGroupsTableOrderingComposer get examGroupsId {
    final $$ExamGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examGroupsId,
      referencedTable: $db.examGroups,
      getReferencedColumn: (t) => t.examGroupsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.examGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamSetsTable> {
  $$ExamSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ExamGroupsTableAnnotationComposer get examGroupsId {
    final $$ExamGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examGroupsId,
      referencedTable: $db.examGroups,
      getReferencedColumn: (t) => t.examGroupsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.examGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> examSetQuestionsRefs<T extends Object>(
    Expression<T> Function($$ExamSetQuestionsTableAnnotationComposer a) f,
  ) {
    final $$ExamSetQuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examSetQuestions,
      getReferencedColumn: (t) => t.examSetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamSetQuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.examSetQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExamSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamSetsTable,
          ExamSet,
          $$ExamSetsTableFilterComposer,
          $$ExamSetsTableOrderingComposer,
          $$ExamSetsTableAnnotationComposer,
          $$ExamSetsTableCreateCompanionBuilder,
          $$ExamSetsTableUpdateCompanionBuilder,
          (ExamSet, $$ExamSetsTableReferences),
          ExamSet,
          PrefetchHooks Function({bool examGroupsId, bool examSetQuestionsRefs})
        > {
  $$ExamSetsTableTableManager(_$AppDatabase db, $ExamSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> examGroupsId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExamSetsCompanion(
                id: id,
                examGroupsId: examGroupsId,
                name: name,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int examGroupsId,
                Value<String?> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExamSetsCompanion.insert(
                id: id,
                examGroupsId: examGroupsId,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExamSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({examGroupsId = false, examSetQuestionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (examSetQuestionsRefs) db.examSetQuestions,
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
                        if (examGroupsId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.examGroupsId,
                                    referencedTable: $$ExamSetsTableReferences
                                        ._examGroupsIdTable(db),
                                    referencedColumn: $$ExamSetsTableReferences
                                        ._examGroupsIdTable(db)
                                        .examGroupsId,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (examSetQuestionsRefs)
                        await $_getPrefetchedData<
                          ExamSet,
                          $ExamSetsTable,
                          ExamSetQuestion
                        >(
                          currentTable: table,
                          referencedTable: $$ExamSetsTableReferences
                              ._examSetQuestionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExamSetsTableReferences(
                                db,
                                table,
                                p0,
                              ).examSetQuestionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examSetId == item.id,
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

typedef $$ExamSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamSetsTable,
      ExamSet,
      $$ExamSetsTableFilterComposer,
      $$ExamSetsTableOrderingComposer,
      $$ExamSetsTableAnnotationComposer,
      $$ExamSetsTableCreateCompanionBuilder,
      $$ExamSetsTableUpdateCompanionBuilder,
      (ExamSet, $$ExamSetsTableReferences),
      ExamSet,
      PrefetchHooks Function({bool examGroupsId, bool examSetQuestionsRefs})
    >;
typedef $$ExamSetQuestionsTableCreateCompanionBuilder =
    ExamSetQuestionsCompanion Function({
      Value<int?> examSetId,
      Value<int?> questionId,
      Value<int?> questionOrder,
      Value<int> rowid,
    });
typedef $$ExamSetQuestionsTableUpdateCompanionBuilder =
    ExamSetQuestionsCompanion Function({
      Value<int?> examSetId,
      Value<int?> questionId,
      Value<int?> questionOrder,
      Value<int> rowid,
    });

final class $$ExamSetQuestionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ExamSetQuestionsTable, ExamSetQuestion> {
  $$ExamSetQuestionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExamSetsTable _examSetIdTable(_$AppDatabase db) =>
      db.examSets.createAlias(
        $_aliasNameGenerator(db.examSetQuestions.examSetId, db.examSets.id),
      );

  $$ExamSetsTableProcessedTableManager? get examSetId {
    final $_column = $_itemColumn<int>('exam_set_id');
    if ($_column == null) return null;
    final manager = $$ExamSetsTableTableManager(
      $_db,
      $_db.examSets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examSetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $QuestionsTable _questionIdTable(_$AppDatabase db) =>
      db.questions.createAlias(
        $_aliasNameGenerator(db.examSetQuestions.questionId, db.questions.id),
      );

  $$QuestionsTableProcessedTableManager? get questionId {
    final $_column = $_itemColumn<int>('question_id');
    if ($_column == null) return null;
    final manager = $$QuestionsTableTableManager(
      $_db,
      $_db.questions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExamSetQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $ExamSetQuestionsTable> {
  $$ExamSetQuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get questionOrder => $composableBuilder(
    column: $table.questionOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$ExamSetsTableFilterComposer get examSetId {
    final $$ExamSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examSetId,
      referencedTable: $db.examSets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamSetsTableFilterComposer(
            $db: $db,
            $table: $db.examSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionsTableFilterComposer get questionId {
    final $$QuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableFilterComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamSetQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamSetQuestionsTable> {
  $$ExamSetQuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get questionOrder => $composableBuilder(
    column: $table.questionOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExamSetsTableOrderingComposer get examSetId {
    final $$ExamSetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examSetId,
      referencedTable: $db.examSets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamSetsTableOrderingComposer(
            $db: $db,
            $table: $db.examSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionsTableOrderingComposer get questionId {
    final $$QuestionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableOrderingComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamSetQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamSetQuestionsTable> {
  $$ExamSetQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get questionOrder => $composableBuilder(
    column: $table.questionOrder,
    builder: (column) => column,
  );

  $$ExamSetsTableAnnotationComposer get examSetId {
    final $$ExamSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examSetId,
      referencedTable: $db.examSets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.examSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionsTableAnnotationComposer get questionId {
    final $$QuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamSetQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamSetQuestionsTable,
          ExamSetQuestion,
          $$ExamSetQuestionsTableFilterComposer,
          $$ExamSetQuestionsTableOrderingComposer,
          $$ExamSetQuestionsTableAnnotationComposer,
          $$ExamSetQuestionsTableCreateCompanionBuilder,
          $$ExamSetQuestionsTableUpdateCompanionBuilder,
          (ExamSetQuestion, $$ExamSetQuestionsTableReferences),
          ExamSetQuestion,
          PrefetchHooks Function({bool examSetId, bool questionId})
        > {
  $$ExamSetQuestionsTableTableManager(
    _$AppDatabase db,
    $ExamSetQuestionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamSetQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamSetQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamSetQuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int?> examSetId = const Value.absent(),
                Value<int?> questionId = const Value.absent(),
                Value<int?> questionOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExamSetQuestionsCompanion(
                examSetId: examSetId,
                questionId: questionId,
                questionOrder: questionOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int?> examSetId = const Value.absent(),
                Value<int?> questionId = const Value.absent(),
                Value<int?> questionOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExamSetQuestionsCompanion.insert(
                examSetId: examSetId,
                questionId: questionId,
                questionOrder: questionOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExamSetQuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examSetId = false, questionId = false}) {
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
                    if (examSetId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.examSetId,
                                referencedTable:
                                    $$ExamSetQuestionsTableReferences
                                        ._examSetIdTable(db),
                                referencedColumn:
                                    $$ExamSetQuestionsTableReferences
                                        ._examSetIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (questionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.questionId,
                                referencedTable:
                                    $$ExamSetQuestionsTableReferences
                                        ._questionIdTable(db),
                                referencedColumn:
                                    $$ExamSetQuestionsTableReferences
                                        ._questionIdTable(db)
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

typedef $$ExamSetQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamSetQuestionsTable,
      ExamSetQuestion,
      $$ExamSetQuestionsTableFilterComposer,
      $$ExamSetQuestionsTableOrderingComposer,
      $$ExamSetQuestionsTableAnnotationComposer,
      $$ExamSetQuestionsTableCreateCompanionBuilder,
      $$ExamSetQuestionsTableUpdateCompanionBuilder,
      (ExamSetQuestion, $$ExamSetQuestionsTableReferences),
      ExamSetQuestion,
      PrefetchHooks Function({bool examSetId, bool questionId})
    >;
typedef $$PracticeSessionsTableCreateCompanionBuilder =
    PracticeSessionsCompanion Function({
      Value<int> id,
      Value<String?> mode,
      Value<int?> topicId,
      Value<int?> totalQuestions,
      Value<int?> correctAnswers,
      Value<int?> score,
      Value<DateTime> createdAt,
    });
typedef $$PracticeSessionsTableUpdateCompanionBuilder =
    PracticeSessionsCompanion Function({
      Value<int> id,
      Value<String?> mode,
      Value<int?> topicId,
      Value<int?> totalQuestions,
      Value<int?> correctAnswers,
      Value<int?> score,
      Value<DateTime> createdAt,
    });

final class $$PracticeSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PracticeSessionsTable, PracticeSession> {
  $$PracticeSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TopicsTable _topicIdTable(_$AppDatabase db) => db.topics.createAlias(
    $_aliasNameGenerator(db.practiceSessions.topicId, db.topics.id),
  );

  $$TopicsTableProcessedTableManager? get topicId {
    final $_column = $_itemColumn<int>('topic_id');
    if ($_column == null) return null;
    final manager = $$TopicsTableTableManager(
      $_db,
      $_db.topics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_topicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$UserAnswersTable, List<UserAnswer>>
  _userAnswersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userAnswers,
    aliasName: $_aliasNameGenerator(
      db.practiceSessions.id,
      db.userAnswers.sessionId,
    ),
  );

  $$UserAnswersTableProcessedTableManager get userAnswersRefs {
    final manager = $$UserAnswersTableTableManager(
      $_db,
      $_db.userAnswers,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userAnswersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PracticeSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTable> {
  $$PracticeSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TopicsTableFilterComposer get topicId {
    final $$TopicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableFilterComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> userAnswersRefs(
    Expression<bool> Function($$UserAnswersTableFilterComposer f) f,
  ) {
    final $$UserAnswersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userAnswers,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserAnswersTableFilterComposer(
            $db: $db,
            $table: $db.userAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PracticeSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTable> {
  $$PracticeSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TopicsTableOrderingComposer get topicId {
    final $$TopicsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableOrderingComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PracticeSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTable> {
  $$PracticeSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TopicsTableAnnotationComposer get topicId {
    final $$TopicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableAnnotationComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> userAnswersRefs<T extends Object>(
    Expression<T> Function($$UserAnswersTableAnnotationComposer a) f,
  ) {
    final $$UserAnswersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userAnswers,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserAnswersTableAnnotationComposer(
            $db: $db,
            $table: $db.userAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PracticeSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PracticeSessionsTable,
          PracticeSession,
          $$PracticeSessionsTableFilterComposer,
          $$PracticeSessionsTableOrderingComposer,
          $$PracticeSessionsTableAnnotationComposer,
          $$PracticeSessionsTableCreateCompanionBuilder,
          $$PracticeSessionsTableUpdateCompanionBuilder,
          (PracticeSession, $$PracticeSessionsTableReferences),
          PracticeSession,
          PrefetchHooks Function({bool topicId, bool userAnswersRefs})
        > {
  $$PracticeSessionsTableTableManager(
    _$AppDatabase db,
    $PracticeSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PracticeSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PracticeSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PracticeSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> mode = const Value.absent(),
                Value<int?> topicId = const Value.absent(),
                Value<int?> totalQuestions = const Value.absent(),
                Value<int?> correctAnswers = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PracticeSessionsCompanion(
                id: id,
                mode: mode,
                topicId: topicId,
                totalQuestions: totalQuestions,
                correctAnswers: correctAnswers,
                score: score,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> mode = const Value.absent(),
                Value<int?> topicId = const Value.absent(),
                Value<int?> totalQuestions = const Value.absent(),
                Value<int?> correctAnswers = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PracticeSessionsCompanion.insert(
                id: id,
                mode: mode,
                topicId: topicId,
                totalQuestions: totalQuestions,
                correctAnswers: correctAnswers,
                score: score,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PracticeSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({topicId = false, userAnswersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (userAnswersRefs) db.userAnswers],
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
                    if (topicId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.topicId,
                                referencedTable:
                                    $$PracticeSessionsTableReferences
                                        ._topicIdTable(db),
                                referencedColumn:
                                    $$PracticeSessionsTableReferences
                                        ._topicIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userAnswersRefs)
                    await $_getPrefetchedData<
                      PracticeSession,
                      $PracticeSessionsTable,
                      UserAnswer
                    >(
                      currentTable: table,
                      referencedTable: $$PracticeSessionsTableReferences
                          ._userAnswersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PracticeSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).userAnswersRefs,
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

typedef $$PracticeSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PracticeSessionsTable,
      PracticeSession,
      $$PracticeSessionsTableFilterComposer,
      $$PracticeSessionsTableOrderingComposer,
      $$PracticeSessionsTableAnnotationComposer,
      $$PracticeSessionsTableCreateCompanionBuilder,
      $$PracticeSessionsTableUpdateCompanionBuilder,
      (PracticeSession, $$PracticeSessionsTableReferences),
      PracticeSession,
      PrefetchHooks Function({bool topicId, bool userAnswersRefs})
    >;
typedef $$UserAnswersTableCreateCompanionBuilder =
    UserAnswersCompanion Function({
      Value<int> id,
      Value<int?> sessionId,
      Value<int?> questionId,
      Value<String?> selectedAnswer,
      Value<int?> isCorrect,
    });
typedef $$UserAnswersTableUpdateCompanionBuilder =
    UserAnswersCompanion Function({
      Value<int> id,
      Value<int?> sessionId,
      Value<int?> questionId,
      Value<String?> selectedAnswer,
      Value<int?> isCorrect,
    });

final class $$UserAnswersTableReferences
    extends BaseReferences<_$AppDatabase, $UserAnswersTable, UserAnswer> {
  $$UserAnswersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PracticeSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.practiceSessions.createAlias(
        $_aliasNameGenerator(db.userAnswers.sessionId, db.practiceSessions.id),
      );

  $$PracticeSessionsTableProcessedTableManager? get sessionId {
    final $_column = $_itemColumn<int>('session_id');
    if ($_column == null) return null;
    final manager = $$PracticeSessionsTableTableManager(
      $_db,
      $_db.practiceSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $QuestionsTable _questionIdTable(_$AppDatabase db) =>
      db.questions.createAlias(
        $_aliasNameGenerator(db.userAnswers.questionId, db.questions.id),
      );

  $$QuestionsTableProcessedTableManager? get questionId {
    final $_column = $_itemColumn<int>('question_id');
    if ($_column == null) return null;
    final manager = $$QuestionsTableTableManager(
      $_db,
      $_db.questions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserAnswersTableFilterComposer
    extends Composer<_$AppDatabase, $UserAnswersTable> {
  $$UserAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedAnswer => $composableBuilder(
    column: $table.selectedAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  $$PracticeSessionsTableFilterComposer get sessionId {
    final $$PracticeSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.practiceSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PracticeSessionsTableFilterComposer(
            $db: $db,
            $table: $db.practiceSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionsTableFilterComposer get questionId {
    final $$QuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableFilterComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserAnswersTableOrderingComposer
    extends Composer<_$AppDatabase, $UserAnswersTable> {
  $$UserAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedAnswer => $composableBuilder(
    column: $table.selectedAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  $$PracticeSessionsTableOrderingComposer get sessionId {
    final $$PracticeSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.practiceSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PracticeSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.practiceSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionsTableOrderingComposer get questionId {
    final $$QuestionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableOrderingComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserAnswersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserAnswersTable> {
  $$UserAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get selectedAnswer => $composableBuilder(
    column: $table.selectedAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  $$PracticeSessionsTableAnnotationComposer get sessionId {
    final $$PracticeSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.practiceSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PracticeSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.practiceSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionsTableAnnotationComposer get questionId {
    final $$QuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserAnswersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserAnswersTable,
          UserAnswer,
          $$UserAnswersTableFilterComposer,
          $$UserAnswersTableOrderingComposer,
          $$UserAnswersTableAnnotationComposer,
          $$UserAnswersTableCreateCompanionBuilder,
          $$UserAnswersTableUpdateCompanionBuilder,
          (UserAnswer, $$UserAnswersTableReferences),
          UserAnswer,
          PrefetchHooks Function({bool sessionId, bool questionId})
        > {
  $$UserAnswersTableTableManager(_$AppDatabase db, $UserAnswersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserAnswersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> sessionId = const Value.absent(),
                Value<int?> questionId = const Value.absent(),
                Value<String?> selectedAnswer = const Value.absent(),
                Value<int?> isCorrect = const Value.absent(),
              }) => UserAnswersCompanion(
                id: id,
                sessionId: sessionId,
                questionId: questionId,
                selectedAnswer: selectedAnswer,
                isCorrect: isCorrect,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> sessionId = const Value.absent(),
                Value<int?> questionId = const Value.absent(),
                Value<String?> selectedAnswer = const Value.absent(),
                Value<int?> isCorrect = const Value.absent(),
              }) => UserAnswersCompanion.insert(
                id: id,
                sessionId: sessionId,
                questionId: questionId,
                selectedAnswer: selectedAnswer,
                isCorrect: isCorrect,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserAnswersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, questionId = false}) {
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
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$UserAnswersTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$UserAnswersTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (questionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.questionId,
                                referencedTable: $$UserAnswersTableReferences
                                    ._questionIdTable(db),
                                referencedColumn: $$UserAnswersTableReferences
                                    ._questionIdTable(db)
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

typedef $$UserAnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserAnswersTable,
      UserAnswer,
      $$UserAnswersTableFilterComposer,
      $$UserAnswersTableOrderingComposer,
      $$UserAnswersTableAnnotationComposer,
      $$UserAnswersTableCreateCompanionBuilder,
      $$UserAnswersTableUpdateCompanionBuilder,
      (UserAnswer, $$UserAnswersTableReferences),
      UserAnswer,
      PrefetchHooks Function({bool sessionId, bool questionId})
    >;
typedef $$WrongQuestionsTableCreateCompanionBuilder =
    WrongQuestionsCompanion Function({
      Value<int> id,
      Value<int?> questionId,
      Value<int> wrongCount,
      Value<DateTime> lastWrongAt,
    });
typedef $$WrongQuestionsTableUpdateCompanionBuilder =
    WrongQuestionsCompanion Function({
      Value<int> id,
      Value<int?> questionId,
      Value<int> wrongCount,
      Value<DateTime> lastWrongAt,
    });

final class $$WrongQuestionsTableReferences
    extends BaseReferences<_$AppDatabase, $WrongQuestionsTable, WrongQuestion> {
  $$WrongQuestionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuestionsTable _questionIdTable(_$AppDatabase db) =>
      db.questions.createAlias(
        $_aliasNameGenerator(db.wrongQuestions.questionId, db.questions.id),
      );

  $$QuestionsTableProcessedTableManager? get questionId {
    final $_column = $_itemColumn<int>('question_id');
    if ($_column == null) return null;
    final manager = $$QuestionsTableTableManager(
      $_db,
      $_db.questions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WrongQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $WrongQuestionsTable> {
  $$WrongQuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wrongCount => $composableBuilder(
    column: $table.wrongCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastWrongAt => $composableBuilder(
    column: $table.lastWrongAt,
    builder: (column) => ColumnFilters(column),
  );

  $$QuestionsTableFilterComposer get questionId {
    final $$QuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableFilterComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WrongQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WrongQuestionsTable> {
  $$WrongQuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wrongCount => $composableBuilder(
    column: $table.wrongCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastWrongAt => $composableBuilder(
    column: $table.lastWrongAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuestionsTableOrderingComposer get questionId {
    final $$QuestionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableOrderingComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WrongQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WrongQuestionsTable> {
  $$WrongQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get wrongCount => $composableBuilder(
    column: $table.wrongCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastWrongAt => $composableBuilder(
    column: $table.lastWrongAt,
    builder: (column) => column,
  );

  $$QuestionsTableAnnotationComposer get questionId {
    final $$QuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WrongQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WrongQuestionsTable,
          WrongQuestion,
          $$WrongQuestionsTableFilterComposer,
          $$WrongQuestionsTableOrderingComposer,
          $$WrongQuestionsTableAnnotationComposer,
          $$WrongQuestionsTableCreateCompanionBuilder,
          $$WrongQuestionsTableUpdateCompanionBuilder,
          (WrongQuestion, $$WrongQuestionsTableReferences),
          WrongQuestion,
          PrefetchHooks Function({bool questionId})
        > {
  $$WrongQuestionsTableTableManager(
    _$AppDatabase db,
    $WrongQuestionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WrongQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WrongQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WrongQuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> questionId = const Value.absent(),
                Value<int> wrongCount = const Value.absent(),
                Value<DateTime> lastWrongAt = const Value.absent(),
              }) => WrongQuestionsCompanion(
                id: id,
                questionId: questionId,
                wrongCount: wrongCount,
                lastWrongAt: lastWrongAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> questionId = const Value.absent(),
                Value<int> wrongCount = const Value.absent(),
                Value<DateTime> lastWrongAt = const Value.absent(),
              }) => WrongQuestionsCompanion.insert(
                id: id,
                questionId: questionId,
                wrongCount: wrongCount,
                lastWrongAt: lastWrongAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WrongQuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({questionId = false}) {
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
                    if (questionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.questionId,
                                referencedTable: $$WrongQuestionsTableReferences
                                    ._questionIdTable(db),
                                referencedColumn:
                                    $$WrongQuestionsTableReferences
                                        ._questionIdTable(db)
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

typedef $$WrongQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WrongQuestionsTable,
      WrongQuestion,
      $$WrongQuestionsTableFilterComposer,
      $$WrongQuestionsTableOrderingComposer,
      $$WrongQuestionsTableAnnotationComposer,
      $$WrongQuestionsTableCreateCompanionBuilder,
      $$WrongQuestionsTableUpdateCompanionBuilder,
      (WrongQuestion, $$WrongQuestionsTableReferences),
      WrongQuestion,
      PrefetchHooks Function({bool questionId})
    >;
typedef $$ExamHistoryTableCreateCompanionBuilder =
    ExamHistoryCompanion Function({
      Value<int> id,
      Value<String?> licenseType,
      Value<int?> totalQuestions,
      Value<int?> correctAnswers,
      Value<int?> isPassed,
      Value<int?> timeSpent,
      Value<DateTime> createdAt,
    });
typedef $$ExamHistoryTableUpdateCompanionBuilder =
    ExamHistoryCompanion Function({
      Value<int> id,
      Value<String?> licenseType,
      Value<int?> totalQuestions,
      Value<int?> correctAnswers,
      Value<int?> isPassed,
      Value<int?> timeSpent,
      Value<DateTime> createdAt,
    });

class $$ExamHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ExamHistoryTable> {
  $$ExamHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licenseType => $composableBuilder(
    column: $table.licenseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPassed => $composableBuilder(
    column: $table.isPassed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeSpent => $composableBuilder(
    column: $table.timeSpent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExamHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamHistoryTable> {
  $$ExamHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licenseType => $composableBuilder(
    column: $table.licenseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPassed => $composableBuilder(
    column: $table.isPassed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeSpent => $composableBuilder(
    column: $table.timeSpent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExamHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamHistoryTable> {
  $$ExamHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get licenseType => $composableBuilder(
    column: $table.licenseType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isPassed =>
      $composableBuilder(column: $table.isPassed, builder: (column) => column);

  GeneratedColumn<int> get timeSpent =>
      $composableBuilder(column: $table.timeSpent, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ExamHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamHistoryTable,
          ExamHistoryData,
          $$ExamHistoryTableFilterComposer,
          $$ExamHistoryTableOrderingComposer,
          $$ExamHistoryTableAnnotationComposer,
          $$ExamHistoryTableCreateCompanionBuilder,
          $$ExamHistoryTableUpdateCompanionBuilder,
          (
            ExamHistoryData,
            BaseReferences<_$AppDatabase, $ExamHistoryTable, ExamHistoryData>,
          ),
          ExamHistoryData,
          PrefetchHooks Function()
        > {
  $$ExamHistoryTableTableManager(_$AppDatabase db, $ExamHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> licenseType = const Value.absent(),
                Value<int?> totalQuestions = const Value.absent(),
                Value<int?> correctAnswers = const Value.absent(),
                Value<int?> isPassed = const Value.absent(),
                Value<int?> timeSpent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExamHistoryCompanion(
                id: id,
                licenseType: licenseType,
                totalQuestions: totalQuestions,
                correctAnswers: correctAnswers,
                isPassed: isPassed,
                timeSpent: timeSpent,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> licenseType = const Value.absent(),
                Value<int?> totalQuestions = const Value.absent(),
                Value<int?> correctAnswers = const Value.absent(),
                Value<int?> isPassed = const Value.absent(),
                Value<int?> timeSpent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExamHistoryCompanion.insert(
                id: id,
                licenseType: licenseType,
                totalQuestions: totalQuestions,
                correctAnswers: correctAnswers,
                isPassed: isPassed,
                timeSpent: timeSpent,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExamHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamHistoryTable,
      ExamHistoryData,
      $$ExamHistoryTableFilterComposer,
      $$ExamHistoryTableOrderingComposer,
      $$ExamHistoryTableAnnotationComposer,
      $$ExamHistoryTableCreateCompanionBuilder,
      $$ExamHistoryTableUpdateCompanionBuilder,
      (
        ExamHistoryData,
        BaseReferences<_$AppDatabase, $ExamHistoryTable, ExamHistoryData>,
      ),
      ExamHistoryData,
      PrefetchHooks Function()
    >;
typedef $$TrafficSignsTableCreateCompanionBuilder =
    TrafficSignsCompanion Function({
      required String signId,
      required String category,
      required String name,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<int> rowid,
    });
typedef $$TrafficSignsTableUpdateCompanionBuilder =
    TrafficSignsCompanion Function({
      Value<String> signId,
      Value<String> category,
      Value<String> name,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<int> rowid,
    });

class $$TrafficSignsTableFilterComposer
    extends Composer<_$AppDatabase, $TrafficSignsTable> {
  $$TrafficSignsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get signId => $composableBuilder(
    column: $table.signId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrafficSignsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrafficSignsTable> {
  $$TrafficSignsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get signId => $composableBuilder(
    column: $table.signId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrafficSignsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrafficSignsTable> {
  $$TrafficSignsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get signId =>
      $composableBuilder(column: $table.signId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);
}

class $$TrafficSignsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrafficSignsTable,
          TrafficSign,
          $$TrafficSignsTableFilterComposer,
          $$TrafficSignsTableOrderingComposer,
          $$TrafficSignsTableAnnotationComposer,
          $$TrafficSignsTableCreateCompanionBuilder,
          $$TrafficSignsTableUpdateCompanionBuilder,
          (
            TrafficSign,
            BaseReferences<_$AppDatabase, $TrafficSignsTable, TrafficSign>,
          ),
          TrafficSign,
          PrefetchHooks Function()
        > {
  $$TrafficSignsTableTableManager(_$AppDatabase db, $TrafficSignsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrafficSignsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrafficSignsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrafficSignsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> signId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrafficSignsCompanion(
                signId: signId,
                category: category,
                name: name,
                description: description,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String signId,
                required String category,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrafficSignsCompanion.insert(
                signId: signId,
                category: category,
                name: name,
                description: description,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrafficSignsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrafficSignsTable,
      TrafficSign,
      $$TrafficSignsTableFilterComposer,
      $$TrafficSignsTableOrderingComposer,
      $$TrafficSignsTableAnnotationComposer,
      $$TrafficSignsTableCreateCompanionBuilder,
      $$TrafficSignsTableUpdateCompanionBuilder,
      (
        TrafficSign,
        BaseReferences<_$AppDatabase, $TrafficSignsTable, TrafficSign>,
      ),
      TrafficSign,
      PrefetchHooks Function()
    >;
typedef $$SettingTableCreateCompanionBuilder =
    SettingCompanion Function({
      required int SettingId,
      Value<String> rankId,
      Value<int> models,
      Value<int> mode,
      Value<int> vibration,
      Value<int> rowid,
    });
typedef $$SettingTableUpdateCompanionBuilder =
    SettingCompanion Function({
      Value<int> SettingId,
      Value<String> rankId,
      Value<int> models,
      Value<int> mode,
      Value<int> vibration,
      Value<int> rowid,
    });

class $$SettingTableFilterComposer
    extends Composer<_$AppDatabase, $SettingTable> {
  $$SettingTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get SettingId => $composableBuilder(
    column: $table.SettingId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rankId => $composableBuilder(
    column: $table.rankId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get models => $composableBuilder(
    column: $table.models,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vibration => $composableBuilder(
    column: $table.vibration,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingTable> {
  $$SettingTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get SettingId => $composableBuilder(
    column: $table.SettingId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rankId => $composableBuilder(
    column: $table.rankId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get models => $composableBuilder(
    column: $table.models,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vibration => $composableBuilder(
    column: $table.vibration,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingTable> {
  $$SettingTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get SettingId =>
      $composableBuilder(column: $table.SettingId, builder: (column) => column);

  GeneratedColumn<String> get rankId =>
      $composableBuilder(column: $table.rankId, builder: (column) => column);

  GeneratedColumn<int> get models =>
      $composableBuilder(column: $table.models, builder: (column) => column);

  GeneratedColumn<int> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get vibration =>
      $composableBuilder(column: $table.vibration, builder: (column) => column);
}

class $$SettingTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingTable,
          SettingData,
          $$SettingTableFilterComposer,
          $$SettingTableOrderingComposer,
          $$SettingTableAnnotationComposer,
          $$SettingTableCreateCompanionBuilder,
          $$SettingTableUpdateCompanionBuilder,
          (
            SettingData,
            BaseReferences<_$AppDatabase, $SettingTable, SettingData>,
          ),
          SettingData,
          PrefetchHooks Function()
        > {
  $$SettingTableTableManager(_$AppDatabase db, $SettingTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> SettingId = const Value.absent(),
                Value<String> rankId = const Value.absent(),
                Value<int> models = const Value.absent(),
                Value<int> mode = const Value.absent(),
                Value<int> vibration = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingCompanion(
                SettingId: SettingId,
                rankId: rankId,
                models: models,
                mode: mode,
                vibration: vibration,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int SettingId,
                Value<String> rankId = const Value.absent(),
                Value<int> models = const Value.absent(),
                Value<int> mode = const Value.absent(),
                Value<int> vibration = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingCompanion.insert(
                SettingId: SettingId,
                rankId: rankId,
                models: models,
                mode: mode,
                vibration: vibration,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingTable,
      SettingData,
      $$SettingTableFilterComposer,
      $$SettingTableOrderingComposer,
      $$SettingTableAnnotationComposer,
      $$SettingTableCreateCompanionBuilder,
      $$SettingTableUpdateCompanionBuilder,
      (SettingData, BaseReferences<_$AppDatabase, $SettingTable, SettingData>),
      SettingData,
      PrefetchHooks Function()
    >;
typedef $$RecognitionHistoryTableTableCreateCompanionBuilder =
    RecognitionHistoryTableCompanion Function({
      Value<int> id,
      required String imagePath,
      required String result,
      Value<String?> signName,
      Value<String?> signType,
      Value<DateTime> createdAt,
    });
typedef $$RecognitionHistoryTableTableUpdateCompanionBuilder =
    RecognitionHistoryTableCompanion Function({
      Value<int> id,
      Value<String> imagePath,
      Value<String> result,
      Value<String?> signName,
      Value<String?> signType,
      Value<DateTime> createdAt,
    });

class $$RecognitionHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecognitionHistoryTableTable> {
  $$RecognitionHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signName => $composableBuilder(
    column: $table.signName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signType => $composableBuilder(
    column: $table.signType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecognitionHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecognitionHistoryTableTable> {
  $$RecognitionHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signName => $composableBuilder(
    column: $table.signName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signType => $composableBuilder(
    column: $table.signType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecognitionHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecognitionHistoryTableTable> {
  $$RecognitionHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get signName =>
      $composableBuilder(column: $table.signName, builder: (column) => column);

  GeneratedColumn<String> get signType =>
      $composableBuilder(column: $table.signType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RecognitionHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecognitionHistoryTableTable,
          RecognitionHistoryData,
          $$RecognitionHistoryTableTableFilterComposer,
          $$RecognitionHistoryTableTableOrderingComposer,
          $$RecognitionHistoryTableTableAnnotationComposer,
          $$RecognitionHistoryTableTableCreateCompanionBuilder,
          $$RecognitionHistoryTableTableUpdateCompanionBuilder,
          (
            RecognitionHistoryData,
            BaseReferences<
              _$AppDatabase,
              $RecognitionHistoryTableTable,
              RecognitionHistoryData
            >,
          ),
          RecognitionHistoryData,
          PrefetchHooks Function()
        > {
  $$RecognitionHistoryTableTableTableManager(
    _$AppDatabase db,
    $RecognitionHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecognitionHistoryTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecognitionHistoryTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecognitionHistoryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<String> result = const Value.absent(),
                Value<String?> signName = const Value.absent(),
                Value<String?> signType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RecognitionHistoryTableCompanion(
                id: id,
                imagePath: imagePath,
                result: result,
                signName: signName,
                signType: signType,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String imagePath,
                required String result,
                Value<String?> signName = const Value.absent(),
                Value<String?> signType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RecognitionHistoryTableCompanion.insert(
                id: id,
                imagePath: imagePath,
                result: result,
                signName: signName,
                signType: signType,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecognitionHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecognitionHistoryTableTable,
      RecognitionHistoryData,
      $$RecognitionHistoryTableTableFilterComposer,
      $$RecognitionHistoryTableTableOrderingComposer,
      $$RecognitionHistoryTableTableAnnotationComposer,
      $$RecognitionHistoryTableTableCreateCompanionBuilder,
      $$RecognitionHistoryTableTableUpdateCompanionBuilder,
      (
        RecognitionHistoryData,
        BaseReferences<
          _$AppDatabase,
          $RecognitionHistoryTableTable,
          RecognitionHistoryData
        >,
      ),
      RecognitionHistoryData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TopicsTableTableManager get topics =>
      $$TopicsTableTableManager(_db, _db.topics);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$ExamGroupsTableTableManager get examGroups =>
      $$ExamGroupsTableTableManager(_db, _db.examGroups);
  $$RanksTableTableManager get ranks =>
      $$RanksTableTableManager(_db, _db.ranks);
  $$ExamSetsTableTableManager get examSets =>
      $$ExamSetsTableTableManager(_db, _db.examSets);
  $$ExamSetQuestionsTableTableManager get examSetQuestions =>
      $$ExamSetQuestionsTableTableManager(_db, _db.examSetQuestions);
  $$PracticeSessionsTableTableManager get practiceSessions =>
      $$PracticeSessionsTableTableManager(_db, _db.practiceSessions);
  $$UserAnswersTableTableManager get userAnswers =>
      $$UserAnswersTableTableManager(_db, _db.userAnswers);
  $$WrongQuestionsTableTableManager get wrongQuestions =>
      $$WrongQuestionsTableTableManager(_db, _db.wrongQuestions);
  $$ExamHistoryTableTableManager get examHistory =>
      $$ExamHistoryTableTableManager(_db, _db.examHistory);
  $$TrafficSignsTableTableManager get trafficSigns =>
      $$TrafficSignsTableTableManager(_db, _db.trafficSigns);
  $$SettingTableTableManager get setting =>
      $$SettingTableTableManager(_db, _db.setting);
  $$RecognitionHistoryTableTableTableManager get recognitionHistoryTable =>
      $$RecognitionHistoryTableTableTableManager(
        _db,
        _db.recognitionHistoryTable,
      );
}
