import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:thebestoutfit/components/avatar.dart';
import 'package:thebestoutfit/constant.dart';
import 'package:thebestoutfit/principale/main_principale.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final nom = _nomController.text;
    final prenom = _prenomController.text;
    final twitter = _twitterController.text;
    final instagram = _instagramController.text;
    final tiktok = _tiktokController.text;
    final user = supabase.auth.currentUser;
    final updates = {
      'id': user!.id,
      'nom': nom,
      'prenom': prenom,
      'twitter': twitter,
      'instagram': instagram,
      'tiktok': tiktok,
      'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      await supabase.from('profiles').upsert(updates);
      if (mounted) {
        context.showSnackBar(message: 'Successfully updated profile!');
      }
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpeted error occurred');
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected error occurred');
    }
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _twitterController.dispose();
    _instagramController.dispose();
    _tiktokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          TextFormField(
            controller: _nomController,
            decoration: const InputDecoration(labelText: 'Nom'),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _prenomController,
            decoration: const InputDecoration(labelText: 'Prenom'),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _twitterController,
            decoration: const InputDecoration(labelText: 'Twitter'),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _instagramController,
            decoration: const InputDecoration(labelText: 'Instagram'),
          ),
          const SizedBox(height: 18),  
          TextFormField(
            controller: _tiktokController,
            decoration: const InputDecoration(labelText: 'Tiktok'),
          ),
          const SizedBox(height: 18),                  
          ElevatedButton(
            onPressed: _updateProfile,
            child: Text(_loading ? 'Saving...' : 'Update'),
          ),
          const SizedBox(height: 18),
          TextButton(onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MainPrincipalePage()),
                        );
                      }, child: const Text('Go to the next page')),
          TextButton(onPressed: _signOut, child: const Text('Sign Out')),
        ],
      ),
    );
  }
}