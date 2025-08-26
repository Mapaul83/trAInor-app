-- Sample data for trAInor Fitness App (Safe Version)
-- This version handles existing data gracefully

-- Insert sample exercises (using ON CONFLICT to handle duplicates)
INSERT INTO exercises (name, description, instructions, category, muscle_groups, difficulty_level, equipment_needed) VALUES
-- Bodyweight exercises
('Push-ups', 'Classic upper body bodyweight exercise', 'Start in plank position. Lower body until chest nearly touches floor. Push back up to starting position.', 'bodyweight', '{"chest", "shoulders", "triceps", "core"}', 'beginner', 'None'),
('Squats', 'Fundamental lower body exercise', 'Stand with feet shoulder-width apart. Lower body as if sitting back into chair. Return to standing position.', 'bodyweight', '{"quadriceps", "glutes", "hamstrings", "calves"}', 'beginner', 'None'),
('Pull-ups', 'Upper body pulling exercise', 'Hang from bar with arms fully extended. Pull body up until chin clears bar. Lower with control.', 'bodyweight', '{"latissimus dorsi", "biceps", "rhomboids", "rear deltoids"}', 'intermediate', 'Pull-up bar'),
('Burpees', 'Full body explosive exercise', 'Start standing. Drop to squat, kick feet back to plank, do push-up, jump feet to squat, then jump up.', 'bodyweight', '{"full body", "core", "legs", "chest", "shoulders"}', 'intermediate', 'None'),
('Planks', 'Core stability exercise', 'Hold a push-up position, maintaining straight line from head to heels. Engage core throughout.', 'bodyweight', '{"core", "shoulders", "back"}', 'beginner', 'None'),

-- Cardio exercises
('Running', 'Cardiovascular endurance exercise', 'Maintain steady pace. Focus on breathing rhythm and proper form.', 'cardio', '{"legs", "cardiovascular system"}', 'beginner', 'None or treadmill'),
('Jumping Jacks', 'High-impact cardio exercise', 'Jump while spreading legs and raising arms overhead. Return to starting position.', 'cardio', '{"legs", "shoulders", "cardiovascular system"}', 'beginner', 'None'),
('High Knees', 'Cardio and leg strengthening', 'Run in place bringing knees up to waist level. Maintain quick pace.', 'cardio', '{"hip flexors", "calves", "cardiovascular system"}', 'beginner', 'None'),

-- Strength exercises
('Deadlifts', 'Compound lower body and back exercise', 'Stand with feet hip-width apart. Hinge at hips to lower weight. Drive through heels to return to standing.', 'strength', '{"hamstrings", "glutes", "erector spinae", "latissimus dorsi", "traps"}', 'intermediate', 'Barbell or dumbbells'),
('Bench Press', 'Upper body pushing exercise', 'Lie on bench. Lower barbell to chest with control. Press back up to full arm extension.', 'strength', '{"chest", "shoulders", "triceps"}', 'intermediate', 'Barbell and bench'),
('Overhead Press', 'Shoulder and core strengthening', 'Stand with weight at shoulder level. Press directly overhead until arms are fully extended.', 'strength', '{"shoulders", "triceps", "core"}', 'intermediate', 'Barbell or dumbbells'),

-- Flexibility exercises
('Downward Dog', 'Full body stretch and strengthening', 'Start on hands and knees. Tuck toes, lift hips up and back to form inverted V shape.', 'flexibility', '{"hamstrings", "calves", "shoulders", "back"}', 'beginner', 'Yoga mat'),
('Cat-Cow Stretch', 'Spinal mobility exercise', 'On hands and knees, alternate between arching and rounding your spine.', 'flexibility', '{"spine", "core", "back"}', 'beginner', 'Yoga mat'),
('Pigeon Pose', 'Hip and glute stretch', 'From table top, bring one knee forward. Extend opposite leg back. Hold stretch.', 'flexibility', '{"hip flexors", "glutes", "IT band"}', 'intermediate', 'Yoga mat')
ON CONFLICT (name) DO NOTHING; -- Skip if exercise already exists

-- Insert sample workout templates (using ON CONFLICT to handle duplicates)
INSERT INTO workouts (name, description, duration_minutes, difficulty_level, category, is_template, created_by) 
SELECT * FROM (VALUES
('Beginner Full Body', 'Perfect introduction to fitness covering all major muscle groups', 30, 'beginner'::fitness_level, 'full_body'::workout_category, true, null::uuid),
('HIIT Cardio Blast', 'High-intensity interval training for cardiovascular fitness', 20, 'intermediate'::fitness_level, 'cardio'::workout_category, true, null::uuid),
('Upper Body Strength', 'Focus on building upper body strength and muscle', 45, 'intermediate'::fitness_level, 'upper_body'::workout_category, true, null::uuid),
('Flexibility Flow', 'Gentle stretching routine to improve mobility', 25, 'beginner'::fitness_level, 'flexibility'::workout_category, true, null::uuid),
('Lower Body Power', 'Explosive lower body workout for strength and power', 40, 'advanced'::fitness_level, 'lower_body'::workout_category, true, null::uuid)
) AS v(name, description, duration_minutes, difficulty_level, category, is_template, created_by)
WHERE NOT EXISTS (SELECT 1 FROM workouts WHERE workouts.name = v.name);

