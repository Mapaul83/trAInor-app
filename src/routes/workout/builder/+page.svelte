<script lang="ts">
	import { goto } from '$app/navigation';
	import { onMount } from 'svelte';
	import { isAuthenticated } from '$lib/stores/auth';
	import { workoutService, type Workout } from '$lib/workoutService';
	import type { Database } from '$lib/supabaseTypes';

	type Exercise = Database['public']['Tables']['exercises']['Row'];
	type WorkoutExercise = {
		exercise: Exercise;
		duration: number;
		order: number;
	};

	// Redirect if not authenticated
	$: if (!$isAuthenticated) {
		goto('/auth/login');
	}

	// State
	let exercises: Exercise[] = [];
	let filteredExercises: Exercise[] = [];
	let selectedExercises: WorkoutExercise[] = [];
	let workoutName = '';
	let workoutDescription = '';
	let loading = false;
	let saving = false;
	let showSaveDialog = false;

	// Filters
	let searchTerm = '';
	let selectedMuscleGroup = '';
	let selectedDifficulty = '';
	let selectedEquipment = '';

	// Filter options (these will come from your database enum types)
	const muscleGroups = ['chest', 'back', 'shoulders', 'arms', 'core', 'legs', 'full_body'];
	const difficulties = ['beginner', 'intermediate', 'advanced'];
	const equipmentTypes = ['none', 'pull_up_bar', 'resistance_band', 'parallettes'];

	// Load exercises on mount
	onMount(async () => {
		await loadExercises();
	});

	async function loadExercises() {
		loading = true;
		const result = await workoutService.getExercises();
		if (result.success && result.data) {
			exercises = result.data;
			filteredExercises = result.data;
		}
		loading = false;
	}

	// Apply filters
	$: {
		if (exercises.length > 0) {
			applyFilters();
		}
	}

	function applyFilters() {
		filteredExercises = exercises.filter(exercise => {
			const matchesSearch = !searchTerm || 
				exercise.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
				(exercise.description && exercise.description.toLowerCase().includes(searchTerm.toLowerCase()));
			
			const matchesMuscleGroup = !selectedMuscleGroup || exercise.muscle_group === selectedMuscleGroup;
			const matchesDifficulty = !selectedDifficulty || exercise.difficulty === selectedDifficulty;
			const matchesEquipment = !selectedEquipment || exercise.equipment === selectedEquipment;

			return matchesSearch && matchesMuscleGroup && matchesDifficulty && matchesEquipment;
		});
	}

	function addExercise(exercise: Exercise) {
		const newWorkoutExercise: WorkoutExercise = {
			exercise,
			duration: 30, // Default 30 seconds
			order: selectedExercises.length + 1
		};
		selectedExercises = [...selectedExercises, newWorkoutExercise];
	}

	function removeExercise(index: number) {
		selectedExercises = selectedExercises.filter((_, i) => i !== index);
		// Reorder exercises
		selectedExercises = selectedExercises.map((ex, i) => ({
			...ex,
			order: i + 1
		}));
	}

	function updateDuration(index: number, durationInput: string) {
		const duration = workoutService.parseTimeInput(durationInput) || 30;
		selectedExercises[index].duration = duration;
		selectedExercises = [...selectedExercises]; // Trigger reactivity
	}

	function moveExercise(index: number, direction: 'up' | 'down') {
		if (
			(direction === 'up' && index === 0) ||
			(direction === 'down' && index === selectedExercises.length - 1)
		) {
			return;
		}

		const newIndex = direction === 'up' ? index - 1 : index + 1;
		const exercises = [...selectedExercises];
		[exercises[index], exercises[newIndex]] = [exercises[newIndex], exercises[index]];
		
		// Update order numbers
		exercises[index].order = index + 1;
		exercises[newIndex].order = newIndex + 1;
		
		selectedExercises = exercises;
	}

	function clearWorkout() {
		selectedExercises = [];
		workoutName = '';
		workoutDescription = '';
	}

	function openSaveDialog() {
		if (selectedExercises.length === 0) {
			alert('Please add at least one exercise to your workout.');
			return;
		}
		showSaveDialog = true;
	}

	async function saveWorkout() {
		if (!workoutName.trim()) {
			alert('Please enter a workout name.');
			return;
		}

		saving = true;
		const workout: Omit<Workout, 'id' | 'created_at' | 'user_id'> = {
			name: workoutName.trim(),
			description: workoutDescription.trim() || undefined,
			exercises: selectedExercises,
			total_duration: workoutService.calculateTotalDuration(selectedExercises)
		};

		const result = await workoutService.saveWorkout(workout);
		
		if (result.success) {
			alert('Workout saved successfully!');
			showSaveDialog = false;
			// Optionally redirect to workout execution or dashboard
			goto('/workout/execute/' + result.data?.id);
		} else {
			alert('Failed to save workout. Please try again.');
		}
		
		saving = false;
	}

	function startWorkout() {
		if (selectedExercises.length === 0) {
			alert('Please add at least one exercise to start a workout.');
			return;
		}
		
		// For now, we'll create a temporary workout and start it
		const tempWorkout: Workout = {
			id: 'temp-' + Date.now(),
			name: 'Quick Workout',
			exercises: selectedExercises,
			total_duration: workoutService.calculateTotalDuration(selectedExercises)
		};
		
		// Store temporarily and redirect to execution
		sessionStorage.setItem('currentWorkout', JSON.stringify(tempWorkout));
		goto('/workout/execute');
	}

	$: totalDuration = workoutService.calculateTotalDuration(selectedExercises);
