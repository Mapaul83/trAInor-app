-- trAInor Fitness App Database Schema
-- This file contains the complete database structure for the personal training app

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types (enums)
CREATE TYPE fitness_level AS ENUM ('beginner', 'intermediate', 'advanced');
CREATE TYPE exercise_category AS ENUM ('bodyweight', 'cardio', 'flexibility', 'strength');
CREATE TYPE workout_category AS ENUM ('strength', 'cardio', 'flexibility', 'full_body', 'upper_body', 'lower_body');
CREATE TYPE primary_goal AS ENUM ('strength', 'endurance', 'flexibility', 'weight_loss', 'muscle_gain');

-- User profiles table (extends auth.users)
CREATE TABLE profiles (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    email TEXT NOT NULL,
    full_name TEXT,
    username TEXT UNIQUE,
    avatar_url TEXT,
    fitness_level fitness_level DEFAULT 'beginner',
    primary_goal primary_goal DEFAULT 'strength',
    weight DECIMAL(5,2), -- in kg
    height DECIMAL(5,2), -- in cm
    date_of_birth DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Exercise library table
CREATE TABLE exercises (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    instructions TEXT NOT NULL,
    category exercise_category NOT NULL,
    muscle_groups TEXT[] NOT NULL, -- Array of muscle groups
    difficulty_level fitness_level NOT NULL,
    equipment_needed TEXT,
    video_url TEXT,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Workout templates table
CREATE TABLE workouts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    duration_minutes INTEGER NOT NULL,
    difficulty_level fitness_level NOT NULL,
    category workout_category NOT NULL,
    is_template BOOLEAN DEFAULT true, -- true for templates, false for user-created
    created_by UUID REFERENCES auth.users(id), -- null for system templates
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Junction table for workout exercises
CREATE TABLE workout_exercises (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    workout_id UUID REFERENCES workouts(id) ON DELETE CASCADE,
    exercise_id UUID REFERENCES exercises(id) ON DELETE CASCADE,
    sets INTEGER,
    reps INTEGER,
    duration_seconds INTEGER, -- for time-based exercises
    rest_seconds INTEGER DEFAULT 60,
    weight DECIMAL(6,2), -- in kg
    notes TEXT,
    order_index INTEGER NOT NULL, -- order within the workout
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Workout logs for completed sessions
CREATE TABLE workout_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    workout_id UUID REFERENCES workouts(id),
    started_at TIMESTAMP WITH TIME ZONE NOT NULL,
    completed_at TIMESTAMP WITH TIME ZONE,
    duration_minutes INTEGER, -- actual duration
    calories_burned INTEGER,
    notes TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5), -- 1-5 star rating
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Exercise logs for individual exercise performance
CREATE TABLE exercise_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    workout_log_id UUID REFERENCES workout_logs(id) ON DELETE CASCADE,
    exercise_id UUID REFERENCES exercises(id),
    sets_completed INTEGER NOT NULL,
    reps_completed INTEGER,
    duration_seconds INTEGER,
    weight_used DECIMAL(6,2), -- in kg
    rest_seconds INTEGER,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Progress tracking table
CREATE TABLE progress_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    weight DECIMAL(5,2), -- in kg
    body_fat_percentage DECIMAL(4,2), -- percentage
    muscle_mass DECIMAL(5,2), -- in kg
    measurements JSONB, -- flexible measurements (chest, waist, etc.)
    photos TEXT[], -- array of photo URLs
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, date) -- one entry per user per day
);

-- Create indexes for performance
CREATE INDEX idx_profiles_username ON profiles(username) WHERE username IS NOT NULL;
CREATE INDEX idx_exercises_category ON exercises(category);
CREATE INDEX idx_exercises_difficulty ON exercises(difficulty_level);
CREATE INDEX idx_exercises_muscle_groups ON exercises USING GIN(muscle_groups);
CREATE INDEX idx_workouts_category ON workouts(category);
CREATE INDEX idx_workouts_difficulty ON workouts(difficulty_level);
CREATE INDEX idx_workouts_created_by ON workouts(created_by);
CREATE INDEX idx_workout_exercises_workout_id ON workout_exercises(workout_id);
CREATE INDEX idx_workout_exercises_exercise_id ON workout_exercises(exercise_id);
CREATE INDEX idx_workout_logs_user_id ON workout_logs(user_id);
CREATE INDEX idx_workout_logs_date ON workout_logs(started_at);
CREATE INDEX idx_exercise_logs_workout_log_id ON exercise_logs(workout_log_id);
CREATE INDEX idx_progress_logs_user_id ON progress_logs(user_id);
CREATE INDEX idx_progress_logs_date ON progress_logs(date);

-- Enable Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE workout_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE exercise_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE progress_logs ENABLE ROW LEVEL SECURITY;

-- RLS Policies for profiles
CREATE POLICY "Users can view their own profile" ON profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- RLS Policies for exercises (public read, admin write)
CREATE POLICY "Anyone can view exercises" ON exercises
    FOR SELECT TO authenticated USING (true);

-- RLS Policies for workouts
CREATE POLICY "Users can view public workout templates" ON workouts
    FOR SELECT USING (is_template = true OR created_by = auth.uid());

CREATE POLICY "Users can create their own workouts" ON workouts
    FOR INSERT WITH CHECK (created_by = auth.uid());

CREATE POLICY "Users can update their own workouts" ON workouts
    FOR UPDATE USING (created_by = auth.uid());

CREATE POLICY "Users can delete their own workouts" ON workouts
    FOR DELETE USING (created_by = auth.uid());

-- RLS Policies for workout_logs
CREATE POLICY "Users can view their own workout logs" ON workout_logs
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own workout logs" ON workout_logs
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own workout logs" ON workout_logs
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own workout logs" ON workout_logs
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for exercise_logs (inherit from workout_logs)
CREATE POLICY "Users can view their own exercise logs" ON exercise_logs
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM workout_logs 
            WHERE workout_logs.id = exercise_logs.workout_log_id 
            AND workout_logs.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can insert their own exercise logs" ON exercise_logs
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM workout_logs 
            WHERE workout_logs.id = exercise_logs.workout_log_id 
            AND workout_logs.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update their own exercise logs" ON exercise_logs
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM workout_logs 
            WHERE workout_logs.id = exercise_logs.workout_log_id 
            AND workout_logs.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can delete their own exercise logs" ON exercise_logs
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM workout_logs 
            WHERE workout_logs.id = exercise_logs.workout_log_id 
            AND workout_logs.user_id = auth.uid()
        )
    );

-- RLS Policies for progress_logs
CREATE POLICY "Users can view their own progress logs" ON progress_logs
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own progress logs" ON progress_logs
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own progress logs" ON progress_logs
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own progress logs" ON progress_logs
    FOR DELETE USING (auth.uid() = user_id);

-- Functions for automatic timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at timestamps
CREATE TRIGGER update_profiles_updated_at 
    BEFORE UPDATE ON profiles 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_exercises_updated_at 
    BEFORE UPDATE ON exercises 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_workouts_updated_at 
    BEFORE UPDATE ON workouts 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to handle new user registration
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name)
    VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to automatically create profile on user signup
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
