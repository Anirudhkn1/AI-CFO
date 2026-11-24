import Aurora from '../components/reactbits/Aurora/Aurora.jsx';
import Lightning from '../components/reactbits/Lightning/Lightning.jsx';
import Particles from '../components/reactbits/Particles/Particles.jsx';
import Orb from '../components/reactbits/Orb/Orb.jsx';
import SplitText from '../components/reactbits/SplitText/SplitText.jsx';
import ShinyText from '../components/reactbits/ShinyText/ShinyText.jsx';
import BlurText from '../components/reactbits/BlurText/BlurText.jsx';
import GlitchText from '../components/reactbits/GlitchText/GlitchText.jsx';
import DecryptedText from '../components/reactbits/DecryptedText/DecryptedText.jsx';
import TextType from '../components/reactbits/TextType/TextType.jsx';
import TextPressure from '../components/reactbits/TextPressure/TextPressure.jsx';
import CircularText from '../components/reactbits/CircularText/CircularText.jsx';
import ScrollVelocity from '../components/reactbits/ScrollVelocity/ScrollVelocity.jsx';
import StarBorder from '../components/reactbits/StarBorder/StarBorder.jsx';
import { Badge, CTAs, FloatCard, MiniLedger, ScrollCue, HeroStatRow } from '../ui/HeroKit.jsx';
import Icon from '../ui/Icons.jsx';

/* 01 ─ CRIMSON LEDGER · Aurora over midnight navy, editorial serif with crimson italics */
export function HeroCrimson() {
  return (
    <section className="hero hero--crimson" id="top">
      <div className="hero-bg">
        <Aurora colorStops={['#16296E', '#8A1228', '#243F96']} amplitude={0.9} blend={0.7} speed={0.6} height={0.55} glow={0.45} brightness={0.62} />
      </div>
      <div className="hero-vignette" />
      <div className="container hero-split">
        <div className="hero-copy">
          <Badge><ShinyText text="Autonomous month-end close is here" color="#A39D90" shineColor="#F0364F" speed={3} /></Badge>
          <h1 className="h-mega">
            <SplitText text="Your finances," tag="span" splitType="words" textAlign="left" delay={70} duration={1.1} />
            <SplitText text="run by intelligence." tag="span" className="crimson-em" splitType="words" textAlign="left" delay={90} duration={1.2} />
          </h1>
          <p className="lead">
            NEUROPLAST is the AI CFO that reconciles every transaction, forecasts every month and writes your board
            report — so your leadership team decides, instead of chasing spreadsheets.
          </p>
          <CTAs />
          <HeroStatRow items={[['Month-end close', '3 days → 4 hrs'], ['Forecast refresh', 'Every morning'], ['Audit trail', 'Immutable']]} />
        </div>
        <div className="hero-visual">
          <MiniLedger className="tilt-a" />
          <FloatCard className="fc-1" label="Cash runway" value="18.4 months" delta="+2.1" icon="coin" />
          <FloatCard className="fc-2" label="Forecast accuracy" value="96.8%" delta="+1.4%" icon="radar" />
        </div>
      </div>
      <div className="hero-ticker">
        <ScrollVelocity baseVelocity={3} className="ticker-text" fontSize="clamp(2.4rem,6vw,5rem)" gap={40} color="rgba(214,208,196,.14)">
          FORECAST ◆ RECONCILE ◆ REPORT ◆ DECIDE ◆
        </ScrollVelocity>
      </div>
      <ScrollCue />
    </section>
  );
}

/* 02 ─ NEON SYNDICATE · Lightning + glitch headline, terminal strap */
export function HeroNeon() {
  return (
    <section className="hero hero--neon" id="top">
      <div className="hero-bg">
        <Lightning color="#6C6CFF" bolts={2} spread={0.7} branches={0.6} glow={1.2} intensity={1.1} speed={1.1} thickness={1.1} flicker={0.7} />
      </div>
      <div className="hero-redwash" />
      <div className="hero-scan" />
      <div className="container hero-center">
        <Badge className="badge--neon">SYS.ONLINE · AI CFO v4</Badge>
        <h1 className="h-neon">
          <GlitchText fontSize="inherit" fontWeight={700} speed={0.6} shadowColors={['#FF1744', '#5B5BFF']} intensity={0.55} trigger="always" mode="slices">
            THE CFO THAT
          </GlitchText>
          <span className="h-neon-2">
            <GlitchText fontSize="inherit" fontWeight={700} speed={0.5} shadowColors={['#5B5BFF', '#FF1744']} intensity={0.4} mode="slices">
              NEVER SLEEPS
            </GlitchText>
          </span>
        </h1>
        <p className="lead lead--mono">
          <DecryptedText text="Real-time books. Predictive cash. Zero spreadsheets." animateOn="view" sequential speed={38} characters="01▌▐░▒#/\\" />
        </p>
        <div className="cta-row">
          <StarBorder as="a" href="#console" color="#FF1744" trailColor="#6C6CFF" duration={3.5} radius={14} backgroundColor="#0A0A14" textColor="#fff" className="neon-star">
            Launch the console <Icon name="arrow" size={18} />
          </StarBorder>
          <a href="#features" className="btn btn--ghost">Read the spec</a>
        </div>
        <div className="terminal-strap">
          <TextType
            as="span"
            text={['> forecast --horizon 12m --scenario base', '> reconcile --all-accounts  ✔ 4,812 matched', '> anomaly --scan  ⚠ 1 vendor invoice flagged', '> board-report --export  ✔ ready']}
            typingSpeed={32}
            pauseDuration={1600}
            cursorCharacter="█"
          />
        </div>
      </div>
      <ScrollCue />
    </section>
  );
}

