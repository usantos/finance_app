import 'package:financial_app/core/injection_container.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';

void showTwoFieldBottomSheet(BuildContext context) {
  final TextEditingController field1Controller = TextEditingController();
  final TextEditingController field2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _transactionViewModel = sl.get<TransactionViewModel>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Adicionar Informações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Primeiro campo
              TextFormField(
                controller: field1Controller,
                decoration: InputDecoration(
                  labelText: 'Campo 1',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Informe algo' : null,
              ),
              const SizedBox(height: 12),

              // Segundo campo
              TextFormField(
                controller: field2Controller,
                decoration: InputDecoration(
                  labelText: 'Campo 2',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Informe algo' : null,
              ),
              const SizedBox(height: 20),

              // Botão salvar
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final field1 = field1Controller.text.trim();
                      final field2 = field2Controller.text.trim();

                      await _transactionViewModel.createPixKey(field1, field2);
                    }
                  },
                  child: const Text('Salvar', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}
