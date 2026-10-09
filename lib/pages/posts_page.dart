import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/post_bloc.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late final PostBloc postBloc;

  @override
  void initState() {
    super.initState();
    postBloc = PostBloc()..add(GetPostEvent());
  }

  @override
  void dispose() {
    postBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: BlocBuilder<PostBloc, PostState>(
        bloc: postBloc,
        builder: (context, state) {
          if (state is LoadingPostState || state is PostInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FetchedPostsState) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.posts.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(post.body),
                  ],
                );
              },
            );
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Ошибка загрузки данных'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => postBloc.add(GetPostEvent()),
                  child: const Text('Повторить'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
