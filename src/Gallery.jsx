import { Link } from 'react-router-dom';
import { useEffect } from 'react';
import { THEMES } from './themes/themes.js';
import Aurora from './components/reactbits/Aurora/Aurora.jsx';
import SplitText from './components/reactbits/SplitText/SplitText.jsx';
import ShinyText from './components/reactbits/ShinyText/ShinyText.jsx';
import { LogoMark } from './ui/Logo.jsx';
import './styles/gallery.css';

export default function Gallery() {
  useEffect(() => {
    document.title = 'NEUROPLAST — AI CFO · Design Directions';
    document.body.style.background = '#070709';
    window.scrollTo(0, 0);
  }, []);
  return (
    <div className="gal">
      <div className="gal-bg">
        <Aurora colorStops={['#3b2a8f', '#0f766e', '#9d174d']} amplitude={0.9} blend={0.7} speed={0.5} height={0.5} />
      </div>
      <header className="gal-hero">
        <div className="gal-brand"><LogoMark size={34} /><span>NEUROPLAST <i>AI CFO</i></span></div>
        <h1>
          <SplitText text="Twelve premium directions." tag="span" splitType="words" textAlign="center" delay={80} />
        </h1>
        <p><ShinyText text="Each one a complete frontend — its own palette, type, hero and component language." color="#9a9ab0" shineColor="#fff" speed={4} /></p>
        <small>Tip: inside any design, press Alt + ← / → to hop between directions.</small>
      </header>
      <main className="gal-grid">
        {THEMES.map((t) => (
          <Link key={t.slug} to={`/t/${t.slug}`} className="gcard" style={t.vars}>
            <div className="gcard-preview">
              <div className="gp-orb gp-orb-1" />
              <div className="gp-orb gp-orb-2" />
              <span className="gp-no">{t.no}</span>
              <h3 className="gp-title">{t.name.split(' ').map((w, i) => <span key={i}>{w}</span>)}</h3>
              <div className="gp-bar"><i /><i /><i /></div>
              <span className="gp-btn">Book a demo →</span>
            </div>
            <div className="gcard-info">
              <div className="gcard-row">
                <b>{t.name}</b>
                <span className="gc-mode">{t.mode}</span>
              </div>
              <p>{t.mood}</p>
              <div className="gcard-sw">
                {t.swatches.map(([n, c]) => (
                  <span key={n} title={`${n} ${c}`}><i style={{ background: c }} /></span>
                ))}
              </div>
              <small>{t.fonts}</small>
            </div>
          </Link>
        ))}
      </main>
      <footer className="gal-foot">Built with React · ReactBits components (GSAP, Motion, WebGL) · Sample content for design review.</footer>
    </div>
  );
}
