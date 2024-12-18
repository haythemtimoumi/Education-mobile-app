import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SocieteDetails extends StatefulWidget {
  final String studentId;

  SocieteDetails({required this.studentId});

  @override
  _SocieteDetailsState createState() => _SocieteDetailsState();
}

class _SocieteDetailsState extends State<SocieteDetails> {
  late Future<Map<String, dynamic>> _societeFuture;

  @override
  void initState() {
    super.initState();
    _societeFuture = ApiService().fetchSocieteByStudent(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Societe Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _societeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            final societe = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildInfoSection(
                    icon: Icons.business,
                    label: 'Nom',
                    value: societe['NOM_SOC'] as String?,
                  ),
                  _buildInfoSection(
                    icon: Icons.location_on,
                    label: 'Adresse',
                    value: societe['ADR_SOC'] as String?,
                  ),
                  _buildContactCard(
                    icon: Icons.phone,
                    label: 'Téléphone',
                    value: societe['TEL_SOC'] as String?,
                  ),
                  _buildContactCard(
                    icon: Icons.print,
                    label: 'Fax',
                    value: societe['FAX_SOC'] as String?,
                  ),
                  _buildContactCard(
                    icon: Icons.email,
                    label: 'Email',
                    value: societe['E_MAIL'] as String?,
                  ),
                  _buildInfoSection(
                    icon: Icons.location_city,
                    label: 'Code Postal',
                    value: societe['CODE_POSTAL'] as String?,
                  ),
                  _buildInfoSection(
                    icon: Icons.location_city,
                    label: 'Ville',
                    value: societe['VILLE'] as String?,
                  ),
                  _buildInfoSection(
                    icon: Icons.account_balance_wallet,
                    label: 'RIB',
                    value: societe['RIB'] as String?,
                  ),
                  _buildInfoSection(
                    icon: Icons.account_balance,
                    label: 'Banque',
                    value: societe['BANQUE'] as String?,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String label,
    required String? value, // Make value nullable
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurpleAccent),
          SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A', // Provide a default value if null
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String? value, // Make value nullable
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.deepPurpleAccent,
              child: Icon(icon, color: Colors.white),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value ?? 'N/A', // Provide a default value if null
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
