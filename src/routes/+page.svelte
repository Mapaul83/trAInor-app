<script lang="ts">
	import { onMount } from 'svelte';
	import { isAuthenticated, user, authError } from '$lib/stores/auth';
	import { supabase } from '$lib/supabase';
	
	let supabaseStatus = 'checking';
	let supabaseDetails = '';

	onMount(async () => {
		// Check Supabase connection
		try {
			console.log('Testing Supabase connection...');
			
			// First test basic connection
			const { data, error } = await supabase.auth.getSession();
			console.log('Auth session test:', { data, error });
			
			if (error && error.message.includes('Invalid API key')) {
				supabaseStatus = 'config-needed';
				supabaseDetails = 'Invalid API credentials';
				return;
			}

			// Test database access with a simple query
			console.log('Testing database access...');
			const { data: testData, error: dbError } = await supabase.from('exercises').select('count').limit(1);
			console.log('Database test result:', { testData, dbError });
			
			if (dbError) {
				if (dbError.message.includes('relation "exercises" does not exist')) {
					supabaseStatus = 'schema-needed';
					supabaseDetails = 'Database schema not created yet';
				} else if (dbError.message.includes('environment variables')) {
					supabaseStatus = 'config-needed';
					supabaseDetails = 'Environment variables not configured';
				} else {
					supabaseStatus = 'error';
					supabaseDetails = `Database error: ${dbError.message}`;
				}
			} else {
				// Check if we have sample data
				const { data: exerciseCount, error: countError } = await supabase
					.from('exercises')
					.select('*', { count: 'exact', head: true });
				
				console.log('Exercise count check:', { exerciseCount, countError });
				
				if (countError) {
					supabaseStatus = 'error';
					supabaseDetails = `Count error: ${countError.message}`;
				} else {
					supabaseStatus = 'connected';
					supabaseDetails = `Database ready with ${exerciseCount?.length || 0} exercises`;
				}
			}
		} catch (err) {
			console.error('Supabase connection error:', err);
			supabaseStatus = 'config-needed';
			supabaseDetails = 'Please configure your .env.local file';
		}
	});

	function getStatusIcon(status: string) {
		switch (status) {
			case 'connected': return '✅';
			case 'config-needed': return '⚙️';
			case 'schema-needed': return '🗄️';
			case 'error': return '❌';
			default: return '⏳';
		}
	}

	function getStatusColor(status: string) {
		switch (status) {
			case 'connected': return 'text-green-600';
			case 'config-needed': return 'text-yellow-600';
			case 'schema-needed': return 'text-blue-600';
			case 'error': return 'text-red-600';
			default: return 'text-gray-600';
		}
	}
</script>

