import LightRays from '../components/reactbits/LightRays/LightRays.jsx';
import LiquidChrome from '../components/reactbits/LiquidChrome/LiquidChrome.jsx';
import FaultyTerminal from '../components/reactbits/FaultyTerminal/FaultyTerminal.jsx';
import Galaxy from '../components/reactbits/Galaxy/Galaxy.jsx';
import SplitText from '../components/reactbits/SplitText/SplitText.jsx';
import RotatingText from '../components/reactbits/RotatingText/RotatingText.jsx';
import ShinyText from '../components/reactbits/ShinyText/ShinyText.jsx';
import DecryptedText from '../components/reactbits/DecryptedText/DecryptedText.jsx';
import GradientText from '../components/reactbits/GradientText/GradientText.jsx';
import TrueFocus from '../components/reactbits/TrueFocus/TrueFocus.jsx';
import CircularText from '../components/reactbits/CircularText/CircularText.jsx';
import CountUp from '../components/reactbits/CountUp/CountUp.jsx';
import ElectricBorder from '../components/reactbits/ElectricBorder/ElectricBorder.jsx';
import { Badge, CTAs, FloatCard, MiniLedger, ScrollCue, HeroStatRow } from '../ui/HeroKit.jsx';
import CFOConsole from '../ui/CFOConsole.jsx';
import Icon from '../ui/Icons.jsx';

/* 05 ─ EMERALD RESERVE · champagne light rays, rotating serif, console rising from the floor */
export function HeroEmerald() {
  return (
    <section className="hero hero--emerald" id="top">
      <div className="hero-bg">
        <LightRays raysOrigin="top-center" raysColor="#D9C089" raysSpeed={0.8} lightSpread={0.7} rayLength={3.2} glow={0.8} haze={0.35} followMouse mouseInfluence={0.12} />
      </div>
      <div className="hero-floor" />
      <div className="container hero-center">
        <Badge className="badge--gold">Private-bank rigour · software speed</Badge>
        <h1 className="h-mega h-serif h-center">
          <span>Quiet money.</span>
          <span className="h-line">
            Loud{' '}
            <RotatingText
              texts={['clarity', 'control', 'confidence', 'growth']}
              mainClassName="rot-word"
              rotationInterval={2600}
              staggerDuration={0.03}
              effect="slide"
            />
          </span>
        </h1>
        <p className="lead lead--c">
          Your AI CFO watches every account, every contract and every filing — and speaks only when it matters.
        </p>
        <CTAs className="cta-row--c" primary="Request access" secondary="See it in action" />
      </div>
      <div className="container hero-peek">
        <div className="peek-frame"><CFOConsole /></div>
      </div>
    </section>
  );
}

/* 06 ─ OXBLOOD VAULT · liquid metal chrome, brass medallion */
export function HeroOxblood() {
  return (
    <section className="hero hero--oxblood" id="top">
      <div className="hero-bg">
        <LiquidChrome color="#6D0F1D" speed={0.16} amplitude={0.3} depth={1.1} roughness={0.35} exposure={0.62} rippleStrength={1.2} />
      </div>
      <div className="hero-vignette hero-vignette--deep" />
      <div className="container hero-center">
        <div className="medallion">
          <CircularText text="VAULT-GRADE FINANCE • NEUROPLAST • " size={170} fontSize={12} spinDuration={26} color="#C9974B" letterSpacing={3} fill={false} />
          <span className="medallion-core"><Icon name="scale" size={34} stroke={1.3} /></span>
        </div>
        <h1 className="h-mega h-serif h-center">
          <SplitText text="Command every dollar." tag="span" splitType="words" textAlign="center" delay={110} duration={1.2} />
        </h1>
        <p className="lead lead--c">
          <ShinyText text="Treasury, forecasting and compliance — sealed in one intelligent ledger." color="#C09A97" shineColor="#F3D9A4" speed={3.2} />
        </p>
        <CTAs className="cta-row--c" primary="Open an account" secondary="Explore the vault" />
        <div className="vault-row">
          <div><b><CountUp to={4.8} decimals={1} duration={2.2} suffix="B" prefix="$" /></b><span>Modelled cash flow</span></div>
          <div><b><CountUp to={99.2} decimals={1} duration={2.2} suffix="%" /></b><span>Auto-reconciled</span></div>
          <div><b><CountUp to={24} duration={2.2} suffix="/7" /></b><span>Always-on monitoring</span></div>
        </div>
      </div>
      <ScrollCue />
    </section>
  );
}

