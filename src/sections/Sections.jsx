import { useEffect, useRef, useState } from 'react';
import LogoLoop from '../components/reactbits/LogoLoop/LogoLoop.jsx';
import CountUp from '../components/reactbits/CountUp/CountUp.jsx';
import BlurText from '../components/reactbits/BlurText/BlurText.jsx';
import ScrollReveal from '../components/reactbits/ScrollReveal/ScrollReveal.jsx';
import MagicBento from '../components/reactbits/MagicBento/MagicBento.jsx';
import SpotlightCard from '../components/reactbits/SpotlightCard/SpotlightCard.jsx';
import PixelCard from '../components/reactbits/PixelCard/PixelCard.jsx';
import TiltedCard from '../components/reactbits/TiltedCard/TiltedCard.jsx';
import GlareHover from '../components/reactbits/GlareHover/GlareHover.jsx';
import Stack from '../components/reactbits/Stack/Stack.jsx';
import StarBorder from '../components/reactbits/StarBorder/StarBorder.jsx';
import ElectricBorder from '../components/reactbits/ElectricBorder/ElectricBorder.jsx';
import Magnet from '../components/reactbits/Magnet/Magnet.jsx';
import CurvedLoop from '../components/reactbits/CurvedLoop/CurvedLoop.jsx';
import GlitchText from '../components/reactbits/GlitchText/GlitchText.jsx';
import CircularText from '../components/reactbits/CircularText/CircularText.jsx';
import ScrollVelocity from '../components/reactbits/ScrollVelocity/ScrollVelocity.jsx';
import CFOConsole from '../ui/CFOConsole.jsx';
import Icon from '../ui/Icons.jsx';
import Logo from '../ui/Logo.jsx';

/* ───────── helpers ───────── */
export function Reveal({ children, delay = 0, className = '', as: Tag = 'div' }) {
  const ref = useRef(null);
  const [on, setOn] = useState(false);
  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    const io = new IntersectionObserver(([e]) => e.isIntersecting && (setOn(true), io.disconnect()), { threshold: 0.12 });
    io.observe(el);
    return () => io.disconnect();
  }, []);
  return (
    <Tag ref={ref} className={`reveal ${on ? 'in' : ''} ${className}`} style={{ transitionDelay: `${delay}ms` }}>
      {children}
    </Tag>
  );
}

function SectionHead({ eyebrow, title, sub, align = 'center' }) {
  return (
    <div className={`sec-head sec-head--${align}`}>
      <p className="eyebrow">{eyebrow}</p>
      <div role="heading" aria-level={2} className="h-sec">
        <BlurText text={title} animateBy="words" delay={90} stepDuration={0.4} className="blur-title" />
      </div>
      {sub && <p className="lead">{sub}</p>}
    </div>
  );
}

/* ───────── Trust strip ───────── */
const NAMES = ['Halden & Co', 'Lumora', 'Northwind Labs', 'Verity Capital', 'Kestrel', 'Obsidian Foods', 'Meridian Health', 'Aster Freight', 'Quillon', 'Brightpath'];
export function Trust() {
  const logos = NAMES.map((n, i) => ({
    node: <span className={`fake-logo fl-${i % 5}`}>{n}</span>,
    title: n,
  }));
  return (
    <section className="trust" id="trust">
      <p className="trust-label">Trusted by finance teams at ambitious companies <em>(sample names)</em></p>
      <LogoLoop logos={logos} speed={70} gap={56} logoHeight={30} fadeOut fadeOutWidth={0.14} pauseOnHover />
    </section>
  );
}

/* ───────── Stats ───────── */
export function Stats() {
  const items = [
    [92, '%', 'less time on month-end close'],
    [14, 'x', 'faster board reporting'],
    [4.2, 'M', 'transactions categorised daily', 1],
    [99.2, '%', 'reconciliation accuracy', 1],
  ];
  return (
    <section className="stats">
      <div className="container stats-grid">
        {items.map(([n, s, label, d], i) => (
          <Reveal key={label} delay={i * 80} className="stat">
            <b><CountUp to={n} decimals={d || 0} duration={2.2} suffix={s} /></b>
            <span>{label}</span>
          </Reveal>
        ))}
        <p className="stats-note">Illustrative targets for design preview.</p>
      </div>
    </section>
  );
}

