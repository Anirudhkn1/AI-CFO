const P = {
  spark: 'M12 3l1.9 5.1L19 10l-5.1 1.9L12 17l-1.9-5.1L5 10l5.1-1.9L12 3zM19 15l.9 2.1L22 18l-2.1.9L19 21l-.9-2.1L16 18l2.1-.9L19 15z',
  chart: 'M4 19V5M4 19h16M8 15l3-4 3 2 5-7',
  shield: 'M12 3l7 3v5c0 4.5-3 8.2-7 10-4-1.8-7-5.5-7-10V6l7-3zM9 12l2 2 4-4',
  layers: 'M12 3l9 5-9 5-9-5 9-5zM3 13l9 5 9-5M3 17.5l9 5 9-5',
  file: 'M7 3h7l5 5v13H7V3zM14 3v5h5M10 13h6M10 17h6',
  globe: 'M12 21a9 9 0 100-18 9 9 0 000 18zM3 12h18M12 3c2.5 2.7 3.8 5.7 3.8 9S14.5 18.3 12 21c-2.5-2.7-3.8-5.7-3.8-9S9.5 5.7 12 3z',
  bolt: 'M13 2L4 14h7l-1 8 9-12h-7l1-8z',
  check: 'M5 12.5l4.5 4.5L19 7.5',
  arrow: 'M5 12h14M13 6l6 6-6 6',
  arrowUR: 'M7 17L17 7M8 7h9v9',
  plus: 'M12 5v14M5 12h14',
  calendar: 'M4 6h16v14H4V6zM4 10h16M8 3v4M16 3v4',
  users: 'M9 11a3.5 3.5 0 100-7 3.5 3.5 0 000 7zM2.5 20c.6-3.4 3.2-5.5 6.5-5.5s5.9 2.1 6.5 5.5M16 4.5a3.5 3.5 0 010 6.5M18 14.8c2 .7 3.2 2.4 3.5 5.2',
  lock: 'M6 11h12v9H6v-9zM8.5 11V8a3.5 3.5 0 017 0v3',
  coin: 'M12 21a9 9 0 100-18 9 9 0 000 18zM14.8 9.2c-.5-.8-1.5-1.2-2.8-1.2-1.7 0-2.8.8-2.8 2s1 1.7 2.8 2 2.8.9 2.8 2.1-1.1 2-2.8 2c-1.3 0-2.4-.5-2.9-1.4M12 6v2M12 16v2',
  radar: 'M12 21a9 9 0 100-18 9 9 0 000 18zM12 16a4 4 0 100-8 4 4 0 000 8zM12 12l6-6',
  chat: 'M4 5h16v11H9l-5 4V5zM8 9.5h8M8 12.5h5',
  sliders: 'M4 7h9M17 7h3M4 17h3M11 17h9M15 4v6M9 14v6',
  scale: 'M12 4v16M5 20h14M5 8l-3 7a3 3 0 006 0L5 8zm14 0l-3 7a3 3 0 006 0l-3-7zM5 8h14',
};

export default function Icon({ name, size = 22, stroke = 1.6, className = '' }) {
  return (
    <svg
      className={className}
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={stroke}
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      <path d={P[name] || P.spark} />
    </svg>
  );
}
