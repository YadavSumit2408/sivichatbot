import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';
import 'core/utils/constants.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/users/cubit/users_cubit.dart';
import 'features/chat/cubit/chat_cubit.dart';
import 'features/chat/repository/chat_repository.dart';

List<BlocProvider> buildBlocProviders() {
  final apiClient = ApiClient(
    client: http.Client(),
    baseUrl: ApiConstants.quotableBaseUrl,
  );

  final chatRepository = ChatRepository(apiClient: apiClient);

  return [
    BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(),
    ),
    BlocProvider<ChatCubit>(
      create: (_) => ChatCubit(repository: chatRepository),
    ),
    BlocProvider<UsersCubit>(
      create: (_) => UsersCubit(),
    ),
  ];
}