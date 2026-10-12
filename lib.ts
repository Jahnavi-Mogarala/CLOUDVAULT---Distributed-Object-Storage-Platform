import { createClient, SupabaseClient } from '@supabase/supabase-js';
const url = import.meta.env.VITE_SUPABASE_URL as string | undefined;
const key = import.meta.env.VITE_SUPABASE_ANON_KEY as string | undefined;
export const supabase: SupabaseClient | null = url && key && !url.includes('YOUR_PROJECT') ? createClient(url, key) : null;
export type Profile = { id: string; display_name: string; emergency_name: string | null; emergency_phone: string | null; language: string; created_at?: string };
export type Checkin = { id?: string; user_id?: string; mood: number; energy: number; note: string; created_at?: string };
export const getLocal = <T,>(key:string, fallback:T):T => { try { const x=localStorage.getItem(`careloom:${key}`); return x ? JSON.parse(x) as T : fallback; } catch { return fallback; } };
export const setLocal = (key:string,value:unknown) => { try { localStorage.setItem(`careloom:${key}`,JSON.stringify(value)); } catch { /* Storage may be unavailable. */ } };
