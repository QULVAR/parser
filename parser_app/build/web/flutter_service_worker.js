'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "e4651ce1504d801e04010bceab31c4e9",
"version.json": "62afd4a685613dc430b4563fec2b3c0b",
"index.html": "1607861dca27a2b9c6f28ea0bef7af8a",
"/": "1607861dca27a2b9c6f28ea0bef7af8a",
"main.dart.js": "0c078508541d837412b4c085bc00436b",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "04c0d99bd140e2b58ad974fd91cff1e4",
"assets/AssetManifest.json": "0b71c2f32e397919a5394af0ea9a2e8d",
"assets/NOTICES": "501e34b31316fe3fdaa2a13d4c53db3e",
"assets/FontManifest.json": "7ce933f90416d6763a0a1f60d3c59636",
"assets/AssetManifest.bin.json": "66bc88729cadabd6bdfbdb95731b8fa3",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "fe90abecc6e55f0e81a19410896e88a6",
"assets/fonts/MaterialIcons-Regular.otf": "8365a78a66ff96715000aca9d417bf4b",
"assets/assets/icons/check.png": "5ea11e11679eb2df816e9aa46d564f3e",
"assets/assets/icons/plus.png": "49297353a76ad48cf263a8c18ede33e5",
"assets/assets/icons/cart.png": "6f5aeed5aac654a511e1cacd057538e9",
"assets/assets/icons/pen.png": "51648bcb5d70ee2efd9772ab970874bd",
"assets/assets/icons/right_arrow.svg": "d94cfc50ab8fda778f78846abf4f4c21",
"assets/assets/icons/left_arrow.svg": "64a254b24f8fafd981693c35fea0ca96",
"assets/assets/icons/eye_with_line.svg": "a940404047409d6efe7fc36e508f914e",
"assets/assets/icons/minus.png": "4963cf7a676119a37c97be251822909a",
"assets/assets/icons/arrow_down.svg": "e99a1bc6ef922797c2397e9bd2d89f0d",
"assets/assets/icons/logo.png": "5c6855fd5f65c260bea58ccc123fd219",
"assets/assets/icons/profile.png": "ccb9824bfc27a29cccab6d8c01dfc0f0",
"assets/assets/icons/calendar_icon_green.svg": "e2faea1327f5050b16ca73118a5c9cdf",
"assets/assets/icons/bin.png": "eb45acfcb0cf25c67ec3037347344221",
"assets/assets/icons/exit.png": "ac44daee1b7c9ccb537a6d499b6e2e76",
"assets/assets/icons/calendar_icon.svg": "5d6dd21eaae56adbb225ffadc79d87e1",
"assets/assets/icons/eye.svg": "500a038ecce9b8a9fa8111f843c34750",
"assets/assets/icons/admin.png": "c6d2d87f1be2b0201da94bb8aaf61a94",
"assets/assets/fonts/Rubik-Light.ttf": "23061741bd91192fd8f0fcc2ef2c1d15",
"assets/assets/fonts/Rubik-Medium.ttf": "73e9a5833dcf4b0e27fcd431d660b38d",
"assets/assets/fonts/Rubik-SemiBold.ttf": "929ba7d813b074b8492645157e36bc75",
"assets/assets/fonts/Rubik-Regular.ttf": "e3dfaffb698c7742c8b0f2a10978e3f0",
"assets/assets/animations/switch.json": "243a7f4b028254112aec9864ed2b11fe",
"assets/assets/animations/checkmark%2520success.json": "6d2c2fc3920daa57a81f3df294546382",
"assets/assets/animations/checkbox.json": "0b656ceacb318f7776dbc73a214178d9",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
