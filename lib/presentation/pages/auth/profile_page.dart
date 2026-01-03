import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController nameController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    nameController.text = user?.displayName ?? "";
  }

  Future<void> updateProfile() async {
    if (nameController.text.isEmpty) return;

    try {
      setState(() => loading = true);

      await user?.updateDisplayName(nameController.text);
      await user?.reload(); // refreshes the user data
      final updatedUser = FirebaseAuth.instance.currentUser;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully"),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        nameController.text = updatedUser?.displayName ?? "";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Update failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xffb51837),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // header gradient
            Container(
              height: size.height * 0.25,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffb51837), Color(0xff661c3a)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Color(0xffb51837),
                          )
                        : null,
                  ),

                  const SizedBox(height: 10),
                  Text(
                    user?.displayName ?? "Your Name",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user?.email ?? "Email not set",
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            //Info cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _infoCard("UID", user?.uid ?? "N/A"),
                  const SizedBox(height: 15),
                  _infoCard("Email", user?.email ?? "N/A"),
                  const SizedBox(height: 15),

                  // editable Display name

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5, 
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [const Text(
                      "Display Name",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                    ),
                    const SizedBox(height: 10),

                    TextField(controller: nameController, decoration: InputDecoration(
                      hintText: "Enter your name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                      ), 
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),),

        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity, height: 50, 
          child: ElevatedButton(
                              onPressed: loading ? null : updateProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffb51837),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ), 
            child: loading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      "Update Profile",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                      ),
                                    ),
            ),
        )
                    ],
                    ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to display UID and Email in cards
  Widget _infoCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5, 
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        leading: const Icon(Icons.info_outline,
        color:  Color(0xffb51837),
        ),
        
      ),
    );
  }
}
