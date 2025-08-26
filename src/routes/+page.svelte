<script lang="ts">
	import { onMount } from 'svelte';
	import { isAuthenticated, user, authError } from '$lib/stores/auth';
	import { supabase } from '$lib/supabase';
	
	let supabaseStatus = 'checking';
	let supabaseDetails = '';

	onMount(async () => {
		// Check Supabase connection
		try {
			const { data, error } = await supabase.from('exercises').select('count').limit(1);
			if (error) {
				if (error.message.includes('environment variables')) {
					supabaseStatus = 'config-needed';
					supabaseDetails = 'Environment variables not configured';
				} else {
					supabaseStatus = 'error';
					supabaseDetails = error.message;
				}
			} else {
				supabaseStatus = 'connected';
				supabaseDetails = 'Database connection established';
			}
		} catch (err) {
			supabaseStatus = 'config-needed';
			supabaseDetails = 'Please configure your .env.local file';
		}
	});

	function getStatusIcon(status: string) {
		switch (status) {
			case 'connected': return '✅';
			case 'config-needed': return '⚙️';
			case 'error': return '❌';
			default: return '⏳';
		}
	}

	function getStatusColor(status: string) {
		switch (status) {
			case 'connected': return 'text-green-600';
			case 'config-needed': return 'text-yellow-600';
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