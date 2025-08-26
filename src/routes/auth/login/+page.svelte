<script lang="ts">
	import { goto } from '$app/navigation';
	import { authService, authError, loading, isAuthenticated } from '$lib/stores/auth';
	
	let email = '';
	let password = '';
	let showPassword = false;

	async function handleLogin() {
		if (!email || !password) {
			return;
		}

		const result = await authService.signIn(email, password);
		
		if (result.success) {
			goto('/dashboard');
		}
	}

	// Redirect if already logged in
	$: if ($isAuthenticated) {
		goto('/dashboard');
	}
</script>

<svelte:head>
	<title>Sign In - trAInor</title>
	<meta name="description" content="Sign in to your trAInor account" />
</svelte:head>

<div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
	<div class="max-w-md w-full space-y-8">
		<div class="text-center">
			<h1 class="text-3xl font-bold text-gray-900 mb-2">
				Welcome back to <span class="text-primary-600">tr<span class="text-secondary-600">AI</span>nor</span>
			</h1>
			<p class="text-gray-600">Sign in to continue your fitness journey</p>
		</div>

		<div class="card">
			<form on:submit|preventDefault={handleLogin} class="space-y-6">
				<div>
					<label for="email" class="block text-sm font-medium text-gray-700 mb-1">
						Email Address
					</label>
					<input
						id="email"
						type="email"
						bind:value={email}
						required
						class="input w-full"
						placeholder="Enter your email"
						disabled={$loading}
					/>
				</div>

				<div>
					<label for="password" class="block text-sm font-medium text-gray-700 mb-1">
						Password
					</label>
					<div class="relative">
						<input
							id="password"
							type={showPassword ? 'text' : 'password'}
							bind:value={password}
							required
							class="input w-full pr-10"
							placeholder="Enter your password"
							disabled={$loading}
						/>
						<button
							type="button"
							class="absolute inset-y-0 right-0 pr-3 flex items-center"
							on:click={() => showPassword = !showPassword}
						>
							{#if showPassword}
								👁️
							{:else}
								🙈
							{/if}
						</button>
					</div>
				</div>

				{#if $authError}
					<div class="bg-red-50 border border-red-200 rounded-lg p-3 text-red-700 text-sm">
						{$authError.message}
					</div>
				{/if}

				<button
					type="submit"
					class="btn-primary w-full"
					disabled={$loading || !email || !password}
				>
					{#if $loading}
						<span class="inline-flex items-center">
							<svg class="animate-spin -ml-1 mr-3 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
								<circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
								<path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
							</svg>
							Signing in...
						</span>
					{:else}
						Sign In
					{/if}
				</button>
			</form>

			<div class="mt-6 text-center">
				<p class="text-sm text-gray-600">
					Don't have an account?
					<a href="/auth/signup" class="text-primary-600 hover:text-primary-500 font-medium">
						Sign up here
					</a>
				</p>
				<p class="text-sm text-gray-600 mt-2">
					<a href="/auth/forgot-password" class="text-primary-600 hover:text-primary-500">
						Forgot your password?
					</a>
				</p>
			</div>
		</div>
	</div>
</div>
