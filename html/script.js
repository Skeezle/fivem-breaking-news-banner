let hideTimer = null;

window.addEventListener('message', (e) => {
  const data = e.data || {};
  if (data.action === 'showNews') {
    const t = String(data.title || 'Breaking News');
    const m = String(data.message || 'Live Update');
    const b = String(data.bottom || 'Stay tuned for more breaking news!');
    const secs = Math.max(1, Math.min(60, Number(data.time || 5)));

    document.getElementById('title').textContent = t;
    document.getElementById('message').textContent = m;
    document.getElementById('bottom').textContent = b;

    const banner = document.getElementById('banner');
    banner.classList.remove('hidden');

    if (hideTimer) clearTimeout(hideTimer);
    hideTimer = setTimeout(() => {
      banner.classList.add('hidden');
    }, secs * 1000);
  } else if (data.action === 'hideNews') {
    const banner = document.getElementById('banner');
    banner.classList.add('hidden');
    if (hideTimer) clearTimeout(hideTimer);
  }
});
