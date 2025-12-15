import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  
  const LoadingWidget({super.key, this.message});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const ListTile(
            leading: CircleAvatar(backgroundColor: Colors.grey),
            title: SizedBox(
              height: 20,
              child: ColoredBox(color: Colors.grey),
            ),
            subtitle: SizedBox(
              height: 16,
              child: ColoredBox(color: Colors.grey),
            ),
            trailing: SizedBox(
              width: 60,
              height: 20,
              child: ColoredBox(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}