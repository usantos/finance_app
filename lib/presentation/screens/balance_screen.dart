import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  final authViewModel = sl.get<AuthViewModel>();
  final accountViewModel = sl.get<AccountViewModel>();

  late Future<void> _future;

  Future<void> _loadData() async {
    await authViewModel.checkCurrentUser();
    if (authViewModel.currentUser != null) {
      await accountViewModel.fetchAccount();
    }
  }

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountViewModel>(
      builder: (context, accountViewModel, child) {
        return FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (snapshot.hasError) {
              return Scaffold(body: Center(child: Text('Erro: ${snapshot.error}')));
            }

            if (accountViewModel.account == null) {
              return const Scaffold(body: Center(child: Text('Nenhuma conta encontrada')));
            }

            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saldo em conta',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      accountViewModel.displayBalance,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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
                                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
      },
    );
  }
}
