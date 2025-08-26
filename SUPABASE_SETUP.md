# Supabase Backend Setup Guide

This guide will help you set up the Supabase backend for your trAInor fitness app.

## Prerequisites

- A Supabase account (free tier available)
- Your trAInor development environment running

## Step 1: Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up/sign in
2. Click "New Project"
3. Choose your organization
4. Enter project details:
   - **Name**: `trAInor` (or your preferred name)
   - **Database Password**: Create a strong password and save it
   - **Region**: Choose the region closest to your users
5. Click "Create new project"
6. Wait for the project to be created (this takes a few minutes)

## Step 2: Get Your Project Credentials

1. In your Supabase dashboard, go to **Settings** > **API**
2. You'll need these values:
   - **Project URL** (under "Project URL")
   - **Anon Public Key** (under "Project API keys" > "anon public")
   - **Service Role Key** (under "Project API keys" > "service_role") - Keep this secret!

## Step 3: Configure Environment Variables

1. In your trAInor project root, copy the example environment file:
   ```bash
   copy .env.local.example .env.local
   ```

2. Open `.env.local` and update with your Supabase credentials:
   ```env
   # Your actual Supabase project URL
   PUBLIC_SUPABASE_URL=https://your-project-ref.supabase.co
   
   # Your actual Supabase anon key
   PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   
   # Your actual Supabase service role key (for admin operations)
   SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

## Step 4: Set Up the Database Schema

1. In your Supabase dashboard, go to **SQL Editor**
2. Copy the contents of `database/schema.sql` from your project
3. Paste it into the SQL Editor and click **Run**
4. This will create:
   - All necessary tables (profiles, exercises, workouts, etc.)
   - Row Level Security (RLS) policies
   - Indexes for performance
   - Functions and triggers

## Step 5: Add Sample Data (Optional)

1. In the SQL Editor, copy the contents of `database/seed.sql`
2. Paste and run to add sample exercises and workout templates
3. This gives you a starter library of bodyweight exercises

## Step 6: Configure Authentication

1. Go to **Authentication** > **Settings** in your Supabase dashboard
2. Configure email settings:
   - **Enable email confirmations** (recommended for production)
   - **Enable secure email change** (recommended)
3. Optionally configure OAuth providers (Google, GitHub, etc.)

## Step 7: Test the Connection

1. Restart your development server:
   ```bash
   npm run dev
   ```
2. Open your app at `http://localhost:5173`
3. You should see a green checkmark next to "Supabase Backend" status
4. Try creating an account to test authentication

## Security Best Practices

1. **Row Level Security**: Already enabled in the schema for all user data
2. **Environment Variables**: Never commit `.env.local` to version control
3. **Service Role Key**: Only use on the server-side, never in client code
4. **Database Roles**: Consider creating custom roles for different access levels in production

## Database Structure Overview

Your trAInor database includes:

- **profiles**: User profile information and fitness preferences
- **exercises**: Library of bodyweight exercises and calisthenics movements
- **workouts**: Workout templates and custom routines
- **workout_exercises**: Junction table linking exercises to workouts
- **workout_logs**: Records of completed workout sessions
- **exercise_logs**: Detailed performance data for individual exercises
- **progress_logs**: User progress tracking (weight, measurements, photos)

## Troubleshooting

### Connection Issues
- Verify your environment variables are correct
- Check that `.env.local` is in your project root
- Restart your development server after adding environment variables

### Database Errors
- Ensure you've run the schema.sql file completely
- Check the Supabase logs in the dashboard for detailed error messages
- Verify RLS policies are correctly applied

### Authentication Issues
- Check email confirmation settings
- Verify the redirect URLs match your development environment
- Test with a real email address for signup confirmation

## Next Steps

Once your backend is set up:

1. **User Management**: Test user registration and login
2. **Exercise Library**: Browse the pre-loaded bodyweight exercises
3. **Workout Creation**: Create custom workout routines
4. **Progress Tracking**: Log workouts and track progress
5. **PWA Features**: Test offline functionality

## Production Deployment

When deploying to production:

1. Update environment variables for your production environment
2. Consider using Supabase's connection pooling for better performance
3. Set up proper backup strategies
4. Configure monitoring and alerts
5. Review and tighten security policies as needed

## Support

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Community](https://github.com/supabase/supabase/discussions)
- [trAInor GitHub Issues](https://github.com/your-username/trAInor-app/issues)