/* ───────── Manifesto (scroll-scrubbed text) ───────── */
export function Manifesto() {
  return (
    <section className="manifesto">
      <div className="container">
        <ScrollReveal baseOpacity={0.12} enableBlur baseRotation={2} blurStrength={5} textClassName="manifesto-text">
          Every company deserves a world-class CFO. NEUROPLAST gives you one that reads every transaction, remembers every
          decision, and thinks twelve months ahead — all day, every day.
        </ScrollReveal>
      </div>
    </section>
  );
}

/* ───────── Features ───────── */
const FEATURES = [
  { icon: 'chart', title: 'Predictive Cash Forecasting', desc: 'Probabilistic 12-month forecasts that refresh every morning with live bank and pipeline data.' },
  { icon: 'layers', title: 'Autonomous Bookkeeping', desc: 'Transactions categorised, matched and reconciled continuously — the close happens as you go.' },
  { icon: 'sliders', title: 'Scenario Lab', desc: 'Model hiring, pricing and funding rounds in seconds and see the runway impact instantly.' },
  { icon: 'radar', title: 'Anomaly & Fraud Radar', desc: 'Duplicate payments, vendor drift and policy breaches are flagged the moment they appear.' },
  { icon: 'file', title: 'Board-Ready Reporting', desc: 'Investor updates and board packs assembled in your brand, with commentary written for you.' },
  { icon: 'chat', title: 'Ask Your CFO', desc: 'Plain-English answers to “can we afford it?” with the numbers and the reasoning attached.' },
];

export function Features({ theme }) {
  const kind = theme.features;
  const dark = theme.mode === 'dark';
  const accent = theme.vars['--accent-2'] === theme.vars['--text'] ? theme.vars['--accent'] : theme.vars['--accent'];
  let body;

  if (kind === 'magic') {
    const items = [
      { title: 'Predictive cash forecasting', description: 'Twelve months, refreshed daily', visual: 'analytics' },
      { title: 'Board-ready reporting', description: 'Packs in your brand, in one click', visual: 'dashboard' },
      { title: 'Ask your CFO', description: 'Plain-English answers, with reasoning attached', visual: 'collaboration', colSpan: 2, rowSpan: 2 },
      { title: 'Autonomous bookkeeping', description: 'Matched and reconciled as it happens', visual: 'automation', colSpan: 2, rowSpan: 2 },
      { title: 'Connects to everything', description: 'Bank, ERP, payroll, CRM', visual: 'integration' },
      { title: 'Bank-grade security', description: 'Encrypted, access-controlled, audited', visual: 'security' },
    ];
    body = (
      <div className="bento-wrap">
        <MagicBento items={items} columns={4} rowHeight={190} gap={14} theme={theme.mode} glowColor={accent} enableSpotlight enableBorderGlow enableStars clickEffect />
      </div>
    );
  } else if (kind === 'spotlight') {
    body = (
      <div className="fgrid">
        {FEATURES.map((f, i) => (
          <Reveal key={f.title} delay={i * 70}>
            <SpotlightCard theme={theme.mode} spotlightColor={accent} className="fcard">
              <span className="fico"><Icon name={f.icon} size={24} /></span>
              <h3>{f.title}</h3>
              <p>{f.desc}</p>
              <span className="fmore">Explore <Icon name="arrowUR" size={16} /></span>
            </SpotlightCard>
          </Reveal>
        ))}
      </div>
    );
  } else if (kind === 'pixel') {
    const variants = ['default', 'blue', 'pink', 'default', 'blue', 'pink'];
    body = (
      <div className="fgrid">
        {FEATURES.map((f, i) => (
          <Reveal key={f.title} delay={i * 70}>
            <PixelCard theme={theme.mode} colors={[theme.vars['--accent'], theme.vars['--accent-2'], theme.vars['--accent-3']]} glowColor={accent} className="fcard fcard--pixel" variant={variants[i]}>
              <div className="fcard-in">
                <span className="fico"><Icon name={f.icon} size={24} /></span>
                <h3>{f.title}</h3>
                <p>{f.desc}</p>
              </div>
            </PixelCard>
          </Reveal>
        ))}
      </div>
    );
  } else if (kind === 'tilt') {
    body = (
      <div className="fgrid">
        {FEATURES.map((f, i) => (
          <Reveal key={f.title} delay={i * 70}>
            <TiltedCard depth={18} className="fcard-tilt">
              <div className="fcard fcard--solid">
                <span className="fico"><Icon name={f.icon} size={24} /></span>
                <h3>{f.title}</h3>
                <p>{f.desc}</p>
                <span className="fno">0{i + 1}</span>
              </div>
            </TiltedCard>
          </Reveal>
        ))}
      </div>
    );
  } else {
    // glare
    body = (
      <div className="fgrid fgrid--glare">
        {FEATURES.map((f, i) => (
          <Reveal key={f.title} delay={i * 70}>
            <GlareHover width="100%" height="100%" background="transparent" borderRadius="var(--radius)" glareColor={theme.vars['--accent-3']} glareOpacity={dark ? 0.35 : 0.5} className="glare-card">
              <div className="fcard fcard--outline">
                <span className="fno">0{i + 1}</span>
                <span className="fico"><Icon name={f.icon} size={26} stroke={1.3} /></span>
                <h3>{f.title}</h3>
                <p>{f.desc}</p>
              </div>
            </GlareHover>
          </Reveal>
        ))}
      </div>
    );
  }

  return (
    <section className="sec" id="features">
      <div className="container">
        <SectionHead eyebrow="The platform" title="Everything a CFO does. Without the overhead." sub="Six intelligent capabilities working as one finance function — always on, always explaining itself." />
        {body}
      </div>
    </section>
  );
}

