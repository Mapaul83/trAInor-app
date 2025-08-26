import { writable } from 'svelte/store';
import { supabase } from '$lib/supabase';
import type { User, Session, AuthError } from '@supabase/supabase-js';

// Profile type definition
interface Profile {
	id: string;
	email: string;
	full_name?: string;
	username?: string;
	avatar_url?: string;
	fitness_level?: 'beginner' | 'intermediate' | 'advanced';
	primary_goal?: 'strength' | 'endurance' | 'flexibility' | 'weight_loss' | 'muscle_gain';
	weight?: number;
	height?: number;
	date_of_birth?: string;
	created_at?: string;
	updated_at?: string;
}

// Auth state stores
export const isLoading = writable(true);
export const loading = writable(false); // Add alias for compatibility
export const isAuthenticated = writable(false);
export const user = writable<User | null>(null);
export const session = writable<Session | null>(null);
export const authError = writable<AuthError | null>(null);
export const profile = writable<Profile | null>(null);

// Auth service
export const authService = {
	async init() {
		try {
			// Get initial session
			const { data: { session: initialSession }, error } = await supabase.auth.getSession();
			
			if (error) {
				console.error('Auth init error:', error);
				authError.set(error);
			} else {
				session.set(initialSession);
				user.set(initialSession?.user ?? null);
				isAuthenticated.set(!!initialSession?.user);
			}

			// Listen for auth changes
			supabase.auth.onAuthStateChange((event, session) => {
				console.log('Auth state change:', event, session?.user?.email);
				user.set(session?.user ?? null);
				isAuthenticated.set(!!session?.user);
				authError.set(null);
			});
		} catch (err) {
			console.error('Auth initialization failed:', err);
			authError.set(err as AuthError);
		} finally {
			isLoading.set(false);
		}
	},

	async signUp(email: string, password: string, fullName?: string) {
		isLoading.set(true);
		authError.set(null);

		try {
			console.log('Attempting signup for:', email);
			const { data, error } = await supabase.auth.signUp({
				email,
				password,
				options: {
					emailRedirectTo: `${window.location.origin}/auth/confirm`,
					data: {
						full_name: fullName
					}
				}
			});

			if (error) {
				console.error('Signup error:', error);
				authError.set(error);
				return { success: false, error };
			}

			console.log('Signup result:', data);
			return { success: true, data };
		} catch (err) {
			const error = err as AuthError;
			console.error('Signup exception:', error);
			authError.set(error);
			return { success: false, error };
		} finally {
			isLoading.set(false);
		}
	},

	async signIn(email: string, password: string) {
		isLoading.set(true);
		authError.set(null);

		try {
			console.log('Attempting sign in for:', email);
			const { data, error } = await supabase.auth.signInWithPassword({
				email,
				password
			});

			if (error) {
				console.error('Sign in error:', error);
				authError.set(error);
				return { success: false, error };
			}

			console.log('Sign in successful:', data.user?.email);
			return { success: true, data };
		} catch (err) {
			const error = err as AuthError;
			console.error('Sign in exception:', error);
			authError.set(error);
			return { success: false, error };
		} finally {
			isLoading.set(false);
		}
	},

	async signOut() {
		isLoading.set(true);
		authError.set(null);

		try {
			const { error } = await supabase.auth.signOut();
			
			if (error) {
				authError.set(error);
				return { success: false, error };
			}

			return { success: true };
		} catch (err) {
			const error = err as AuthError;
			authError.set(error);
			return { success: false, error };
		} finally {
			isLoading.set(false);
		}
	}
};
