import '../models/user.dart';
import 'edit_profile_screen.dart';
import '../widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _user;

  final AuthService _authService = AuthService();

  String? _novoUuid;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  Future<void> _editarPerfil() async {
    final updatedUser = await Navigator.push<User>(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen(user: _user)),
    );

    if (updatedUser != null) {
      setState(() {
        _user = updatedUser;
      });
    }
  }

  Future<void> _simularNovoDispositivo() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Simular Novo Dispositivo'),
          content: const Text(
            'Deseja gerar um novo UUID para simular outro celular?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Gerar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    final novoUuid = await _authService.simularNovoDispositivo();

    setState(() {
      _novoUuid = novoUuid;
    });

    if (!mounted) return;

    AppSnackBar.show(
      context,
      message: 'Novo UUID gerado com sucesso!',
      type: SnackType.success,
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.18),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nome = _user.nome?.isNotEmpty == true
        ? _user.nome!
        : 'Usuário sem nome';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1D4ED8), Color(0xFF4F46E5), Color(0xFF111827)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person_rounded,
                            color: Color(0xFF2563EB),
                            size: 34,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Login realizado',
                                style: TextStyle(
                                  color: Color(0xFFBFDBFE),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                nome,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.18),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dados do usuário autenticado',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _infoCard(
                            icon: Icons.badge_rounded,
                            title: 'ID do usuário',
                            value: _user.id.toString(),
                          ),
                          const SizedBox(height: 12),
                          _infoCard(
                            icon: Icons.phone_rounded,
                            title: 'Telefone',
                            value: _user.telefone,
                          ),
                          const SizedBox(height: 12),
                          _infoCard(
                            icon: Icons.devices_rounded,
                            title: 'UUID do dispositivo',
                            value: _user.uuid,
                          ),
                          if (_novoUuid != null) ...[
                            const SizedBox(height: 12),
                            _infoCard(
                              icon: Icons.smartphone_rounded,
                              title: 'Novo UUID Simulado',
                              value: _novoUuid!,
                            ),
                          ],
                          const SizedBox(height: 12),
                          _infoCard(
                            icon: Icons.verified_user_rounded,
                            title: 'Status',
                            value: _user.ativo
                                ? 'Usuário ativo'
                                : 'Usuário inativo',
                          ),
                          const SizedBox(height: 12),
                          _infoCard(
                            icon: Icons.description_rounded,
                            title: 'Descrição',
                            value: _user.descricao?.isNotEmpty == true
                                ? _user.descricao!
                                : 'Sem descrição cadastrada',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _editarPerfil,
                        icon: const Icon(Icons.edit_rounded),
                        label: const Text('Atualizar perfil'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1D4ED8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _simularNovoDispositivo,
                        icon: const Icon(Icons.devices_other_rounded),
                        label: const Text('Simular Novo Dispositivo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
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
        ),
      ),
    );
  }
}