-- Create workout exercises (safely handle existing data)
DO $$
DECLARE
    full_body_id UUID;
    hiit_cardio_id UUID;
    upper_body_id UUID;
    flexibility_id UUID;
    lower_body_id UUID;
    current_exercise_id UUID;
BEGIN
    -- Get workout IDs
    SELECT id INTO full_body_id FROM workouts WHERE name = 'Beginner Full Body';
    SELECT id INTO hiit_cardio_id FROM workouts WHERE name = 'HIIT Cardio Blast';
    SELECT id INTO upper_body_id FROM workouts WHERE name = 'Upper Body Strength';
    SELECT id INTO flexibility_id FROM workouts WHERE name = 'Flexibility Flow';
    SELECT id INTO lower_body_id FROM workouts WHERE name = 'Lower Body Power';

    -- Only proceed if we have the workout IDs
    IF full_body_id IS NOT NULL THEN
        -- Beginner Full Body workout exercises
        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'Squats';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = full_body_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, reps, rest_seconds, order_index) 
            VALUES (full_body_id, current_exercise_id, 3, 10, 60, 1);
        END IF;

        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'Push-ups';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = full_body_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, reps, rest_seconds, order_index) 
            VALUES (full_body_id, current_exercise_id, 3, 8, 60, 2);
        END IF;

        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'Planks';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = full_body_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, duration_seconds, rest_seconds, order_index) 
            VALUES (full_body_id, current_exercise_id, 3, 30, 45, 3);
        END IF;
    END IF;

    -- HIIT Cardio Blast workout exercises
    IF hiit_cardio_id IS NOT NULL THEN
        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'Burpees';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = hiit_cardio_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, duration_seconds, rest_seconds, order_index) 
            VALUES (hiit_cardio_id, current_exercise_id, 4, 30, 30, 1);
        END IF;

        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'Jumping Jacks';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = hiit_cardio_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, duration_seconds, rest_seconds, order_index) 
            VALUES (hiit_cardio_id, current_exercise_id, 4, 45, 15, 2);
        END IF;

        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'High Knees';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = hiit_cardio_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, duration_seconds, rest_seconds, order_index) 
            VALUES (hiit_cardio_id, current_exercise_id, 4, 30, 30, 3);
        END IF;
    END IF;

    -- Upper Body Strength workout exercises
    IF upper_body_id IS NOT NULL THEN
        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'Bench Press';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = upper_body_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, reps, rest_seconds, order_index) 
            VALUES (upper_body_id, current_exercise_id, 4, 8, 90, 1);
        END IF;

        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'Pull-ups';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = upper_body_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, reps, rest_seconds, order_index) 
            VALUES (upper_body_id, current_exercise_id, 3, 6, 90, 2);
        END IF;

        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'Overhead Press';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = upper_body_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, reps, rest_seconds, order_index) 
            VALUES (upper_body_id, current_exercise_id, 3, 10, 75, 3);
        END IF;
    END IF;

    -- Flexibility Flow workout exercises
    IF flexibility_id IS NOT NULL THEN
        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'Downward Dog';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = flexibility_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, duration_seconds, rest_seconds, order_index) 
            VALUES (flexibility_id, current_exercise_id, 2, 60, 30, 1);
        END IF;

        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'Cat-Cow Stretch';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = flexibility_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, reps, rest_seconds, order_index) 
            VALUES (flexibility_id, current_exercise_id, 2, 10, 30, 2);
        END IF;

        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'Pigeon Pose';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = flexibility_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, duration_seconds, rest_seconds, order_index) 
            VALUES (flexibility_id, current_exercise_id, 2, 45, 30, 3);
        END IF;
    END IF;

    -- Lower Body Power workout exercises
    IF lower_body_id IS NOT NULL THEN
        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'Deadlifts';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = lower_body_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, reps, rest_seconds, order_index) 
            VALUES (lower_body_id, current_exercise_id, 4, 6, 120, 1);
        END IF;

        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'Squats';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = lower_body_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, reps, rest_seconds, order_index) 
            VALUES (lower_body_id, current_exercise_id, 4, 12, 90, 2);
        END IF;

        SELECT id INTO current_exercise_id FROM exercises WHERE name = 'Burpees';
        IF current_exercise_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM workout_exercises we WHERE we.workout_id = lower_body_id AND we.exercise_id = current_exercise_id) THEN
            INSERT INTO workout_exercises (workout_id, exercise_id, sets, reps, rest_seconds, order_index) 
            VALUES (lower_body_id, current_exercise_id, 3, 8, 60, 3);
        END IF;
    END IF;

END $$;

-- Add some helpful comments
COMMENT ON TABLE exercises IS 'Library of exercises with instructions and metadata';
COMMENT ON TABLE workouts IS 'Workout templates and user-created workouts';
COMMENT ON TABLE workout_exercises IS 'Junction table linking exercises to workouts with specific parameters';
COMMENT ON TABLE workout_logs IS 'Historical record of completed workout sessions';
COMMENT ON TABLE exercise_logs IS 'Detailed logs of individual exercise performance within workouts';
COMMENT ON TABLE progress_logs IS 'User progress tracking including measurements and photos';

-- Show summary of inserted data
SELECT 
    'Sample data setup completed!' as message,
    (SELECT COUNT(*) FROM exercises) as total_exercises,
    (SELECT COUNT(*) FROM workouts WHERE is_template = true) as total_workout_templates,
    (SELECT COUNT(*) FROM workout_exercises) as total_workout_exercise_links;
