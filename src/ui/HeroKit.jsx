import { useEffect, useState } from 'react';
import Magnet from '../components/reactbits/Magnet/Magnet.jsx';
import Icon from './Icons.jsx';

export function Badge({ children, className = '' }) {
  return (
    <span className={`badge ${className}`}>
      <i className="badge-dot" />
      {children}
    </span>
  );
}

export function CTAs({ primary = 'Book a live demo', secondary = 'Watch the 90-second tour', magnet = true, className = '' }) {
  const main = (
    <a href="#console" className="btn btn--primary">
      {primary} <Icon name="arrow" size={18} />
    </a>
  );
  return (
    <div className={`cta-row ${className}`}>
      {magnet ? <Magnet padding={60} magnetStrength={3}>{main}</Magnet> : main}
      <a href="#features" className="btn btn--ghost">
        {secondary}
      </a>
    </div>
  );
}

/** Small floating metric card that drifts. */
export function FloatCard({ label, value, delta, style, className = '', icon = 'chart' }) {
  return (
    <div className={`float-card glass-panel ${className}`} style={style}>
      <span className="fc-ico"><Icon name={icon} size={18} /></span>
      <div>
        <small>{label}</small>
        <b>{value}</b>
      </div>
      {delta && <em className={delta.startsWith('-') ? 'down' : 'up'}>{delta}</em>}
    </div>
  );
}

/** Streaming transactions ledger – feels alive. */
const TX = [
  ['Stripe payout', '+$48,210', 'ok'],
  ['AWS · Infrastructure', '-$12,904', ''],
  ['Payroll · Engineering', '-$84,330', ''],
  ['Invoice #2841 · Halden Co.', '+$31,500', 'ok'],
  ['Figma · duplicate seat', '-$1,240', 'warn'],
  ['R&D tax credit accrual', '+$9,870', 'ok'],
  ['Vendor invoice · +38% vs avg', '-$22,180', 'warn'],
  ['Series A tranche 2', '+$1,500,000', 'ok'],
];
export function MiniLedger({ rows = 5, className = '' }) {
  const [i, setI] = useState(0);
  useEffect(() => {
    const t = setInterval(() => setI((x) => x + 1), 1800);
    return () => clearInterval(t);
  }, []);
  const view = Array.from({ length: rows }, (_, k) => [i + k, ...TX[(i + k) % TX.length]]);
  return (
    <div className={`mini-ledger glass-panel ${className}`}>
      <div className="ml-head"><span><b />Reconciling live</span><em>AI CFO</em></div>
      <ul>
        {view.map(([id, n, a, s]) => (
          <li key={id} className={s}>
            <span>{n}</span>
            <b>{a}</b>
          </li>
        ))}
      </ul>
    </div>
  );
}

export function ScrollCue() {
  return (
    <a href="#trust" className="scroll-cue" aria-label="Scroll to content">
      <span />
    </a>
  );
}

export function HeroStatRow({ items }) {
  return (
    <dl className="hero-stats">
      {items.map(([k, v]) => (
        <div key={k}>
          <dt>{k}</dt>
          <dd>{v}</dd>
        </div>
      ))}
    </dl>
  );
}
