import 'dart:convert';

import 'package:uniprintgestao/src/models/graph/professor.dart';
import 'package:uniprintgestao/src/models/graph/turma.dart';

class ProfessorTurma {
  Turma turma;
  Professor professor;
  ProfessorTurma({
    this.turma,
    this.professor,
  });

  Map<String, dynamic> toMap() {
    return {
      'turma': turma.toMap(),
      'professor': professor.toMap(),
    };
  }

  static ProfessorTurma fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ProfessorTurma(
      turma: Turma.fromMap(map['turma']),
      professor: Professor.fromMap(map['professor']),
    );
  }

  String toJson() => json.encode(toMap());

  static ProfessorTurma fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'ProfessorTurma turma: $turma, professor: $professor';
}
