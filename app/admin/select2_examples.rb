ActiveAdmin.register Select2Example do
  permit_params :name, :example_types, :description

  form do |f|
    f.inputs 'x-init': 'alpineFixes.select2.init',
             'x-data': CGI.escapeHTML("{...#{f.resource.attributes.to_json}}") do
      f.input :name
      f.input :example_type,
              collection: Select2Example.example_types,
              input_html: {
                'x-model': 'example_type'
              }
      f.input :description, wrapper_html: {
        'x-show': 'example_type === "with_description"'
      }
    end
  end
end
