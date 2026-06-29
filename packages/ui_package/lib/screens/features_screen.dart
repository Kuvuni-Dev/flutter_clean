import 'package:flutter/material.dart';
import '../services/feature_service.dart';
import '../widgets/result_bar.dart';
import 'sections/feature_form_section.dart';

class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen> {
  final _featureService = FeatureService();
  final _featureNameCtrl = TextEditingController();
  String _projectPath = '.';
  final _entityCtrl = TextEditingController();
  final _entities = <String>[];
  bool _includeDataLayer = true;
  bool _includePresentation = true;

  bool _creating = false;
  String? _result;
  String? _error;

  @override
  void dispose() {
    _featureNameCtrl.dispose();
    _entityCtrl.dispose();
    super.dispose();
  }

  void _addEntity() {
    final name = _entityCtrl.text.trim();
    if (name.isNotEmpty && !_entities.contains(name)) {
      setState(() {
        _entities.add(name);
        _entityCtrl.clear();
      });
    }
  }

  Future<void> _createFeature() async {
    setState(() {
      _creating = true;
      _error = null;
      _result = null;
    });

    final result = await _featureService.createFeature(
      featureName: _featureNameCtrl.text,
      projectPath: _projectPath,
      entities: List.from(_entities),
      includeDataLayer: _includeDataLayer,
      includePresentation: _includePresentation,
    );

    if (mounted) {
      setState(() {
        _creating = false;
        if (result.isSuccess) {
          _result = result.message;
        } else {
          _error = result.error;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: FeatureFormSection(
                  featureNameCtrl: _featureNameCtrl,
                  projectPath: _projectPath,
                  entityCtrl: _entityCtrl,
                  entities: _entities,
                  includeDataLayer: _includeDataLayer,
                  includePresentation: _includePresentation,
                  creating: _creating,
                  onPickProjectDir: () async {
                    final path = await FeatureService.pickProjectDirectory();
                    if (path != null) setState(() => _projectPath = path);
                  },
                  onAddEntity: _addEntity,
                  onRemoveEntity: (e) => setState(() => _entities.remove(e)),
                  onToggleDataLayer: (v) =>
                      setState(() => _includeDataLayer = v),
                  onTogglePresentation: (v) =>
                      setState(() => _includePresentation = v),
                  onCreateFeature: _createFeature,
                ),
              ),
            ),
          ),
        ),
        if (_result != null || _error != null)
          ResultBar(
            error: _error,
            result: _result,
            onDismiss: () => setState(() {
              _error = null;
              _result = null;
            }),
          ),
      ],
    );
  }
}
