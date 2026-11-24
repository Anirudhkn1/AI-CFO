export function LogoMark({ size = 30 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 40 40" fill="none" aria-hidden="true" className="logo-mark">
      <rect x="1.5" y="1.5" width="37" height="37" rx="11" stroke="currentColor" strokeOpacity="0.35" strokeWidth="1.5" />
      <path d="M11 29V11l18 18V11" stroke="var(--accent)" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round" />
      <circle cx="11" cy="11" r="2.4" fill="var(--accent-2)" />
      <circle cx="29" cy="29" r="2.4" fill="var(--accent-2)" />
    </svg>
  );
}

export default function Logo({ compact = false }) {
  return (
    <span className="logo">
      <LogoMark />
      {!compact && (
        <span className="logo-word">
          <b>NEUROPLAST</b>
          <i>AI&nbsp;CFO</i>
        </span>
      )}
    </span>
  );
}
