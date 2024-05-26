import 'package:demoapp/Global_bloc/cubit/api_call_cubit.dart';
import 'package:demoapp/Global_bloc/cubit/internet_cubit.dart';
import 'package:demoapp/ui/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    InternetConnectivity internetConnectivity = InternetConnectivity(
        internetObservingStrategy:
            DefaultObServingStrategy(timeOut: Duration(seconds: 1)));

    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetCubit>(
          create: (context) =>
              InternetCubit(internetConnectivity: internetConnectivity),
        ),
        BlocProvider<ApiCallCubit>(
          create: (context) => ApiCallCubit(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Homepage(),
      ),
    );
  }
}
