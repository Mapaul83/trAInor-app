import { supabase } from './supabase';
import type { Database } from './supabaseTypes';

type Exercise = Database['public']['Tables']['exercises']['Row'];
type WorkoutExercise = {
	exercise: Exercise;
	duration: number; // Duration in seconds
	order: number;
};

export type Workout = {
	id?: string;
	name: string;
	description?: string;
	exercises: WorkoutExercise[];
	total_duration: number;
	created_at?: string;
	user_id?: string;
};

// Workout service for managing workout data
export const workoutService = {
	// Get all available exercises
	async getExercises(): Promise<{ success: boolean; data?: Exercise[]; error?: any }> {
		try {
			const { data, error } = await supabase
				.from('exercises')
				.select('*')
				.order('name');

			if (error) {
				console.error('Error fetching exercises:', error);
				return { success: false, error };
			}

			return { success: true, data: data || [] };
		} catch (err) {
			console.error('Exception fetching exercises:', err);
			return { success: false, error: err };
		}
	},

	// Filter exercises by criteria
	async getFilteredExercises(filters: {
		muscle_group?: string;
		difficulty?: string;
		equipment?: string;
		search?: string;
	}): Promise<{ success: boolean; data?: Exercise[]; error?: any }> {
		try {
			let query = supabase
				.from('exercises')
				.select('*');

			// Apply filters
			if (filters.muscle_group) {
				query = query.eq('muscle_group', filters.muscle_group);
			}
			if (filters.difficulty) {
				query = query.eq('difficulty', filters.difficulty);
			}
			if (filters.equipment) {
				query = query.eq('equipment', filters.equipment);
			}
			if (filters.search) {
				query = query.or(`name.ilike.%${filters.search}%,description.ilike.%${filters.search}%`);
			}

			query = query.order('name');

			const { data, error } = await query;

			if (error) {
				console.error('Error filtering exercises:', error);
				return { success: false, error };
			}

			return { success: true, data: data || [] };
		} catch (err) {
			console.error('Exception filtering exercises:', err);
			return { success: false, error: err };
		}
	},

	// Save a custom workout
	async saveWorkout(workout: Omit<Workout, 'id' | 'created_at' | 'user_id'>): Promise<{ success: boolean; data?: any; error?: any }> {
		try {
			const { data: { user } } = await supabase.auth.getUser();
			if (!user) {
				return { success: false, error: 'User not authenticated' };
			}

			// Save workout to database (we'll implement the workout tables later)
			// For now, we'll just return success and store locally
			console.log('Saving workout:', workout);
			
			// TODO: Implement database save when workout tables are created
			return { success: true, data: { ...workout, id: Date.now().toString(), user_id: user.id } };
		} catch (err) {
			console.error('Exception saving workout:', err);
			return { success: false, error: err };
		}
	},

	// Calculate total workout duration
	calculateTotalDuration(exercises: WorkoutExercise[]): number {
		return exercises.reduce((total, exercise) => total + exercise.duration, 0);
	},

	// Format duration for display
	formatDuration(seconds: number): string {
		const minutes = Math.floor(seconds / 60);
		const remainingSeconds = seconds % 60;
		if (minutes > 0) {
			return `${minutes}m ${remainingSeconds}s`;
		}
		return `${remainingSeconds}s`;
	},

	// Convert duration string to seconds
	parseTimeInput(input: string): number {
		// Parse inputs like "1m 30s", "90s", "1:30", etc.
		const timeRegex = /(?:(\d+)m\s*)?(?:(\d+)s?)?/;
		const colonRegex = /(\d+):(\d+)/;
		
		if (colonRegex.test(input)) {
			const [, minutes, seconds] = input.match(colonRegex) || [];
			return (parseInt(minutes) || 0) * 60 + (parseInt(seconds) || 0);
		}
		
		const [, minutes, seconds] = input.match(timeRegex) || [];
		return (parseInt(minutes) || 0) * 60 + (parseInt(seconds) || 0);
	}
};
