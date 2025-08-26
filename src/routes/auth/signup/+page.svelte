<script lang="ts">
	import { goto } from '$app/navigation';
	import { authService, authError, loading, isAuthenticated } from '$lib/stores/auth';
	
	let email = '';
	let password = '';
	let confirmPassword = '';
	let fullName = '';
	let showPassword = false;
	let showConfirmPassword = false;
	let signupSuccess = false;

	$: passwordsMatch = password === confirmPassword;
	$: canSubmit = email && password && confirmPassword && fullName && passwordsMatch && password.length >= 6;

	async function handleSignup() {
		if (!canSubmit) return;

		const result = await authService.signUp(email, password, { full_name: fullName });
		
		if (result.success) {
			// Show success message
			signupSuccess = true;
		}
	}

	// Redirect if already logged in
	$: if ($isAuthenticated) {
		goto('/dashboard');
	}
</script>

<svelte:head>
	<title>Sign Up - trAInor</title>
	<meta name="description" content="Create your trAInor account and start your fitness journey" />
</svelte:head>

<div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
	<div class="max-w-md w-full space-y-8">
		<div class="text-center">
			<h1 class="text-3xl font-bold text-gray-900 mb-2">
				Join <span class="text-primary-600">tr<span class="text-secondary-600">AI</span>nor</span>
			</h1>
			<p class="text-gray-600">Start your free calisthenics journey today</p>
		</div>

		<div class="card">
			{#if signupSuccess}
				<div class="bg-green-50 border border-green-200 rounded-lg p-4 mb-6">
					<div class="flex">
						<div class="flex-shrink-0">
							<svg class="h-5 w-5 text-green-400" fill="currentColor" viewBox="0 0 20 20">
								<path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
							</svg>
						</div>
						<div class="ml-3">
							<h3 class="text-sm font-medium text-green-800">
								Account created successfully!
							</h3>
							<div class="mt-2 text-sm text-green-700">
								<p>
									We've sent a confirmation email to <strong>{email}</strong>. 
									Please check your inbox and click the confirmation link to activate your account.
								</p>
							</div>
							<div class="mt-4">
								<div class="flex space-x-2">
									<button
										type="button"
										on:click={() => goto('/auth/login')}
										class="bg-green-100 px-2 py-1.5 rounded-md text-sm font-medium text-green-800 hover:bg-green-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
									>
										Go to Login
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			{:else}
				<form on:submit|preventDefault={handleSignup} class="space-y-6">
				<div>
					<label for="fullName" class="block text-sm font-medium text-gray-700 mb-1">
						Full Name
					</label>
					<input
						id="fullName"
						type="text"
						bind:value={fullName}
						required
						class="input w-full"
						placeholder="Enter your full name"
						disabled={$loading}
					/>
				</div>

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
							minlength="6"
							class="input w-full pr-10"
							placeholder="Create a password (min 6 characters)"
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
					{#if password && password.length < 6}
						<p class="text-xs text-red-600 mt-1">Password must be at least 6 characters</p>
					{/if}
				</div>

				<div>
					<label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-1">
						Confirm Password
					</label>
					<div class="relative">
						<input
							id="confirmPassword"
							type={showConfirmPassword ? 'text' : 'password'}
							bind:value={confirmPassword}
							required
							class="input w-full pr-10"
							placeholder="Confirm your password"
							disabled={$loading}
						/>
						<button
							type="button"
							class="absolute inset-y-0 right-0 pr-3 flex items-center"
							on:click={() => showConfirmPassword = !showConfirmPassword}
						>
							{#if showConfirmPassword}
								👁️
							{:else}
								🙈
							{/if}
						</button>
					</div>
					{#if confirmPassword && !passwordsMatch}
						<p class="text-xs text-red-600 mt-1">Passwords do not match</p>
					{/if}
				</div>

				{#if $authError}
					<div class="bg-red-50 border border-red-200 rounded-lg p-3 text-red-700 text-sm">
						{$authError.message}
					</div>
				{/if}

				<button
					type="submit"
					class="btn-primary w-full"
					disabled={$loading || !canSubmit}
				>
					{#if $loading}
						<span class="inline-flex items-center">
							<svg class="animate-spin -ml-1 mr-3 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
								<circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
								<path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
							</svg>
							Creating account...
						</span>
					{:else}
						Create Account
					{/if}
				</button>
			</form>

			<div class="mt-6 text-center">
				<p class="text-sm text-gray-600">
					Already have an account?
					<a href="/auth/login" class="text-primary-600 hover:text-primary-500 font-medium">
						Sign in here
					</a>
				</p>
			</div>
			{/if}

			<div class="mt-6 text-xs text-gray-500 text-center">
				By creating an account, you agree to our
				<a href="/terms" class="text-primary-600 hover:text-primary-500">Terms of Service</a>
				and
				<a href="/privacy" class="text-primary-600 hover:text-primary-500">Privacy Policy</a>
			</div>
		</div>
	</div>
</div>