/* 03 ─ ATLAS & IVORY · ivory paper with a navy arch holding gold particles */
export function HeroAtlas() {
  return (
    <section className="hero hero--atlas" id="top">
      <div className="hero-paper" />
      <div className="container hero-split hero-split--atlas">
        <div className="hero-copy">
          <p className="eyebrow"><span className="rule" />Est. for the modern finance office</p>
          <h1 className="h-mega h-serif">
            <SplitText text="Capital," tag="span" splitType="chars" textAlign="left" delay={40} duration={1.1} mask />
            <SplitText text="composed." tag="span" className="gold-em" splitType="chars" textAlign="left" delay={40} duration={1.2} mask />
          </h1>
          <p className="lead">
            An AI chief financial officer, quietly assembling your forecasts, closes and board papers with the
            discipline of a private bank — and the speed of software.
          </p>
          <CTAs primary="Request a private demo" secondary="Read the whitepaper" />
          <ul className="hero-assure">
            <li><Icon name="shield" size={18} /> SOC 2-ready architecture</li>
            <li><Icon name="lock" size={18} /> Encrypted end-to-end</li>
            <li><Icon name="file" size={18} /> Audit-grade trail</li>
          </ul>
        </div>
        <div className="arch-wrap">
          <div className="arch">
            <Particles particleColors={['#D8B565', '#F7F2E7', '#B8893A']} particleCount={260} particleSpread={9} speed={0.07} particleBaseSize={90} alphaParticles hoverEffect="parallax" connections={false} twinkle={0.5} glow={0.6} />
            <div className="arch-inner">
              <FloatCard className="fc-arch-1" label="Net position" value="$24.8M" delta="+3.2%" icon="coin" />
              <FloatCard className="fc-arch-2" label="Next filing" value="14 days" icon="calendar" />
              <FloatCard className="fc-arch-3" label="Variance flagged" value="2 items" icon="radar" />
            </div>
          </div>
          <div className="seal">
            <CircularText text="NEUROPLAST • AI CFO • EST 2026 • " size={150} fontSize={13} spinDuration={22} color="#D8B565" letterSpacing={2} fill={false} />
            <span className="seal-core">N</span>
          </div>
        </div>
      </div>
    </section>
  );
}

/* 04 ─ PERIWINKLE NOIR · a living orb behind pressure-reactive type */
export function HeroPeriwinkle() {
  return (
    <section className="hero hero--peri" id="top">
      <div className="hero-bg hero-orb">
        <Orb colors={['#9AA6FF', '#CCCCFF', '#FF6B5E']} backgroundColor="#000000" hoverIntensity={1.2} glow={1.2} wobble={1.1} size={1} />
      </div>
      <div className="hero-vignette hero-vignette--black" />
      <div className="container hero-center hero-center--tall">
        <Badge className="badge--peri">The first AI CFO built for boards</Badge>
        <h1 className="pressure-static">FORESIGHT</h1>
        <div className="pressure-wrap" aria-hidden="true">
          <TextPressure text="FORESIGHT" fontFamily="'Roboto Flex', 'Inter', sans-serif" textColor="#EEF0FF" pressureColor="#9AA6FF" minFontSize={48} idle="wave" />
        </div>
        <div role="heading" aria-level={2} className="h-sub">
          <BlurText text="is the new leverage." animateBy="words" delay={140} stepDuration={0.45} />
        </div>
        <p className="lead lead--c">
          See every outcome before it happens. NEUROPLAST models your cash, your hiring and your risk — and tells you
          what to do next, in plain English.
        </p>
        <CTAs className="cta-row--c" />
        <HeroStatRow items={[['Scenarios / sec', '12,000'], ['Sources linked', '200+'], ['Setup time', '< 1 day']]} />
      </div>
    </section>
  );
}
