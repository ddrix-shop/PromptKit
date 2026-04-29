import 'package:uuid/uuid.dart';

import '../models/generated_component.dart';

class AiGenerationService {
  AiGenerationService({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  Future<GeneratedComponent> generateComponent({
    required String prompt,
    required String componentType,
    required String stylePreset,
    required bool includeResponsive,
    required bool includeAnimations,
    required bool useCssVariables,
    required bool oneFileHtml,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 420));

    final title = _titleFrom(prompt: prompt, componentType: componentType);
    final description =
        'A premium $stylePreset $componentType generated from your prompt with clean semantic HTML and mobile-first CSS.';
    final html = _buildHeroHtml(title: title, prompt: prompt, stylePreset: stylePreset);
    final css = _buildHeroCss(
      includeResponsive: includeResponsive,
      includeAnimations: includeAnimations,
      useCssVariables: useCssVariables,
      stylePreset: stylePreset,
    );
    final fullHtml = _buildFullHtml(title: title, html: html, css: css);

    return GeneratedComponent(
      id: _uuid.v4(),
      title: title,
      description: description,
      prompt: prompt,
      componentType: componentType,
      stylePreset: stylePreset,
      html: html,
      css: css,
      fullHtml: fullHtml,
      createdAt: DateTime.now(),
      isSaved: false,
    );
  }

  String _titleFrom({required String prompt, required String componentType}) {
    final normalized = prompt.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized.isEmpty) {
      return 'Premium $componentType';
    }

    final nameMatch = RegExp(r'(called|named|for)\s+([A-Za-z0-9\- ]{2,28})', caseSensitive: false)
        .firstMatch(normalized);
    final brand = nameMatch?.group(2)?.trim().replaceAll(RegExp(r'[.!,]$'), '');
    if (brand != null && brand.isNotEmpty) {
      return '$brand $componentType';
    }

    final words = normalized.split(' ').take(5).join(' ');
    return '$words $componentType';
  }

