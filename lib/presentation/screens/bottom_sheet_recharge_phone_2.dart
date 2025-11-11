import 'package:financial_app/core/theme/app_colors.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetRechargePhone2 extends StatefulWidget {
  const BottomSheetRechargePhone2({super.key});

  @override
  State<BottomSheetRechargePhone2> createState() => _BottomSheetRechargePhone2State();
}

class _BottomSheetRechargePhone2State extends State<BottomSheetRechargePhone2> {
  int? _selectedIndex;
  final List<String> _values = ["R\$20,00", "R\$30,00", "R\$50,00", "R\$100,00"];

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountViewModel>(
      builder: (context, accountViewModel, child) {
        return Center(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: AppColors.black),
                ),
              ),
              Text("Escolha os valores", style: TextStyle(color: AppColors.black, fontSize: 18)),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_buildOperatorItem(0), _buildOperatorItem(1)],
                  ),
                  const SizedBox(width: 60),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_buildOperatorItem(2), _buildOperatorItem(3)],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text("Seu saldo", style: TextStyle(color: AppColors.black, fontSize: 18)),
              SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 14),
                  Text(
                    accountViewModel.displayBalance,
                    style: const TextStyle(color: AppColors.blackText, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        accountViewModel.toggleVisibility();
                      });
                    },
                    child: Icon(
                      accountViewModel.isHidden ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              _selectedIndex == null
                  ? SizedBox()
                  : Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Recarga de ${_values[_selectedIndex!]} efetuada com sucesso!'),
                              backgroundColor: AppColors.greenSuccess,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_forward, color: AppColors.black),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOperatorItem(int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
              child: Center(
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondary : AppColors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.secondary, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(_values[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
