import { useEffect, useMemo, useRef, useState } from 'react';
import CountUp from '../components/reactbits/CountUp/CountUp.jsx';
import TextType from '../components/reactbits/TextType/TextType.jsx';
import Icon from './Icons.jsx';

/* ---------- Tiny financial model (illustrative numbers) ---------- */
const SCENARIOS = {
  base: { label: 'Base', growth: 0.025, note: 'Current trajectory' },
  growth: { label: 'Growth', growth: 0.065, note: 'Pipeline converts +40%' },
  downside: { label: 'Downside', growth: -0.012, note: 'Churn spikes, deals slip' },
};

function model(scenario, hires) {
  const { growth } = SCENARIOS[scenario];
  let cash = 2200; // $k
  let rev = 260;
  let cost = 360 + hires * 13;
  const burn0 = cost - rev;
  const cashSeries = [cash];
  let runway = null;
  for (let m = 1; m <= 36; m++) {
    rev *= 1 + growth;
    cost *= 1.008;
    cash += rev - cost;
    if (m <= 12) cashSeries.push(cash);
    if (runway === null && cash < 0) runway = m;
  }
  return { cashSeries, runway: runway ?? 36, burn: Math.max(0, burn0), cash12: cashSeries[12], rev };
}

function useTween(target, ms = 650) {
  const [v, setV] = useState(target);
  const from = useRef(target);
  const raf = useRef(0);
  useEffect(() => {
    const start = performance.now();
    const a = from.current;
    cancelAnimationFrame(raf.current);
    const tick = (t) => {
      const p = Math.min(1, (t - start) / ms);
      const e = 1 - Math.pow(1 - p, 3);
      const next = target.map((x, i) => (a[i] ?? x) + (x - (a[i] ?? x)) * e);
      from.current = next;
      setV(next);
      if (p < 1) raf.current = requestAnimationFrame(tick);
    };
    raf.current = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(raf.current);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [target.join(',')]);
  return v;
}

function Chart({ series }) {
  const W = 640, H = 240, pad = 14;
  const vals = useTween(series);
  const max = Math.max(2800, ...vals) * 1.05;
  const min = Math.min(0, ...vals);
  const x = (i) => pad + (i / (vals.length - 1)) * (W - pad * 2);
  const y = (v) => H - pad - ((v - min) / (max - min)) * (H - pad * 2 - 6);
  const pts = vals.map((v, i) => [x(i), y(v)]);
  const line = pts.map((p, i) => `${i ? 'L' : 'M'}${p[0].toFixed(1)},${p[1].toFixed(1)}`).join(' ');
  const area = `${line} L${x(vals.length - 1)},${H - pad} L${x(0)},${H - pad} Z`;
  const bandUp = vals.map((v, i) => [x(i), y(v * (1 + i * 0.022))]);
  const bandDn = vals.map((v, i) => [x(i), y(v * (1 - i * 0.03))]).reverse();
  const band = [...bandUp, ...bandDn].map((p, i) => `${i ? 'L' : 'M'}${p[0].toFixed(1)},${p[1].toFixed(1)}`).join(' ') + 'Z';
  const zeroY = y(0);
  const last = pts[pts.length - 1];

  return (
    <svg className="cons-chart" viewBox={`0 0 ${W} ${H}`} role="img" aria-label="12 month cash forecast">
      <defs>
        <linearGradient id="cg-fill" x1="0" x2="0" y1="0" y2="1">
          <stop offset="0" stopColor="var(--accent)" stopOpacity="0.38" />
          <stop offset="1" stopColor="var(--accent)" stopOpacity="0" />
        </linearGradient>
      </defs>
      {[0.25, 0.5, 0.75].map((g) => (
        <line key={g} x1={pad} x2={W - pad} y1={pad + g * (H - pad * 2)} y2={pad + g * (H - pad * 2)} className="cons-grid" />
      ))}
      <line x1={pad} x2={W - pad} y1={zeroY} y2={zeroY} className="cons-zero" />
      <path d={band} fill="var(--accent-2)" opacity="0.12" />
      <path d={area} fill="url(#cg-fill)" />
      <path d={line} fill="none" stroke="var(--accent)" strokeWidth="2.6" strokeLinejoin="round" strokeLinecap="round" />
      {pts.map((p, i) => (i % 3 === 0 ? <circle key={i} cx={p[0]} cy={p[1]} r="3.2" fill="var(--bg)" stroke="var(--accent)" strokeWidth="2" /> : null))}
      <g transform={`translate(${last[0]},${last[1]})`}>
        <circle r="10" fill="var(--accent)" opacity="0.22">
          <animate attributeName="r" values="6;14;6" dur="2.4s" repeatCount="indefinite" />
          <animate attributeName="opacity" values="0.4;0;0.4" dur="2.4s" repeatCount="indefinite" />
        </circle>
        <circle r="4.5" fill="var(--accent)" />
      </g>
    </svg>
  );
}

const fmt = (k) => (Math.abs(k) >= 1000 ? `$${(k / 1000).toFixed(2)}M` : `$${Math.round(k)}k`);

export default function CFOConsole() {
  const [scenario, setScenario] = useState('base');
  const [hires, setHires] = useState(4);
  const m = useMemo(() => model(scenario, hires), [scenario, hires]);

  const insights = useMemo(() => {
    const list = [];
    if (m.runway >= 36) list.push(`Runway exceeds 36 months. You can safely fund ${Math.min(12, hires + 4)} more hires.`);
    else if (m.runway < 14) list.push(`Runway is ${m.runway} months. I recommend pausing ${Math.max(1, Math.ceil(hires / 2))} hires and renegotiating two vendor contracts.`);
    else list.push(`Runway is ${m.runway} months. Closing the Q3 renewal pipeline would extend it by ~4 months.`);
    list.push(`Detected 3 duplicate SaaS subscriptions worth $4,180/mo. Draft cancellation emails are ready.`);
    return list;
  }, [m.runway, hires]);

  return (
    <div className="console glass-panel">
      <header className="cons-head">
        <div className="cons-dots"><i /><i /><i /></div>
        <span className="cons-title">NEUROPLAST · AI CFO · Scenario Lab</span>
        <span className="cons-live"><b />Live model</span>
      </header>

      <div className="cons-body">
        <div className="cons-main">
          <div className="cons-tabs" role="tablist">
            {Object.entries(SCENARIOS).map(([k, s]) => (
              <button key={k} role="tab" aria-selected={scenario === k} className={scenario === k ? 'on' : ''} onClick={() => setScenario(k)}>
                {s.label}
              </button>
            ))}
            <span className="cons-note">{SCENARIOS[scenario].note}</span>
          </div>

          <div className="cons-kpis">
            <div className="kpi">
              <span>Cash in 12 mo</span>
              <b>{fmt(m.cash12)}</b>
            </div>
            <div className="kpi">
              <span>Runway</span>
              <b>{m.runway >= 36 ? '36+' : m.runway} <small>mo</small></b>
            </div>
            <div className="kpi">
              <span>Net burn</span>
              <b>{fmt(m.burn)}<small>/mo</small></b>
            </div>
          </div>

          <Chart series={m.cashSeries} />

          <label className="cons-slider">
            <span><Icon name="users" size={16} /> Planned hires</span>
            <input type="range" min="0" max="16" value={hires} onChange={(e) => setHires(+e.target.value)} aria-label="Planned hires" />
            <b>{hires}</b>
          </label>
        </div>

        <aside className="cons-side">
          <div className="cons-side-head"><Icon name="spark" size={16} /> AI CFO says</div>
          <p className="cons-say">
            <TextType as="span" key={insights[0]} text={[insights[0]]} typingSpeed={22} loop={false} showCursor cursorCharacter="▍" />
          </p>
          <ul className="cons-feed">
            <li><i className="ok" /> Bank feeds reconciled <em>99.2%</em></li>
            <li><i className="warn" /> Anomaly: vendor invoice +38% <em>review</em></li>
            <li><i className="ok" /> Sales-tax filing drafted <em>Fri</em></li>
            <li><i className="ok" /> Board report assembled <em>ready</em></li>
          </ul>
          <div className="cons-count">
            <span>Hours returned to your team</span>
            <b><CountUp to={42} duration={2} suffix="h" /><small>/wk</small></b>
          </div>
        </aside>
      </div>
      <p className="cons-foot">Illustrative model · figures are sample data.</p>
    </div>
  );
}
