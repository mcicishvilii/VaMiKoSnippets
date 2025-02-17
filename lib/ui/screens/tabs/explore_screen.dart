import 'package:flutmisho/ui/viewmodel/all_items_view_model.dart';
import 'package:flutmisho/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MishoViewModel>(context);
    final resource = viewModel.mishosUser;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              if (resource is Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (resource is Success<List>) {
                final items = (resource as Success<List>).data;
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.description),
                      // leading: ,
                    );
                  },
                );
              } else if (resource is Error) {
                return Center(
                    child: Text("Error: ${(resource as Error).error}"));
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }
}


  // final int id;
  // final String title;
  // final String description;
  // final bool status;
  // final String updatedAt;