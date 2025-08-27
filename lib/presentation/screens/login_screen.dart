import 'package:financial_app/core/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final _authViewModel = sl.get<AuthViewModel>();

  @override
  void initState() {
    super.initState();
    _authViewModel.addListener(_authListener);
  }

  void _authListener() {
    if (!mounted) return;
    setState(() {
      _isLoading = _authViewModel.isLoading;
    });
  }

  @override
  void dispose() {
    _authViewModel.removeListener(_authListener);
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet_rounded, size: 64, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Bem-vindo de volta!',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Usuário',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: _authViewModel.validateUser,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: _authViewModel.validatePassword,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              final success = await _authViewModel.login(
                                _usernameController.text,
                                _passwordController.text,
                              );

                              if (!context.mounted) return;

                              if (success) {
                                Navigator.pushReplacementNamed(context, '/home');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(_authViewModel.errorMessage ?? 'Erro de login'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [Icon(Icons.login), SizedBox(width: 8), Text('Entrar')],
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Não tem uma conta? Cadastre-se'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
