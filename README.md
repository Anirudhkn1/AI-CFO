# NEUROPLAST · AI CFO — 12 frontend design directions

One React + Vite project containing **12 complete, distinct landing-page frontends**. Each has its own palette,
typography, hero (built from [React Bits](https://reactbits.dev) components) and component language.

```bash
npm install
npm run dev      # http://localhost:5173  → gallery of all 12
npm run build
```

Inside any design: use the floating dock (bottom) or **Alt + ← / →** to hop between directions.

| # | Direction | Palette | Hero engine |
|---|-----------|---------|-------------|
| 01 | Crimson Ledger | Midnight navy · warm stone grey · crimson | Aurora + SplitText + ScrollVelocity |
| 02 | Neon Syndicate | Deep black · neon red · indigo | Lightning + GlitchText + DecryptedText + TextType |
| 03 | Atlas & Ivory | Ivory · gold · deep atlas navy | Particles in a navy arch + CircularText seal |
| 04 | Periwinkle Noir | Pure black · periwinkle · coral | Orb + TextPressure + BlurText |
| 05 | Emerald Reserve | Emerald · champagne · bone | LightRays + RotatingText |
| 06 | Oxblood Vault | Oxblood · brass · blush | LiquidChrome + CircularText medallion + CountUp |
| 07 | Quantum Teal | Graphite · electric teal · ice | FaultyTerminal + DecryptedText + ElectricBorder |
| 08 | Aubergine Dusk | Aubergine · lilac · amber | Galaxy + GradientText + TrueFocus |
| 09 | Terracotta Atelier | Sand · terracotta · espresso | DotGrid + SplitText(mask) + TiltedCard |
| 10 | Cobalt Glacier | Ice · cobalt · silver | Threads + GradientText + GlassSurface |
| 11 | Platinum Obsidian | Obsidian · platinum · champagne | Silk + FuzzyText + SpecularButton |
| 12 | Solar Flare | Plum · magenta · saffron | PrismaticBurst + Shuffle + CurvedLoop |

## Shared page system
Trust marquee (LogoLoop) → stats (CountUp) → scroll-scrubbed manifesto (ScrollReveal) → features
(MagicBento / SpotlightCard / PixelCard / TiltedCard / GlareHover, chosen per theme) → **live CFO Scenario Lab**
(custom: switch scenarios, drag the hiring slider, the cash chart and runway recompute) → process → testimonials
(draggable Stack) → pricing (StarBorder / ElectricBorder / conic glow / gilt frame) → FAQ → CTA → footer.

## Where things live
- `src/themes/themes.js` – every palette, font pairing and component recipe (add a theme = add an object + a hero).
- `src/heroes/` – the 12 heroes. `src/sections/` – shared sections. `src/ui/CFOConsole.jsx` – the signature Scenario Lab.
- `src/components/reactbits/` – components pulled from the official React Bits registry (`https://reactbits.dev/r/<Name>-JS-CSS.json`).
- Colour is driven by CSS variables set per theme on the `.site` wrapper (see `src/styles/base.css`).

All figures, customer names and testimonials are **sample content** for design review.
