import 'home_screen.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:phone_auth_ios_android_app/widgets/app_snackbar.dart';


class ConfirmCodeScreen extends StatefulWidget {
  final String telefone;
  final String codigoGerado;

  const ConfirmCodeScreen({
    super.key,
    required this.telefone,
    required this.codigoGerado,
  });

  @override
  State<ConfirmCodeScreen> createState() => _ConfirmCodeScreenState();
}

class _ConfirmCodeScreenState extends State<ConfirmCodeScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _codigoController = TextEditingController();

  bool _loading = false;

  Future<void> _confirmar() async {
    if (_codigoController.text.trim().isEmpty) return;

    setState(() => _loading = true);

    try {
      final user = await _authService.confirmCode(
        telefone: widget.telefone,
        codigo: _codigoController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } catch (e) {
      AppSnackBar.show(context, message: e.toString(), type: SnackType.warning);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _preencherCodigo() {
    _codigoController.text = widget.codigoGerado;
  }

 

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Confirmar SMS'),
        backgroundColor: const Color(0xFFF5F7FB),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 430),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFFE0E7FF),
                  child: Icon(
                    Icons.sms_rounded,
                    size: 36,
                    color: Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Código de confirmação',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enviamos um código para ${widget.telefone}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF6B7280), height: 1.5),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Código simulado para apresentação',
                        style: TextStyle(color: Color(0xFF4F46E5)),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.codigoGerado,
                        style: const TextStyle(
                          fontSize: 28,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF312E81),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _codigoController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Código SMS',
                    hintText: 'Digite o código',
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextButton.icon(
                  onPressed: _preencherCodigo,
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text('Preencher código automaticamente'),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _loading ? null : _confirmar,
                    icon: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.verified_rounded),
                    label: Text(_loading ? 'Confirmando...' : 'Confirmar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
