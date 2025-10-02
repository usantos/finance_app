import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/injection_container.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFF2C2C54),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width * 0.95,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_balance_wallet_rounded, size: 64, color: colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Bem-vindo',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 20, 24, 56),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Entre na sua conta',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 102, 108, 153),
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
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
                        fillColor: const Color.fromARGB(255, 242, 242, 242),
                        labelText: 'Cpf',
                        labelStyle: const TextStyle(fontSize: 14),
                        prefixIcon: const Icon(Icons.assignment_ind, size: 18),
                        suffixIcon: _isCpfMasked
                            ? IconButton(
                                icon: const Icon(Icons.edit),
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
                        return _authViewModel.validateCpf(cpf);
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
                        labelStyle: const TextStyle(fontSize: 14),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 242, 242, 242),
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

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
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
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Icon(Icons.login), SizedBox(width: 8), Text('Entrar')],
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Não tem uma conta?'),
                        TextButton(
                          onPressed: () {
                            _clearErrors();
                            Navigator.pushReplacementNamed(context, '/register');
                          },
                          child: const Text('Cadastre-se', style: TextStyle(color: Colors.black)),
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
