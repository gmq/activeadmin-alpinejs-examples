ActiveAdmin.register FormatFieldExample do
  permit_params :rut, :amount

  form do |f|
    f.inputs 'x-data': CGI.escapeHTML("{
        ...#{f.resource.attributes.to_json},
        active_admin_amount: '#{number_to_currency(f.resource.attributes['amount'])}'
      }") do
      f.input :rut, input_html: {
        'x-model': 'rut',
        'x-on:input': 'rut = formatters.rutFormat(rut)'
      }

      f.input :active_admin_amount, input_html: {
        'x-model': 'active_admin_amount',
        'x-on:input': '
          active_admin_amount = formatters.currency.format(formatters.numberCleaner($event.target.value));
          amount = formatters.numberCleaner(active_admin_amount);
        '
      }
      f.input :amount, as: :hidden, input_html: {
        'x-bind:value': 'amount'
      }
      f.actions
    end
  end
end
