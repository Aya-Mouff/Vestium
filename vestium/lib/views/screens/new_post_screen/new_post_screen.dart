import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_router.dart';
import '../../../repo/post_repo.dart';
import 'cubit/new_post_cubit.dart';
import 'cubit/new_post_state.dart';
import 'widgets/new_post_app_bar.dart';
import 'widgets/outfit_picker.dart';
import 'widgets/caption_field.dart';
import 'widgets/public_toggle.dart';

@RoutePage()
class NewPostScreen extends StatelessWidget {
  final int userId;

  const NewPostScreen({
    super.key,
    @PathParam('userId') this.userId = -1,
  });

  @override
  Widget build(BuildContext context) {
    if (userId == -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.router.replaceNamed('/access-denied');
      });
    }

    return BlocProvider(
      create: (_) => NewPostCubit(PostRepo(), userId: userId),
      child: const _NewPostView(),
    );
  }
}

class _NewPostView extends StatefulWidget {
  const _NewPostView();

  @override
  State<_NewPostView> createState() => _NewPostViewState();
}

class _NewPostViewState extends State<_NewPostView> {
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

Future _selectOutfit(BuildContext context) async {
  final cubit = context.read<NewPostCubit>();

  final result = await context.router.push(
    SelectOutfitRoute(userId: cubit.userId),
  );

  if (result != null && result is Map) {
    final typed = Map<String, dynamic>.from(result);  // 👈 cast here
    print('✅ NewPost got outfit: $typed');
    cubit.setSelectedOutfit(typed);
  }
}



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewPostCubit, NewPostState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
        if (state.postSuccess) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        final cubit = context.read<NewPostCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFFF5EDE8),
          appBar: NewPostAppBar(
            isLoading: state.isLoading,
            onPostPressed: () {
              cubit.submitPost();
            },
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutfitPicker(
                    selectedOutfit: state.selectedOutfit,
                    onSelectOutfit: () => _selectOutfit(context),
                  ),
                  const SizedBox(height: 16),
                  CaptionField(
                    controller: _captionController,
                    onChanged: cubit.setCaption,
                  ),
                  const SizedBox(height: 20),
                  PublicToggle(
                    isPublic: state.isPublic,
                    onChanged: cubit.togglePublic,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
