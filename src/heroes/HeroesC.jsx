import DotGrid from '../components/reactbits/DotGrid/DotGrid.jsx';
import Threads from '../components/reactbits/Threads/Threads.jsx';
import Silk from '../components/reactbits/Silk/Silk.jsx';
import PrismaticBurst from '../components/reactbits/PrismaticBurst/PrismaticBurst.jsx';
import SplitText from '../components/reactbits/SplitText/SplitText.jsx';
import TiltedCard from '../components/reactbits/TiltedCard/TiltedCard.jsx';
import GradientText from '../components/reactbits/GradientText/GradientText.jsx';
import ShinyText from '../components/reactbits/ShinyText/ShinyText.jsx';
import FuzzyText from '../components/reactbits/FuzzyText/FuzzyText.jsx';
import SpecularButton from '../components/reactbits/SpecularButton/SpecularButton.jsx';
import Shuffle from '../components/reactbits/Shuffle/Shuffle.jsx';
import CountUp from '../components/reactbits/CountUp/CountUp.jsx';
import CurvedLoop from '../components/reactbits/CurvedLoop/CurvedLoop.jsx';
import GlassSurface from '../components/reactbits/GlassSurface/GlassSurface.jsx';
import { Badge, CTAs, FloatCard, ScrollCue, HeroStatRow } from '../ui/HeroKit.jsx';
import CFOConsole from '../ui/CFOConsole.jsx';
import Icon from '../ui/Icons.jsx';

/* 09 ─ TERRACOTTA ATELIER · reactive dot-grid paper, editorial serif, tilted artefacts */
export function HeroTerracotta() {
  return (
    <section className="hero hero--terra" id="top">
      <div className="hero-bg">
        <DotGrid baseColor="#DCC4AE" activeColor="#C4572E" dotSize={4} gap={20} proximity={150} glow={0.6} shockRadius={280} />
      </div>
      <div className="container hero-split hero-split--terra">
        <div className="hero-copy">
          <p className="eyebrow"><span className="rule" />Finance, made by hand — and by machine</p>
          <h1 className="h-mega h-serif">
            <SplitText text="The finance partner" tag="span" splitType="words" textAlign="left" delay={80} duration={1.1} mask />
            <SplitText text="your ambition" tag="span" splitType="words" textAlign="left" delay={80} duration={1.1} mask />
            <SplitText text="deserves." tag="span" className="terra-em" splitType="words" textAlign="left" delay={80} duration={1.2} mask />
          </h1>
          <p className="lead">
            Beautifully clear reporting, forecasts that explain themselves, and an AI CFO that treats your numbers like
            craft.
          </p>
          <CTAs primary="Book a studio call" secondary="Browse sample reports" />
        </div>
        <div className="artefacts">
          <TiltedCard depth={26} className="art art-1">
            <div className="paper">
              <small>BOARD REPORT · Q3</small>
              <h4>Revenue up 14% on plan</h4>
              <div className="paper-bars"><i style={{ height: '42%' }} /><i style={{ height: '58%' }} /><i style={{ height: '51%' }} /><i style={{ height: '76%' }} /><i style={{ height: '92%' }} /></div>
            </div>
          </TiltedCard>
          <TiltedCard depth={20} className="art art-2">
            <div className="paper paper--dark">
              <small>CASH RUNWAY</small>
              <h4>19.2 <span>months</span></h4>
              <p>+2.4 vs last quarter</p>
            </div>
          </TiltedCard>
          <TiltedCard depth={18} className="art art-3">
            <div className="paper paper--accent">
              <small>TAX LEDGER</small>
              <h4>3 filings drafted</h4>
              <p><Icon name="check" size={16} /> Reviewed by AI · awaiting you</p>
            </div>
          </TiltedCard>
        </div>
      </div>
      <ScrollCue />
    </section>
  );
}

