import '@activeadmin/activeadmin';
import '@fortawesome/fontawesome-free/css/all.css';
import 'arctic_admin';
import 'activeadmin_addons';
import { createApp } from 'vue';
import Alpine from 'alpinejs';
import { select2 } from 'active-admin-alpinejs-fixes';
import { rutFormat, rutValidate } from 'rut-helpers';

import './stylesheets/active_admin.scss';
import AdminComponent from './components/admin-component.vue';

window.formatters = {
  currency: new Intl.NumberFormat('es-CL', { style: 'currency', currency: 'CLP' }),
  numberCleaner(value) {
    return value.replaceAll(/\D/g, '');
  },
  rutFormat,
};

window.validators = {
  rut: rutValidate,
};

function onLoad() {
  /* Alpine Examples */
  window.Alpine = Alpine;
  window.alpineFixes = { select2 };
  Alpine.start();

  /* Default Potassium Vue stuff */
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

