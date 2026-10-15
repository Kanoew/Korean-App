// Web Speech API — synthèse vocale coréenne (ko-KR). Dégrade proprement si non supportée.

export const ttsSupported = typeof window !== 'undefined' && 'speechSynthesis' in window;

function koVoice() {
  const voices = window.speechSynthesis.getVoices();
  return voices.find((v) => v.lang.replace('_', '-').toLowerCase().startsWith('ko'));
}

export function speak(text, { rate = 0.9 } = {}) {
  if (!ttsSupported || !text) return false;
  try {
    window.speechSynthesis.cancel();
    const u = new SpeechSynthesisUtterance(text);
    u.lang = 'ko-KR';
    u.rate = rate;
    const v = koVoice();
    if (v) u.voice = v;
    window.speechSynthesis.speak(u);
    return true;
  } catch {
    return false;
  }
}

export function stopSpeaking() {
  if (ttsSupported) window.speechSynthesis.cancel();
}
