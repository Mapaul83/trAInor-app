<script lang="ts">
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import { supabase } from '$lib/supabase';
	import { authService } from '$lib/stores/auth';

	let status: 'confirming' | 'success' | 'error' = 'confirming';
	let message = '';

	onMount(async () => {
		try {
			// Get the token hash from URL
			const hashParams = new URLSearchParams(window.location.hash.substring(1));
			const accessToken = hashParams.get('access_token');
			const refreshToken = hashParams.get('refresh_token');
			const type = hashParams.get('type');

			console.log('Confirmation page loaded with:', { type, hasAccessToken: !!accessToken });

			if (type === 'signup' && accessToken && refreshToken) {
				// Set the session using the tokens
				const { data, error } = await supabase.auth.setSession({
					access_token: accessToken,
					refresh_token: refreshToken
				});

				if (error) {
					console.error('Error setting session:', error);
					status = 'error';
					message = 'Failed to confirm email. Please try again.';
				} else {
					console.log('Email confirmed successfully:', data);
					status = 'success';
					message = 'Email confirmed! Redirecting to dashboard...';
					
					// Wait a moment then redirect to dashboard
					setTimeout(() => {
						goto('/dashboard');
					}, 2000);
				}
			} else {
				// Check if user is already authenticated
				const { data: { user } } = await supabase.auth.getUser();
				if (user) {
					console.log('User already authenticated, redirecting...');
					goto('/dashboard');
				} else {
					status = 'error';
					message = 'Invalid confirmation link. Please try signing up again.';
				}
			}
		} catch (error) {
			console.error('Confirmation error:', error);
			status = 'error';
			message = 'An error occurred during confirmation. Please try again.';
		}
	});
</script>

<svelte:head>
	<title>Confirm Email - trAInor</title>
</svelte:head>

<div class="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
	<div class="sm:mx-auto sm:w-full sm:max-w-md">
		<div class="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
			<div class="text-center">
				{#if status === 'confirming'}
					<div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
					<h2 class="text-2xl font-bold text-gray-900 mb-4">Confirming Email...</h2>
					<p class="text-gray-600">Please wait while we confirm your email address.</p>
				{:else if status === 'success'}
					<div class="rounded-full h-12 w-12 bg-green-100 mx-auto mb-4 flex items-center justify-center">
						<svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
						</svg>
					</div>
					<h2 class="text-2xl font-bold text-green-900 mb-4">Email Confirmed!</h2>
					<p class="text-green-600">{message}</p>
				{:else if status === 'error'}
					<div class="rounded-full h-12 w-12 bg-red-100 mx-auto mb-4 flex items-center justify-center">
						<svg class="h-6 w-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
						</svg>
					</div>
					<h2 class="text-2xl font-bold text-red-900 mb-4">Confirmation Failed</h2>
					<p class="text-red-600 mb-6">{message}</p>
					<div class="space-y-3">
						<button
							on:click={() => goto('/auth/signup')}
							class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
						>
							Try Signing Up Again
						</button>
						<button
							on:click={() => goto('/auth/login')}
							class="w-full flex justify-center py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
						>
							Go to Login
						</button>
					</div>
				{/if}
			</div>
		</div>
	</div>
</div>
