import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/news_cubit.dart';
import '../bloc/news_state.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => NewsCubit()..load(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.screenNews)),
        body: BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            if (state.status == NewsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  tileColor: AppColors.surfaceMuted,
                  title: Text(item.title),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(item.subtitle),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
