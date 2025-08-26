<script lang="ts">
	import { onMount } from 'svelte';
	import { authService, isLoading, user } from '$lib/stores/auth';
	import favicon from '$lib/assets/favicon.svg';
	import '../app.css';

	let { children } = $props();

	// Initialize authentication on app load
	onMount(() => {
		authService.init();
	});
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
</svelte:head>

<main class="min-h-screen bg-gray-50">
	{#if $isLoading}
		<div class="flex items-center justify-center min-h-screen">
			<div class="animate-spin rounded-full h-12 w-12 border-b-2 border-emerald-600"></div>
		</div>
	{:else}
		{@render children?.()}
	{/if}
</main>