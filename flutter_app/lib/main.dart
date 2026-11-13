import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/api_service.dart';
import 'screens/tutorials_screen.dart';

void main() {
  runApp(const GlowUpApp());
}

class GlowUpApp extends StatelessWidget {
  const GlowUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlowUp Skincare & IoT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeNavigation(),
    );
  }
}

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;
  final String _userName = 'Stephanie';
  String _skinType = 'Pele Mista';
  String _skinGoal = 'Hidratação & Luminosidade';
  double _fridgeTemp = 6.0;

  final List<Map<String, dynamic>> _routine = [
    {'step': 'Limpeza Suave', 'time': 'Manhã & Noite', 'desc': 'Gel de Limpeza com Niacinamida 5%', 'done': true},
    {'step': 'Tratamento Antioxidante', 'time': 'Manhã • 5°C', 'desc': 'Sérum Vitamina C 10% (GlowFridge)', 'done': false},
    {'step': 'Fotoproteção Diária', 'time': 'Manhã', 'desc': 'Protetor Solar Fluido FPS 60 Toque Seco', 'done': false},
  ];

  final List<Map<String, String>> _fridgeItems = [
    {'name': 'Sérum Vitamina C 10%', 'ideal': '5°C', 'val': 'Validade: 45 dias'},
    {'name': 'Roll-on Olhos Cafeína', 'ideal': '4°C', 'val': 'Validade: 60 dias'},
    {'name': 'Bruma Facial Calmante', 'ideal': '6°C', 'val': 'Validade: 90 dias'},
  ];

  final List<Map<String, dynamic>> _products = [
    {'name': 'Sérum Vitamina C 10% Pura', 'tag': 'Conservação 5°C', 'desc': 'Iluminação e ação antioxidante', 'price': 89.90, 'icon': Icons.water_drop_rounded},
    {'name': 'Gel Hidratante Ácido Hialurônico', 'tag': 'Todos os tipos', 'desc': 'Hidratação leve de rápida absorção', 'price': 74.50, 'icon': Icons.spa_rounded},
    {'name': 'Espuma de Limpeza Micelar', 'tag': 'pH Fisiológico', 'desc': 'Remove impurezas sem ressecar', 'price': 49.90, 'icon': Icons.bubble_chart_rounded},
    {'name': 'Protetor Solar Invisível FPS 60', 'tag': 'Toque Seco', 'desc': 'Alta proteção UVA/UVB sem resíduo', 'price': 65.00, 'icon': Icons.wb_sunny_rounded},
  ];

  final List<Map<String, dynamic>> _cart = [];

  @override
  void initState() {
    super.initState();
    _syncWithBackend();
  }

  Future<void> _syncWithBackend() async {
    final data = await ApiService.fetchFridgeStatus();
    if (data != null && mounted) {
      setState(() {
        _fridgeTemp = (data['temperature'] as num).toDouble();
      });
    }
  }

  void _openQuizModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 18),
            Text('Diagnóstico de Pele', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            const Text('Selecione a característica principal da sua pele:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 18),
            _quizOption('Pele Oleosa', 'Controle de Sebo & Poros', 'Brilho intenso na zona T e poros visíveis', Icons.opacity_rounded),
            _quizOption('Pele Mista', 'Equilíbrio & Luminosidade', 'Oleosa na testa/nariz e equilibrada nas bochechas', Icons.auto_awesome_rounded),
            _quizOption('Pele Seca / Sensível', 'Barreira Cutânea & Hidratação', 'Sensação de repuxamento ou vermelhidão fácil', Icons.local_florist_rounded),
          ],
        ),
      ),
    );
  }

  Widget _quizOption(String type, String goal, String label, IconData icon) {
    final selected = _skinType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _skinType = type;
          _skinGoal = goal;
        });
        ApiService.saveSkinQuiz(_userName, type, goal);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoft : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppColors.primary : AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                  Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCartSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          double total = _cart.fold(0, (sum, item) => sum + (item['price'] as double));
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 16),
                Text('Sua Sacola', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 14),
                if (_cart.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Text('Nenhum produto adicionado ainda.', style: TextStyle(color: AppColors.textSecondary)),
                  )
                else ...[
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _cart.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderSubtle),
                      itemBuilder: (_, i) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(_cart[i]['name'], style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                        subtitle: Text('R\$ ${_cart[i]['price'].toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                        trailing: IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.textSecondary),
                          onPressed: () {
                            setState(() => _cart.removeAt(i));
                            setModalState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total do Pedido', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        Text('R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () async {
                        final itemsCopy = List<Map<String, dynamic>>.from(_cart);
                        setState(() => _cart.clear());
                        Navigator.pop(context);
                        await ApiService.createOrder(_userName, itemsCopy, total);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pedido confirmado e salvo com sucesso!')),
                          );
                        }
                      },
                      child: const Text('Finalizar Compra', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    ),
                  )
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeTab(),
      _buildFridgeTab(),
      const TutorialsScreen(),
      _buildShopTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Center(child: Text('G', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17))),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GlowUp', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.textPrimary, height: 1.1)),
                Text('Skincare & Smart IoT', style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: AppColors.surface, side: const BorderSide(color: AppColors.borderSubtle)),
                  icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary, size: 21),
                  onPressed: _openCartSheet,
                ),
                if (_cart.isNotEmpty)
                  Positioned(
                    right: 4,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: Text('${_cart.length}', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.spa_outlined), selectedIcon: Icon(Icons.spa_rounded, color: AppColors.primary), label: 'Rotina'),
          NavigationDestination(icon: Icon(Icons.ac_unit_outlined), selectedIcon: Icon(Icons.ac_unit_rounded, color: AppColors.primary), label: 'GlowFridge'),
          NavigationDestination(icon: Icon(Icons.play_circle_outline), selectedIcon: Icon(Icons.play_circle_rounded, color: AppColors.primary), label: 'Academia'),
          NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront_rounded, color: AppColors.primary), label: 'Loja'),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    int doneCount = _routine.where((r) => r['done'] == true).length;
    double progress = doneCount / _routine.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        // Hero Card Editorial
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF9D174D), Color(0xFFBE185D), Color(0xFFE11D48)],
            ),
            borderRadius: BorderRadius.circular(26),
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(20)),
                child: const Text('DIAGNÓSTICO PERSONALIZADO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
              ),
              const SizedBox(height: 12),
              Text('Olá, $_userName', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('$_skinType • $_skinGoal', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _openQuizModal,
                icon: const Icon(Icons.tune_rounded, size: 16),
                label: const Text('Ajustar Perfil de Pele', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Cabeçalho da Rotina + Barra de Progresso
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Rotina Diária', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text('$doneCount de ${_routine.length} etapas', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: AppColors.primarySoft,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),

        // Lista de Etapas
        ...List.generate(_routine.length, (i) {
          final item = _routine[i];
          final bool done = item['done'];
          return GestureDetector(
            onTap: () => setState(() => item['done'] = !done),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: done ? AppColors.surfaceTint : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: done ? AppColors.primary.withOpacity(0.35) : AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: done ? AppColors.primary : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: done ? AppColors.primary : Colors.grey.shade400, width: 2),
                    ),
                    child: done ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['step'],
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5,
                                color: done ? AppColors.textSecondary : AppColors.textPrimary,
                                decoration: done ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            Text(item['time'], style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(item['desc'], style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 8),

        // Card Educativo Sutil
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFEF3C7)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: AppColors.accentGold, size: 22),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dica Científica', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF92400E))),
                    SizedBox(height: 3),
                    Text(
                      'Manter antioxidantes entre 4°C e 8°C na GlowFridge desacelera a oxidação e reduz a vermelhidão matinal.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF78350F), height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFridgeTab() {
    bool isIdeal = _fridgeTemp >= 4.0 && _fridgeTemp <= 8.0;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GlowFridge IoT', style: Theme.of(context).textTheme.headlineSmall),
                const Text('Conservação térmica inteligente', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(20)),
              child: const Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: AppColors.success),
                  SizedBox(width: 6),
                  Text('Conectada', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.success)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Termostato Sofisticado
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.fridgeDark, AppColors.fridgeDeep],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            children: [
              const Text('TEMPERATURA INTERNA', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.4)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_fridgeTemp.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w800, height: 1)),
                  const Padding(
                    padding: EdgeInsets.only(top: 6, left: 4),
                    child: Text('°C', style: TextStyle(color: AppColors.iceAccent, fontSize: 22, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isIdeal ? AppColors.success.withOpacity(0.18) : Colors.amber.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isIdeal ? 'Faixa ideal para ativos sensíveis (4°C – 8°C)' : 'Fora da faixa ideal recomendada (4°C – 8°C)',
                  style: TextStyle(color: isIdeal ? const Color(0xFF6EE7B7) : const Color(0xFFFCD34D), fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 18),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.iceAccent,
                  inactiveTrackColor: Colors.white12,
                  thumbColor: Colors.white,
                  overlayColor: AppColors.iceAccent.withOpacity(0.2),
                ),
                child: Slider(
                  value: _fridgeTemp,
                  min: 2.0,
                  max: 14.0,
                  divisions: 24,
                  onChanged: (v) {
                    setState(() => _fridgeTemp = v);
                    ApiService.updateFridgeTemperature(v);
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2°C Turbo', style: TextStyle(color: Colors.white38, fontSize: 11)),
                    Text('6°C Ideal', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
                    Text('14°C Eco', style: TextStyle(color: Colors.white38, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        const Text('Cosméticos Armazenados', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 12),

        ..._fridgeItems.map((it) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.ac_unit_rounded, color: Color(0xFF0284C7), size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(it['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text(it['val']!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
                    child: Text('Ideal ${it['ideal']}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildShopTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text('Curadoria GlowUp', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        const Text('Fórmulas selecionadas para o seu diagnóstico', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 18),
        ..._products.map((p) => Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: AppTheme.softShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceTint,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(p['icon'] as IconData, color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(6)),
                          child: Text(p['tag'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ),
                        const SizedBox(height: 6),
                        Text(p['name'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text(p['desc'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('R\$ ${p['price'].toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary)),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                setState(() => _cart.add(p));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${p['name']} adicionado à sacola!'), duration: const Duration(seconds: 1)),
                                );
                              },
                              child: const Text('+ Adicionar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
