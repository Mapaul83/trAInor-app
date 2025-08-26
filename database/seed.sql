-- Seed data for trAInor fitness app
-- Essential bodyweight and calisthenics exercises for the exercise library

-- Insert sample exercises focusing on bodyweight/calisthenics
INSERT INTO exercises (name, description, instructions, category, muscle_groups, difficulty_level, equipment_needed) VALUES

-- Bodyweight Upper Body Exercises
(
    'Push-ups',
    'Classic bodyweight exercise targeting chest, shoulders, and triceps',
    'Start in plank position with hands slightly wider than shoulder-width. Lower your body until chest nearly touches the floor, then push back up. Keep your body in a straight line throughout the movement.',
    'bodyweight',
    ARRAY['chest', 'shoulders', 'triceps', 'core'],
    'beginner',
    'none'
),

(
    'Diamond Push-ups',
    'Advanced push-up variation targeting triceps more intensely',
    'Form a diamond shape with your hands by touching thumbs and index fingers together. Perform push-ups with hands in this position, focusing on tricep engagement.',
    'bodyweight',
    ARRAY['triceps', 'chest', 'shoulders', 'core'],
    'intermediate',
    'none'
),

(
    'Pike Push-ups',
    'Shoulder-focused push-up variation that mimics overhead pressing',
    'Start in downward dog position. Lower your head toward the ground between your hands, then push back up. Focus on shoulder strength.',
    'bodyweight',
    ARRAY['shoulders', 'triceps', 'upper_back'],
    'intermediate',
    'none'
),

(
    'Pull-ups',
    'Essential upper body pulling exercise',
    'Hang from a pull-up bar with palms facing away. Pull your body up until your chin clears the bar, then lower with control.',
    'bodyweight',
    ARRAY['lats', 'biceps', 'rhomboids', 'rear_delts'],
    'intermediate',
    'pull-up bar'
),

(
    'Chin-ups',
    'Pull-up variation with bicep emphasis',
    'Similar to pull-ups but with palms facing toward you. This variation places more emphasis on the biceps.',
    'bodyweight',
    ARRAY['biceps', 'lats', 'rhomboids'],
    'intermediate',
    'pull-up bar'
),

-- Bodyweight Lower Body Exercises
(
    'Bodyweight Squats',
    'Fundamental lower body exercise',
    'Stand with feet shoulder-width apart. Lower your body by bending at hips and knees until thighs are parallel to floor. Return to starting position.',
    'bodyweight',
    ARRAY['quadriceps', 'glutes', 'hamstrings', 'calves'],
    'beginner',
    'none'
),

(
    'Jump Squats',
    'Explosive squat variation for power and cardio',
    'Perform a regular squat, then explosively jump up. Land softly and immediately go into the next squat.',
    'bodyweight',
    ARRAY['quadriceps', 'glutes', 'hamstrings', 'calves'],
    'intermediate',
    'none'
),

(
    'Lunges',
    'Unilateral leg exercise for balance and strength',
    'Step forward with one leg, lowering your hips until both knees are bent at 90 degrees. Return to starting position and repeat with other leg.',
    'bodyweight',
    ARRAY['quadriceps', 'glutes', 'hamstrings'],
    'beginner',
    'none'
),

(
    'Bulgarian Split Squats',
    'Advanced single-leg exercise',
    'Place rear foot on elevated surface behind you. Lower into a lunge position on front leg, then return to starting position.',
    'bodyweight',
    ARRAY['quadriceps', 'glutes', 'hamstrings'],
    'intermediate',
    'bench or chair'
),

(
    'Single-leg Calf Raises',
    'Calf strengthening exercise',
    'Stand on one foot, rise up onto the ball of your foot, then lower with control. Repeat on other leg.',
    'bodyweight',
    ARRAY['calves'],
    'beginner',
    'none'
),

-- Core Exercises
(
    'Plank',
    'Isometric core strengthening exercise',
    'Hold your body in a straight line from head to heels, supporting yourself on forearms and toes. Engage your core throughout.',
    'bodyweight',
    ARRAY['core', 'shoulders', 'glutes'],
    'beginner',
    'none'
),

(
    'Side Plank',
    'Lateral core strengthening exercise',
    'Lie on your side, prop yourself up on one forearm. Lift your hips to create a straight line from head to feet. Hold the position.',
    'bodyweight',
    ARRAY['obliques', 'core', 'shoulders'],
    'intermediate',
    'none'
),

(
    'Mountain Climbers',
    'Dynamic core and cardio exercise',
    'Start in plank position. Alternate bringing knees toward chest in a running motion while maintaining plank position.',
    'bodyweight',
    ARRAY['core', 'shoulders', 'hip_flexors'],
    'intermediate',
    'none'
),

