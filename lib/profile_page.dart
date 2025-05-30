import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String email;
  const ProfilePage({required this.email, Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  ImageProvider avatarImage = const AssetImage('assets/default_avatar.png');
  bool _saving = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(widget.email);
    if (userData != null) {
      final Map<String, dynamic> userMap = json.decode(userData);
      _nameController.text = userMap['name'] ?? '';
      final imagePath = userMap['image'];
      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (await file.exists()) {
          setState(() {
            avatarImage = FileImage(file);
          });
          return;
        }
      }
    }
    setState(() {
      avatarImage = const AssetImage('assets/default_avatar.png');
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked != null) {
      setState(() {
        avatarImage = FileImage(File(picked.path));
      });
      await _saveUserData(imagePath: picked.path);
    }
  }

  Future<void> _saveUserData({String? imagePath}) async {
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();

    final data = {
      'name': _nameController.text.trim(),
      'image': imagePath ?? '',
    };
    await prefs.setString(widget.email, json.encode(data));
    setState(() => _saving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profil salvat cu succes')));
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blueAccent = Colors.blueAccent;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Profil', style: TextStyle(color: blueAccent)),
        iconTheme: IconThemeData(color: blueAccent),
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: avatarImage,
                      backgroundColor: Colors.grey[900],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: blueAccent,
                          child: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nume complet',
                  labelStyle: TextStyle(color: blueAccent),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: blueAccent, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saving ? null : () => _saveUserData(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: blueAccent.withOpacity(0.6),
                ),
                child: _saving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Salvează profil',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
