import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_twitte_clone/features/auth/domain/services/user_session_service.dart';
import 'package:flutter_twitte_clone/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:flutter_twitte_clone/features/auth/presentation/login/screen/login_page.dart';
import 'package:flutter_twitte_clone/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:flutter_twitte_clone/features/auth/presentation/register/screen/register_page.dart';
import 'package:flutter_twitte_clone/features/feed/presentation/bloc/feed/feed_bloc.dart';
import 'package:flutter_twitte_clone/features/feed/presentation/screens/feed_page.dart';
import 'package:flutter_twitte_clone/features/feed/presentation/bloc/post/create_post_bloc.dart';
import 'package:flutter_twitte_clone/features/splash/splash_page.dart';
import 'package:flutter_twitte_clone/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 加载 .env 文件
  await dotenv.load(fileName: ".env"); // 新增这一行
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final userSessionService = sl.get<UserSessionService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(
            registerUserCase: sl(),
            userSessionService: userSessionService,
          ),
        ),
        BlocProvider(
          create: (context) => LoginBloc(
            loginUserCase: sl(),
            userSessionService: userSessionService,
          ),
        ),
        BlocProvider(
          create: (context) => FeedBloc(
            fetchPostUseCase: sl(),
            likePostUseCase: sl(),
            unlikePostUseCase: sl(),
            userSessionService: sl(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              CreatePostBloc(createPostUseCase: sl(), userSessionService: sl()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Twitter Clone',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(userSessionService: userSessionService),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const FeedPage(),
          '/splash': (context) =>
              SplashPage(userSessionService: userSessionService),
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text("Welcome to the Home Page")),
    );
  }
}