/* ───────── Console showcase ───────── */
export function ConsoleSection() {
  return (
    <section className="sec sec--tint" id="console">
      <div className="container">
        <SectionHead eyebrow="Try it" title="Drive the numbers. Watch the runway move." sub="A live scenario model. Switch the outlook, adjust your hiring plan, and hear what your AI CFO would do." />
        <Reveal><CFOConsole /></Reveal>
      </div>
    </section>
  );
}

/* ───────── Process ───────── */
const STEPS = [
  ['Connect', 'Link banks, cards, ERP, payroll and CRM in minutes. Read-only, encrypted, revocable.', 'globe'],
  ['Learn', 'NEUROPLAST studies your history, your vendors and your seasonality to build a living model.', 'spark'],
  ['Forecast', 'Cash, revenue and risk are projected every morning — with the reasoning shown.', 'chart'],
  ['Decide', 'Get clear, ranked recommendations and one-click board reports. You stay in control.', 'check'],
];
export function Process() {
  const refs = useRef([]);
  const [active, setActive] = useState(0);
  useEffect(() => {
    const io = new IntersectionObserver(
      (entries) => entries.forEach((e) => e.isIntersecting && setActive(+e.target.dataset.i)),
      { rootMargin: '-40% 0px -40% 0px' }
    );
    refs.current.forEach((r) => r && io.observe(r));
    return () => io.disconnect();
  }, []);
  return (
    <section className="sec" id="process">
      <div className="container process">
        <div className="process-side">
          <SectionHead align="left" eyebrow="How it works" title="From messy data to confident decisions." sub="Four steps. Most teams are live within a day." />
          <div className="process-meter" aria-hidden="true">
            <i style={{ height: `${((active + 1) / STEPS.length) * 100}%` }} />
            <span>0{active + 1}<small>/04</small></span>
          </div>
        </div>
        <ol className="steps">
          {STEPS.map(([t, d, ic], i) => (
            <li key={t} ref={(el) => (refs.current[i] = el)} data-i={i} className={i === active ? 'on' : i < active ? 'past' : ''}>
              <span className="step-no">0{i + 1}</span>
              <div>
                <h3><Icon name={ic} size={22} /> {t}</h3>
                <p>{d}</p>
              </div>
            </li>
          ))}
        </ol>
      </div>
    </section>
  );
}

