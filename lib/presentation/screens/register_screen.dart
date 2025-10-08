import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/core/utils.dart';
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
  final _cpfFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String _rawCpf = "";
  String _rawPhone = "";

  @override
  void dispose() {
    _cpfController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
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
    _cpfController.clear();
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _passwordController.clear();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          icon: const Icon(Icons.arrow_back, color: AppColors.white, size: 28),
        ),
        title: const Text('Entrar', style: TextStyle(color: AppColors.white, fontSize: 22)),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width * 0.95,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    const Text(
                      'Cadastro',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: AppColors.black),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _nameController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        filled: true,
                        fillColor: AppColors.greyBackground,
                        labelText: 'Nome',
                        labelStyle: const TextStyle(fontSize: 14, color: AppColors.blackText),
                        prefixIcon: const Icon(Icons.person, size: 18, color: AppColors.black),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      validator: Utils.validateName,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: _cpfFieldKey,
                      keyboardType: TextInputType.number,
                      maxLength: 14,
                      buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                      controller: _cpfController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        filled: true,
                        fillColor: AppColors.greyBackground,
                        labelText: 'Cpf',
                        labelStyle: const TextStyle(fontSize: 14, color: AppColors.blackText),
                        prefixIcon: const Icon(Icons.assignment_ind, size: 18, color: AppColors.black),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      validator: Utils.validateCpf,
                      onChanged: (value) {
                        _rawCpf = value.replaceAll(RegExp(r'\D'), '');
                        setState(() {
                          _cpfController.text = _rawCpf.toCPFProgressive();
                        });
                      },
                      onEditingComplete: () {
                        if (!(_cpfFieldKey.currentState?.validate() ?? false)) {
                          _cpfController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _cpfController.text.length),
                          );
                          return;
                        }
                        FocusScope.of(context).unfocus();
                      },
                    ),

                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 11,
                      buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                      controller: _phoneController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        filled: true,
                        fillColor: AppColors.greyBackground,
                        labelText: 'Telefone',
                        labelStyle: const TextStyle(fontSize: 14, color: AppColors.blackText),
                        prefixIcon: const Icon(Icons.phone, size: 18, color: AppColors.black),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      validator: Utils.validatePhone,
                      onChanged: (value) {
                        _rawPhone = value.replaceAll(RegExp(r'\D'), '');
                        setState(() {
                          _phoneController.text = _rawPhone.toPhone();
                        });
                      },
                    ),

                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        filled: true,
                        fillColor: AppColors.greyBackground,
                        labelText: 'Email',
                        labelStyle: const TextStyle(fontSize: 14, color: AppColors.blackText),
                        prefixIcon: const Icon(Icons.email, size: 18, color: AppColors.black),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      validator: Utils.validateEmail,
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
                        fillColor: AppColors.greyBackground,
                        labelText: 'Senha',
                        labelStyle: const TextStyle(fontSize: 14, color: AppColors.blackText),
                        prefixIcon: const Icon(Icons.lock, size: 18, color: AppColors.black),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      validator: Utils.validatePassword,
                    ),

                    const SizedBox(height: 16),

                    Consumer<AuthViewModel>(
                      builder: (context, authViewModel, child) {
                        return authViewModel.isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                                  ),
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    final userRequest = authViewModel.toUserRequest(
                                      _nameController.text,
                                      _rawCpf,
                                      _rawPhone,
                                      _emailController.text,
                                      _passwordController.text,
                                    );

                                    final success = await authViewModel.register(userRequest);

                                    if (!context.mounted) return;

                                    if (!success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(authViewModel.errorMessage ?? 'Erro no cadastro'),
                                          backgroundColor: AppColors.redError,
                                        ),
                                      );
                                    } else {
                                      Navigator.popAndPushNamed(context, '/home');
                                    }
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.app_registration, color: AppColors.white),
                                      SizedBox(width: 8),
                                      Text('Cadastrar', style: TextStyle(color: AppColors.white)),
                                    ],
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
