import 'package:financial_app/core/components/template.dart';
import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/core/utils.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetCreateCreditCard extends StatefulWidget {
  const BottomSheetCreateCreditCard({super.key});

  @override
  State<BottomSheetCreateCreditCard> createState() => _BottomSheetCreateCreditCardState();
}

class _BottomSheetCreateCreditCardState extends State<BottomSheetCreateCreditCard> {
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, viewModel, child) {
        final pixKeys = viewModel.pixKeys;

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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      _openTemplate(
                        title: 'Registrar telefone',
                        typeTitle: 'Telefone',
                        description: 'Insira o telefone para ser registrado como chave Pix',
                        buttonText: 'Cadastrar chave',
                        controller: _telefoneController,
                        body: TextFormField(
                          controller: _telefoneController,
                          keyboardType: TextInputType.phone,
                          validator: Utils.validatePhone,
                        ),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      _openTemplate(
                        title: 'Registrar CPF',
                        typeTitle: 'CPF',
                        description: 'Insira o CPF para ser registrado como chave Pix',
                        buttonText: 'Cadastrar chave',
                        controller: _cpfController,
                        body: TextFormField(
                          controller: _cpfController,
                          keyboardType: TextInputType.number,
                          validator: Utils.validateCpf,
                        ),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      _openTemplate(
                        title: 'Registrar Email',
                        typeTitle: 'Email',
                        description: 'Insira o Email para ser registrado como chave Pix',
                        buttonText: 'Cadastrar chave',
                        controller: _emailController,
                        body: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: Utils.validateEmail,
                        ),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
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
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
                              ),
                            ],
                          ),
                        ),
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
