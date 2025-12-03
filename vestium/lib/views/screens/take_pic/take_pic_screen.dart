import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'cubit/take_pic_cubit.dart';
import 'widgets/take_pic_body.dart';

@RoutePage()
class TakePicScreen extends StatelessWidget {
  const TakePicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TakePicCubit(),
      child: const TakePicBody(),
    );
  }
}