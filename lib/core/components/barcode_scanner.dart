import 'package:financial_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  final TextEditingController _controller = TextEditingController();
  bool _isScanning = true;

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;
    final barcode = capture.barcodes.first;
    final String? value = barcode.rawValue;
    if (value != null) {
      setState(() {
        _isScanning = false;
        _controller.text = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: AppColors.white),
        ),
        title: const Text('Leitor de Código de Barras', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                MobileScanner(onDetect: _onDetect),
                if (!_isScanning)
                  Container(
                    color: AppColors.black.withValues(alpha: 0.5),
                    child: const Center(
                      child: Text('Código lido!', style: TextStyle(color: AppColors.white, fontSize: 24)),
                    ),
                  ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      style: const TextStyle(color: AppColors.white),
                      cursorColor: AppColors.white,
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.white),
                        ),
                        labelText: 'Digite o código manualmente',
                        labelStyle: const TextStyle(color: AppColors.white),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.check, color: AppColors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Aponte a câmera para o código ou digite acima.',
                      style: TextStyle(color: AppColors.white),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
