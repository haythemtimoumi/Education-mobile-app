// lib/model/module.dart

class StudentModule {
  final String codeModule;
  final String designationModule;
  final double moyenneModule;
  final String libUE;
  final double moyenneUE;

  StudentModule({
    required this.codeModule,
    required this.designationModule,
    required this.moyenneModule,
    required this.libUE,
    required this.moyenneUE,
  });

  factory StudentModule.fromJson(List<dynamic> json) {
    return StudentModule(
      codeModule: json[0],
      designationModule: json[1],
      moyenneModule: json[2].toDouble(),
      libUE: json[3],
      moyenneUE: json[4].toDouble(),
    );
  }
}
