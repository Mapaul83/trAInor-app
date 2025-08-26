<script lang="ts">
	import { goto } from '$app/navigation';
	import { authService, user, profile, isAuthenticated } from '$lib/stores/auth';
	
	// Redirect if not authenticated
	$: if (!$isAuthenticated) {
		goto('/auth/login');
	}

	async function handleSignOut() {
		const result = await authService.signOut();
		if (result.success) {
			goto('/');
		}
	}
</script>

<svelte:head>
	<title>Dashboard - trAInor</title>
	<meta name="description" content="Your personal training dashboard" />
</svelte:head>

{#if $isAuthenticated && $user}
	<div class="min-h-screen bg-gray-50">
		<!-- Header -->
		<header class="bg-white shadow-sm border-b border-gray-200">
			<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
				<div class="flex justify-between items-center h-16">
					<div class="flex items-center">
						<h1 class="text-xl font-semibold text-gray-900">
							<span class="text-primary-600">tr<span class="text-secondary-600">AI</span>nor</span>
							Dashboard
						</h1>
					</div>
					<div class="flex items-center space-x-4">
						<span class="text-sm text-gray-600">
							Welcome, {$profile?.full_name || $user.email}
						</span>
						<button
							on:click={handleSignOut}
							class="btn-outline text-sm"
						>
							Sign Out
						</button>
					</div>
				</div>
			</div>
		</header>

		<!-- Main Content -->
		<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
			<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
				
				<!-- Welcome Card -->
				<div class="lg:col-span-2">
					<div class="card">
						<h2 class="text-2xl font-bold text-gray-900 mb-4">
							Welcome to your fitness journey! 🎯
						</h2>
						<p class="text-gray-600 mb-6">
							You're successfully authenticated and ready to start training. Your Supabase backend is connected and your profile is set up.
						</p>
						
						<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
							<button 
								on:click={() => goto('/workout/builder')}
								class="btn-primary"
							>
								Start Workout
							</button>
							<button class="btn-secondary">
								Browse Exercises
							</button>
							<button class="btn-outline">
								View Progress
							</button>
							<button class="btn-outline">
								Edit Profile
							</button>
						</div>
					</div>
				</div>

				<!-- Profile Card -->
				<div class="space-y-6">
					<div class="card">
						<h3 class="text-lg font-semibold text-gray-900 mb-4">Profile</h3>
						<div class="space-y-3">
							<div>
								<label class="text-sm font-medium text-gray-700">Email</label>
								<p class="text-sm text-gray-900">{$user.email}</p>
							</div>
							{#if $profile?.full_name}
								<div>
									<label class="text-sm font-medium text-gray-700">Name</label>
									<p class="text-sm text-gray-900">{$profile.full_name}</p>
								</div>
							{/if}
							{#if $profile?.fitness_level}
								<div>
									<label class="text-sm font-medium text-gray-700">Fitness Level</label>
									<p class="text-sm text-gray-900 capitalize">{$profile.fitness_level}</p>
								</div>
							{/if}
							{#if $profile?.primary_goal}
								<div>
									<label class="text-sm font-medium text-gray-700">Primary Goal</label>
									<p class="text-sm text-gray-900 capitalize">{$profile.primary_goal}</p>
								</div>
							{/if}
						</div>
					</div>

					<!-- Quick Stats -->
					<div class="card">
						<h3 class="text-lg font-semibold text-gray-900 mb-4">Quick Stats</h3>
						<div class="space-y-3">
							<div class="flex justify-between">
								<span class="text-sm text-gray-600">Workouts this week</span>
								<span class="text-sm font-medium">0</span>
							</div>
							<div class="flex justify-between">
								<span class="text-sm text-gray-600">Total exercises</span>
								<span class="text-sm font-medium">25+</span>
							</div>
							<div class="flex justify-between">
								<span class="text-sm text-gray-600">Member since</span>
								<span class="text-sm font-medium">
									{new Date($user.created_at).toLocaleDateString()}
								</span>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- Coming Soon Features -->
			<div class="mt-8">
				<div class="card">
					<h3 class="text-lg font-semibold text-gray-900 mb-4">🚧 Coming Soon Features</h3>
					<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
						<div class="p-4 bg-gray-50 rounded-lg">
							<h4 class="font-medium text-gray-900 mb-2">Workout Library</h4>
							<p class="text-sm text-gray-600">Browse and customize workout routines</p>
						</div>
						<div class="p-4 bg-gray-50 rounded-lg">
							<h4 class="font-medium text-gray-900 mb-2">Progress Tracking</h4>
							<p class="text-sm text-gray-600">Log workouts and track improvements</p>
						</div>
						<div class="p-4 bg-gray-50 rounded-lg">
							<h4 class="font-medium text-gray-900 mb-2">Exercise Timer</h4>
							<p class="text-sm text-gray-600">Built-in timer for sets and rest periods</p>
						</div>
						<div class="p-4 bg-gray-50 rounded-lg">
							<h4 class="font-medium text-gray-900 mb-2">Offline Mode</h4>
							<p class="text-sm text-gray-600">Work out without internet connection</p>
						</div>
					</div>
				</div>
			</div>
		</main>
	</div>
{:else}
	<div class="min-h-screen flex items-center justify-center">
		<div class="animate-spin rounded-full h-12 w-12 border-b-2 border-emerald-600"></div>
	</div>
{/if}
