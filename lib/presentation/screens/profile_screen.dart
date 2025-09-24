import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'components/custom_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authViewModel = sl.get<AuthViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          CustomAppbar(title: widget.title, description: widget.description),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildUserInfoCard(),
                  const SizedBox(height: 24),
                  _buildMenuOption(icon: Icons.edit_outlined, text: 'Editar dados pessoais', onTap: () {}),
                  _buildMenuOption(icon: Icons.settings_outlined, text: 'Configurações', onTap: () {}),
                  _buildMenuOption(icon: Icons.notifications_outlined, text: 'Notificações', onTap: () {}),
                  _buildMenuOption(icon: Icons.shield_outlined, text: 'Segurança', onTap: () {}),
                  _buildMenuOption(icon: Icons.help_outline, text: 'Ajuda e suporte', onTap: () {}),
                  const SizedBox(height: 24),
                  _buildVerifiedAccountCard(),
                  const SizedBox(height: 24),
                  const Text('Versão do aplicativo', style: TextStyle(color: Colors.grey)),
                  const Text('1.0.0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  _buildLogoutButton(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFF2C2C54),
                  child: Text('J', style: TextStyle(color: Colors.white, fontSize: 24)),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('João Silva', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Conta: 12345-6', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const Divider(height: 30),
            _buildInfoRow('E-mail', 'joao.silva@email.com'),
            const SizedBox(height: 16),
            _buildInfoRow('Telefone', '(11) 99999-9999'),
            const SizedBox(height: 16),
            _buildInfoRow('CPF', '123.456.789-00'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }

  Widget _buildMenuOption({required IconData icon, required String text, required VoidCallback onTap}) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildVerifiedAccountCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user_outlined, color: Colors.green.shade700),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Conta verificada', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Sua conta está totalmente verificada e segura'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        icon: const Icon(Icons.logout),
        label: const Text('Sair da conta'),
        onPressed: () {
          _authViewModel.logout();
          Navigator.pushReplacementNamed(context, '/');
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
