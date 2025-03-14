import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'data/datasources/local/local_storage.dart';
import 'data/datasources/remote/gemini_api.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'domain/repositories/chat_repository.dart';
import 'domain/usecases/agent_usecases.dart';
import 'domain/usecases/chat_usecases.dart';
import 'presentation/providers/agent_provider.dart';
import 'presentation/providers/chat_provider.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  final localStorage = LocalStorage();
  await localStorage.init();
  
  final geminiApi = GeminiApi(apiKey: dotenv.env['GEMINI_API_KEY'] ?? '');
  
  runApp(MyApp(
    localStorage: localStorage,
    geminiApi: geminiApi,
  ));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;
  final GeminiApi geminiApi;

  const MyApp({
    super.key,
    required this.localStorage,
    required this.geminiApi,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repository
        Provider<ChatRepository>(
          create: (context) => ChatRepositoryImpl(
            localStorage: localStorage,
            geminiApi: geminiApi,
          ),
        ),
        
        // Use Cases
        Provider<GetAgents>(
          create: (context) => GetAgents(context.read<ChatRepository>()),
        ),
        Provider<AddAgent>(
          create: (context) => AddAgent(context.read<ChatRepository>()),
        ),
        Provider<DeleteAgent>(
          create: (context) => DeleteAgent(context.read<ChatRepository>()),
        ),
        Provider<GetMessages>(
          create: (context) => GetMessages(context.read<ChatRepository>()),
        ),
        Provider<AddMessage>(
          create: (context) => AddMessage(context.read<ChatRepository>()),
        ),
        Provider<GenerateAIResponse>(
          create: (context) => GenerateAIResponse(context.read<ChatRepository>()),
        ),
        
        // Providers
        ChangeNotifierProvider<AgentProvider>(
          create: (context) => AgentProvider(
            getAgents: context.read<GetAgents>(),
            addAgent: context.read<AddAgent>(),
            deleteAgent: context.read<DeleteAgent>(),
          ),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(
            getMessages: context.read<GetMessages>(),
            addMessage: context.read<AddMessage>(),
            generateAIResponse: context.read<GenerateAIResponse>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Virtual Agent Chat',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}