<div class="container mx-auto px-4 py-8">
	<div class="text-center">
		<h1 class="text-4xl font-bold text-gray-900 mb-4">
			Welcome to <span class="text-primary-600">tr<span class="text-secondary-600">AI</span>nor</span>
		</h1>
		<p class="text-xl text-gray-600 mb-8">
			Your free, offline-first calisthenics and bodyweight training companion
		</p>
		
		<div class="card max-w-md mx-auto mb-6">
			<h2 class="text-2xl font-semibold mb-4">🚀 Development Environment Status</h2>
			<div class="space-y-3">
				<div class="flex items-center justify-between text-sm">
					<span>SvelteKit + TypeScript</span>
					<span class="text-green-600">✅</span>
				</div>
				<div class="flex items-center justify-between text-sm">
					<span>TailwindCSS Styling</span>
					<span class="text-green-600">✅</span>
				</div>
				<div class="flex items-center justify-between text-sm">
					<span>PWA Support</span>
					<span class="text-green-600">✅</span>
				</div>
				<div class="flex items-center justify-between text-sm">
					<span>LocalForage Storage</span>
					<span class="text-green-600">✅</span>
				</div>
				<div class="flex items-center justify-between text-sm">
					<span>Supabase Backend</span>
					<span class={getStatusColor(supabaseStatus)}>{getStatusIcon(supabaseStatus)}</span>
				</div>
				{#if supabaseStatus !== 'checking'}
					<div class="text-xs {getStatusColor(supabaseStatus)} mt-1">
						{supabaseDetails}
					</div>
				{/if}
			</div>
		</div>

		{#if supabaseStatus === 'config-needed'}
			<div class="card max-w-2xl mx-auto mb-6 bg-yellow-50 border-yellow-200">
				<h3 class="text-lg font-semibold text-yellow-800 mb-2">⚙️ Supabase Setup Required</h3>
				<div class="text-left text-sm text-yellow-700 space-y-2">
					<p class="mb-3">To complete the backend setup:</p>
					<ol class="list-decimal list-inside space-y-1 ml-4">
						<li>Create a new project at <a href="https://supabase.com" target="_blank" class="underline">supabase.com</a></li>
						<li>Copy <code class="bg-yellow-100 px-1 rounded">.env.local.example</code> to <code class="bg-yellow-100 px-1 rounded">.env.local</code></li>
						<li>Add your Supabase URL and anon key to <code class="bg-yellow-100 px-1 rounded">.env.local</code></li>
						<li>Run the database schema in the SQL editor: <code class="bg-yellow-100 px-1 rounded">database/schema.sql</code></li>
						<li>Optionally add sample data: <code class="bg-yellow-100 px-1 rounded">database/seed.sql</code></li>
						<li>Refresh this page to verify connection</li>
					</ol>
				</div>
			</div>
		{:else if supabaseStatus === 'schema-needed'}
			<div class="card max-w-2xl mx-auto mb-6 bg-blue-50 border-blue-200">
				<h3 class="text-lg font-semibold text-blue-800 mb-2">🗄️ Database Schema Setup Required</h3>
				<div class="text-left text-sm text-blue-700 space-y-2">
					<p class="mb-3">Your Supabase connection is working! Now set up the database:</p>
					<ol class="list-decimal list-inside space-y-1 ml-4">
						<li>Go to your <a href="https://supabase.com/dashboard" target="_blank" class="underline">Supabase project dashboard</a></li>
						<li>Navigate to <strong>SQL Editor</strong> in the sidebar</li>
						<li>Create a new query and copy the contents from <code class="bg-blue-100 px-1 rounded">database/schema.sql</code></li>
						<li>Run the query to create all tables and security policies</li>
						<li>Optionally, create another query with <code class="bg-blue-100 px-1 rounded">database/sample-data.sql</code> for sample exercises</li>
						<li>Refresh this page to verify the database setup</li>
					</ol>
				</div>
			</div>
		{:else if supabaseStatus === 'connected'}
			<div class="card max-w-md mx-auto mb-6 bg-green-50 border-green-200">
				<h3 class="text-lg font-semibold text-green-800 mb-2">🎉 Backend Connected!</h3>
				<p class="text-sm text-green-700">
					Your Supabase backend is ready. You can now start building workout features!
				</p>
			</div>
		{/if}

		{#if $isAuthenticated}
			<div class="card max-w-md mx-auto bg-blue-50 border-blue-200">
				<h3 class="text-lg font-semibold text-blue-800 mb-2">👋 Welcome back!</h3>
				<p class="text-sm text-blue-700 mb-3">
					Logged in as: {$user?.email}
				</p>
				<button class="btn-primary w-full" on:click={() => window.location.href = '/dashboard'}>
					Go to Dashboard
				</button>
			</div>
		{:else}
			<div class="card max-w-md mx-auto">
				<h2 class="text-xl font-semibold mb-4">Get Started</h2>
				<div class="space-y-3">
					<button class="btn-primary w-full" on:click={() => window.location.href = '/auth/signup'}>
						Create Account
					</button>
					<button class="btn-secondary w-full" on:click={() => window.location.href = '/auth/login'}>
						Sign In
					</button>
					<button class="btn-outline w-full" on:click={() => window.location.href = '/workouts'}>
						Browse Workouts
					</button>
				</div>
			</div>
		{/if}

		{#if $authError}
			<div class="mt-4 p-3 bg-red-50 border border-red-200 rounded-lg text-red-700 text-sm">
				Error: {$authError.message}
			</div>
		{/if}
	</div>
</div>
