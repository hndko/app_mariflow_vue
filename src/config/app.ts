/**
 * ==============================================================================
 * MariFlow SaaS — Central Application Configuration & Semantic Versioning
 * ==============================================================================
 * Acuan versi aplikasi menggunakan Semantic Versioning (MAJOR.MINOR.PATCH).
 * Selalu sinkronkan perubahan versi dengan `package.json` dan panduan AGENTS.md.
 */

export const APP_CONFIG = {
  name: 'MariFlow',
  brand: 'Mari Partner',
  version: '1.0.3',
  tagline: 'Simple Workspace & Task Management',
  releaseName: 'Titanium Flow',
  buildDate: '2026-09-02',
  links: {
    github: 'https://github.com/hndko/app_mariflow_vue',
    docs: '/docs',
  },
} as const
