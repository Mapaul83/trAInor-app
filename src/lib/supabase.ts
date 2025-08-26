import { createClient } from '@supabase/supabase-js';
import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public';
import type { Database } from './supabaseTypes';

if (!PUBLIC_SUPABASE_URL) {
  throw new Error('Missing PUBLIC_SUPABASE_URL environment variable');
}

if (!PUBLIC_SUPABASE_ANON_KEY) {
  throw new Error('Missing PUBLIC_SUPABASE_ANON_KEY environment variable');
}

// Create Supabase client
export const supabase = createClient<Database>(
  PUBLIC_SUPABASE_URL,
  PUBLIC_SUPABASE_ANON_KEY,
  {
    auth: {
      autoRefreshToken: true,
      persistSession: true,
      detectSessionInUrl: true,
    },
    realtime: {
      params: {
        eventsPerSecond: 10,
      },
    },
  }
);

// Server-side client factory (for use in load functions and API routes)
export const createServerClient = (
  supabaseUrl: string = PUBLIC_SUPABASE_URL,
  supabaseKey: string = PUBLIC_SUPABASE_ANON_KEY
) => {
  return createClient<Database>(supabaseUrl, supabaseKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  });
};

// Type exports for convenience
export type SupabaseClient = typeof supabase;
export type Tables<T extends keyof Database['public']['Tables']> = Database['public']['Tables'][T]['Row'];
export type Enums<T extends keyof Database['public']['Enums']> = Database['public']['Enums'][T];

// Helper types for common operations
export type Profile = Tables<'profiles'>;
export type Exercise = Tables<'exercises'>;
export type Workout = Tables<'workouts'>;
export type WorkoutExercise = Tables<'workout_exercises'>;
export type WorkoutLog = Tables<'workout_logs'>;
export type ExerciseLog = Tables<'exercise_logs'>;
export type ProgressLog = Tables<'progress_logs'>;

// Enum types
export type FitnessLevel = Enums<'fitness_level'>;
export type ExerciseCategory = Enums<'exercise_category'>;
export type WorkoutCategory = Enums<'workout_category'>;
export type PrimaryGoal = Enums<'primary_goal'>;

// Auth helpers
export const getUser = async () => {
  const { data: { user } } = await supabase.auth.getUser();
  return user;
};

export const getSession = async () => {
  const { data: { session } } = await supabase.auth.getSession();
  return session;
};

export const signOut = async () => {
  return await supabase.auth.signOut();
};