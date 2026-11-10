import 'package:flutter/material.dart';

class ChatWelcomeView extends StatelessWidget {
  const ChatWelcomeView({required this.onPromptSelected, super.key});

  final ValueChanged<String> onPromptSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 44, color: colors.primary),
            const SizedBox(height: 16),
            Text(
              'What can I help with?',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ask a question or choose a suggestion to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            _PromptCard(
              icon: Icons.lightbulb_outline,
              label: 'Explain a complex idea simply',
              onTap: () =>
                  onPromptSelected('Explain a complex idea in a simple way.'),
            ),
            const SizedBox(height: 10),
            _PromptCard(
              icon: Icons.edit_note,
              label: 'Help me write something',
              onTap: () => onPromptSelected('Help me write a short story.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 420,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFE7E9F0)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Expanded(child: Text(label)),
                const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
