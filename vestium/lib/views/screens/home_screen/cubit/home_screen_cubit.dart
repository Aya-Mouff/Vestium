import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/dummy/dummy-data-loader.dart';
import 'home_screen_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading()) {
    loadPosts();
  }

  Future<void> loadPosts() async {
    try {
      emit(HomeLoading());
      await Future.delayed(Duration(milliseconds: 700)); // simulate delay
      final data = await DummyDataLoader.loadDummyData();
      emit(HomeLoaded(posts: data['posts']));
    } catch (e) {
      emit(HomeError("Failed to load posts"));
    }
  }
}
