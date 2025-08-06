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
  late AccountViewModel _accountViewModel;
  bool _isLoading = false;
  bool _saldoVisivel = true;

  void _accountListener() {
    if (!mounted) return;
    setState(() {
      _isLoading = _accountViewModel.isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    _accountViewModel = Provider.of<AccountViewModel>(context, listen: false);
    _accountViewModel.addListener(_accountListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      if (authViewModel.currentUser != null) {
        Provider.of<AccountViewModel>(context, listen: false).fetchAccount(authViewModel.currentUser!.id);
      }
    });
  }

  @override
  void dispose() {
    _accountViewModel.removeListener(_accountListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AccountViewModel>(
        builder: (context, accountViewModel, child) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (accountViewModel.errorMessage != null) {
            return Center(child: Text('Erro: ${accountViewModel.errorMessage}'));
          } else if (accountViewModel.account == null) {
            // TODO criar tela de erro
            return const SizedBox.shrink();
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Saldo em conta',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          _saldoVisivel == true
                              ? Text(
                                  'R\$ ${accountViewModel.account!.balance.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  '•••••',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          if (_saldoVisivel == true) {
                            setState(() {
                              _saldoVisivel = false;
                            });
                          } else {
                            setState(() {
                              _saldoVisivel = true;
                            });
                          }
                        },
                        icon: _saldoVisivel == true ? Icon(Icons.remove_red_eye_outlined) : Icon(Icons.remove_red_eye),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: accountViewModel.nomes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: GestureDetector(
                              onTap: () {},
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.teal,
                                    child: SvgPicture.asset(
                                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                      accountViewModel.iconAssets[index],
                                      width: 32,
                                      height: 32,
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
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
