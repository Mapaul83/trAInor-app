<script lang="ts">
	import { goto } from '$app/navigation';
	import { onMount } from 'svelte';
	import { isAuthenticated } from '$lib/stores/auth';
	import { workoutService, type Workout } from '$lib/workoutService';

	// Redirect if not authenticated
	$: if (!$isAuthenticated) {
		goto('/auth/login');
	}

	let workout: Workout | null = null;
	let currentExerciseIndex = 0;
	let timeRemaining = 0;
	let isRunning = false;
	let isPaused = false;
	let isCompleted = false;
	let intervalId: number;

	onMount(() => {
		// Load workout from session storage (for temp workouts) or URL params
		const tempWorkout = sessionStorage.getItem('currentWorkout');
		if (tempWorkout) {
			workout = JSON.parse(tempWorkout);
			if (workout && workout.exercises.length > 0) {
				timeRemaining = workout.exercises[0].duration;
			}
		} else {
			// TODO: Load saved workout by ID from URL params
			goto('/workout/builder');
		}
	});

	function startTimer() {
		if (!workout) return;
		
		isRunning = true;
		isPaused = false;
		
		intervalId = setInterval(() => {
			if (timeRemaining > 0) {
				timeRemaining--;
			} else {
				// Move to next exercise or complete workout
				nextExercise();
			}
		}, 1000);
	}

	function pauseTimer() {
		isPaused = true;
		isRunning = false;
		if (intervalId) {
			clearInterval(intervalId);
		}
	}

	function resumeTimer() {
		startTimer();
	}

	function nextExercise() {
		if (!workout) return;
		
		if (intervalId) {
			clearInterval(intervalId);
		}
		
		if (currentExerciseIndex < workout.exercises.length - 1) {
			currentExerciseIndex++;
			timeRemaining = workout.exercises[currentExerciseIndex].duration;
			isRunning = false;
			isPaused = false;
		} else {
			// Workout completed
			completeWorkout();
		}
	}

	function previousExercise() {
		if (!workout) return;
		
		if (intervalId) {
			clearInterval(intervalId);
		}
		
		if (currentExerciseIndex > 0) {
			currentExerciseIndex--;
			timeRemaining = workout.exercises[currentExerciseIndex].duration;
			isRunning = false;
			isPaused = false;
		}
	}

	function skipExercise() {
		nextExercise();
	}

	function restartExercise() {
		if (!workout) return;
		
		if (intervalId) {
			clearInterval(intervalId);
		}
		
		timeRemaining = workout.exercises[currentExerciseIndex].duration;
		isRunning = false;
		isPaused = false;
	}

	function completeWorkout() {
		if (intervalId) {
			clearInterval(intervalId);
		}
		
		isCompleted = true;
		isRunning = false;
		isPaused = false;
		
		// TODO: Save workout completion to database
		console.log('Workout completed!');
	}

	function exitWorkout() {
		if (intervalId) {
			clearInterval(intervalId);
		}
		sessionStorage.removeItem('currentWorkout');
		goto('/dashboard');
	}

	function formatTime(seconds: number): string {
		const mins = Math.floor(seconds / 60);
		const secs = seconds % 60;
		return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
	}

	$: currentExercise = workout?.exercises[currentExerciseIndex];
	$: progress = workout ? ((currentExerciseIndex + 1) / workout.exercises.length) * 100 : 0;
</script>

<svelte:head>
	<title>Workout in Progress - trAInor</title>
	<meta name="description" content="Execute your workout routine" />
</svelte:head>

