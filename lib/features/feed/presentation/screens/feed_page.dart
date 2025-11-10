import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitte_clone/features/auth/domain/services/user_session_service.dart';
import 'package:flutter_twitte_clone/features/feed/presentation/bloc/feed/feed_bloc.dart';
import 'package:flutter_twitte_clone/features/feed/presentation/bloc/post/create_post_bloc.dart';
import 'package:flutter_twitte_clone/features/feed/presentation/widgets/post_card.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    context.read<FeedBloc>().add(FetchPostsRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: Colors.black,
        elevation: 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(backgroundColor: Colors.grey[800]),
        ),
        title: Image.asset("assets/images/logo.png", width: 40, height: 40),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mail_outline, color: Colors.white),
          ),
          IconButton(
            onPressed: () async {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.noHeader,
                title: 'Confirm Logout',
                desc: 'Are you sure you want to log out?',
                btnCancelOnPress: () {},
                btnOkOnPress: () async {
                  await getIt<UserSessionService>().logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/splash',
                    (route) => false,
                  );
                },
              ).show(); //dialog
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),

      body: BlocBuilder<FeedBloc, FeedBlocState>(
        builder: (context, state) {
          if (state is FeedBlocLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FeedBlocLoaded) {
            final posts = state.posts;
            if (posts.isEmpty) {
              return const Center(
                child: Text(
                  "No posts found",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            }

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(post: post);
              },
            );
          } else if (state is FeedBlocError) {
            return const Center(child: Text('Error'));
          }

          return Container();
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _showCreatePostModal(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreatePostModal(BuildContext context) {
    final TextEditingController contentController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 关键：允许全屏 & 键盘自适应
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          // ⚠️ 一定要加这一行：让底部随键盘上移
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BlocConsumer<CreatePostBloc, CreatePostState>(
            listener: (dialogContext, state) {
              if (state is CreatePostSuccess) {
                Navigator.pop(dialogContext);
                context.read<FeedBloc>().add(FetchPostsRequested());
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Post created')));
              } else if (state is CreatePostFailure) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("${state.message} ")));
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: contentController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "What's happening?",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                        maxLines: 5,
                        maxLength: 280,
                        validator: (v) => v == null || v.isEmpty
                            ? 'please enter content'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: state is CreatePostLoading
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<CreatePostBloc>().add(
                                        CreatePostRequested(
                                          content: contentController.text,
                                        ),
                                      );
                                    }
                                  },
                            child: state is CreatePostLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Post'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
