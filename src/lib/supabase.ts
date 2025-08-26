import { createClient } from '@supabase/supabase-js';
import type { Database } from './supabaseTypes';

// Temporarily hardcode the values to bypass environment variable issues
const supabaseUrl = 'https://qsjnzpciqcssirwtxwwl.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzam56cGNpcWNzc2lyd3R4d3dsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU2OTU2MDMsImV4cCI6MjA3MTI3MTYwM30.scf5fN7hP7L1gLWnWSkbKPvDok92gAE6XKY78go4zsE';

// Debug logging
console.log('Using hardcoded Supabase credentials:');
console.log('URL:', supabaseUrl);
console.log('Key:', supabaseKey ? 'Set (hidden)' : 'Not set');

// Create Supabase client
export const supabase = createClient<Database>(
  supabaseUrl,
  supabaseKey,
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
  supabaseUrlParam: string = supabaseUrl,
  supabaseKeyParam: string = supabaseKey
) => {
  return createClient<Database>(supabaseUrlParam, supabaseKeyParam, {
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

// Insert types
export type ProfileInsert = Database['public']['Tables']['profiles']['Insert'];
export type ExerciseInsert = Database['public']['Tables']['exercises']['Insert'];
export type WorkoutInsert = Database['public']['Tables']['workouts']['Insert'];
export type WorkoutExerciseInsert = Database['public']['Tables']['workout_exercises']['Insert'];
export type WorkoutLogInsert = Database['public']['Tables']['workout_logs']['Insert'];
export type ExerciseLogInsert = Database['public']['Tables']['exercise_logs']['Insert'];
export type ProgressLogInsert = Database['public']['Tables']['progress_logs']['Insert'];

// Update types
export type ProfileUpdate = Database['public']['Tables']['profiles']['Update'];
export type ExerciseUpdate = Database['public']['Tables']['exercises']['Update'];
export type WorkoutUpdate = Database['public']['Tables']['workouts']['Update'];
export type WorkoutExerciseUpdate = Database['public']['Tables']['workout_exercises']['Update'];
export type WorkoutLogUpdate = Database['public']['Tables']['workout_logs']['Update'];
export type ExerciseLogUpdate = Database['public']['Tables']['exercise_logs']['Update'];
export type ProgressLogUpdate = Database['public']['Tables']['progress_logs']['Update'];
