import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitte_clone/core/utils.dart';
import 'package:flutter_twitte_clone/features/feed/domain/entities/post_entity.dart';
import 'package:flutter_twitte_clone/features/feed/presentation/bloc/feed/feed_bloc.dart';

class PostCard extends StatelessWidget {
  PostEntity post;
  PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedBlocState>(
      builder: (context, state) {
        final isLiked = post.isLiked;
        final likesCount = post.likesCount;

        return Card(
          color: Colors.black,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(backgroundColor: Colors.grey[200]),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                post.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Spacer(),

                              Text(
                                formatTime(post.createdAt),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),
                          Text(
                            post.content,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      post.imageUrl!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _PostStat(
                      icon: isLiked ? Icons.favorite : Icons.favorite_border,
                      count: post.likesCount,
                      iconColor: isLiked ? Colors.red : Colors.grey,
                      onTap: () {
                        final bloc = context.read<FeedBloc>();
                        if (isLiked) {
                          bloc.add(
                            UnLikePostRequested(
                              postId: post.id!,
                              userId: post.userId,
                            ),
                          );
                        } else {
                          bloc.add(
                            LikePostRequested(
                              postId: post.id!,
                              userId: post.userId,
                            ),
                          );
                        }
                      },
                    ),
                    _PostStat(
                      icon: Icons.comment_outlined,
                      count: post.commentsCount,
                    ),
                    _PostStat(icon: Icons.loop, count: post.respostsCount),
                    const Icon(Icons.share, size: 20, color: Colors.grey),
                  ],
                ),
                // Text(post.content, style: const TextStyle(fontSize: 16)),
                // const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PostStat extends StatelessWidget {
  final IconData icon;
  final int? count;
  final VoidCallback? onTap;
  final Color iconColor;
  const _PostStat({
    super.key,
    required this.icon,
    required this.count,
    this.iconColor = Colors.grey,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
          Text(
            '${count ?? 0}',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
