import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repo/post_repo.dart';
import '../../../../databases/db_models.dart';
import '../../../../databases/services/post_image_service.dart';
import 'new_post_state.dart';

class NewPostCubit extends Cubit<NewPostState> {
  final PostRepo _postRepo;
  final int userId;

  NewPostCubit(this._postRepo, {required this.userId})
      : super(const NewPostState());

  // ----- Mutations on simple fields -----

  void setCaption(String value) {
    emit(
      state.copyWith(
        caption: value,
        postSuccess: false,
        errorMessage: null,
      ),
    );
  }

  
  void setSelectedOutfit(Map<String, dynamic> outfit) {
    print('✅ Cubit selected outfit: $outfit');
    print('🔍 Keys in outfit: ${outfit.keys.toList()}');
    outfit.forEach((key, value) {
      print('  - $key: $value (${value.runtimeType})');
    });
    emit(
      state.copyWith(
        selectedOutfit: outfit,
        postSuccess: false,
        errorMessage: null,
      ),
    );
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  // ----- Submit post to DB -----

  Future<void> submitPost() async {
    if (state.selectedOutfit == null) {
      emit(
        state.copyWith(
          errorMessage: 'Please choose an outfit first',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        postSuccess: false,
      ),
    );

    try {
      final outfit = state.selectedOutfit!;

      print('📦 Processing outfit data: $outfit');

      // Check if this is a gallery image (outfit ID is null or missing)
      final bool isGalleryImage = (outfit['id'] == null || outfit['id'].toString().isEmpty) &&
                                   (outfit['outfitId'] == null || outfit['outfitId'].toString().isEmpty) &&
                                   (outfit['outfit_id'] == null || outfit['outfit_id'].toString().isEmpty);

      print('🔍 Is gallery image: $isGalleryImage');

      int? outfitId;
      String? imageSource;

      if (isGalleryImage) {
        // This is from gallery - post without outfit
        print('📸 Gallery image detected - creating post without outfit');
        
        imageSource = outfit['imageUrl'] ?? outfit['imagePath'] ?? outfit['image_path'] ?? outfit['data'];
        
        if (imageSource == null || imageSource.isEmpty) {
          throw Exception('No image data found for gallery image');
        }

        // outfitId stays null for gallery posts
        outfitId = null;
        
      } else {
        // This is from saved outfits - extract outfit ID
        if (outfit['id'] != null && outfit['id'].toString().isNotEmpty) {
          outfitId = outfit['id'] is int ? outfit['id'] : int.parse(outfit['id'].toString());
        } else if (outfit['outfitId'] != null && outfit['outfitId'].toString().isNotEmpty) {
          outfitId = outfit['outfitId'] is int ? outfit['outfitId'] : int.parse(outfit['outfitId'].toString());
        } else if (outfit['outfit_id'] != null && outfit['outfit_id'].toString().isNotEmpty) {
          outfitId = outfit['outfit_id'] is int ? outfit['outfit_id'] : int.parse(outfit['outfit_id'].toString());
        } else {
          throw Exception('Outfit ID not found in outfit data: ${outfit.keys}');
        }
        
        imageSource = outfit['imageUrl'] ?? outfit['imagePath'] ?? outfit['image_path'];
      }

      print('📝 Creating post with outfitId: $outfitId, imagePath: $imageSource');

      if (imageSource == null || imageSource.isEmpty) {
        throw Exception('No image source found');
      }

      // Create the post WITHOUT image path first (to get postId)
      final post = PostModel(
        outfitId: outfitId, // Can be null for gallery posts
        userId: userId,     // Always include userId for fetching posts
        imagePath: null,    // Will update after getting postId
        caption: state.caption.isEmpty ? null : state.caption,
        date: DateTime.now().toIso8601String(),
      );

      print('📝 Post object created: outfitId=$outfitId, userId=$userId, caption=${post.caption}');
      print('📝 Post.toMap(): ${post.toMap()}');

      // Insert post and get the new ID
      final newPostId = await _postRepo.insert(post);
      print('✅ Post inserted with ID: $newPostId');

      // Now copy the image to post_images directory
      String? postImagePath;
      try {
        postImagePath = await PostImageService.savePostImage(
          imageSource,
          postId: newPostId,
          userId: userId,
        );
        print('✅ Post image saved: $postImagePath');

        // Update the post with the image path
        final updatedPost = post.copyWith(
          postId: newPostId,
          imagePath: postImagePath,
        );
        await _postRepo.update(newPostId, updatedPost);
        print('✅ Post updated with image path');
      } catch (e) {
        print('⚠️ Failed to save post image: $e');
        throw Exception('Failed to save image: $e');
      }

      emit(
        state.copyWith(
          isLoading: false,
          postSuccess: true,
        ),
      );
    } catch (e, stackTrace) {
      print('❌ Failed to create post: $e');
      print('Stack trace: $stackTrace');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to create post: ${e.toString()}',
        ),
      );
    }
  }
}