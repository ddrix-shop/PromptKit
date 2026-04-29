String codeForLanguage({
  required String language,
  required String html,
  required String css,
  required String fullHtml,
}) {
  switch (language) {
    case 'HTML':
      return html;
    case 'CSS':
      return css;
    case 'Full':
    default:
      return fullHtml;
  }
}
