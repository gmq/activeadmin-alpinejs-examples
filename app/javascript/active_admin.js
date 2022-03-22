import '@activeadmin/activeadmin';
import '@fortawesome/fontawesome-free/css/all.css';
import 'arctic_admin';
import 'activeadmin_addons';
import { createApp } from 'vue';
import Alpine from 'alpinejs';
import './stylesheets/active_admin.scss';
import AdminComponent from './components/admin-component.vue';

function onLoad() {
  window.Alpine = Alpine;
  Alpine.start();
  if (document.getElementById('wrapper') !== null) {
    const app = createApp({
      mounted() {
        // We need to re-trigger DOMContentLoaded for ArcticAdmin after Vue replaces DOM elements
        window.document.dispatchEvent(new Event('DOMContentLoaded', {
          bubbles: true,
          cancelable: true,
        }));
      },
    });
    app.component('AdminComponent', AdminComponent);
    app.mount('#wrapper');
  }

  return null;
}

document.addEventListener('DOMContentLoaded', onLoad, { once: true });