(
    'Bicycle Crunches',
    'Dynamic core exercise targeting obliques',
    'Lie on back with hands behind head. Bring opposite elbow to knee in a cycling motion while extending the other leg.',
    'bodyweight',
    ARRAY['obliques', 'core', 'hip_flexors'],
    'beginner',
    'none'
),

(
    'Dead Bug',
    'Core stability exercise',
    'Lie on back with arms extended toward ceiling and knees bent at 90 degrees. Lower opposite arm and leg slowly, then return to starting position.',
    'bodyweight',
    ARRAY['core', 'hip_flexors'],
    'beginner',
    'none'
),

-- Full Body Exercises
(
    'Burpees',
    'Full-body high-intensity exercise',
    'Start standing, drop into squat position, jump back to plank, perform push-up, jump feet back to squat, then jump up with arms overhead.',
    'bodyweight',
    ARRAY['full_body', 'core', 'legs', 'chest', 'shoulders'],
    'advanced',
    'none'
),

(
    'Bear Crawl',
    'Primal movement pattern for full-body strength',
    'Start on hands and knees with knees hovering just above ground. Crawl forward by moving opposite hand and foot together.',
    'bodyweight',
    ARRAY['core', 'shoulders', 'quadriceps'],
    'intermediate',
    'none'
),

-- Flexibility/Mobility Exercises
(
    'Downward Dog',
    'Yoga pose for posterior chain flexibility',
    'Start on hands and knees, tuck toes and lift hips up and back. Create an inverted V-shape with your body.',
    'flexibility',
    ARRAY['hamstrings', 'calves', 'shoulders', 'back'],
    'beginner',
    'none'
),

(
    'Cat-Cow Stretch',
    'Spinal mobility exercise',
    'Start on hands and knees. Arch your back and look up (cow), then round your spine and tuck chin to chest (cat).',
    'flexibility',
    ARRAY['spine', 'core'],
    'beginner',
    'none'
),

(
    'Hip Circles',
    'Hip mobility exercise',
    'Stand with feet hip-width apart. Make large circles with your hips, first clockwise then counterclockwise.',
    'flexibility',
    ARRAY['hips', 'core'],
    'beginner',
    'none'
),

-- Cardio Exercises
(
    'Jumping Jacks',
    'Classic cardio exercise',
    'Jump while spreading feet apart and raising arms overhead, then return to starting position. Maintain steady rhythm.',
    'cardio',
    ARRAY['full_body', 'calves'],
    'beginner',
    'none'
),

(
    'High Knees',
    'Running in place with knee emphasis',
    'Run in place while bringing knees up toward chest as high as possible. Maintain quick pace.',
    'cardio',
    ARRAY['hip_flexors', 'calves', 'core'],
    'beginner',
    'none'
),

(
    'Butt Kickers',
    'Running in place with heel emphasis',
    'Run in place while kicking heels toward glutes. Focus on quick turnover.',
    'cardio',
    ARRAY['hamstrings', 'calves'],
    'beginner',
    'none'
);

-- Insert sample workout templates
INSERT INTO workouts (name, description, duration_minutes, difficulty_level, category, is_template, created_by) VALUES

('Beginner Full Body', 'A complete beginner-friendly workout targeting all major muscle groups', 30, 'beginner', 'full_body', true, null),
('Upper Body Strength', 'Focus on building upper body strength with bodyweight exercises', 25, 'intermediate', 'upper_body', true, null),
('Core Power', 'Intense core workout for building stability and strength', 20, 'intermediate', 'strength', true, null),
('Cardio Blast', 'High-intensity cardio session to get your heart pumping', 15, 'beginner', 'cardio', true, null),
('Advanced Calisthenics', 'Challenging bodyweight workout for experienced athletes', 45, 'advanced', 'strength', true, null),
('Morning Mobility', 'Gentle stretching and mobility routine to start your day', 15, 'beginner', 'flexibility', true, null);

-- Get workout IDs for adding exercises (this would be done manually or via application logic)
-- For demonstration, we'll show the structure for the Beginner Full Body workout

-- Note: In a real implementation, you would insert workout_exercises using the actual UUIDs
-- This is just to show the structure. The application would handle this dynamically.

/*
Example workout_exercises entries for "Beginner Full Body":
INSERT INTO workout_exercises (workout_id, exercise_id, sets, reps, rest_seconds, order_index) VALUES
('workout_uuid', 'bodyweight_squats_uuid', 3, 12, 60, 1),
('workout_uuid', 'push_ups_uuid', 3, 8, 60, 2),
('workout_uuid', 'plank_uuid', 3, 30, 45, 3), -- 30 seconds hold
('workout_uuid', 'lunges_uuid', 3, 10, 60, 4), -- 10 per leg
('workout_uuid', 'dead_bug_uuid', 2, 10, 45, 5); -- 10 per side
*/
