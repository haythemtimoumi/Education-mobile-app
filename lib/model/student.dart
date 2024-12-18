class Student {
  final String idEt;
  final String nomEt;
  final String prenomEt;
  final DateTime dateNaissance;
  final String lieuNaissance;
  final String? fonctionPere;
  final String? fonctionMere;
  final String adresse;
  final String tel;
  final String telParent;
  final String email;
  final String cycle;
  final String natureBac;
  final DateTime dateBac;
  final String numBac;
  final String etabBac;
  final String? diplomeSup;
  final int? niveauDiplomeSup;
  final String etabOrigine;
  final String specialite;
  final DateTime dateEntree;
  final String anneeEntree;
  final String classeCourante;
  final String situationFinanciere;
  final int niveauCourant;
  final double? moyenneDernSemestre;
  final String resultatFinal;
  final String diplomeObtenu;
  final DateTime? dateSortie;
  final String? observation;
  final String sexe;
  final String nationalite;
  final String cinPasseport;
  final DateTime? dateSaisie;
  final DateTime? dateDernModif;
  final String? agent;
  final String? numOrd;
  final DateTime? dateDelivrance;
  final String? lieuDelivrance;
  final int niveauAcces;
  final String natureCours;
  final String naturePieceId;
  final String adresseParent;
  final String cpParent;
  final String villeParent;
  final String paysParent;
  final String cpEt;
  final String villeEt;
  final String paysEt;
  final String emailParent;
  final String telParentAlt;
  final String typeEnreg;
  final String? dateLieuNaissance;
  final String codeEtabOrigine;
  final String codeSpecOrigine;
  final String libSpecOrigine;
  final String classePrec;
  final String idEtOrigin;
  final String etat;
  final String? justifEtat;
  final String libJustifEtat;
  final String idEtNew;
  final String idEtOrigine;
  final DateTime? dateLastChangeEtat;
  final String? dernUtilisateur;
  final String? numCompte;
  final String? banque;
  final String? ribBanque;
  final String? mp08;
  final String typeEt;
  final String codeNationalite;
  final int? numPromotionCS;
  final String? codeDecisionSessionPAP1;
  final String? libDecisionSessionPAP1;
  final String? codeDecisionSessionRAP1;
  final String? libDecisionSessionRAP1;
  final String? codeDecisionSessionPAP2;
  final String? libDecisionSessionPAP2;
  final String? codeDecisionSessionRAP2;
  final String? libDecisionSessionRAP2;
  final String? codeDecisionSessionPAP3;
  final String? libDecisionSessionPAP3;
  final String? codeDecisionSessionRAP3;
  final String? libDecisionSessionRAP3;
  final double? moyPAP1;
  final double? moyRAP1;
  final double? moyPAP2;
  final double? moyRAP2;
  final double? moyPAP3;
  final double? moyRAP3;
  final int? nbImpReleve;
  final String codeBarre;
  final String moyBacEt;
  final String login;
  final String password;

  Student({
    required this.idEt,
    required this.nomEt,
    required this.prenomEt,
    required this.dateNaissance,
    required this.lieuNaissance,
    this.fonctionPere,
    this.fonctionMere,
    required this.adresse,
    required this.tel,
    required this.telParent,
    required this.email,
    required this.cycle,
    required this.natureBac,
    required this.dateBac,
    required this.numBac,
    required this.etabBac,
    this.diplomeSup,
    this.niveauDiplomeSup,
    required this.etabOrigine,
    required this.specialite,
    required this.dateEntree,
    required this.anneeEntree,
    required this.classeCourante,
    required this.situationFinanciere,
    required this.niveauCourant,
    this.moyenneDernSemestre,
    required this.resultatFinal,
    required this.diplomeObtenu,
    this.dateSortie,
    this.observation,
    required this.sexe,
    required this.nationalite,
    required this.cinPasseport,
    this.dateSaisie,
    this.dateDernModif,
    this.agent,
    this.numOrd,
    this.dateDelivrance,
    this.lieuDelivrance,
    required this.niveauAcces,
    required this.natureCours,
    required this.naturePieceId,
    required this.adresseParent,
    required this.cpParent,
    required this.villeParent,
    required this.paysParent,
    required this.cpEt,
    required this.villeEt,
    required this.paysEt,
    required this.emailParent,
    required this.telParentAlt,
    required this.typeEnreg,
    this.dateLieuNaissance,
    required this.codeEtabOrigine,
    required this.codeSpecOrigine,
    required this.libSpecOrigine,
    required this.classePrec,
    required this.idEtOrigin,
    required this.etat,
    this.justifEtat,
    required this.libJustifEtat,
    required this.idEtNew,
    required this.idEtOrigine,
    this.dateLastChangeEtat,
    this.dernUtilisateur,
    this.numCompte,
    this.banque,
    this.ribBanque,
    this.mp08,
    required this.typeEt,
    required this.codeNationalite,
    this.numPromotionCS,
    this.codeDecisionSessionPAP1,
    this.libDecisionSessionPAP1,
    this.codeDecisionSessionRAP1,
    this.libDecisionSessionRAP1,
    this.codeDecisionSessionPAP2,
    this.libDecisionSessionPAP2,
    this.codeDecisionSessionRAP2,
    this.libDecisionSessionRAP2,
    this.codeDecisionSessionPAP3,
    this.libDecisionSessionPAP3,
    this.codeDecisionSessionRAP3,
    this.libDecisionSessionRAP3,
    this.moyPAP1,
    this.moyRAP1,
    this.moyPAP2,
    this.moyRAP2,
    this.moyPAP3,
    this.moyRAP3,
    this.nbImpReleve,
    required this.codeBarre,
    required this.moyBacEt,
    required this.login,
    required this.password,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      idEt: json['idEt'],
      nomEt: json['nomEt'],
      prenomEt: json['prenomEt'],
      dateNaissance: DateTime.parse(json['dateNaissance']),
      lieuNaissance: json['lieuNaissance'],
      fonctionPere: json['fonctionPere'],
      fonctionMere: json['fonctionMere'],
      adresse: json['adresse'],
      tel: json['tel'],
      telParent: json['telParent'],
      email: json['email'],
      cycle: json['cycle'],
      natureBac: json['natureBac'],
      dateBac: DateTime.parse(json['dateBac']),
      numBac: json['numBac'],
      etabBac: json['etabBac'],
      diplomeSup: json['diplomeSup'],
      niveauDiplomeSup: json['niveauDiplomeSup'],
      etabOrigine: json['etabOrigine'],
      specialite: json['specialite'],
      dateEntree: DateTime.parse(json['dateEntree']),
      anneeEntree: json['anneeEntree'],
      classeCourante: json['classeCourante'],
      situationFinanciere: json['situationFinanciere'],
      niveauCourant: json['niveauCourant'],
      moyenneDernSemestre: json['moyenneDernSemestre'],
      resultatFinal: json['resultatFinal'],
      diplomeObtenu: json['diplomeObtenu'],
      dateSortie: json['dateSortie'] != null ? DateTime.parse(json['dateSortie']) : null,
      observation: json['observation'],
      sexe: json['sexe'],
      nationalite: json['nationalite'],
      cinPasseport: json['cinPasseport'],
      dateSaisie: json['dateSaisie'] != null ? DateTime.parse(json['dateSaisie']) : null,
      dateDernModif: json['dateDernModif'] != null ? DateTime.parse(json['dateDernModif']) : null,
      agent: json['agent'],
      numOrd: json['numOrd'],
      dateDelivrance: json['dateDelivrance'] != null ? DateTime.parse(json['dateDelivrance']) : null,
      lieuDelivrance: json['lieuDelivrance'],
      niveauAcces: json['niveauAcces'],
      natureCours: json['natureCours'],
      naturePieceId: json['naturePieceId'],
      adresseParent: json['adresseParent'],
      cpParent: json['cpParent'],
      villeParent: json['villeParent'],
      paysParent: json['paysParent'],
      cpEt: json['cpEt'],
      villeEt: json['villeEt'],
      paysEt: json['paysEt'],
      emailParent: json['emailParent'],
      telParentAlt: json['telParentAlt'],
      typeEnreg: json['typeEnreg'],
      dateLieuNaissance: json['dateLieuNaissance'],
      codeEtabOrigine: json['codeEtabOrigine'],
      codeSpecOrigine: json['codeSpecOrigine'],
      libSpecOrigine: json['libSpecOrigine'],
      classePrec: json['classePrec'],
      idEtOrigin: json['idEtOrigin'],
      etat: json['etat'],
      justifEtat: json['justifEtat'],
      libJustifEtat: json['libJustifEtat'],
      idEtNew: json['idEtNew'],
      idEtOrigine: json['idEtOrigine'],
      dateLastChangeEtat: json['dateLastChangeEtat'] != null ? DateTime.parse(json['dateLastChangeEtat']) : null,
      dernUtilisateur: json['dernUtilisateur'],
      numCompte: json['numCompte'],
      banque: json['banque'],
      ribBanque: json['ribBanque'],
      mp08: json['mp08'],
      typeEt: json['typeEt'],
      codeNationalite: json['codeNationalite'],
      numPromotionCS: json['numPromotionCS'],
      codeDecisionSessionPAP1: json['codeDecisionSessionPAP1'],
      libDecisionSessionPAP1: json['libDecisionSessionPAP1'],
      codeDecisionSessionRAP1: json['codeDecisionSessionRAP1'],
      libDecisionSessionRAP1: json['libDecisionSessionRAP1'],
      codeDecisionSessionPAP2: json['codeDecisionSessionPAP2'],
      libDecisionSessionPAP2: json['libDecisionSessionPAP2'],
      codeDecisionSessionRAP2: json['codeDecisionSessionRAP2'],
      libDecisionSessionRAP2: json['libDecisionSessionRAP2'],
      codeDecisionSessionPAP3: json['codeDecisionSessionPAP3'],
      libDecisionSessionPAP3: json['libDecisionSessionPAP3'],
      codeDecisionSessionRAP3: json['codeDecisionSessionRAP3'],
      libDecisionSessionRAP3: json['libDecisionSessionRAP3'],
      moyPAP1: json['moyPAP1'],
      moyRAP1: json['moyRAP1'],
      moyPAP2: json['moyPAP2'],
      moyRAP2: json['moyRAP2'],
      moyPAP3: json['moyPAP3'],
      moyRAP3: json['moyRAP3'],
      nbImpReleve: json['nbImpReleve'],
      codeBarre: json['codeBarre'],
      moyBacEt: json['moyBacEt'],
      login: json['login'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEt': idEt,
      'nomEt': nomEt,
      'prenomEt': prenomEt,
      'dateNaissance': dateNaissance.toIso8601String(),
      'lieuNaissance': lieuNaissance,
      'fonctionPere': fonctionPere,
      'fonctionMere': fonctionMere,
      'adresse': adresse,
      'tel': tel,
      'telParent': telParent,
      'email': email,
      'cycle': cycle,
      'natureBac': natureBac,
      'dateBac': dateBac.toIso8601String(),
      'numBac': numBac,
      'etabBac': etabBac,
      'diplomeSup': diplomeSup,
      'niveauDiplomeSup': niveauDiplomeSup,
      'etabOrigine': etabOrigine,
      'specialite': specialite,
      'dateEntree': dateEntree.toIso8601String(),
      'anneeEntree': anneeEntree,
      'classeCourante': classeCourante,
      'situationFinanciere': situationFinanciere,
      'niveauCourant': niveauCourant,
      'moyenneDernSemestre': moyenneDernSemestre,
      'resultatFinal': resultatFinal,
      'diplomeObtenu': diplomeObtenu,
      'dateSortie': dateSortie?.toIso8601String(),
      'observation': observation,
      'sexe': sexe,
      'nationalite': nationalite,
      'cinPasseport': cinPasseport,
      'dateSaisie': dateSaisie?.toIso8601String(),
      'dateDernModif': dateDernModif?.toIso8601String(),
      'agent': agent,
      'numOrd': numOrd,
      'dateDelivrance': dateDelivrance?.toIso8601String(),
      'lieuDelivrance': lieuDelivrance,
      'niveauAcces': niveauAcces,
      'natureCours': natureCours,
      'naturePieceId': naturePieceId,
      'adresseParent': adresseParent,
      'cpParent': cpParent,
      'villeParent': villeParent,
      'paysParent': paysParent,
      'cpEt': cpEt,
      'villeEt': villeEt,
      'paysEt': paysEt,
      'emailParent': emailParent,
      'telParentAlt': telParentAlt,
      'typeEnreg': typeEnreg,
      'dateLieuNaissance': dateLieuNaissance,
      'codeEtabOrigine': codeEtabOrigine,
      'codeSpecOrigine': codeSpecOrigine,
      'libSpecOrigine': libSpecOrigine,
      'classePrec': classePrec,
      'idEtOrigin': idEtOrigin,
      'etat': etat,
      'justifEtat': justifEtat,
      'libJustifEtat': libJustifEtat,
      'idEtNew': idEtNew,
      'idEtOrigine': idEtOrigine,
      'dateLastChangeEtat': dateLastChangeEtat?.toIso8601String(),
      'dernUtilisateur': dernUtilisateur,
      'numCompte': numCompte,
      'banque': banque,
      'ribBanque': ribBanque,
      'mp08': mp08,
      'typeEt': typeEt,
      'codeNationalite': codeNationalite,
      'numPromotionCS': numPromotionCS,
      'codeDecisionSessionPAP1': codeDecisionSessionPAP1,
      'libDecisionSessionPAP1': libDecisionSessionPAP1,
      'codeDecisionSessionRAP1': codeDecisionSessionRAP1,
      'libDecisionSessionRAP1': libDecisionSessionRAP1,
      'codeDecisionSessionPAP2': codeDecisionSessionPAP2,
      'libDecisionSessionPAP2': libDecisionSessionPAP2,
      'codeDecisionSessionRAP2': codeDecisionSessionRAP2,
      'libDecisionSessionRAP2': libDecisionSessionRAP2,
      'codeDecisionSessionPAP3': codeDecisionSessionPAP3,
      'libDecisionSessionPAP3': libDecisionSessionPAP3,
      'codeDecisionSessionRAP3': codeDecisionSessionRAP3,
      'libDecisionSessionRAP3': libDecisionSessionRAP3,
      'moyPAP1': moyPAP1,
      'moyRAP1': moyRAP1,
      'moyPAP2': moyPAP2,
      'moyRAP2': moyRAP2,
      'moyPAP3': moyPAP3,
      'moyRAP3': moyRAP3,
      'nbImpReleve': nbImpReleve,
      'codeBarre': codeBarre,
      'moyBacEt': moyBacEt,
      'login': login,
      'password': password,
    };
  }
}
