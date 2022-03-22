ActiveAdmin.register ToggleFieldExample do
  permit_params :name, :has_description, :description

  form do |f|
    f.inputs 'x-data': CGI.escapeHTML("{...#{f.resource.attributes.to_json}}") do
      f.input :name
      f.input :has_description, input_html: {
        'x-model': 'has_description'
      }
      f.input :description, wrapper_html: {
        'x-show': 'has_description'
      }
    end
  end
end