/* 07 ─ QUANTUM TEAL · glitching terminal field, decrypting headline */
export function HeroTeal() {
  return (
    <section className="hero hero--teal" id="top">
      <div className="hero-bg">
        <FaultyTerminal tint="#14F1D9" brightness={0.38} scanlineIntensity={0.35} glitchAmount={1.1} timeScale={0.25} curvature={0.15} gridMul={[2, 1]} digitSize={1.4} mouseReact />
      </div>
      <div className="hero-vignette hero-vignette--deep" />
      <div className="container hero-split hero-split--teal">
        <div className="hero-copy">
          <Badge className="badge--teal">Autonomous close · v4.2</Badge>
          <h1 className="h-mega h-tight">
            <DecryptedText text="Close the books in minutes, not weeks." animateOn="view" sequential speed={28} maxIterations={14} characters="01<>/\\{}[]#" parentClassName="decrypt" className="decrypt-final" encryptedClassName="decrypt-enc" />
          </h1>
          <p className="lead">
            Every ledger entry matched, categorised and explained. NEUROPLAST audits itself continuously, so month-end
            becomes a non-event.
          </p>
          <CTAs primary="Start free pilot" secondary="Talk to an engineer" />
          <HeroStatRow items={[['Reconciled', '99.2%'], ['Entries / day', '1.2M'], ['Median close', '4 hrs']]} />
        </div>
        <div className="hero-visual">
          <ElectricBorder color="#14F1D9" speed={1.2} chaos={0.4} borderRadius={14} thickness={1.6} glow={0.5}>
            <MiniLedger rows={6} className="ml-flat" />
          </ElectricBorder>
        </div>
      </div>
      <ScrollCue />
    </section>
  );
}

/* 08 ─ AUBERGINE DUSK · starfield galaxy, gradient + focus-bracket headline */
export function HeroAubergine() {
  return (
    <section className="hero hero--aubergine" id="top">
      <div className="hero-bg">
        <Galaxy hueShift={275} saturation={0.7} density={1.1} glowIntensity={0.35} twinkleIntensity={0.5} starSpeed={0.4} speed={0.8} mouseRepulsion transparent={false} backgroundColor="#150A24" />
      </div>
      <div className="hero-vignette" />
      <div className="container hero-center">
        <Badge className="badge--lilac">Meet your finance co-pilot</Badge>
        <h1 className="h-mega h-center">
          <span className="dusk-line">Finance,</span>
          <GradientText colors={['#B692FF', '#FFB547', '#F4EEFF', '#B692FF']} animationSpeed={7} className="dusk-grad">
            thinking ahead.
          </GradientText>
        </h1>
        <div className="focus-wrap">
          <TrueFocus sentence="Forecast. Reconcile. Report. Decide." borderColor="#FFB547" glowColor="rgba(255,181,71,.55)" blurAmount={4} animationDuration={0.55} pauseBetweenAnimations={1.1} />
        </div>
        <CTAs className="cta-row--c" primary="Get early access" secondary="See the roadmap" />
        <div className="orbit-cards">
          <FloatCard className="oc-1" label="Cash runway" value="21 months" icon="coin" />
          <FloatCard className="oc-2" label="Net revenue retention" value="118%" delta="+4%" icon="chart" />
          <FloatCard className="oc-3" label="AI insights today" value="7 new" icon="spark" />
        </div>
      </div>
    </section>
  );
}
