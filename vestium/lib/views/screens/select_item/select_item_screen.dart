import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../gallery_access/cubit/gallery_access_cubit.dart';
import 'cubit/select_item_cubit.dart';
import 'widgets/body_content.dart';

@RoutePage()
class SelectItemScreen extends StatelessWidget {
  const SelectItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SelectItemCubit()),
        BlocProvider(create: (context) => GalleryAccessCubit()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF5EDE8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.router.maybePop(),
          ),
          centerTitle: true,
          title: Builder(
            builder: (context) {
              final loc = AppLocalizations.of(context)!;
              return Text(
                loc.selectItemTitle,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF3E2723),
                  letterSpacing: 0.2,
                ),
              );
            },
          ),
        ),
        body: const BodyContent(),
      ),
    );
  }
}
