import { precacheAndRoute, cleanupOutdatedCaches } from 'workbox-precaching';
import { clientsClaim, skipWaiting } from 'workbox-core';
import { registerRoute } from 'workbox-routing';
import { StaleWhileRevalidate, CacheFirst } from 'workbox-strategies';

declare let self: ServiceWorkerGlobalScope;

// Clean up outdated caches
cleanupOutdatedCaches();

// Take control of all pages under this SW's scope immediately,
// instead of waiting for reload/navigation.
clientsClaim();

// Skip waiting and immediately activate the new service worker
skipWaiting();

// Precache and route for the app shell
precacheAndRoute(self.__WB_MANIFEST);

// Cache API calls
registerRoute(
  ({ url }) => url.origin === 'https://your-supabase-url.supabase.co',
  new StaleWhileRevalidate({
    cacheName: 'api-cache',
  })
);

// Cache exercise animations and images
registerRoute(
  ({ request }) => request.destination === 'image' || request.url.includes('lottie'),
  new CacheFirst({
    cacheName: 'media-cache',
  })
);

// Handle offline fallback
self.addEventListener('fetch', (event) => {
  if (event.request.mode === 'navigate') {
    event.respondWith(
      fetch(event.request).catch(() => {
        return caches.match('/offline') || caches.match('/');
      })
    );
  }
});