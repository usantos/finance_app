import 'package:financial_app/core/components/template.dart';
import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/core/utils.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetCreatePixKey extends StatefulWidget {
  const BottomSheetCreatePixKey({super.key});

  @override
  State<BottomSheetCreatePixKey> createState() => _BottomSheetCreatePixKeyState();
}

class _BottomSheetCreatePixKeyState extends State<BottomSheetCreatePixKey> {
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    authVM.checkCurrentUser();
    _telefoneController.addListener(() {
      final raw = _telefoneController.text.replaceAll(RegExp(r'\D'), '');
      if (_telefoneController.text != raw.toPhone()) {
        _telefoneController.value = TextEditingValue(
          text: raw.toPhone(),
          selection: TextSelection.collapsed(offset: raw.toPhone().length),
        );
      }
    });

    _cpfController.addListener(() {
      final raw = _cpfController.text.replaceAll(RegExp(r'\D'), '');
      if (_cpfController.text != raw.toCPFProgressive()) {
        _cpfController.value = TextEditingValue(
          text: raw.toCPFProgressive(),
          selection: TextSelection.collapsed(offset: raw.toCPFProgressive().length),
        );
      }
    });
  }

  void _openTemplate({
    required String title,
    required String typeTitle,
    required String buttonText,
    String? description,
    String? footerDescription,
    TextEditingController? controller,
    Widget? body,
    required String method,
  }) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemplateScreen(
          title: title,
          typeTitle: typeTitle,
          buttonText: buttonText,
          description: description,
          footerDescription: footerDescription,
          textController: controller,
          body:
              body ??
              TextFormField(
                controller: controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite um valor válido';
                  }
                  return null;
                },
              ),
          method: method,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransactionViewModel, AuthViewModel>(
      builder: (context, transactionVM, authVM, child) {
        final pixKeys = transactionVM.pixKeys;

        bool hasKey(String type) {
          return pixKeys.any((key) => key?['keyType'] == type);
        }

        return Column(
          children: [
            const SizedBox(height: 20),

            if (!hasKey('Telefone')) ...[
              Row(
                children: [
                  const Icon(Icons.phone_android, color: AppColors.black, size: 25),
                  const SizedBox(width: 12),
                  const Text(
                    "Telefone",
                    style: TextStyle(fontSize: 18, fontWeight: .bold, color: AppColors.black),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      _telefoneController.text = authVM.currentUser?.user.phone ?? '';
                      _openTemplate(
                        title: 'Registrar telefone',
                        typeTitle: 'Telefone',
                        description: 'Insira o telefone para ser registrado como chave Pix',
                        buttonText: 'Cadastrar chave',
                        controller: _telefoneController,
                        body: TextFormField(
                          controller: _telefoneController,
                          keyboardType: .phone,
                          validator: Utils.validatePhone,
                        ),
                        method: 'Create Pix',
                      );
                    },
                    icon: const Icon(Icons.add, color: AppColors.black, size: 25),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            if (!hasKey('CPF')) ...[
              Row(
                children: [
                  const Icon(Icons.credit_card, color: AppColors.black, size: 25),
                  const SizedBox(width: 12),
                  const Text(
                    "CPF",
                    style: TextStyle(fontSize: 18, fontWeight: .bold, color: AppColors.black),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      _cpfController.text = authVM.currentUser?.user.cpf ?? '';
                      _openTemplate(
                        title: 'Registrar CPF',
                        typeTitle: 'CPF',
                        description: 'Insira o CPF para ser registrado como chave Pix',
                        buttonText: 'Cadastrar chave',
                        controller: _cpfController,
                        body: TextFormField(
                          controller: _cpfController,
                          keyboardType: .number,
                          validator: Utils.validateCpf,
                        ),
                        method: 'Create Pix',
                      );
                    },
                    icon: const Icon(Icons.add, color: AppColors.black, size: 25),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            if (!hasKey('Email')) ...[
              Row(
                children: [
                  const Icon(Icons.email_outlined, color: AppColors.black, size: 25),
                  const SizedBox(width: 12),
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 18, fontWeight: .bold, color: AppColors.black),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      _emailController.text = authVM.currentUser?.user.email ?? '';
                      _openTemplate(
                        title: 'Registrar Email',
                        typeTitle: 'Email',
                        description: 'Insira o Email para ser registrado como chave Pix',
                        buttonText: 'Cadastrar chave',
                        controller: _emailController,
                        body: TextFormField(
                          controller: _emailController,
                          keyboardType: .emailAddress,
                          validator: Utils.validateEmail,
                        ),
                        method: 'Create Pix',
                      );
                    },
                    icon: const Icon(Icons.add, color: AppColors.black, size: 25),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            if (!hasKey('Aleatoria')) ...[
              Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.black, size: 25),
                  const SizedBox(width: 12),
                  const Text(
                    "Chave aleatória",
                    style: TextStyle(fontSize: 18, fontWeight: .bold, color: AppColors.black),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      _openTemplate(
                        title: 'Registrar chave aleatória',
                        typeTitle: 'Aleatoria',
                        description: 'Com a chave aleatória, você não precisa informar seus dados',
                        buttonText: 'Gerar chave aleatória',
                        footerDescription:
                            'Quem usa Pix pode saber que você tem uma chave cadastrada por telefone ou CPF. '
                            'Ao te pagar, a pessoa só verá seu nome completo e alguns dígitos do seu CPF.',
                        body: Center(
                          child: Row(
                            children: [
                              Icon(Icons.shield_outlined, color: AppColors.black, size: 25),
                              const SizedBox(width: 12),
                              const Text(
                                "Chave aleatória",
                                style: TextStyle(fontSize: 18, fontWeight: .bold, color: AppColors.black),
                              ),
                            ],
                          ),
                        ),
                        method: 'Create Pix',
                      );
                    },
                    icon: const Icon(Icons.add, color: AppColors.black, size: 25),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
