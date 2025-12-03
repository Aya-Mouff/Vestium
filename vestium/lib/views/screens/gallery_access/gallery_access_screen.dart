import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'cubit/gallery_access_cubit.dart';
import 'widgets/gallery_access_body.dart';

@RoutePage()
class GalleryAccessScreen extends StatelessWidget {
  const GalleryAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GalleryAccessCubit(),
      child: const GalleryAccessBody(),
    );
  }
}