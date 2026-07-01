const clearCacheStorage = () => {
  if (!("caches" in window)) {
    return Promise.resolve(false)
  }

  return window.caches.keys().then((cacheNames) => {
    return Promise.all(cacheNames.map((cacheName) => window.caches.delete(cacheName)))
  }).then((results) => results.some(Boolean))
}

const unregisterServiceWorkers = () => {
  if (!("serviceWorker" in navigator)) {
    return Promise.resolve(false)
  }

  return navigator.serviceWorker.getRegistrations().then((registrations) => {
    return Promise.all(registrations.map((registration) => registration.unregister()))
  }).then((results) => results.some(Boolean))
}

window.addEventListener("load", () => {
  Promise.all([unregisterServiceWorkers(), clearCacheStorage()]).catch((error) => {
    // eslint-disable-next-line no-console
    console.warn("Could not clear development service worker caches", error)
  })
})
