import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _cpfFieldKey = GlobalKey<FormFieldState>();
  final FocusNode _cpfFocusNode = FocusNode();
  final _authViewModel = sl.get<AuthViewModel>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isCpfMasked = false;
  String _rawCpf = "";

  @override
  void initState() {
    super.initState();

    _authViewModel.addListener(_authListener);
    _cpfFocusNode.addListener(() {
      if (!_cpfFocusNode.hasFocus) {
        _maskCpfIfComplete();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
      _clearErrors();
    });
  }

  void _clearErrors() {
    _cpfController.clear();
    _passwordController.clear();
    _formKey.currentState?.reset();
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
    _cpfController.dispose();
    _passwordController.dispose();
    _cpfFocusNode.dispose();
    super.dispose();
  }

  void _maskCpfIfComplete() {
    if (_rawCpf.length == 11 && !_isCpfMasked) {
      setState(() {
        _cpfController.text = _rawCpf.maskCPFMid();
        _cpfController.selection = TextSelection.fromPosition(TextPosition(offset: _cpfController.text.length));
        _isCpfMasked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
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
                    Icon(Icons.account_balance_wallet_rounded, size: 64, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text('Bem-vindo', style: TextStyle(color: AppColors.blackText, fontSize: 25)),
                    const SizedBox(height: 8),
                    Text('Entre na sua conta', style: TextStyle(color: AppColors.blackText)),
                    const SizedBox(height: 20),

                    TextFormField(
                      key: _cpfFieldKey,
                      controller: _cpfController,
                      focusNode: _cpfFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 11,
                      buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                      style: const TextStyle(fontSize: 14),
                      readOnly: _isCpfMasked,
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        filled: true,
                        fillColor: AppColors.greyBackground,
                        labelText: 'Cpf',
                        labelStyle: const TextStyle(fontSize: 14, color: AppColors.blackText),
                        prefixIcon: const Icon(Icons.assignment_ind, size: 18, color: AppColors.black),
                        suffixIcon: _isCpfMasked
                            ? IconButton(
                                icon: const Icon(Icons.edit, color: AppColors.black),
                                onPressed: () {
                                  setState(() {
                                    _isCpfMasked = false;
                                    _cpfController.text = _rawCpf.toCPFProgressive();
                                    _cpfController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: _cpfController.text.length),
                                    );
                                    _cpfFocusNode.requestFocus();
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      validator: (_) {
                        final cpf = _rawCpf;
                        return Utils.validateCpf(cpf);
                      },
                      onChanged: (value) {
                        _rawCpf = value.replaceAll(RegExp(r'\D'), '');
                        if (!_isCpfMasked) {
                          setState(() {
                            _cpfController.text = _rawCpf.toCPFProgressive();
                            _cpfController.selection = TextSelection.fromPosition(
                              TextPosition(offset: _cpfController.text.length),
                            );
                          });
                        }
                      },
                      onEditingComplete: () {
                        if (_rawCpf.length == 11 && !_isCpfMasked) {
                          if (!_cpfFieldKey.currentState!.validate()) {
                            return;
                          }
                          setState(() {
                            _cpfController.text = _rawCpf.maskCPFMid();
                            _cpfController.selection = TextSelection.fromPosition(
                              TextPosition(offset: _cpfController.text.length),
                            );
                            _isCpfMasked = true;
                          });
                        }
                      },
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
                        labelText: 'Senha',
                        labelStyle: const TextStyle(fontSize: 14, color: AppColors.blackText),
                        filled: true,
                        fillColor: AppColors.greyBackground,
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

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                final success = await _authViewModel.login(_rawCpf, _passwordController.text);

                                if (!context.mounted) return;

                                if (success) {
                                  Navigator.pushReplacementNamed(context, '/home');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(_authViewModel.errorMessage ?? 'Erro de login'),
                                      backgroundColor: AppColors.redError,
                                    ),
                                  );
                                }
                              },
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2.5),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login, color: AppColors.white),
                                  SizedBox(width: 8),
                                  Text('Entrar', style: TextStyle(color: AppColors.white)),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Não tem uma conta?', style: TextStyle(color: AppColors.blackText)),
                        TextButton(
                          onPressed: () {
                            _clearErrors();
                            Navigator.pushReplacementNamed(context, '/register');
                          },
                          child: const Text('Cadastre-se', style: TextStyle(color: AppColors.blackText)),
                        ),
                      ],
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
