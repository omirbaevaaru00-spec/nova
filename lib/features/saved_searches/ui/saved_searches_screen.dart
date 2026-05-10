import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/saved_searches_cubit.dart';
import '../bloc/saved_searches_state.dart';

class SavedSearchesScreen extends StatelessWidget {
  const SavedSearchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => SavedSearchesCubit()..load(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.screenSavedSearches)),
        body: BlocBuilder<SavedSearchesCubit, SavedSearchesState>(
          builder: (context, state) {
            if (state.status == SavedSearchesStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  tileColor: AppColors.surfaceMuted,
                  title: Text(state.items[index]),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
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