  String _escapeHtml(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  String _buildHeroHtml({
    required String title,
    required String prompt,
    required String stylePreset,
  }) {
    final safeTitle = _escapeHtml(title);
    final safePrompt = _escapeHtml(prompt);
    final eyebrow = stylePreset == 'Gaming' || stylePreset == 'Dark Futuristic'
        ? 'Next-gen digital experience'
        : 'Premium generated interface';

    return '''<section class="craft-hero" aria-labelledby="craft-hero-title">
  <div class="craft-hero__glow craft-hero__glow--one" aria-hidden="true"></div>
  <div class="craft-hero__glow craft-hero__glow--two" aria-hidden="true"></div>

  <nav class="craft-hero__nav" aria-label="Hero navigation">
    <a class="craft-hero__brand" href="#" aria-label="$safeTitle home">
      <span class="craft-hero__brand-mark"></span>
      <span>$safeTitle</span>
    </a>
    <a class="craft-hero__nav-link" href="#features">Explore</a>
  </nav>

  <div class="craft-hero__content">
    <p class="craft-hero__eyebrow">$eyebrow</p>
    <h1 id="craft-hero-title">Build interfaces that feel designed, not generated.</h1>
    <p class="craft-hero__copy">
      $safePrompt Refined into a cinematic, conversion-ready hero section with elegant spacing,
      responsive structure, and modern visual depth.
    </p>

    <div class="craft-hero__actions" aria-label="Primary actions">
      <a class="craft-hero__button craft-hero__button--primary" href="#start">Start building</a>
      <a class="craft-hero__button craft-hero__button--ghost" href="#preview">View preview</a>
    </div>

    <dl class="craft-hero__stats" aria-label="Component highlights">
      <div>
        <dt>98</dt>
        <dd>Lighthouse-ready</dd>
      </div>
      <div>
        <dt>12kb</dt>
        <dd>Clean CSS</dd>
      </div>
      <div>
        <dt>100%</dt>
        <dd>Responsive</dd>
      </div>
    </dl>
  </div>

  <aside class="craft-hero__preview" aria-label="Generated component preview card">
    <div class="craft-hero__window-bar">
      <span></span><span></span><span></span>
    </div>
    <div class="craft-hero__preview-inner">
      <span class="craft-hero__badge">AI UI Kit</span>
      <h2>Premium launch block</h2>
      <p>Semantic HTML, tokenized CSS, and a mobile-first visual system.</p>
      <div class="craft-hero__meter">
        <span></span>
      </div>
      <div class="craft-hero__tiles">
        <span></span><span></span><span></span>
      </div>
    </div>
  </aside>
</section>''';
  }

  String _buildHeroCss({
    required bool includeResponsive,
    required bool includeAnimations,
    required bool useCssVariables,
    required String stylePreset,
  }) {
    final accent = stylePreset == 'Luxury' ? '#D7A955' : '#FD551D';
    final secondary = stylePreset == 'Gaming' ? '#7C3DFF' : '#FF8A4D';
    final surface = stylePreset == 'Minimal' ? '#F7F4EF' : '#080808';
    final text = stylePreset == 'Minimal' ? '#101010' : '#F5F5F5';
    final muted = stylePreset == 'Minimal' ? '#686868' : '#A3A3A3';

    final variables = useCssVariables
        ? ''':root {
  --craft-accent: $accent;
  --craft-accent-soft: $secondary;
  --craft-bg: $surface;
  --craft-surface: ${stylePreset == 'Minimal' ? '#FFFFFF' : '#141414'};
  --craft-text: $text;
  --craft-muted: $muted;
  --craft-border: rgba(255, 255, 255, 0.10);
  --craft-radius-lg: 34px;
  --craft-radius-md: 22px;
  --craft-shadow: 0 26px 90px rgba(0, 0, 0, 0.38);
}

'''
        : '';

    final token = useCssVariables;
    String c(String variable, String fallback) => token ? 'var($variable)' : fallback;

    final responsiveCss = includeResponsive
        ? '''
@media (max-width: 780px) {
  .craft-hero {
    grid-template-columns: 1fr;
    padding: 24px;
    min-height: 720px;
  }

  .craft-hero__nav {
    grid-column: 1;
  }

  .craft-hero__content {
    padding-top: 20px;
  }

  .craft-hero h1 {
    font-size: clamp(44px, 14vw, 72px);
  }

  .craft-hero__preview {
    min-height: 310px;
  }

  .craft-hero__actions,
  .craft-hero__stats {
    grid-template-columns: 1fr;
  }
}
'''
        : '';

    final animationCss = includeAnimations
        ? '''
@keyframes craft-float {
  0%, 100% { transform: translate3d(0, 0, 0) rotate(-1deg); }
  50% { transform: translate3d(0, -14px, 0) rotate(1deg); }
}

@keyframes craft-glow {
  0%, 100% { opacity: 0.55; transform: scale(1); }
  50% { opacity: 0.82; transform: scale(1.12); }
}

.craft-hero__preview {
  animation: craft-float 7s ease-in-out infinite;
}

.craft-hero__glow {
  animation: craft-glow 5.5s ease-in-out infinite;
}

.craft-hero__glow--two {
  animation-delay: -2.4s;
}
'''
        : '';

    return '''$variables* {
  box-sizing: border-box;
}

body {
  margin: 0;
  background: ${c('--craft-bg', surface)};
  color: ${c('--craft-text', text)};
  font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "SF Pro Display", "Segoe UI", sans-serif;
  -webkit-font-smoothing: antialiased;
}

.craft-hero {
  position: relative;
  isolation: isolate;
  display: grid;
  grid-template-columns: minmax(0, 1.05fr) minmax(280px, 0.95fr);
  gap: clamp(28px, 5vw, 72px);
  align-items: center;
  width: min(1180px, calc(100vw - 28px));
  min-height: 680px;
  margin: 0 auto;
  padding: clamp(22px, 4vw, 44px);
  overflow: hidden;
  border: 1px solid ${c('--craft-border', 'rgba(255, 255, 255, 0.10)')};
  border-radius: ${c('--craft-radius-lg', '34px')};
  background:
    radial-gradient(circle at 18% 18%, ${accent}26, transparent 28%),
    radial-gradient(circle at 90% 24%, ${secondary}22, transparent 24%),
    linear-gradient(145deg, rgba(255, 255, 255, 0.09), rgba(255, 255, 255, 0.025));
  box-shadow: ${c('--craft-shadow', '0 26px 90px rgba(0, 0, 0, 0.38)')};
}

.craft-hero::before {
  content: "";
  position: absolute;
  inset: 1px;
  z-index: -2;
  border-radius: inherit;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.08), transparent 42%);
}

.craft-hero__glow {
  position: absolute;
  z-index: -3;
  width: 260px;
  height: 260px;
  border-radius: 999px;
  filter: blur(34px);
  opacity: 0.58;
}

.craft-hero__glow--one {
  top: -72px;
  left: -54px;
  background: ${accent};
}

.craft-hero__glow--two {
  right: -76px;
  bottom: 4%;
  background: ${secondary};
}

.craft-hero__nav {
  grid-column: 1 / -1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
}

.craft-hero__brand,
.craft-hero__nav-link,
.craft-hero__button {
  color: inherit;
  text-decoration: none;
}

.craft-hero__brand {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  font-size: 14px;
  font-weight: 800;
  letter-spacing: -0.02em;
}

.craft-hero__brand-mark {
  width: 34px;
  height: 34px;
  border-radius: 12px;
  background: linear-gradient(135deg, ${accent}, ${secondary});
  box-shadow: 0 14px 32px ${accent}45;
}

.craft-hero__nav-link {
  padding: 10px 14px;
  border: 1px solid ${c('--craft-border', 'rgba(255, 255, 255, 0.10)')};
  border-radius: 999px;
  color: ${c('--craft-muted', muted)};
  font-size: 13px;
  font-weight: 700;
  backdrop-filter: blur(16px);
}

.craft-hero__content {
  max-width: 650px;
}

.craft-hero__eyebrow {
  display: inline-flex;
  margin: 0 0 18px;
  padding: 9px 12px;
  border: 1px solid ${c('--craft-border', 'rgba(255, 255, 255, 0.10)')};
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.06);
  color: ${c('--craft-muted', muted)};
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.craft-hero h1 {
  max-width: 780px;
  margin: 0;
  color: ${c('--craft-text', text)};
  font-size: clamp(54px, 8vw, 104px);
  line-height: 0.88;
  letter-spacing: -0.075em;
}

.craft-hero__copy {
  max-width: 590px;
  margin: 24px 0 0;
  color: ${c('--craft-muted', muted)};
  font-size: clamp(16px, 2vw, 19px);
  line-height: 1.62;
}

.craft-hero__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 32px;
}

.craft-hero__button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 52px;
  padding: 0 20px;
  border-radius: 999px;
  font-weight: 850;
  letter-spacing: -0.02em;
  transition: transform 180ms ease, border-color 180ms ease, background 180ms ease;
}

.craft-hero__button:hover {
  transform: translateY(-2px);
}

.craft-hero__button--primary {
  color: #fff;
  background: linear-gradient(135deg, ${accent}, ${secondary});
  box-shadow: 0 20px 48px ${accent}40;
}

.craft-hero__button--ghost {
  border: 1px solid ${c('--craft-border', 'rgba(255, 255, 255, 0.10)')};
  color: ${c('--craft-text', text)};
  background: rgba(255, 255, 255, 0.055);
}

.craft-hero__stats {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 10px;
  margin: 34px 0 0;
}

.craft-hero__stats div {
  padding: 16px;
  border: 1px solid ${c('--craft-border', 'rgba(255, 255, 255, 0.10)')};
  border-radius: ${c('--craft-radius-md', '22px')};
  background: rgba(255, 255, 255, 0.055);
}

.craft-hero__stats dt {
  margin: 0 0 3px;
  color: ${c('--craft-text', text)};
  font-size: 22px;
  font-weight: 900;
}

.craft-hero__stats dd {
  margin: 0;
  color: ${c('--craft-muted', muted)};
  font-size: 12px;
  font-weight: 700;
}

.craft-hero__preview {
  overflow: hidden;
  min-height: 430px;
  border: 1px solid ${c('--craft-border', 'rgba(255, 255, 255, 0.10)')};
  border-radius: ${c('--craft-radius-lg', '34px')};
  background:
    linear-gradient(160deg, rgba(255, 255, 255, 0.14), rgba(255, 255, 255, 0.035)),
    ${c('--craft-surface', stylePreset == 'Minimal' ? '#FFFFFF' : '#141414')};
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.12), 0 28px 70px rgba(0, 0, 0, 0.30);
}

.craft-hero__window-bar {
  display: flex;
  gap: 7px;
  padding: 18px;
  border-bottom: 1px solid ${c('--craft-border', 'rgba(255, 255, 255, 0.10)')};
}

.craft-hero__window-bar span {
  width: 10px;
  height: 10px;
  border-radius: 99px;
  background: rgba(255, 255, 255, 0.32);
}

.craft-hero__preview-inner {
  padding: clamp(22px, 4vw, 34px);
}

.craft-hero__badge {
  display: inline-flex;
  margin-bottom: 56px;
  padding: 9px 11px;
  border-radius: 999px;
  background: ${accent}20;
  color: ${accent};
  font-size: 12px;
  font-weight: 900;
}

.craft-hero__preview h2 {
  margin: 0;
  max-width: 390px;
  color: ${c('--craft-text', text)};
  font-size: clamp(34px, 6vw, 56px);
  line-height: 0.95;
  letter-spacing: -0.055em;
}

.craft-hero__preview p {
  max-width: 330px;
  margin: 16px 0 0;
  color: ${c('--craft-muted', muted)};
  line-height: 1.56;
}

.craft-hero__meter {
  height: 12px;
  margin-top: 34px;
  overflow: hidden;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.10);
}

.craft-hero__meter span {
  display: block;
  width: 74%;
  height: 100%;
  border-radius: inherit;
  background: linear-gradient(90deg, ${accent}, ${secondary});
}

.craft-hero__tiles {
  display: grid;
  grid-template-columns: 1.3fr 0.9fr 0.65fr;
  gap: 10px;
  margin-top: 12px;
}

.craft-hero__tiles span {
  min-height: 82px;
  border: 1px solid ${c('--craft-border', 'rgba(255, 255, 255, 0.10)')};
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.065);
}
$responsiveCss
$animationCss''';
  }

  String _buildFullHtml({
    required String title,
    required String html,
    required String css,
  }) {
    return '''<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="description" content="Premium HTML and CSS component generated by CraftUI Mobile." />
  <title>${_escapeHtml(title)}</title>
  <style>
$css
  </style>
</head>
<body>
  <main>
$html
  </main>
</body>
</html>''';
  }
}
