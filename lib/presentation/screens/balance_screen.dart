import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  Future<void> _loadData() async {
    final authViewModel = sl.get<AuthViewModel>();
    final accountViewModel = sl.get<AccountViewModel>();

    // 1️⃣ Checa se existe usuário logado
    await authViewModel.checkCurrentUser();

    // 2️⃣ Se existir, carrega a conta
    if (authViewModel.currentUser != null) {
      await accountViewModel.fetchAccount(authViewModel.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountViewModel = sl.get<AccountViewModel>();

    return FutureBuilder<void>(
      future: _loadData(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Erro ao carregar dados
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Erro: ${snapshot.error}')),
          );
        }

        // Nenhuma conta encontrada
        if (accountViewModel.account == null) {
          return const Scaffold(
            body: Center(child: Text('Nenhuma conta encontrada')),
          );
        }

        // Conta carregada com sucesso
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saldo em conta',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  accountViewModel.displayBalance,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: accountViewModel.nomes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.teal,
                              child: SvgPicture.asset(
                                accountViewModel.iconAssets[index],
                                width: 32,
                                height: 32,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              accountViewModel.nomes[index],
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
