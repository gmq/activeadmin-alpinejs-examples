ActiveAdmin.register ComplexExample do
  permit_params :rut

  form do |f|
    f.inputs 'x-data': "complexExample(#{CGI.escapeHTML("{
        ...#{f.resource.attributes.to_json},
        active_admin_amount: '#{number_to_currency(f.resource.attributes['amount'])}'
      }")})" do
      f.input :name
      f.input :example_type,
              collection: ComplexExample.example_types,
              input_html: {
                'x-model': 'example_type'
              }
      f.input :description, wrapper_html: {
        'x-show': 'example_type === "with_description"'
      }

      f.input :rut, input_html: {
        'x-model': 'rut',
        'x-on:input': 'rut = rutFormat(rut)',
        'x-bind:class': '{error: !rutValidate(rut)}'
      }

      f.input :active_admin_amount, input_html: {
        'x-model': 'active_admin_amount',
        'x-on:input': '
          active_admin_amount = currencyFormat.format(numberCleaner($event.target.value));
          amount = numberCleaner(active_admin_amount);
        '
      }
      f.input :amount, as: :hidden, input_html: {
        'x-bind:value': 'amount'
      }

      f.actions do
        f.action :submit, button_html: { 'x-bind:disabled': "!rutValidate(rut)" }
      end
    end
  end
end
