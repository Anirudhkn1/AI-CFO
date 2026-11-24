import PillNav from '../components/reactbits/PillNav/PillNav.jsx';
import GooeyNav from '../components/reactbits/GooeyNav/GooeyNav.jsx';
import CardNav from '../components/reactbits/CardNav/CardNav.jsx';
import Logo, { LogoMark } from '../ui/Logo.jsx';

const LINKS = [
  { label: 'Platform', href: '#features' },
  { label: 'Console', href: '#console' },
  { label: 'Process', href: '#process' },
  { label: 'Voices', href: '#voices' },
  { label: 'Pricing', href: '#pricing' },
];

const CARDS = [
  {
    label: 'Platform',
    description: 'Books, forecasts and reports on autopilot.',
    links: [{ label: 'Capabilities', href: '#features' }, { label: 'Live console', href: '#console' }],
  },
  {
    label: 'Company',
    description: 'Why finance leaders trust NEUROPLAST.',
    links: [{ label: 'How it works', href: '#process' }, { label: 'Customer voices', href: '#voices' }],
  },
  {
    label: 'Pricing',
    description: 'Plans that scale with your ambition.',
    links: [{ label: 'Compare plans', href: '#pricing' }, { label: 'FAQ', href: '#faq' }],
  },
];

export default function Nav({ theme }) {
  const dark = theme.mode === 'dark';
  const v = theme.vars;
  const variant = theme.nav;
  const mode = theme.mode;

  if (variant === 'pill') {
    return (
      <header className="nav-wrap nav-wrap--float">
        <PillNav
          logo={<LogoMark size={26} />}
          logoAlt="NEUROPLAST AI CFO"
          logoHref="#top"
          items={[...LINKS, { label: 'Book demo', href: '#cta' }]}
          theme={mode}
          layout="split"
          surface="glass"
          hoverEffect="fill"
          highlightColor={v['--accent']}
          highlightTextColor={v['--on-accent']}
          textColor={v['--text']}
          barColor={dark ? 'rgba(255,255,255,0.08)' : 'rgba(255,255,255,0.7)'}
          ariaLabel="Primary"
        />
      </header>
    );
  }

  if (variant === 'gooey') {
    return (
      <header className="nav-wrap nav-wrap--gooey">
        <a href="#top" className="nav-logo"><Logo /></a>
        <GooeyNav items={LINKS} theme={mode} color={v['--accent']} activeTextColor={v['--on-accent']} frame />
        <a href="#cta" className="btn btn--primary btn--sm">Book demo</a>
      </header>
    );
  }

  if (variant === 'card') {
    return (
      <header className="nav-wrap nav-wrap--float">
        <CardNav
          logo={<LogoMark size={26} />}
          logoAlt="NEUROPLAST AI CFO"
          logoHref="#top"
          items={CARDS}
          cta={{ label: 'Book demo', href: '#cta' }}
          theme={mode}
          surface="glass"
          accentColor={v['--accent']}
          maxWidth={860}
          ariaLabel="Primary"
        />
      </header>
    );
  }

  if (variant === 'minimal') {
    return (
      <header className="nav-wrap nav-minimal">
        <nav>
          <a href="#features">Platform</a>
          <a href="#console">Console</a>
          <a href="#top" className="nav-logo"><Logo /></a>
          <a href="#pricing">Pricing</a>
          <a href="#cta">Invitation</a>
        </nav>
      </header>
    );
  }

  // classic
  return (
    <header className="nav-wrap nav-classic">
      <a href="#top" className="nav-logo"><Logo /></a>
      <nav>
        {LINKS.map((l) => (
          <a key={l.href} href={l.href}>{l.label}</a>
        ))}
      </nav>
      <a href="#cta" className="btn btn--primary btn--sm">Book demo</a>
    </header>
  );
}
