import { Routes, Route, Navigate } from 'react-router-dom';
import { lazy, Suspense } from 'react';
const Gallery = lazy(() => import('./Gallery.jsx'));
const ThemePage = lazy(() => import('./ThemePage.jsx'));

export default function App() {
  return (
    <Suspense fallback={<div style={{ minHeight: '100vh', background: '#070709' }} />}>
    <Routes>
      <Route path="/" element={<Gallery />} />
      <Route path="/t/:slug" element={<ThemePage />} />
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
    </Suspense>
  );
}
