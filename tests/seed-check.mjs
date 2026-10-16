// node tests/seed-check.mjs — contrôles structurels du contenu des étages (pas de la justesse du coréen !).
import assert from 'node:assert/strict';
import { floor2 } from '../supabase/seed/floor2.mjs';
import { floor3 } from '../supabase/seed/floor3.mjs';
import { floor4 } from '../supabase/seed/floor4.mjs';
import { floor5 } from '../supabase/seed/floor5.mjs';
import { TAG_LABELS } from '../js/utils/helpers.js';

// Phrases acceptées (toutes réponses correctes) d'un étage, sans ponctuation ni espaces
const squash = (t) => String(t).normalize('NFC').replace(/[\s.,!?;:'"“”«»…~()\-]/g, '');
function acceptedOf(floor) {
  const set = new Map();
  for (const u of floor.units) for (const l of u.lessons) {
    l.exercises.forEach((e, i) => {
      const alts = String(e.answer ?? '').split('|').map((x) => x.trim()).filter(Boolean);
      const where = `U${u.unit_number}L${l.lesson_number}#${i + 1}`;
      if (e.type === 'fill_blank') for (const a of alts) set.set(squash(e.ko.replace('___', a)), where);
      else if (['translate_ko', 'reorder', 'listening'].includes(e.type)) for (const a of alts) set.set(squash(a), where);
      else if (e.type === 'translate_fr' && e.ko) set.set(squash(e.ko), where);
      for (const sec of l.content?.sections || []) for (const ex of sec.examples || []) set.set(squash(ex.ko), `cours U${u.unit_number}`);
    });
  }
  return set;
}

const problems = [];
const bad = (where, msg) => problems.push(`${where} : ${msg}`);
let total = 0;

for (const floor of [floor2, floor3, floor4, floor5]) {
  const accepted = acceptedOf(floor);
  for (const unit of floor.units) {
    for (const lesson of unit.lessons) {
      const seen = new Map();
      let run = 0;
      let last = null;
      lesson.exercises.forEach((e, i) => {
        total++;
        const w = `étage ${floor.floor_number} · U${unit.unit_number} L${lesson.lesson_number} #${i + 1} (${e.type})`;
        const answers = String(e.answer ?? '').split('|').map((x) => x.trim()).filter(Boolean);
        if (!answers.length) bad(w, 'réponse vide');
        for (const t of e.tags || []) if (!TAG_LABELS[t] && t !== 'word_order' && t !== 'listening' && t !== 'production') bad(w, `tag sans libellé : ${t}`);
        if (!e.expl) bad(w, 'explication manquante');
        const key = `${e.type}|${e.ko ?? ''}|${e.fr ?? ''}|${answers[0]}`;
        if (seen.has(key)) bad(w, `doublon avec #${seen.get(key)}`);
        seen.set(key, i + 1);
        if (['multiple_choice', 'fill_blank', 'listening'].includes(e.type)) {
          if (!Array.isArray(e.options) || e.options.length < 3) bad(w, 'moins de 3 options');
          else {
            if (new Set(e.options).size !== e.options.length) bad(w, 'options en double');
            if (!answers.every((a) => e.options.includes(a))) bad(w, `la réponse « ${answers.join(' | ')} » n'est pas dans les options`);
            if (e.options.filter((o) => answers.includes(o)).length !== 1) bad(w, 'plusieurs bonnes réponses dans les options');
          }
        }
        if (['multiple_choice', 'fill_blank', 'listening'].includes(e.type) && Array.isArray(e.options) && e.options.length !== 4) bad(w, `${e.options.length} options au lieu de 4 (3 fausses + la bonne)`);
        if (e.type === 'fill_blank') {
          // Une option fausse ne doit pas donner une phrase acceptée ailleurs dans l'étage
          for (const o of e.options.filter((x) => !answers.includes(x))) {
            const hit = accepted.get(squash(e.ko.replace('___', o)));
            if (hit) bad(w, `l'option fausse « ${o} » donne une phrase acceptée ailleurs (${hit})`);
          }
          if ((e.ko.match(/___/g) || []).length !== 1) bad(w, 'il faut exactement un ___');
          // La phrase complète ne doit pas se retrouver telle quelle parmi les autres choix
          const full = e.options.map((o) => e.ko.replace('___', o).replace(/\s+/g, ' ').trim());
          if (new Set(full).size !== full.length) bad(w, 'deux options donnent la même phrase');
        }
        if (e.type === 'reorder') {
          const joined = [...e.options].sort().join('|');
          const target = answers[0].split(' ').sort().join('|');
          if (joined !== target) bad(w, `les mots (${e.options.join(' ')}) ne reconstituent pas « ${answers[0]} »`);
        }
        if (e.type === 'multiple_choice' && Array.isArray(e.options)) {
          for (const o of e.options.filter((x) => !answers.includes(x))) {
            const hit = accepted.get(squash(o));
            if (hit) bad(w, `l'option fausse « ${o} » est une phrase acceptée ailleurs (${hit})`);
          }
        }
        if (e.type === 'listening' && !e.ko) bad(w, 'phrase à écouter manquante');
        if (e.type === 'translate_fr' && !e.ko) bad(w, 'phrase coréenne manquante');
        if (['translate_ko', 'reorder', 'free_production', 'multiple_choice'].includes(e.type) && !e.fr) bad(w, 'énoncé français manquant');
        if (e.type === last) run++; else run = 1;
        last = e.type;
      });
      const types = new Set(lesson.exercises.map((e) => e.type));
      if (lesson.type !== 'teach' && lesson.exercises.length < 8) bad(`étage ${floor.floor_number} U${unit.unit_number} L${lesson.lesson_number}`, 'moins de 8 exercices');
      if (lesson.type === 'teach') {
        if (!lesson.content?.sections?.length) bad(`étage ${floor.floor_number} U${unit.unit_number} L${lesson.lesson_number}`, 'cours sans sections');
        for (const sec of lesson.content?.sections || []) for (const ex of sec.examples || []) if (!ex.ko || !ex.rom || !ex.fr) bad(`cours étage ${floor.floor_number} U${unit.unit_number}`, `exemple incomplet : ${ex.ko}`);
      }
      if (types.size < 4 && lesson.exercises.length >= 8) bad(`étage ${floor.floor_number} U${unit.unit_number} L${lesson.lesson_number}`, `seulement ${types.size} types d'exercices`);
    }
  }
}

// Une phrase coréenne complète ne doit pas apparaître comme bonne réponse ET comme mauvaise option dans le même étage
if (problems.length) {
  console.error(problems.join('\n'));
  console.error(`\n${problems.length} problème(s) sur ${total} exercices`);
  process.exit(1);
}
console.log(`ok : ${total} exercices contrôlés (étages 2 à 5)`);
