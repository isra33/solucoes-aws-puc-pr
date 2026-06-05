import '../models/user.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:phone_auth_ios_android_app/widgets/app_snackbar.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthService _authService = AuthService();

  late final TextEditingController _nomeController;
  late final TextEditingController _descricaoController;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(text: widget.user.nome ?? '');
    _descricaoController = TextEditingController(
      text: widget.user.descricao ?? '',
    );
  }

  Future<void> _salvar() async {
    setState(() => _loading = true);

    try {
      final user = await _authService.updateUser(
        id: widget.user.id,
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, user);
    } catch (e) {
      AppSnackBar.show(context, message: e.toString(), type: SnackType.error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

 
  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Editar perfil'),
        backgroundColor: const Color(0xFFF5F7FB),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 460),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: Color(0xFFD1FAE5),
                  child: Icon(
                    Icons.manage_accounts_rounded,
                    size: 34,
                    color: Color(0xFF059669),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Complete seu cadastro',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Atualize os dados do usuário usando o endpoint PUT /users/{id}.',
                  style: TextStyle(color: Color(0xFF6B7280), height: 1.5),
                ),
                const SizedBox(height: 28),
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: const Icon(Icons.person_rounded),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descricaoController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    prefixIcon: const Icon(Icons.notes_rounded),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _loading ? null : _salvar,
                    icon: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_rounded),
                    label: Text(_loading ? 'Salvando...' : 'Salvar perfil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
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
