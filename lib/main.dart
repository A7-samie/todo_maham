import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_maham/features/home/cubit/task_cubit.dart';
import 'package:todo_maham/features/home/presentation/page/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Maham Todo',

          home: BlocProvider(
            create: (context) => TaskCubit(),
            child: HomeScreen(),
          ),
        );
      },
    );
  }
}
