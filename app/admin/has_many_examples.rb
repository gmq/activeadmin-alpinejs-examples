ActiveAdmin.register HasManyExample do
  permit_params :name, has_many_children_attributes: [:id, :name, :main, :_destroy]

  form do |f|
    f.inputs 'x-init': 'alpineFixes.hasMany.init',
             'x-data': CGI.escapeHTML("{
               ...#{f.resource.attributes.to_json},
               has_many_children: #{f.resource.has_many_children.to_json}
             }") do
      f.input :name
      f.has_many :has_many_children, allow_destroy: true do |co, i|
        # has_many index starts with 1
        co.input :name, input_html: {
          'x-model': "has_many_children[#{i - 1}].name"
        }

        # Uncheck all checkboxes except the one being clicked.
        co.input :main, as: :boolean, input_html: {
          'x-model': "has_many_children[#{i - 1}].main",
          'x-on:change': "(e) => {
            if (e.target.checked) {
              has_many_children = has_many_children.map((c, i) => ({
                ...c, main: (i === alpineFixes.hasMany.getAttributeIdx($el))
              }))
            } }"
        }
      end
      f.actions
    end
  end
end