<div class="min-h-screen bg-gray-50">
	{#if workout && !isCompleted}
		<!-- Header with progress -->
		<header class="bg-white shadow-sm border-b border-gray-200">
			<div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
				<div class="flex justify-between items-center h-16">
					<div class="flex items-center space-x-4">
						<button
							on:click={exitWorkout}
							class="text-gray-600 hover:text-gray-900"
						>
							← Exit Workout
						</button>
						<h1 class="text-xl font-semibold text-gray-900">{workout.name}</h1>
					</div>
					<div class="text-sm text-gray-600">
						Exercise {currentExerciseIndex + 1} of {workout.exercises.length}
					</div>
				</div>
				<!-- Progress bar -->
				<div class="pb-4">
					<div class="w-full bg-gray-200 rounded-full h-2">
						<div 
							class="bg-blue-600 h-2 rounded-full transition-all duration-300" 
							style="width: {progress}%"
						></div>
					</div>
				</div>
			</div>
		</header>

		<div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
			{#if currentExercise}
				<!-- Current Exercise -->
				<div class="bg-white rounded-lg shadow-sm border border-gray-200 p-8 text-center">
					<h2 class="text-3xl font-bold text-gray-900 mb-4">{currentExercise.exercise.name}</h2>
					
					{#if currentExercise.exercise.description}
						<p class="text-gray-600 mb-8 max-w-2xl mx-auto">{currentExercise.exercise.description}</p>
					{/if}

					<!-- Timer -->
					<div class="mb-8">
						<div class="text-6xl font-mono font-bold text-blue-600 mb-2">
							{formatTime(timeRemaining)}
						</div>
						<div class="text-sm text-gray-500">
							Target: {workoutService.formatDuration(currentExercise.duration)}
						</div>
					</div>

					<!-- Exercise metadata -->
					<div class="flex justify-center items-center space-x-6 mb-8 text-sm">
						<span class="bg-gray-100 px-3 py-1 rounded-full">
							{currentExercise.exercise.muscle_group?.replace('_', ' ')}
						</span>
						<span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full">
							{currentExercise.exercise.difficulty}
						</span>
						<span class="bg-green-100 text-green-800 px-3 py-1 rounded-full">
							{currentExercise.exercise.equipment?.replace('_', ' ')}
						</span>
					</div>

					<!-- Controls -->
					<div class="flex justify-center items-center space-x-4">
						<button
							on:click={previousExercise}
							disabled={currentExerciseIndex === 0}
							class="px-4 py-2 text-gray-700 border border-gray-300 rounded-md hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
						>
							← Previous
						</button>

						{#if !isRunning && !isPaused}
							<button
								on:click={startTimer}
								class="px-8 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700 font-medium"
							>
								Start Exercise
							</button>
						{:else if isRunning}
							<button
								on:click={pauseTimer}
								class="px-8 py-3 bg-orange-600 text-white rounded-md hover:bg-orange-700 font-medium"
							>
								Pause
							</button>
						{:else if isPaused}
							<button
								on:click={resumeTimer}
								class="px-8 py-3 bg-green-600 text-white rounded-md hover:bg-green-700 font-medium"
							>
								Resume
							</button>
						{/if}

						<button
							on:click={nextExercise}
							disabled={currentExerciseIndex === workout.exercises.length - 1}
							class="px-4 py-2 text-gray-700 border border-gray-300 rounded-md hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
						>
							Next →
						</button>
					</div>

					<div class="flex justify-center items-center space-x-4 mt-4">
						<button
							on:click={restartExercise}
							class="px-3 py-1 text-sm text-gray-600 hover:text-gray-900"
						>
							Restart Exercise
						</button>
						<button
							on:click={skipExercise}
							class="px-3 py-1 text-sm text-gray-600 hover:text-gray-900"
						>
							Skip Exercise
						</button>
					</div>
				</div>

				<!-- Upcoming exercises -->
				{#if currentExerciseIndex < workout.exercises.length - 1}
					<div class="mt-8 bg-white rounded-lg shadow-sm border border-gray-200 p-6">
						<h3 class="text-lg font-medium text-gray-900 mb-4">Coming Up</h3>
						<div class="space-y-2">
							{#each workout.exercises.slice(currentExerciseIndex + 1, currentExerciseIndex + 4) as upcomingExercise, index}
								<div class="flex justify-between items-center py-2">
									<span class="text-gray-700">{upcomingExercise.exercise.name}</span>
									<span class="text-sm text-gray-500">{workoutService.formatDuration(upcomingExercise.duration)}</span>
								</div>
							{/each}
							{#if workout.exercises.length - currentExerciseIndex > 4}
								<div class="text-sm text-gray-500 italic">
									+ {workout.exercises.length - currentExerciseIndex - 4} more exercises
								</div>
							{/if}
						</div>
					</div>
				{/if}
			{/if}
		</div>

	{:else if isCompleted}
		<!-- Workout Complete -->
		<div class="min-h-screen flex items-center justify-center">
			<div class="bg-white rounded-lg shadow-lg border border-gray-200 p-8 text-center max-w-md w-full mx-4">
				<div class="mb-6">
					<div class="mx-auto h-16 w-16 bg-green-100 rounded-full flex items-center justify-center mb-4">
						<svg class="h-8 w-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
						</svg>
					</div>
					<h2 class="text-2xl font-bold text-gray-900 mb-2">Workout Complete!</h2>
					<p class="text-gray-600">Great job finishing your workout session.</p>
				</div>

				{#if workout}
					<div class="bg-gray-50 rounded-lg p-4 mb-6">
						<div class="text-sm text-gray-600 space-y-1">
							<div class="flex justify-between">
								<span>Workout:</span>
								<span class="font-medium">{workout.name}</span>
							</div>
							<div class="flex justify-between">
								<span>Exercises:</span>
								<span class="font-medium">{workout.exercises.length}</span>
							</div>
							<div class="flex justify-between">
								<span>Total Duration:</span>
								<span class="font-medium">{workoutService.formatDuration(workout.total_duration)}</span>
							</div>
						</div>
					</div>
				{/if}

				<div class="space-y-3">
					<button
						on:click={() => goto('/dashboard')}
						class="w-full px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
					>
						Back to Dashboard
					</button>
					<button
						on:click={() => goto('/workout/builder')}
						class="w-full px-4 py-2 text-gray-700 border border-gray-300 rounded-md hover:bg-gray-50"
					>
						Create New Workout
					</button>
				</div>
			</div>
		</div>

	{:else}
		<!-- Loading or no workout -->
		<div class="min-h-screen flex items-center justify-center">
			<div class="text-center">
				<div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto mb-4"></div>
				<p class="text-gray-600">Loading workout...</p>
			</div>
		</div>
	{/if}
</div>
