import { rutFormat, rutValidate } from 'rut-helpers';
import { select2 } from 'active-admin-alpinejs-fixes';

export default (attributes = {}) => {
  function init() {
    // We need to pass the Alpine context (this) so it can find the element
    select2.init.bind(this)();
  }

  const currencyFormat = new Intl.NumberFormat('es-CL', { style: 'currency', currency: 'CLP' });

  function numberCleaner(value) {
    return value.replaceAll(/\D/g, '');
  }

  return { ...attributes, init, rutValidate, rutFormat, currencyFormat, numberCleaner };
};
