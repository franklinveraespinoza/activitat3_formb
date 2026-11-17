import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Franklin Vera Espinoza',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String title = 'Franklin Vera Espinoza';
  final _formKey = GlobalKey<FormBuilderState>();
  int _currentStep = 0;
  void _onStepContinue() {
    if (_currentStep < 2) {
      setState(() => _currentStep += 1);
    } else {
      final ok = _formKey.currentState?.saveAndValidate() ?? false;
      if (ok) {
        alertDialog(context, _formKey.currentState!.value.toString());
      }
    }
  }
  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }
  String? _validateRequired(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El email es obligatorio';
    }
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(value.trim())) return 'Introduce un email válido';
    return null;
  }
  String? _validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El móvil es obligatorio';
    }
    if (!RegExp(r'^\d{9}$').hasMatch(value.trim())) {
      return 'Debe tener 9 dígitos';
    }
    return null;
  }

  Widget _buildControls(BuildContext context, ControlsDetails details) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          FilledButton(
            onPressed: details.onStepContinue,
            child: const Text('CONTINUE'),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: details.onStepCancel,
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildContactFields() {
    return Column(
      children: [
        const SizedBox(height: 8),
        FormBuilderTextField(
          name: 'email',
          keyboardType: TextInputType.emailAddress,
          decoration: _decoration('Email', Icons.email),
          validator: _validateEmail,
        ),
        const SizedBox(height: 12),
        FormBuilderTextField(
          name: 'address',
          minLines: 4,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: _decoration('Address', Icons.home),
          validator: (v) => _validateRequired(v, 'La dirección es obligatoria'),
        ),
        const SizedBox(height: 12),
        FormBuilderTextField(
          name: 'mobile',
          keyboardType: TextInputType.phone,
          decoration: _decoration('Mobile No', Icons.phone),
          validator: _validateMobile,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,
          onStepTapped: (index) => setState(() => _currentStep = index),
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          controlsBuilder: _buildControls,
          steps: [
            Step(
              title: const Text('Pers.'),
              state: StepState.indexed,
              isActive: _currentStep >= 0,
              content: const StepIntro(
                title: 'Personal',
                text: 'Pulsi "Contact" o pulsi el botó de "Continue".',
              ),
            ),
            Step(
              title: const Text('Contact'),
              state: StepState.editing,
              isActive: _currentStep >= 1,
              content: const StepIntro(
                title: 'Contact',
                text: 'Pulsi "Upload" o pulsi el botó de "Continue".',
              ),
            ),
            Step(
              title: const Text('Upload'),
              state: StepState.complete,
              isActive: _currentStep >= 2,
              content: _buildContactFields(),
            ),
          ],
        ),
      ),
    );
  }
}

class StepIntro extends StatelessWidget {
  const StepIntro({super.key, required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 8),
        Text(text),
      ],
    );
  }
}

void alertDialog(BuildContext context, String contentText) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Submission Completed'),
      icon: const Icon(Icons.check_circle),
      content: Text(contentText),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Close'),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
