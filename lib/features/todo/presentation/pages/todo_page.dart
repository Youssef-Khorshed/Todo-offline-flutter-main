import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/constant/app_colors.dart';
import 'package:todo/core/constant/app_route.dart';
import 'package:todo/features/Login/Data/Datasource/Local/shared_pref.dart';
import 'package:todo/features/todo/presentation/bloc/bloc/todo_bloc.dart';
import 'package:todo/features/todo/presentation/widgets/todo_page/app_bar_widget.dart';
import 'package:todo/features/todo/presentation/widgets/todo_page/bg_bottom_bar.dart';
import 'package:todo/features/todo/presentation/widgets/todo_page/bg_widget.dart';
import 'package:todo/features/todo/presentation/widgets/public/dialog_widget.dart';
import 'package:todo/features/todo/presentation/widgets/todo_page/drawer_widget.dart';
import 'package:todo/features/todo/presentation/widgets/todo_page/main_bottom_bar.dart';
import 'package:todo/features/todo/presentation/widgets/todo_page/second_bottom_bar.dart';
import 'package:todo/features/todo/presentation/widgets/todo_page/todo_post_widget.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  int showNumber = 0;
  List<int> idPostsForUpdate = [];
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      endDrawer: DrawerWidget(
        scaffoldState: scaffoldState,
      ),
      body: _bodyBuilder(context: context),
    );
  }

  Widget _bodyBuilder({required BuildContext context}) {
    return BgWidget(
        childWidget: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: double.maxFinite,
            width: double.maxFinite,
            child: Column(
              children: [
                AppBarWidget(onTapIcon: () async {
                  SharedPref sharedPref = await SharedPref.getInstance();
                  await sharedPref.logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoute.login, (route) => false);
                }),
                _todoListBuilder(),
              ],
            ),
          ),
        ),
        BgBottomBar(
            widget: AnimatedSwitcher(
                duration: Durations.medium1,
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: showNumber == 1
                    ? SecondBottomBar(
                        onTapsubmet: () async {
                          if (idPostsForUpdate.isNotEmpty) {
                            BlocProvider.of<TodoBloc>(context).add(
                                UpdateTodoEvent(idsTodo: idPostsForUpdate));
                          }
                        },
                        onTapClose: () => setState(() {
                          showNumber = 0;
                        }),
                      )
                    : MainBottomBar(
                        onTapAdd: () =>
                            scaffoldState.currentState!.openEndDrawer(),
                        key: const ValueKey(2),
                        onTapDone: () => setState(() {
                          showNumber = 1;
                        }),
                      ))),
      ],
    ));
  }

  Widget _todoListBuilder() {
    return BlocConsumer<TodoBloc, TodoState>(
      listener: (context, state) {
        if (state is LoadedTodoState) {
          setState(() {
            idPostsForUpdate.clear();
            showNumber = 0;
          });
        }
      },
      builder: (context, state) {
        if (state is LoadingTodoState) {
          return Expanded(
              child: Center(
            child: CircularProgressIndicator(
              color: AppColors.bgGrandentTop.withOpacity(0.3),
            ),
          ));
          //!
        } else if (state is ErrorTodoState) {
          //!
          return const Text("NO DATA");
        } else if (state is LoadedTodoState) {
          //! list Posts
          return Expanded(
            child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return index != state.todoList!.length
                      ? TodoPostWidget(
                          ids: idPostsForUpdate,
                          todoEnti: state.todoList![index],
                          showNumber: showNumber,
                          onTapCheckOut: () {
                            setState(() {
                              idPostsForUpdate
                                      .contains(state.todoList![index].id)
                                  ? idPostsForUpdate
                                      .remove(state.todoList![index].id)
                                  : idPostsForUpdate
                                      .add(state.todoList![index].id!);
                            });
                          },
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return PartDownOfDialog(
                                  todoEnti: state.todoList![index]);
                            },
                          ),
                        )
                      : const SizedBox(
                          height: 200,
                        );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                itemCount: state.todoList!.isNotEmpty
                    ? state.todoList!.length + 1
                    : 0),
          );
        }
        return const SizedBox();
      },
    );
  }
}
