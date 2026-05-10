import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../bloc/notifications_cubit.dart';
import '../bloc/notifications_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => NotificationsCubit()..load(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.screenNotifications)),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state.status == NotificationsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.notifications_none),
                  ),
                  title: Text(state.items[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
