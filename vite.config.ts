import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import { SvelteKitPWA } from '@vite-pwa/sveltekit';

export default defineConfig({
	plugins: [
		sveltekit(),
		SvelteKitPWA({
			strategies: 'injectManifest',
			srcDir: './src',
			filename: 'sw.ts',
			devOptions: {
				enabled: true,
				type: 'module'
			},
			kit: {
				adapterFallback: 'index.html'
			},
			manifest: {
				name: 'trAInor - Personal Training App',
				short_name: 'trAInor',
				description: 'Free calisthenics and bodyweight training app',
				theme_color: '#3b82f6',
				background_color: '#ffffff',
				display: 'standalone',
				scope: '/',
				start_url: '/',
				icons: [
					{
						src: '/icon-192.png',
						sizes: '192x192',
						type: 'image/png'
					},
					{
						src: '/icon-512.png',
						sizes: '512x512',
						type: 'image/png'
					}
				]
			}
		})
	]
});