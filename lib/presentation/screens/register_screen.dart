import 'package:financial_app/core/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  final _authViewModel = sl.get<AuthViewModel>();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
      _clearErrors();
    });
  }

  void _clearErrors() {
    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 13, 35),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
        title: const Text('Entrar', style: TextStyle(color: Colors.white, fontSize: 22)),
        backgroundColor: const Color.fromARGB(255, 2, 13, 35),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              height: 360,
              width: MediaQuery.of(context).size.width * 0.95,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Cadastro',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color.fromARGB(255, 20, 24, 56),
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        filled: true,
                        fillColor: const Color.fromARGB(255, 242, 242, 242),
                        labelText: 'Usuário',
                        labelStyle: const TextStyle(fontSize: 14),
                        prefixIcon: const Icon(Icons.person, size: 18),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      validator: _authViewModel.validateUser,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        filled: true,
                        fillColor: const Color.fromARGB(255, 242, 242, 242),
                        labelText: 'Email',
                        labelStyle: const TextStyle(fontSize: 14),
                        prefixIcon: const Icon(Icons.email, size: 18),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      validator: _authViewModel.validateEmail,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        filled: true,
                        fillColor: const Color.fromARGB(255, 242, 242, 242),
                        labelText: 'Senha',
                        labelStyle: const TextStyle(fontSize: 14),
                        prefixIcon: const Icon(Icons.lock, size: 18),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      validator: _authViewModel.validatePassword,
                    ),
                    const SizedBox(height: 24),

                    Consumer<AuthViewModel>(
                      builder: (context, authViewModel, child) {
                        return authViewModel.isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                                  ),
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    final success = await authViewModel.register(
                                      _usernameController.text,
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                    if (!context.mounted) return;
                                    if (success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Cadastro realizado com sucesso! Faça login.')),
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(authViewModel.errorMessage ?? 'Erro no cadastro'),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    }
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Icon(Icons.app_registration), SizedBox(width: 8), Text('Cadastrar')],
                                  ),
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
