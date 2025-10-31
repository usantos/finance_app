import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financial_app/core/components/custom_bottom_sheet.dart';
import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/presentation/screens/components/bottom_sheet_edit_profile.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'components/custom_appbar.dart';
import 'components/skeleton.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authViewModel = sl.get<AuthViewModel>();
  final _accountViewModel = sl.get<AccountViewModel>();
  bool _showSkeleton = true;

  @override
  void initState() {
    super.initState();
    _authViewModel.checkCurrentUser();

    _showSkeleton = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showSkeleton = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authViewModel),
        ChangeNotifierProvider.value(value: _accountViewModel),
      ],
      child: Consumer2<AuthViewModel, AccountViewModel>(
        builder: (context, authVM, accountVM, _) {
          if (_showSkeleton) {
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: CustomAppbar(title: widget.title, description: widget.description),
              body: const Padding(
                padding: EdgeInsets.only(top: 30),
                child: SingleChildScrollView(child: LoadSkeleton(itemCount: 8)),
              ),
            );
          }
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: CustomAppbar(title: widget.title, description: widget.description),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildUserInfoCard(authVM, accountVM),
                    const SizedBox(height: 14),
                    _buildMenuOption(
                      icon: Icons.edit_outlined,
                      text: 'Editar dados pessoais',
                      onTap: () {
                        CustomBottomSheet.show(
                          iconClose: false,
                          context,
                          height: MediaQuery.of(context).size.height * 0.7,
                          isDismissible: true,
                          enableDrag: false,
                          child: const BottomSheetEditProfile(),
                        );
                      },
                    ),
                    _buildMenuOption(icon: Icons.settings_outlined, text: 'Configurações', onTap: () {}),
                    _buildMenuOption(icon: Icons.notifications_outlined, text: 'Notificações', onTap: () {}),
                    _buildMenuOption(icon: Icons.shield_outlined, text: 'Segurança', onTap: () {}),
                    _buildMenuOption(icon: Icons.help_outline, text: 'Ajuda e suporte', onTap: () {}),
                    const SizedBox(height: 16),
                    _buildVerifiedAccountCard(),
                    const SizedBox(height: 16),
                    const Text('Versão do aplicativo', style: TextStyle(color: AppColors.blackText)),
                    const Text(
                      '1.0.0',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                    ),
                    const SizedBox(height: 16),
                    _buildLogoutButton(context, authVM),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoCard(AuthViewModel authVM, AccountViewModel accountVM) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      shadowColor: AppColors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    authVM.currentUser?.user.name.firstLetter ?? "",
                    style: const TextStyle(color: AppColors.white, fontSize: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authVM.currentUser?.user.name ?? '-',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
                    ),
                    Text(
                      'Conta: ${accountVM.account?.accountNumber ?? '-'}',
                      style: const TextStyle(color: AppColors.black),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 30),
            _buildInfoRow('E-mail', authVM.currentUser?.user.email ?? '-'),
            const SizedBox(height: 16),
            _buildInfoRow('Telefone', authVM.currentUser?.user.phone.maskPhoneMid() ?? '-'),
            const SizedBox(height: 16),
            _buildInfoRow('CPF', authVM.currentUser?.user.cpf.maskCPFMid() ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.black)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.black),
        ),
      ],
    );
  }

  Widget _buildMenuOption({required IconData icon, required String text, required VoidCallback onTap}) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.grey),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.black),
        title: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.black),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.black),
        onTap: onTap,
      ),
    );
  }

  Widget _buildVerifiedAccountCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greenShade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.green),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user_outlined, color: AppColors.green),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conta verificada',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.black),
                ),
                Text('Sua conta está totalmente verificada e segura', style: TextStyle(color: AppColors.blackText)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthViewModel authVM) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        icon: const Icon(Icons.logout),
        label: const Text('Sair da conta', style: TextStyle(color: AppColors.red)),
        onPressed: () async {
          await authVM.logout();
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/');
          }
        },
        style: TextButton.styleFrom(
          foregroundColor: AppColors.red,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.red),
          ),
        ),
      ),
    );
  }
}
