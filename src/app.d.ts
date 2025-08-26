// See https://svelte.dev/docs/kit/types#app.d.ts
// for information about these interfaces

import type { Session, SupabaseClient } from '@supabase/supabase-js';
import type { Database } from './lib/supabaseTypes';

declare global {
	namespace App {
		// interface Error {}
		interface Locals {
			supabase: SupabaseClient<Database>;
			getSession(): Promise<Session | null>;
		}
		interface PageData {
			session: Session | null;
		}
		// interface PageState {}
		// interface Platform {}
	}
}

// Environment variables for Supabase
interface ImportMetaEnv {
	readonly PUBLIC_SUPABASE_URL: string;
	readonly PUBLIC_SUPABASE_ANON_KEY: string;
	readonly SUPABASE_SERVICE_ROLE_KEY: string;
	readonly DATABASE_URL: string;
	readonly SUPABASE_JWT_SECRET: string;
}

interface ImportMeta {
	readonly env: ImportMetaEnv;
}

export {};