/* ───────── Testimonials (Stack) ───────── */
const QUOTES = [
  ['We replaced a three-week close with a four-hour one. Our board noticed before we told them.', 'Priya Raman', 'CFO, Lumora (sample)'],
  ['The scenario lab changed how we hire. We now know our runway before we make the offer.', 'Marcus Hale', 'COO, Northwind Labs (sample)'],
  ['It caught a duplicate vendor payment in the first week. It paid for the year in a month.', 'Elena Voss', 'Controller, Verity Capital (sample)'],
  ['Finally, a finance tool that explains itself. Our auditors loved the trail.', 'Tomás Ibarra', 'Founder, Kestrel (sample)'],
];
export function Testimonials({ theme }) {
  const cards = QUOTES.map(([q, n, r], i) => (
    <figure key={n} className={`quote q-${i}`}>
      <Icon name="chat" size={22} />
      <blockquote>{q}</blockquote>
      <figcaption><b>{n}</b><span>{r}</span></figcaption>
    </figure>
  ));
  return (
    <section className="sec sec--tint" id="voices">
      <div className="container voices">
        <div className="voices-copy">
          <SectionHead align="left" eyebrow="Customer voices" title="Finance leaders are done with spreadsheets." sub="Drag a card, flick it away, or click to cycle through." />
          <div className="voices-meta">
            <div><b>4.9/5</b><span>sample rating</span></div>
            <div><b>&lt; 1 day</b><span>typical setup</span></div>
          </div>
        </div>
        <div className="voices-stack">
          <Stack cards={cards} layout={theme.testimonials} visible={4} radius={22} sendToBackOnClick autoplay autoplayDelay={4200} pauseOnHover />
        </div>
      </div>
    </section>
  );
}

/* ───────── Pricing ───────── */
const PLANS = [
  { name: 'Seed', price: 299, blurb: 'For founders replacing spreadsheets.', feats: ['Bank & card sync', 'Auto-bookkeeping', '6-month forecast', 'Monthly report'] },
  { name: 'Scale', price: 899, blurb: 'For teams that plan and raise capital.', feats: ['Everything in Seed', '12-month probabilistic forecast', 'Scenario Lab', 'Anomaly & fraud radar', 'Board-pack builder'], featured: true },
  { name: 'Enterprise', price: null, blurb: 'For groups with complex entities.', feats: ['Multi-entity consolidation', 'Custom controls & SSO', 'Dedicated finance engineer', 'Priority audit support'] },
];
export function Pricing({ theme }) {
  const [annual, setAnnual] = useState(true);
  const v = theme.vars;
  const planR = (parseInt(v['--radius'], 10) || 16) + 6;
  const card = (p) => (
    <div className={`plan ${p.featured ? 'plan--hot' : ''}`}>
      {p.featured && <span className="plan-flag">Most chosen</span>}
      <h3>{p.name}</h3>
      <p className="plan-blurb">{p.blurb}</p>
      <div className="plan-price">
        {p.price ? (<><sup>$</sup><b>{annual ? Math.round(p.price * 0.8) : p.price}</b><span>/mo</span></>) : <b className="plan-custom">Custom</b>}
      </div>
      <ul>{p.feats.map((f) => <li key={f}><Icon name="check" size={16} stroke={2} />{f}</li>)}</ul>
      <a href="#cta" className={`btn ${p.featured ? 'btn--primary' : 'btn--ghost'} btn--block`}>{p.price ? 'Start free trial' : 'Talk to sales'}</a>
    </div>
  );
  const wrap = (p) => {
    if (!p.featured) return card(p);
    switch (theme.pricing) {
      case 'star':
        return <StarBorder as="div" color={v['--accent']} trailColor={v['--accent-2']} radius={planR} duration={5} className="star-plan" backgroundColor="transparent" theme={theme.mode}>{card(p)}</StarBorder>;
      case 'electric':
        return <ElectricBorder color={v['--accent']} borderRadius={planR} speed={1} chaos={0.35} thickness={1.5} theme={theme.mode}>{card(p)}</ElectricBorder>;
      case 'glow':
        return <div className="glow-border">{card(p)}</div>;
      default:
        return <div className="gold-border">{card(p)}</div>;
    }
  };
  return (
    <section className="sec" id="pricing" style={{ '--plan-r': `${planR}px` }}>
      <div className="container">
        <SectionHead eyebrow="Pricing" title="Priced like software. Performs like a CFO." sub="Transparent plans. Cancel anytime." />
        <div className="toggle" role="group" aria-label="Billing period">
          <button className={!annual ? 'on' : ''} onClick={() => setAnnual(false)}>Monthly</button>
          <button className={annual ? 'on' : ''} onClick={() => setAnnual(true)}>Annual <em>−20%</em></button>
        </div>
        <div className="plans">
          {PLANS.map((p, i) => (
            <Reveal key={p.name} delay={i * 90} className={p.featured ? 'plan-slot hot' : 'plan-slot'}>{wrap(p)}</Reveal>
          ))}
        </div>
      </div>
    </section>
  );
}

