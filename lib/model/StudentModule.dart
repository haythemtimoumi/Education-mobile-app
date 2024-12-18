class StudentModule {
  final String firstName;
  final String lastName;
  final String classCode;
  final String academicYear;
  final int hours;
  final double coefficient;
  final int semesterNumber;
  final String moduleCode;
  final int absenceCount;

  StudentModule({
    required this.firstName,
    required this.lastName,
    required this.classCode,
    required this.academicYear,
    required this.hours,
    required this.coefficient,
    required this.semesterNumber,
    required this.moduleCode,
    required this.absenceCount,
  });

  factory StudentModule.fromJson(List<dynamic> json) {
    return StudentModule(
      firstName: json[0],
      lastName: json[1],
      classCode: json[2],
      academicYear: json[3],
      hours: json[4],
      coefficient: json[5],
      semesterNumber: json[6],
      moduleCode: json[7],
      absenceCount: json[8],
    );
  }
}
