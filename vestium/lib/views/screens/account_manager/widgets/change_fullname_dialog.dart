import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/views/screens/account_manager/cubit/account_manager_cubit.dart';

class ChangeFullNameDialog extends StatefulWidget {
  final String currentName;

  const ChangeFullNameDialog({Key? key, required this.currentName})
    : super(key: key);

  @override
  State<ChangeFullNameDialog> createState() => _ChangeFullNameDialogState();
}

class _ChangeFullNameDialogState extends State<ChangeFullNameDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  void _handleUpdate(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final newName = _fullNameController.text.trim();

      // Additional check: ensure name is different from current
      if (newName == widget.currentName) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New name must be different from current name'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Trigger the cubit update
      context.read<AccountManagerCubit>().updateFullName(newName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountManagerCubit, AccountManagerState>(
      listener: (context, state) {
        // Success: close dialog
        if (state is AccountManagerUpdateSuccess &&
            state.updateType == 'fullName') {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Full name updated successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
        // Error: show snackbar with error message
        else if (state is AccountManagerError &&
            state.updateType == 'fullName') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: AlertDialog(
        title: const Text('Change Full Name'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your new full name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Full name cannot be empty';
              }
              if (value.trim().length < 2) {
                return 'Full name must be at least 2 characters';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          BlocBuilder<AccountManagerCubit, AccountManagerState>(
            builder: (context, state) {
              final isLoading =
                  state is AccountManagerUpdating &&
                  state.updateType == 'fullName';
              return ElevatedButton(
                onPressed: isLoading ? null : () => _handleUpdate(context),
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text('Update'),
              );
            },
          ),
        ],
      ),
    );
  }
}
