import 'package:financial_app/core/components/template.dart';
import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

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
    return Column(
      children: [
        const SizedBox(height: 20),

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
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Digite um telefone válido';
                      return null;
                    },
                  ),
                );
              },
              icon: const Icon(Icons.add, color: AppColors.black, size: 25),
            ),
          ],
        ),
        const SizedBox(height: 24),

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
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Digite um CPF válido';
                      return null;
                    },
                  ),
                );
              },
              icon: const Icon(Icons.add, color: AppColors.black, size: 25),
            ),
          ],
        ),
        const SizedBox(height: 24),

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
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Digite um email válido';
                      return null;
                    },
                  ),
                );
              },
              icon: const Icon(Icons.add, color: AppColors.black, size: 25),
            ),
          ],
        ),
        const SizedBox(height: 24),

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
                      'Quem usa Pix, pode saber que você tem uma chave cadastrada por telefone ou CPF. \nAo te pagar, a pessoa só verá seu nome completo e alguns dígitos do seu CPF.',
                  controller: null,
                  body: Center(
                    child: Row(
                      children: [
                        Icon(Icons.shield_outlined, color: AppColors.black, size: 25),
                        SizedBox(width: 12),
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
    );
  }
}
