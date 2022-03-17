import { createApp } from 'vue';
import Alpine from 'alpinejs';

import App from './components/app.vue';
import './css/application.css';

window.Alpine = Alpine;
Alpine.start();

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp({
    components: { App },
  });
  app.mount('#vue-app');

  return app;
});