/* ───────── FAQ ───────── */
const FAQS = [
  ['Is my financial data secure?', 'Connections are read-only and encrypted in transit and at rest. Every action by the AI is logged to an immutable audit trail you can export.'],
  ['Does the AI make financial decisions for us?', 'No. NEUROPLAST recommends and drafts; humans approve. You can set approval thresholds for any automated action.'],
  ['Which tools does it connect to?', 'Banks and cards, major ERPs and accounting platforms, payroll, billing and CRM. If you can export it, we can usually ingest it.'],
  ['How long does onboarding take?', 'Most teams connect their accounts and see a first forecast within a day. Historical clean-up happens in the background.'],
  ['Can it replace our accountant or fractional CFO?', 'It is designed to amplify them. Your advisors get cleaner books, faster reports and more time for strategy.'],
];
export function FAQ() {
  const [open, setOpen] = useState(0);
  return (
    <section className="sec sec--tint" id="faq">
      <div className="container faq">
        <SectionHead align="left" eyebrow="FAQ" title="Questions, answered plainly." />
        <div className="faq-list">
          {FAQS.map(([q, a], i) => (
            <div key={q} className={`faq-item ${open === i ? 'open' : ''}`}>
              <button onClick={() => setOpen(open === i ? -1 : i)} aria-expanded={open === i}>
                <span>{q}</span>
                <Icon name="plus" size={20} className="faq-plus" />
              </button>
              <div className="faq-a"><div><p>{a}</p></div></div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

/* ───────── CTA ───────── */
export function CTA({ theme }) {
  const v = theme.vars;
  const kind = theme.cta;
  return (
    <section className={`cta cta--${kind}`} id="cta">
      <div className="cta-glow" />
      {kind === 'loop' && (
        <div className="cta-loop">
          <CurvedLoop marqueeText="HIRE YOUR AI CFO ✦ HIRE YOUR AI CFO ✦ " speed={1.6} curveAmount={120} fontSize={72} color={v['--accent']} edgeFade={0.12} />
        </div>
      )}
      <div className="container cta-inner">
        {kind === 'seal' && (
          <div className="cta-seal">
            <CircularText text="BY INVITATION • NEUROPLAST • AI CFO • " size={160} fontSize={13} spinDuration={24} color={v['--accent-2']} letterSpacing={2} fill={false} />
            <span className="seal-core"><Logo compact /></span>
          </div>
        )}
        <h2 className="h-cta">
          {kind === 'glitch' ? (
            <GlitchText fontSize="inherit" fontWeight={700} speed={0.6} shadowColors={[v['--accent'], v['--accent-2']]} intensity={0.45} mode="slices">READY TO HIRE YOUR AI CFO?</GlitchText>
          ) : (
            <>Your next CFO never needs <em>a day off.</em></>
          )}
        </h2>
        <p className="lead lead--c">Book a 20-minute walkthrough and see your own numbers inside NEUROPLAST by the end of the call.</p>
        <Magnet padding={90} magnetStrength={3}>
          <a href="mailto:hello@neuroplast.ai" className="btn btn--primary btn--xl">Book your demo <Icon name="arrow" size={20} /></a>
        </Magnet>
      </div>
    </section>
  );
}

/* ───────── Footer ───────── */
export function Footer() {
  return (
    <footer className="footer">
      <div className="footer-word" aria-hidden="true">
        <ScrollVelocity baseVelocity={2} fontSize="clamp(4rem,14vw,12rem)" gap={60} color="currentColor" className="fw">
          NEUROPLAST — AI CFO —
        </ScrollVelocity>
      </div>
      <div className="container footer-grid">
        <div>
          <Logo />
          <p className="footer-blurb">The AI chief financial officer for companies that move fast and still want to sleep at night.</p>
        </div>
        <div><h4>Platform</h4><a href="#features">Capabilities</a><a href="#console">Scenario Lab</a><a href="#process">How it works</a></div>
        <div><h4>Company</h4><a href="#voices">Customers</a><a href="#pricing">Pricing</a><a href="#faq">FAQ</a></div>
        <div><h4>Contact</h4><a href="mailto:hello@neuroplast.ai">hello@neuroplast.ai</a><a href="#top">Back to top ↑</a></div>
      </div>
      <p className="footer-legal">© {new Date().getFullYear()} NEUROPLAST. Design preview — all figures and testimonials are sample content.</p>
    </footer>
  );
}