/* 10 ─ COBALT GLACIER · flowing cobalt threads on ice, product-forward split */
export function HeroCobalt() {
  return (
    <section className="hero hero--cobalt" id="top">
      <div className="hero-bg hero-threads">
        <Threads color={[0.12, 0.3, 1]} amplitude={1.5} distance={0.35} lineCount={70} thickness={0.7} speed={0.5} brightness={1.2} enableMouseInteraction />
      </div>
      <div className="hero-fade-ice" />
      <div className="container hero-split hero-split--cobalt">
        <div className="hero-copy">
          <Badge className="badge--cobalt">Now with natural-language CFO chat</Badge>
          <h1 className="h-mega h-sans">
            <SplitText text="Cash flow," tag="span" splitType="words" textAlign="left" delay={90} duration={1} />
            <GradientText colors={['#1F4DFF', '#6C8CFF', '#0A1633', '#1F4DFF']} animationSpeed={9} className="cobalt-grad">crystal clear.</GradientText>
          </h1>
          <p className="lead">
            Connect your bank, ERP and payroll in minutes. NEUROPLAST turns them into forecasts, alerts and decisions —
            with no analysts required.
          </p>
          <CTAs primary="Start free" secondary="Book a demo" />
          <div className="glass-chips">
            <GlassSurface width={180} height={46} borderRadius={23} className="chip-glass"><span className="chip-in"><Icon name="check" size={16} /> No credit card</span></GlassSurface>
            <GlassSurface width={190} height={46} borderRadius={23} className="chip-glass"><span className="chip-in"><Icon name="bolt" size={16} /> Live in 1 day</span></GlassSurface>
          </div>
        </div>
        <div className="hero-visual hero-visual--console">
          <CFOConsole />
        </div>
      </div>
    </section>
  );
}

/* 11 ─ PLATINUM OBSIDIAN · brushed-silk metal, fuzzy monolithic type, specular CTA */
export function HeroPlatinum() {
  return (
    <section className="hero hero--platinum" id="top">
      <div className="hero-bg">
        <Silk color="#4A4A52" sheenColor="#F2F2F0" speed={3} sheen={0.8} noiseIntensity={1.1} glow={0.45} depth={0.7} />
      </div>
      <div className="hero-vignette hero-vignette--deep" />
      <div className="coords tl">40.7128° N</div>
      <div className="coords tr">AI CFO — MMXXVI</div>
      <div className="coords bl">NEUROPLAST</div>
      <div className="coords br">Scroll</div>
      <div className="container hero-center">
        <p className="eyebrow eyebrow--c"><span className="rule" />The black-card standard for finance<span className="rule" /></p>
        <div className="fuzzy-wrap">
          <FuzzyText fontSize="clamp(3.4rem, 13vw, 12rem)" fontWeight={400} fontFamily="'Italiana', serif" color="#F2F2F0" baseIntensity={0.14} hoverIntensity={0.55} enableHover>
            PRECISION
          </FuzzyText>
        </div>
        <h1 className="h-sub h-sub--thin">
          <ShinyText text="is a luxury. Now it's automatic." color="#BDBDBA" shineColor="#FFFFFF" speed={3.5} />
        </h1>
        <div className="cta-row cta-row--c">
          <SpecularButton size="lg" radius={4} baseColor="#1C1C1E" lineColor="#E5E4E2" textColor="#F2F2F0" tint="#E8D8B0" glow={1}>
            Request an invitation
          </SpecularButton>
          <a href="#features" className="btn btn--ghost">Discover the platform</a>
        </div>
      </div>
    </section>
  );
}

/* 12 ─ SOLAR FLARE · prismatic burst, shuffling headline, curved ticker */
export function HeroSolar() {
  return (
    <section className="hero hero--solar" id="top">
      <div className="hero-bg">
        <PrismaticBurst colors={['#FF2E93', '#FFB02E', '#7A3FF0']} intensity={2.2} speed={0.45} animationType="rotate3d" distort={1.2} rayCount={14} mouseInteraction clickBurst />
      </div>
      <div className="hero-vignette hero-vignette--plum" />
      <div className="container hero-center">
        <Badge className="badge--solar">Built for scale-ups that don&apos;t slow down</Badge>
        <h1 className="h-mega h-center h-solar">
          <Shuffle text="Turn every number into momentum." tag="span" textAlign="center" shuffleDirection="right" duration={0.5} stagger={0.02} shuffleTimes={2} triggerOnce />
        </h1>
        <p className="lead lead--c">
          Forecast growth, model funding rounds and stress-test every decision — before you commit a single dollar.
        </p>
        <CTAs className="cta-row--c" primary="Model my growth" secondary="Watch it run" />
        <div className="solar-stat">
          <span>Projected ARR uplift</span>
          <b><CountUp to={38} duration={2.4} prefix="+" suffix="%" /></b>
          <small>illustrative scenario</small>
        </div>
      </div>
      <div className="hero-curve">
        <CurvedLoop marqueeText="GROWTH ✦ RUNWAY ✦ MARGIN ✦ MOMENTUM ✦ " speed={2} curveAmount={90} fontSize={64} color="rgba(255,243,236,.9)" />
      </div>
    </section>
  );
}
