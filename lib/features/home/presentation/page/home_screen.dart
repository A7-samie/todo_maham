import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:todo_maham/core/constants/Text_style.dart';
import 'package:todo_maham/core/constants/colors.dart';
import 'package:todo_maham/features/home/cubit/task_cubit.dart';
import 'package:todo_maham/features/home/presentation/widgets/Task_Screen.dart';
import 'package:todo_maham/features/home/presentation/widgets/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().loadTasks();
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const Drawer(),
        backgroundColor: const Color.fromARGB(240, 255, 255, 255),
        appBar: AppBar(
          elevation: 3,
          backgroundColor: AppColor.whiteColor,
          title: Text("Maham", style: AppStyle.black18Bold),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () {},
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  height: 35.h,
                  width: 35.w,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/ahmed.jpeg",
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        body: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TaskError) {
              return Center(child: Text(state.message));
            }

            if (state is TaskLoaded) {
              return _buildBody(context, state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TaskLoaded state) {
    final cubit = context.read<TaskCubit>();

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 15),
          child: Column(
            children: [
              CustomTextField(
                onChanged: (value) => cubit.searchTasks(value),
                hintText: "Search",
              ),
              SizedBox(height: 20.h),

              Expanded(
                child: ListView(
                  children: [
                    Center(
                      child: Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Colors.black,
                              height: 2,
                              thickness: 2,
                              indent: 10,
                              endIndent: 10,
                            ),
                          ),
                          const Text(
                            "MyTasks",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                              height: 50,
                              thickness: 2,
                              indent: 10,
                              endIndent: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    for (final task in state.filteredTasks.reversed)
                      TaskScreen(
                        task: task,
                        onTaskChange: (t) => cubit.toggleTask(t),
                        onDelete: (id) => cubit.deleteTask(id),
                      ),

                    SizedBox(height: 90.h),
                  ],
                ),
              ),
            ],
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(
                    bottom: 20.h,
                    right: 20.h,
                    left: 20.h,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: CustomTextField(
                      controller: taskController,
                      hintText: "Add Your Tasks",
                      prefixIcon: const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.h, right: 20.h),
                child: ElevatedButton.icon(
                  label: const Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    cubit.addTask(taskController.text);
                    taskController.clear();
                  },
                  icon: const Icon(Icons.add, size: 20, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
