import 'package:flutter/cupertino.dart';

class AppConstants {
  const AppConstants._();

  static const appName = 'CraftUI Mobile';
  static const tagline = 'Generate premium HTML & CSS components from your phone.';
  static const samplePrompt = 'Create a hero section for a gaming marketplace called DriveX.';

  static const componentTypes = <String>[
    'Hero Section',
    'Navbar',
    'Pricing Section',
    'Product Card',
    'Footer',
    'Landing Page',
    'Dashboard Card',
    'Contact Section',
  ];

  static const stylePresets = <String>[
    'Minimal',
    'SaaS',
    'Gaming',
    'Luxury',
    'Portfolio',
    'E-commerce',
    'Glassmorphism',
    'Dark Futuristic',
  ];

  static const loadingSteps = <String>[
    'Designing layout…',
    'Writing clean HTML…',
    'Polishing CSS…',
  ];
}

IconData iconForPreset(String preset) {
  switch (preset) {
    case 'SaaS':
      return CupertinoIcons.square_stack_3d_up_fill;
    case 'Gaming':
      return CupertinoIcons.gamecontroller_fill;
    case 'Luxury':
      return CupertinoIcons.sparkles;
    case 'Portfolio':
      return CupertinoIcons.person_crop_square_fill;
    case 'E-commerce':
      return CupertinoIcons.bag_fill;
    case 'Glassmorphism':
      return CupertinoIcons.circle_grid_hex_fill;
    case 'Dark Futuristic':
      return CupertinoIcons.bolt_horizontal_circle_fill;
    case 'Minimal':
    default:
      return CupertinoIcons.circle_lefthalf_fill;
  }
}

IconData iconForComponentType(String type) {
  switch (type) {
    case 'Navbar':
      return CupertinoIcons.rectangle_grid_1x2_fill;
    case 'Pricing Section':
      return CupertinoIcons.creditcard_fill;
    case 'Product Card':
      return CupertinoIcons.cube_box_fill;
    case 'Footer':
      return CupertinoIcons.rectangle_bottomthird_inset_filled;
    case 'Landing Page':
      return CupertinoIcons.doc_richtext_fill;
    case 'Dashboard Card':
      return CupertinoIcons.chart_bar_square_fill;
    case 'Contact Section':
      return CupertinoIcons.chat_bubble_2_fill;
    case 'Hero Section':
    default:
      return CupertinoIcons.rectangle_3_offgrid_fill;
  }
}
