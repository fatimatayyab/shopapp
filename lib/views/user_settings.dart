import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mitt konto',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // User Information Section
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'myname@gmail.com',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '07XXXXXXXX',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Menu Options
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.black),
            title: const Text('Kontoinställningar'),
            onTap: () {
              // Add action here
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment, color: Colors.black),
            title: const Text('Mina betalmetoder'),
            onTap: () {
              // Add action here
            },
          ),
          ListTile(
            leading: const Icon(Icons.support_agent, color: Colors.black),
            title: const Text('Support'),
            onTap: () {
              // Add action here
            },
          ),
        ],
      ),
    );
  }
}
