import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
//import 'package:vestium/app_router.dart';
import 'cubit/camera_access_cubit.dart';
import 'widgets/camera_access_body.dart';

@RoutePage()
class CameraAccessScreen extends StatelessWidget {
  const CameraAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraAccessCubit(),
      child: const CameraAccessBody(),
    );
  }
}