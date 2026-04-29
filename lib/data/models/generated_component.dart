class GeneratedComponent {
  const GeneratedComponent({
    required this.id,
    required this.title,
    required this.description,
    required this.prompt,
    required this.componentType,
    required this.stylePreset,
    required this.html,
    required this.css,
    required this.fullHtml,
    required this.createdAt,
    this.isSaved = false,
  });

  final String id;
  final String title;
  final String description;
  final String prompt;
  final String componentType;
  final String stylePreset;
  final String html;
  final String css;
  final String fullHtml;
  final DateTime createdAt;
  final bool isSaved;

  GeneratedComponent copyWith({
    String? id,
    String? title,
    String? description,
    String? prompt,
    String? componentType,
    String? stylePreset,
    String? html,
    String? css,
    String? fullHtml,
    DateTime? createdAt,
    bool? isSaved,
  }) {
    return GeneratedComponent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      prompt: prompt ?? this.prompt,
      componentType: componentType ?? this.componentType,
      stylePreset: stylePreset ?? this.stylePreset,
      html: html ?? this.html,
      css: css ?? this.css,
      fullHtml: fullHtml ?? this.fullHtml,
      createdAt: createdAt ?? this.createdAt,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'prompt': prompt,
      'componentType': componentType,
      'stylePreset': stylePreset,
      'html': html,
      'css': css,
      'fullHtml': fullHtml,
      'createdAt': createdAt.toIso8601String(),
      'isSaved': isSaved,
    };
  }

  factory GeneratedComponent.fromJson(Map<String, dynamic> json) {
    return GeneratedComponent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      prompt: json['prompt'] as String,
      componentType: json['componentType'] as String,
      stylePreset: json['stylePreset'] as String,
      html: json['html'] as String,
      css: json['css'] as String,
      fullHtml: json['fullHtml'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }
}
