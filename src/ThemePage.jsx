import { lazy, Suspense, useEffect } from 'react';
import { Link, Navigate, useParams, useNavigate } from 'react-router-dom';
import { THEMES, getTheme } from './themes/themes.js';
import ClickSpark from './components/reactbits/ClickSpark/ClickSpark.jsx';
import Nav from './sections/Nav.jsx';
import { Trust, Stats, Manifesto, Features, ConsoleSection, Process, Testimonials, Pricing, FAQ, CTA, Footer } from './sections/Sections.jsx';
import './styles/heroes.css';

const pick = (loader, name) => lazy(() => loader().then((m) => ({ default: m[name] })));
const A = () => import('./heroes/HeroesA.jsx');
const B = () => import('./heroes/HeroesB.jsx');
const C = () => import('./heroes/HeroesC.jsx');

const HEROES = {
  crimson: pick(A, 'HeroCrimson'), neon: pick(A, 'HeroNeon'), atlas: pick(A, 'HeroAtlas'), periwinkle: pick(A, 'HeroPeriwinkle'),
  emerald: pick(B, 'HeroEmerald'), oxblood: pick(B, 'HeroOxblood'), teal: pick(B, 'HeroTeal'), aubergine: pick(B, 'HeroAubergine'),
  terracotta: pick(C, 'HeroTerracotta'), cobalt: pick(C, 'HeroCobalt'), platinum: pick(C, 'HeroPlatinum'), solar: pick(C, 'HeroSolar'),
};

function ThemeDock({ index }) {
  const nav = useNavigate();
  const prev = THEMES[(index + THEMES.length - 1) % THEMES.length];
  const next = THEMES[(index + 1) % THEMES.length];
  const t = THEMES[index];
  useEffect(() => {
    const onKey = (e) => {
      if (e.target.matches('input,textarea')) return;
      if (e.key === 'ArrowRight' && e.altKey) nav(`/t/${next.slug}`);
      if (e.key === 'ArrowLeft' && e.altKey) nav(`/t/${prev.slug}`);
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [nav, next.slug, prev.slug]);
  return (
    <div className="theme-dock" role="navigation" aria-label="Design directions">
      <Link to={`/t/${prev.slug}`} aria-label={`Previous: ${prev.name}`}>‹</Link>
      <Link to="/" className="dock-all">All 12</Link>
      <span className="dock-now"><b>{t.no}</b> {t.name}</span>
      <span className="dock-sw">{t.swatches.map(([n, c]) => <i key={n} title={n} style={{ background: c }} />)}</span>
      <Link to={`/t/${next.slug}`} aria-label={`Next: ${next.name}`}>›</Link>
    </div>
  );
}

export default function ThemePage() {
  const { slug } = useParams();
  const theme = getTheme(slug);

  useEffect(() => {
    if (!theme) return;
    document.title = `${theme.name} — NEUROPLAST AI CFO`;
    const prev = document.body.style.background;
    document.body.style.background = theme.vars['--bg'];
    window.scrollTo(0, 0);
    const onClick = (e) => {
      const a = e.target.closest?.('a[href^="#"]');
      if (!a) return;
      const id = a.getAttribute('href').slice(1);
      if (!id || id.startsWith('/')) return;
      e.preventDefault();
      (id === 'top' ? document.documentElement : document.getElementById(id))?.scrollIntoView({ behavior: 'smooth' });
    };
    document.addEventListener('click', onClick);
    return () => {
      document.removeEventListener('click', onClick);
      document.body.style.background = prev;
    };
  }, [theme]);

  if (!theme) return <Navigate to="/" replace />;
  const Hero = HEROES[theme.hero];
  const index = THEMES.indexOf(theme);

  return (
    <div className={`site site--${theme.mode} t-${theme.slug}`} data-mode={theme.mode} style={theme.vars} key={theme.slug}>
      <ClickSpark sparkColor={theme.vars['--accent']} sparkSize={12} sparkRadius={26} sparkCount={9} duration={550} shape="streak" glow={0.4}>
        <Nav theme={theme} />
        <main>
          <Suspense fallback={<section className="hero" id="top" />}><Hero /></Suspense>
          <Trust />
          <Stats />
          <Manifesto />
          <Features theme={theme} />
          <ConsoleSection />
          <Process />
          <Testimonials theme={theme} />
          <Pricing theme={theme} />
          <FAQ />
          <CTA theme={theme} />
        </main>
        <Footer />
      </ClickSpark>
      <ThemeDock index={index} />
    </div>
  );
}
