import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/module.dart';
import '../model/module_performance.dart';

class ApiService {

  final String baseUrl = 'http://192.168.44.29:3000';


  Future<List<dynamic>> fetchStudentById(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('student_$studentId');

    try {
      final response = await http.get(Uri.parse('$baseUrl/studentById/$studentId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        prefs.setString('student_$studentId', json.encode(data)); // Cache data
        return data;
      } else {
        throw Exception('Failed to load student data');
      }
    } catch (e) {
      if (cachedData != null) {
        return json.decode(cachedData);
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }

  Future<List<List<dynamic>>> fetchStudentAbsences(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('absences_$studentId');

    try {
      final url = Uri.parse('$baseUrl/studentAbsences/$studentId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<List<dynamic>> formattedData = data.map<List<dynamic>>((json) => List<dynamic>.from(json)).toList();

        prefs.setString('absences_$studentId', json.encode(formattedData)); // Cache data
        return formattedData;
      } else {
        throw Exception('Failed to load absences, status code: ${response.statusCode}');
      }
    } catch (e) {
      if (cachedData != null) {
        final List<dynamic> cachedList = json.decode(cachedData);
        return cachedList.map<List<dynamic>>((json) => List<dynamic>.from(json)).toList();
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }

  Future<List<StudentModule>> fetchStudentModules(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('modules_$studentId');

    try {
      final response = await http.get(Uri.parse('$baseUrl/studentModules/$studentId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final modules = data.map<StudentModule>((json) => StudentModule.fromJson(json)).toList();

        prefs.setString('modules_$studentId', json.encode(data)); // Cache data
        return modules;
      } else {
        throw Exception('Failed to load student modules');
      }
    } catch (e) {
      if (cachedData != null) {
        final List<dynamic> cachedList = json.decode(cachedData);
        return cachedList.map<StudentModule>((json) => StudentModule.fromJson(json)).toList();
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }

  Future<List<StudentModule>> fetchStudentModulesR(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('modulesR_$studentId');

    try {
      final response = await http.get(Uri.parse('$baseUrl/studentModulesR/$studentId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final modules = data.map<StudentModule>((json) => StudentModule.fromJson(json)).toList();

        prefs.setString('modulesR_$studentId', json.encode(data)); // Cache data
        return modules;
      } else {
        throw Exception('Failed to load student modules');
      }
    } catch (e) {
      if (cachedData != null) {
        final List<dynamic> cachedList = json.decode(cachedData);
        return cachedList.map<StudentModule>((json) => StudentModule.fromJson(json)).toList();
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }

  Future<List<dynamic>> fetchAbsencesById(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('absence_$studentId');

    try {
      final response = await http.get(Uri.parse('$baseUrl/absenceById/$studentId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        prefs.setString('absence_$studentId', json.encode(data)); // Cache data
        return data;
      } else {
        throw Exception('Failed to load absences');
      }
    } catch (e) {
      if (cachedData != null) {
        return json.decode(cachedData);
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }

  Future<List<dynamic>> fetchEnseignants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('enseignants');

    try {
      final response = await http.get(Uri.parse('$baseUrl/enseignantActive'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        prefs.setString('enseignants', json.encode(data)); // Cache data
        return data;
      } else {
        throw Exception('Failed to load enseignants data');
      }
    } catch (e) {
      if (cachedData != null) {
        return json.decode(cachedData);
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }

  Future<Map<String, dynamic>> studentStudyHours(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('studyHours_$studentId');

    try {
      final url = Uri.parse('$baseUrl/studentStudyHours/$studentId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        prefs.setString('studyHours_$studentId', json.encode(data)); // Cache data
        return data;
      } else {
        throw Exception('Failed to load student study hours');
      }
    } catch (e) {
      if (cachedData != null) {
        return json.decode(cachedData);
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }

  Future<List<List<dynamic>>> fetchStudentModulesSt(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('modulesSt_$studentId');

    try {
      final url = Uri.parse('$baseUrl/studentModulesSt/$studentId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        prefs.setString('modulesSt_$studentId', json.encode(data)); // Cache data
        return data.map<List<dynamic>>((json) => List<dynamic>.from(json)).toList();
      } else {
        throw Exception('Failed to load student modules');
      }
    } catch (e) {
      if (cachedData != null) {
        final List<dynamic> cachedList = json.decode(cachedData);
        return cachedList.map<List<dynamic>>((json) => List<dynamic>.from(json)).toList();
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }

  Future<Map<String, dynamic>> fetchSocieteByStudent(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('societe_$studentId');

    try {
      final response = await http.get(Uri.parse('$baseUrl/societeByStudent/$studentId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        prefs.setString('societe_$studentId', json.encode(data)); // Cache data
        return {
          'NOM_SOC': data[0][0],
          'ADR_SOC': data[0][1],
          'TEL_SOC': data[0][2],
          'FAX_SOC': data[0][3],
          'E_MAIL': data[0][4],
          'LIAISON_SITE': data[0][5],
          'VILLE': data[0][6],
          'RIB': data[0][7],
          'BANQUE': data[0][8],
        };
      } else {
        throw Exception('Failed to load societe data');
      }
    } catch (e) {
      if (cachedData != null) {
        return json.decode(cachedData);
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchNotesBelowThreshold(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('notesBelow_$studentId');

    try {
      final response = await http.get(Uri.parse('$baseUrl/notesBelowThreshold/$studentId'));

      if (response.statusCode == 200) {
        final rawData = response.body;
        final List<dynamic> data = json.decode(rawData);
        prefs.setString('notesBelow_$studentId', json.encode(data)); // Cache data

        return data.map((e) => Map<String, dynamic>.from({
          'ANNEE_DEB': e[1],
          'LIB_UE': e[0],
          'NOTE': e[2],
        })).toList();
      } else {
        throw Exception('Failed to load notes below threshold');
      }
    } catch (e) {
      if (cachedData != null) {
        final List<dynamic> data = json.decode(cachedData);
        return data.map((e) => Map<String, dynamic>.from({
          'ANNEE_DEB': e[1],
          'LIB_UE': e[0],
          'NOTE': e[2],
        })).toList();
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }

  Future<Map<String, dynamic>> fetchMotivationalMessages(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('motivationalMsg_$studentId');

    try {
      final url = Uri.parse('$baseUrl/studentMsg/$studentId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        prefs.setString('motivationalMsg_$studentId', json.encode(data)); // Cache data
        return data;
      } else {
        throw Exception('Failed to load motivational messages');
      }
    } catch (e) {
      if (cachedData != null) {
        return json.decode(cachedData);
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }

  Future<List<List<dynamic>>> fetchEmploiByClasseAndDate(String classeId, {String? date}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cacheKey = 'emploi_$classeId${date != null ? '_$date' : ''}';
    String? cachedData = prefs.getString(cacheKey);

    try {
      final url = Uri.parse('$baseUrl/emploi/$classeId${date != null ? '?date=$date' : ''}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        prefs.setString(cacheKey, json.encode(data)); // Cache data
        return data.map<List<dynamic>>((item) => List<dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load emploi data, status code: ${response.statusCode}');
      }
    } catch (e) {
      if (cachedData != null) {
        final List<dynamic> cachedList = json.decode(cachedData);
        return cachedList.map<List<dynamic>>((item) => List<dynamic>.from(item)).toList();
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }

  Future<List<ModulePerformance>> fetchStudentStats(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('studentStats_$studentId');

    try {
      final url = Uri.parse('$baseUrl/studentstats/$studentId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("API Response: $data");  // Debugging print

        prefs.setString('studentStats_$studentId', json.encode(data)); // Cache data

        return (data['modules'] as List<dynamic>).map((module) {
          return ModulePerformance(
            module['module'] ?? '',            // Ensure module is handled safely
            module['ueName'] ?? 'Unknown',     // Handle potential null ueName
            module['typeMoyenne'] ?? '',       // Ensure typeMoyenne is handled safely

            // Cast studentMoyenne and classAverageMoyenne to double
            (module['studentMoyenne'] is int)
                ? (module['studentMoyenne'] as int).toDouble()
                : (module['studentMoyenne'] ?? 0.0),

            (module['classAverageMoyenne'] is int)
                ? (module['classAverageMoyenne'] as int).toDouble()
                : (module['classAverageMoyenne'] ?? 0.0),
          );
        }).toList();
      } else {
        throw Exception('Failed to load student stats. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching student stats: $e");  // Debugging print

      // Handle cached data if available
      if (cachedData != null) {
        final data = json.decode(cachedData);
        return (data['modules'] as List<dynamic>).map((module) {
          return ModulePerformance(
            module['module'] ?? '',
            module['ueName'] ?? 'Unknown',
            module['typeMoyenne'] ?? '',

            (module['studentMoyenne'] is int)
                ? (module['studentMoyenne'] as int).toDouble()
                : (module['studentMoyenne'] ?? 0.0),

            (module['classAverageMoyenne'] is int)
                ? (module['classAverageMoyenne'] as int).toDouble()
                : (module['classAverageMoyenne'] ?? 0.0),
          );
        }).toList();
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }


  Future<List<Map<String, dynamic>>> fetchStudentNotesById(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('studentNotes_$studentId');

    try {
      final response = await http.get(Uri.parse('$baseUrl/studentNotesById/$studentId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        prefs.setString('studentNotes_$studentId', json.encode(data)); // Cache data

        return data.map<Map<String, dynamic>>((json) => {
          'CODE_MODULE': json[0],
          'NOTE_EXAM': json[1],
          'NOTE_CC': json[2],
          'NOTE_TP': json[3],
          'SEMESTRE': json[4],
          'TYPE_MOY': json[5],
          'ANNEE_DEB': json[6],
          'MOYENNE': json[7],
        }).toList();
      } else {
        throw Exception('Failed to load student notes');
      }
    } catch (e) {
      if (cachedData != null) {
        final List<dynamic> data = json.decode(cachedData);
        return data.map<Map<String, dynamic>>((json) => {
          'CODE_MODULE': json[0],
          'NOTE_EXAM': json[1],
          'NOTE_CC': json[2],
          'NOTE_TP': json[3],
          'SEMESTRE': json[4],
          'TYPE_MOY': json[5],
          'ANNEE_DEB': json[6],
          'MOYENNE': json[7],
        }).toList();
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }


  Future<List<Map<String, dynamic>>> fetchModulesWithEnseignantsByStudent(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('modules_enseignants_$studentId');

    try {
      final response = await http.get(Uri.parse('$baseUrl/teacherModules/$studentId'));

      // Log the response status and body
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Cache the data
        prefs.setString('modules_enseignants_$studentId', json.encode(data));

        // Transform the array-based response into a List of Maps, now with emails included
        return data.map<Map<String, dynamic>>((module) => {
          'LIB_UE': module[0],                    // Module name
          'NOM_ENS1': module[1] ?? '',            // Name of Enseignant 1
          'EMAIL_1': module[2] ?? '',             // Email of Enseignant 1
          'NOM_ENS2': module[3] ?? '',            // Name of Enseignant 2
          'EMAIL_2': module[4] ?? '',             // Email of Enseignant 2
          'NOM_ENS3': module[5] ?? '',            // Name of Enseignant 3
          'EMAIL_3': module[6] ?? '',             // Email of Enseignant 3
          'NOM_ENS4': module[7] ?? '',            // Name of Enseignant 4
          'EMAIL_4': module[8] ?? '',             // Email of Enseignant 4
          'NOM_ENS5': module[9] ?? '',            // Name of Enseignant 5
          'EMAIL_5': module[10] ?? '',            // Email of Enseignant 5
        }).toList();
      } else {
        throw Exception('Failed to load modules with enseignants, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e'); // Log any errors
      if (cachedData != null) {
        // If there's no internet connection but cached data is available
        final List<dynamic> cachedList = json.decode(cachedData);
        return cachedList.map<Map<String, dynamic>>((module) => {
          'LIB_UE': module[0],                    // Module name
          'NOM_ENS1': module[1] ?? '',            // Name of Enseignant 1
          'EMAIL_1': module[2] ?? '',             // Email of Enseignant 1
          'NOM_ENS2': module[3] ?? '',            // Name of Enseignant 2
          'EMAIL_2': module[4] ?? '',             // Email of Enseignant 2
          'NOM_ENS3': module[5] ?? '',            // Name of Enseignant 3
          'EMAIL_3': module[6] ?? '',             // Email of Enseignant 3
          'NOM_ENS4': module[7] ?? '',            // Name of Enseignant 4
          'EMAIL_4': module[8] ?? '',             // Email of Enseignant 4
          'NOM_ENS5': module[9] ?? '',            // Name of Enseignant 5
          'EMAIL_5': module[10] ?? '',            // Email of Enseignant 5
        }).toList();
      } else {
        // Handle the case where no internet and no cached data
        throw Exception('No cached data available and no internet connection');
      }
    }
  }

  Future<Map<String, dynamic>> fetchMoyFinalById(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('moyFinal_$studentId');

    try {
      final response = await http.get(Uri.parse('$baseUrl/moyFinal/$studentId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Convert the list into a map
        if (data.isNotEmpty && data[0] is List) {
          final Map<String, dynamic> result = {
            'MOY_SEM1': data[0][0].toString(),
            'MOY_SEM2': data[0][1].toString(),
            'MOY_GENERAL': data[0][2].toString(),
            'MOY_RATT': data[0][3].toString(),
          };

          prefs.setString('moyFinal_$studentId', json.encode(result)); // Cache the data
          return result;
        } else {
          throw Exception('Unexpected data format from API');
        }
      } else {
        throw Exception('Failed to load MoyFinal data');
      }
    } catch (e) {
      if (cachedData != null) {
        return json.decode(cachedData);
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }




  Future<Map<String, dynamic>> fetchStudyProgress(String studentId, String studentClass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('studyProgress_$studentId');

    try {
      final url = Uri.parse('$baseUrl/studentStudyProgress/$studentId/$studentClass');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        prefs.setString('studyProgress_$studentId', json.encode(data)); // Cache data
        return data;
      } else {
        throw Exception('Failed to load student study progress');
      }
    } catch (e) {
      if (cachedData != null) {
        return json.decode(cachedData);
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }

  Future<void> submitInternshipData({
    required String idEt,
    required String dateDebut,
    required String dateFin,
    required String adresseSociete,
    required String telephoneSociete,
    required String nomSociete,
    required String emailSociete,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/submitSociete/$idEt');

      // Create the JSON body for the POST request
      final body = json.encode({
        'DATE_DEBUT': dateDebut,
        'DATE_FIN': dateFin,
        'ADRESSE_SOCIETE': adresseSociete,
        'EMAIL_SOCIETE': emailSociete,
        'TELEPHONE_SOCIETE': telephoneSociete,
        'NOM_SOCIETE': nomSociete,
      });

      // Send the POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Check the response status code
      if (response.statusCode == 201) {
        print('Internship data submitted successfully');
      } else if (response.statusCode == 400) {
        final errorMessage = json.decode(response.body)['error'];
        if (errorMessage.contains('once per year')) {
          throw Exception('You have already submitted an internship this year. You can only submit once per year.');
        } else {
          throw Exception('Failed to submit internship data: $errorMessage');
        }
      } else {
        throw Exception('Failed to submit internship data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error submitting internship data: $e');
    }
  }


  Future<String> fetchPdf(String studentId) async {
    try {
      // Correct the URL to match the working one from Postman
      final url = Uri.parse('$baseUrl/studentStage/$studentId');
      print('Fetching PDF from URL: $url'); // Log the URL for debugging
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Get the application's document directory
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/Demande_Stage_$studentId.pdf';
        final file = File(filePath);

        // Write the bytes of the PDF file
        await file.writeAsBytes(response.bodyBytes);
        print("PDF saved at: $filePath");

        // Return the file path for display
        return filePath;
      } else {
        print('Failed to download PDF, status code: ${response.statusCode}');
        throw Exception('Failed to download PDF, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching the PDF: $e');
      throw Exception('Error fetching the PDF');
    }
  }

  Future<Map<String, dynamic>> fetchStudentNiveau(String studentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('niveau_$studentId');

    try {
      final response = await http.get(Uri.parse('$baseUrl/studentNiveau/$studentId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        prefs.setString('niveau_$studentId', json.encode(data)); // Cache the data
        return {
          'NIVEAU_COURANT_ANG': data['NIVEAU_COURANT_ANG'],
          'NIVEAU_COURANT_FR': data['NIVEAU_COURANT_FR'],
        };
      } else {
        throw Exception('Failed to load student level');
      }
    } catch (e) {
      if (cachedData != null) {
        final data = json.decode(cachedData);
        return {
          'NIVEAU_COURANT_ANG': data['NIVEAU_COURANT_ANG'],
          'NIVEAU_COURANT_FR': data['NIVEAU_COURANT_FR'],
        };
      } else {
        throw Exception('No cached data available and no internet connection');
      }
    }
  }


  Future<String> downloadStudentPdf(String studentId) async {
    try {
      // The URL to fetch the PDF
      final url = Uri.parse('$baseUrl/pdf/journal-stage'); // Adjust your API endpoint
      print('Fetching PDF from URL: $url');

      // Send the GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Get the application's document directory
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/Journal_Stage_$studentId.pdf';
        final file = File(filePath);

        // Write the PDF file to the device
        await file.writeAsBytes(response.bodyBytes);
        print("PDF saved at: $filePath");

        // Return the local file path for further use
        return filePath;
      } else {
        print('Failed to download PDF, status code: ${response.statusCode}');
        throw Exception('Failed to download PDF, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading the PDF: $e');
      throw Exception('Error downloading the PDF');
    }
  }

  Future<String> fetchCodeClByStudentId(String studentId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/studentClassCode/$studentId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['CODE_CL'];
      } else {
        throw Exception('Failed to load CODE_CL, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching CODE_CL: $e');
      throw Exception('Error fetching CODE_CL');
    }
  }
  Future<void> submitReclamation({
    required String idEt,
    required String codeCl,
    required String typeRec,
    required String description,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/submitReclamation');

      // Create the JSON body for the POST request
      final body = json.encode({
        'ID_ET': idEt,
        'CODE_CL': codeCl,
        'TYPE_REC': typeRec,
        'DISCREPTION': description,
      });

      // Send the POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Check the response status code
      if (response.statusCode == 201) {
        print('Reclamation submitted successfully');
      } else {
        throw Exception('Failed to submit reclamation: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting reclamation: $e');
      throw Exception('Error submitting reclamation');
    }
  }
  Future<Map<String, dynamic>> fetchStudentPaymentStatus(String studentId) async {
    try {
      final response = await http.get(Uri.parse('http://ws.testing.esprit.tn/fin-statement/student/$studentId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Ensure the data contains the expected fields
        if (data.containsKey('locked') && data.containsKey('message')) {
          return {
            'locked': data['locked'],
            'message': data['message'],
          };
        } else {
          throw Exception('Unexpected response structure');
        }
      } else {
        throw Exception('Failed to load payment status, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching payment status: $e');
      throw Exception('Error fetching payment status');
    }
  }



}