</script>

<svelte:head>
	<title>Workout Builder - trAInor</title>
	<meta name="description" content="Create your custom calisthenics workout" />
</svelte:head>

<div class="min-h-screen bg-gray-50">
	<!-- Header -->
	<header class="bg-white shadow-sm border-b border-gray-200">
		<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
			<div class="flex justify-between items-center h-16">
				<div class="flex items-center space-x-4">
					<button
						on:click={() => goto('/dashboard')}
						class="text-gray-600 hover:text-gray-900"
					>
						← Back to Dashboard
					</button>
					<h1 class="text-xl font-semibold text-gray-900">Workout Builder</h1>
				</div>
				<div class="flex items-center space-x-3">
					{#if selectedExercises.length > 0}
						<span class="text-sm text-gray-600">
							{selectedExercises.length} exercises • {workoutService.formatDuration(totalDuration)}
						</span>
					{/if}
				</div>
			</div>
		</div>
	</header>

	<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
		<div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
			<!-- Exercise Library -->
			<div class="bg-white rounded-lg shadow-sm border border-gray-200">
				<div class="p-6 border-b border-gray-200">
					<h2 class="text-lg font-medium text-gray-900 mb-4">Exercise Library</h2>
					
					<!-- Filters -->
					<div class="space-y-4">
						<div>
							<input
								type="text"
								placeholder="Search exercises..."
								bind:value={searchTerm}
								class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
							/>
						</div>
						
						<div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
							<select bind:value={selectedMuscleGroup} class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
								<option value="">All Muscle Groups</option>
								{#each muscleGroups as group}
									<option value={group}>{group.replace('_', ' ')}</option>
								{/each}
							</select>
							
							<select bind:value={selectedDifficulty} class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
								<option value="">All Difficulties</option>
								{#each difficulties as difficulty}
									<option value={difficulty}>{difficulty}</option>
								{/each}
							</select>
							
							<select bind:value={selectedEquipment} class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
								<option value="">All Equipment</option>
								{#each equipmentTypes as equipment}
									<option value={equipment}>{equipment.replace('_', ' ')}</option>
								{/each}
							</select>
						</div>
					</div>
				</div>

				<!-- Exercise List -->
				<div class="p-6">
					{#if loading}
						<div class="text-center py-8">
							<div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
							<p class="text-gray-600 mt-2">Loading exercises...</p>
						</div>
					{:else if filteredExercises.length === 0}
						<div class="text-center py-8">
							<p class="text-gray-600">No exercises found matching your criteria.</p>
						</div>
					{:else}
						<div class="space-y-3 max-h-96 overflow-y-auto">
							{#each filteredExercises as exercise}
								<div class="border border-gray-200 rounded-lg p-4 hover:border-blue-300 transition-colors">
									<div class="flex justify-between items-start">
										<div class="flex-1">
											<h3 class="font-medium text-gray-900">{exercise.name}</h3>
											{#if exercise.description}
												<p class="text-sm text-gray-600 mt-1">{exercise.description}</p>
											{/if}
											<div class="flex items-center space-x-4 mt-2 text-xs text-gray-500">
												<span class="bg-gray-100 px-2 py-1 rounded">{exercise.muscle_group?.replace('_', ' ')}</span>
												<span class="bg-blue-100 text-blue-800 px-2 py-1 rounded">{exercise.difficulty}</span>
												<span class="bg-green-100 text-green-800 px-2 py-1 rounded">{exercise.equipment?.replace('_', ' ')}</span>
											</div>
										</div>
										<button
											on:click={() => addExercise(exercise)}
											class="ml-4 bg-blue-600 text-white px-3 py-1 rounded text-sm hover:bg-blue-700 transition-colors"
											disabled={selectedExercises.some(se => se.exercise.id === exercise.id)}
										>
											{selectedExercises.some(se => se.exercise.id === exercise.id) ? 'Added' : 'Add'}
										</button>
									</div>
								</div>
							{/each}
						</div>
					{/if}
				</div>
			</div>

			<!-- Workout Builder -->
			<div class="bg-white rounded-lg shadow-sm border border-gray-200">
				<div class="p-6 border-b border-gray-200">
					<div class="flex justify-between items-center">
						<h2 class="text-lg font-medium text-gray-900">Your Workout</h2>
						<div class="space-x-2">
							{#if selectedExercises.length > 0}
								<button
									on:click={clearWorkout}
									class="px-3 py-1 text-sm text-gray-600 hover:text-gray-900"
								>
									Clear All
								</button>
								<button
									on:click={openSaveDialog}
									class="px-4 py-2 bg-green-600 text-white rounded text-sm hover:bg-green-700"
								>
									Save Workout
								</button>
								<button
									on:click={startWorkout}
									class="px-4 py-2 bg-blue-600 text-white rounded text-sm hover:bg-blue-700"
								>
									Start Now
								</button>
							{/if}
						</div>
					</div>
				</div>

				<div class="p-6">
					{#if selectedExercises.length === 0}
						<div class="text-center py-12">
							<div class="text-gray-400 mb-4">
								<svg class="mx-auto h-12 w-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
								</svg>
							</div>
							<p class="text-gray-600">Add exercises from the library to build your workout</p>
						</div>
					{:else}
						<div class="space-y-3">
							{#each selectedExercises as workoutExercise, index}
								<div class="border border-gray-200 rounded-lg p-4">
									<div class="flex items-center space-x-4">
										<div class="flex flex-col space-y-1">
											<button
												on:click={() => moveExercise(index, 'up')}
												disabled={index === 0}
												class="text-gray-400 hover:text-gray-600 disabled:opacity-30"
											>
												↑
											</button>
											<button
												on:click={() => moveExercise(index, 'down')}
												disabled={index === selectedExercises.length - 1}
												class="text-gray-400 hover:text-gray-600 disabled:opacity-30"
											>
												↓
											</button>
										</div>
										
										<div class="flex-1">
											<h3 class="font-medium text-gray-900">{workoutExercise.exercise.name}</h3>
											<div class="flex items-center space-x-4 mt-2">
												<div class="flex items-center space-x-2">
													<label class="text-sm text-gray-600">Duration:</label>
													<input
														type="text"
														value={workoutService.formatDuration(workoutExercise.duration)}
														on:blur={(e) => updateDuration(index, e.target.value)}
														class="w-20 px-2 py-1 text-sm border border-gray-300 rounded focus:outline-none focus:ring-1 focus:ring-blue-500"
														placeholder="30s"
													/>
												</div>
											</div>
										</div>
										
										<button
											on:click={() => removeExercise(index)}
											class="text-red-600 hover:text-red-800 p-1"
										>
											<svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
												<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
											</svg>
										</button>
									</div>
								</div>
							{/each}
							
							<div class="mt-6 p-4 bg-gray-50 rounded-lg">
								<div class="flex justify-between items-center text-sm">
									<span class="font-medium text-gray-900">Total Duration:</span>
									<span class="text-blue-600 font-medium">{workoutService.formatDuration(totalDuration)}</span>
								</div>
							</div>
						</div>
					{/if}
				</div>
			</div>
		</div>
	</div>
</div>

<!-- Save Workout Dialog -->
{#if showSaveDialog}
	<div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
		<div class="bg-white rounded-lg max-w-md w-full p-6">
			<h3 class="text-lg font-medium text-gray-900 mb-4">Save Workout</h3>
			
			<div class="space-y-4">
				<div>
					<label for="workout-name" class="block text-sm font-medium text-gray-700 mb-1">
						Workout Name *
					</label>
					<input
						id="workout-name"
						type="text"
						bind:value={workoutName}
						placeholder="e.g., Morning Strength Circuit"
						class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
					/>
				</div>
				
				<div>
					<label for="workout-description" class="block text-sm font-medium text-gray-700 mb-1">
						Description (optional)
					</label>
					<textarea
						id="workout-description"
						bind:value={workoutDescription}
						placeholder="Brief description of your workout..."
						rows="3"
						class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
					></textarea>
				</div>
			</div>
			
			<div class="mt-6 flex justify-end space-x-3">
				<button
					on:click={() => showSaveDialog = false}
					class="px-4 py-2 text-gray-700 border border-gray-300 rounded-md hover:bg-gray-50"
					disabled={saving}
				>
					Cancel
				</button>
				<button
					on:click={saveWorkout}
					class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50"
					disabled={saving || !workoutName.trim()}
				>
					{saving ? 'Saving...' : 'Save Workout'}
				</button>
			</div>
		</div>
	</div>
{/if}
