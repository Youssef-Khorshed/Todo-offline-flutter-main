import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/constant/app_colors.dart';
import 'package:todo/features/todo/domain/entities/todo_enti.dart';
import 'package:todo/features/todo/presentation/bloc/bloc/todo_bloc.dart';
import 'package:todo/features/todo/presentation/widgets/done_todo_page/done_todo_posts_widget.dart';
import 'package:todo/features/todo/presentation/widgets/todo_page/bg_widget.dart';
import 'package:todo/features/todo/presentation/widgets/public/dialog_widget.dart';

class DoneTodoPage extends StatefulWidget {
  const DoneTodoPage({Key? key}) : super(key: key);

  @override
  State<DoneTodoPage> createState() => _DoneTodoPageState();
}

class _DoneTodoPageState extends State<DoneTodoPage> {
  int? _itemToDeleteId;
  bool get _isDeleteMode => _itemToDeleteId != null;

  void _deleteSelectedItem() {
    if (_itemToDeleteId == null) return;

    final itemIdToDelete = _itemToDeleteId!;

    context.read<TodoBloc>().add(DeleteTodoEvent(itemIdToDelete));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item deleted'),
          backgroundColor: Colors.green,
        ),
      );
    }

    _cancelDeleteMode();

    context.read<TodoBloc>().add(GetDoneTodoEvent());
  }

  void _enterDeleteMode(int itemId) {
    setState(() {
      _itemToDeleteId = itemId;
    });
  }

  void _cancelDeleteMode() {
    setState(() {
      _itemToDeleteId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyBuilder(context),
    );
  }

  Widget _bodyBuilder(BuildContext context) {
    return BgWidget(
      childWidget: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: double.maxFinite,
              width: double.maxFinite,
              child: Column(
                children: [
                  if (_isDeleteMode)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delete selected item?'),
                          Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.grey),
                                onPressed: _cancelDeleteMode,
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: _deleteSelectedItem,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  _todoListBuilder(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _todoListBuilder() {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is LoadingTodoState) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.bgGrandentTop.withOpacity(0.3),
              ),
            ),
          );
        } else if (state is ErrorTodoState) {
          return Expanded(
            child: Center(
              child: Text(
                "Error loading data: ${state.message ?? 'Unknown error'}",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        } else if (state is LoadedTodoState) {
          if (state.todoList == null || state.todoList!.isEmpty) {
            return const Expanded(
              child: Center(
                child: Text("No completed tasks yet."),
              ),
            );
          }
          return Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (index >= state.todoList!.length) {
                  return const SizedBox(height: 20);
                }

                final todoItem = state.todoList![index];
                final isMarkedForDeletion = _itemToDeleteId == todoItem.id;

                return _DeletableTodoItem(
                  todoEnti: todoItem,
                  isMarkedForDeletion: isMarkedForDeletion,
                  onTap: () {
                    if (_isDeleteMode) {
                      if (isMarkedForDeletion) {
                        _cancelDeleteMode();
                      } else {
                        _enterDeleteMode(todoItem.id!);
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DialogMoreWidget(todoEnti: todoItem);
                        },
                      );
                    }
                  },
                  onLongPress: () {
                    _enterDeleteMode(todoItem.id!);
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemCount:
                  state.todoList!.isNotEmpty ? state.todoList!.length + 1 : 0,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _DeletableTodoItem extends StatelessWidget {
  final TodoEnti todoEnti;
  final bool isMarkedForDeletion;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _DeletableTodoItem({
    Key? key,
    required this.todoEnti,
    required this.isMarkedForDeletion,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          DoneTodoPostWidget(
            todoEnti: todoEnti,
            onTap: onTap,
          ),
          if (isMarkedForDeletion)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
