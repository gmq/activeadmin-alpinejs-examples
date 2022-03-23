ActiveAdmin.register ValidateFieldExample do
  permit_params :rut

  form do |f|
    f.inputs 'x-data': CGI.escapeHTML("{...#{f.resource.attributes.to_json}}") do
      f.input :rut, input_html: {
        'x-model': 'rut',
        'x-on:input': 'rut = formatters.rutFormat(rut)',
        'x-bind:class': '{error: !validators.rut(rut)}'
      }

      f.actions do
        f.action :submit, button_html: { 'x-bind:disabled': "!validators.rut(rut)" }
      end
    end
  end
end
