import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:thebestoutfit/components/avatar.dart';
import 'package:thebestoutfit/constant.dart';



class MainPrincipalePage extends StatefulWidget {
  const MainPrincipalePage({super.key});

  @override
  _MainPrincipalePageState createState() => _MainPrincipalePageState();
}

class _MainPrincipalePageState extends State<MainPrincipalePage> {


  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _twitterController = TextEditingController();
  final _instagramController = TextEditingController();
  final _tiktokController = TextEditingController();
  String? _avatarUrl;
  var _loading = false;

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single() as Map;
      _nomController.text = (data['nom'] ?? '') as String;
      _prenomController.text = (data['prenom'] ?? '') as String;
      _twitterController.text = (data['twitter'] ?? '') as String;
      _instagramController.text = (data['instagram'] ?? '') as String;
      _tiktokController.text = (data['tiktok'] ?? '') as String;
      _avatarUrl = (data['avatar_url'] ?? '') as String;
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected exception occurred');
    }

    setState(() {
      _loading = false;
    });
  }   

  @override
  void initState() {
    super.initState();
    _getProfile();
  } 

 @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          Text('BONJOUR ' + _nomController.text)          
        ],
      ),
    );
  }
}