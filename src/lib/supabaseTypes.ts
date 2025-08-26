// Database type definitions for trAInor fitness app
// Generated from Supabase schema

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string;
          email: string;
          full_name: string | null;
          username: string | null;
          avatar_url: string | null;
          fitness_level: 'beginner' | 'intermediate' | 'advanced';
          primary_goal: 'strength' | 'endurance' | 'flexibility' | 'weight_loss' | 'muscle_gain';
          weight: number | null;
          height: number | null;
          date_of_birth: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id: string;
          email: string;
          full_name?: string | null;
          username?: string | null;
          avatar_url?: string | null;
          fitness_level?: 'beginner' | 'intermediate' | 'advanced';
          primary_goal?: 'strength' | 'endurance' | 'flexibility' | 'weight_loss' | 'muscle_gain';
          weight?: number | null;
          height?: number | null;
          date_of_birth?: string | null;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          email?: string;
          full_name?: string | null;
          username?: string | null;
          avatar_url?: string | null;
          fitness_level?: 'beginner' | 'intermediate' | 'advanced';
          primary_goal?: 'strength' | 'endurance' | 'flexibility' | 'weight_loss' | 'muscle_gain';
          weight?: number | null;
          height?: number | null;
          date_of_birth?: string | null;
          created_at?: string;
          updated_at?: string;
        };
      };
      exercises: {
        Row: {
          id: string;
          name: string;
          description: string | null;
          instructions: string;
          category: 'bodyweight' | 'cardio' | 'flexibility' | 'strength';
          muscle_groups: string[];
          difficulty_level: 'beginner' | 'intermediate' | 'advanced';
          equipment_needed: string | null;
          video_url: string | null;
          image_url: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          name: string;
          description?: string | null;
          instructions: string;
          category: 'bodyweight' | 'cardio' | 'flexibility' | 'strength';
          muscle_groups: string[];
          difficulty_level: 'beginner' | 'intermediate' | 'advanced';
          equipment_needed?: string | null;
          video_url?: string | null;
          image_url?: string | null;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          name?: string;
          description?: string | null;
          instructions?: string;
          category?: 'bodyweight' | 'cardio' | 'flexibility' | 'strength';
          muscle_groups?: string[];
          difficulty_level?: 'beginner' | 'intermediate' | 'advanced';
          equipment_needed?: string | null;
          video_url?: string | null;
          image_url?: string | null;
          created_at?: string;
          updated_at?: string;
        };
      };
      workouts: {
        Row: {
          id: string;
          name: string;
          description: string | null;
          duration_minutes: number;
          difficulty_level: 'beginner' | 'intermediate' | 'advanced';
          category: 'strength' | 'cardio' | 'flexibility' | 'full_body' | 'upper_body' | 'lower_body';
          is_template: boolean;
          created_by: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          name: string;
          description?: string | null;
          duration_minutes: number;
          difficulty_level: 'beginner' | 'intermediate' | 'advanced';
          category: 'strength' | 'cardio' | 'flexibility' | 'full_body' | 'upper_body' | 'lower_body';
          is_template?: boolean;
          created_by?: string | null;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          name?: string;
          description?: string | null;
          duration_minutes?: number;
          difficulty_level?: 'beginner' | 'intermediate' | 'advanced';
          category?: 'strength' | 'cardio' | 'flexibility' | 'full_body' | 'upper_body' | 'lower_body';
          is_template?: boolean;
          created_by?: string | null;
          created_at?: string;
          updated_at?: string;
        };
      };
      workout_exercises: {
        Row: {
          id: string;
          workout_id: string;
          exercise_id: string;
          sets: number | null;
          reps: number | null;
          duration_seconds: number | null;
          rest_seconds: number | null;
          weight: number | null;
          notes: string | null;
          order_index: number;
          created_at: string;
        };
        Insert: {
          id?: string;
          workout_id: string;
          exercise_id: string;
          sets?: number | null;
          reps?: number | null;
          duration_seconds?: number | null;
          rest_seconds?: number | null;
          weight?: number | null;
          notes?: string | null;
          order_index: number;
          created_at?: string;
        };
        Update: {
          id?: string;
          workout_id?: string;
          exercise_id?: string;
          sets?: number | null;
          reps?: number | null;
          duration_seconds?: number | null;
          rest_seconds?: number | null;
          weight?: number | null;
          notes?: string | null;
          order_index?: number;
          created_at?: string;
        };
      };
      workout_logs: {
        Row: {
          id: string;
          user_id: string;
          workout_id: string;
          started_at: string;
          completed_at: string | null;
          duration_minutes: number | null;
          calories_burned: number | null;
          notes: string | null;
          rating: number | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          user_id: string;
          workout_id: string;
          started_at: string;
          completed_at?: string | null;
          duration_minutes?: number | null;
          calories_burned?: number | null;
          notes?: string | null;
          rating?: number | null;
          created_at?: string;
        };
        Update: {
          id?: string;
          user_id?: string;
          workout_id?: string;
          started_at?: string;
          completed_at?: string | null;
          duration_minutes?: number | null;
          calories_burned?: number | null;
          notes?: string | null;
          rating?: number | null;
          created_at?: string;
        };
      };
      exercise_logs: {
        Row: {
          id: string;
          workout_log_id: string;
          exercise_id: string;
          sets_completed: number;
          reps_completed: number | null;
          duration_seconds: number | null;
          weight_used: number | null;
          rest_seconds: number | null;
          notes: string | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          workout_log_id: string;
          exercise_id: string;
          sets_completed: number;
          reps_completed?: number | null;
          duration_seconds?: number | null;
          weight_used?: number | null;
          rest_seconds?: number | null;
          notes?: string | null;
          created_at?: string;
        };
        Update: {
          id?: string;
          workout_log_id?: string;
          exercise_id?: string;
          sets_completed?: number;
          reps_completed?: number | null;
          duration_seconds?: number | null;
          weight_used?: number | null;
          rest_seconds?: number | null;
          notes?: string | null;
          created_at?: string;
        };
      };
      progress_logs: {
        Row: {
          id: string;
          user_id: string;
          date: string;
          weight: number | null;
          body_fat_percentage: number | null;
          muscle_mass: number | null;
          measurements: Record<string, number> | null;
          photos: string[] | null;
          notes: string | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          user_id: string;
          date: string;
          weight?: number | null;
          body_fat_percentage?: number | null;
          muscle_mass?: number | null;
          measurements?: Record<string, number> | null;
          photos?: string[] | null;
          notes?: string | null;
          created_at?: string;
        };
        Update: {
          id?: string;
          user_id?: string;
          date?: string;
          weight?: number | null;
          body_fat_percentage?: number | null;
          muscle_mass?: number | null;
          measurements?: Record<string, number> | null;
          photos?: string[] | null;
          notes?: string | null;
          created_at?: string;
        };
      };
    };
    Views: {
      [_ in never]: never;
    };
    Functions: {
      [_ in never]: never;
    };
    Enums: {
      fitness_level: 'beginner' | 'intermediate' | 'advanced';
      exercise_category: 'bodyweight' | 'cardio' | 'flexibility' | 'strength';
      workout_category: 'strength' | 'cardio' | 'flexibility' | 'full_body' | 'upper_body' | 'lower_body';
      primary_goal: 'strength' | 'endurance' | 'flexibility' | 'weight_loss' | 'muscle_gain';
    };
  };
}
