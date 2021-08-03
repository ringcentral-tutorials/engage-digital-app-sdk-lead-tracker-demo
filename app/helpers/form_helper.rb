module FormHelper
  AVAILABLE_FORM_ELEMENTS = %w(input checkbox select textarea).freeze
  INPUT_CSS_CLASSES = 'appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:z-10 sm:text-sm'.freeze
  LABEL_CSS_CLASSES = 'text-md font-medium text-gray-700'.freeze
  TEXT_AREA_CSS_CLASSES = 'w-full px-3 py-2 text-gray-700 border rounded-lg focus:outline-none border-gray-300'.freeze

  def render_form_elements_for(form, entity_name, lead)
    html = ''.html_safe
    entity_form_elements = Rails.application.config.form_configuration.dig(:entities, @entity_name, :config)

    return if entity_form_elements.blank?

    html << content_tag(:div, class: 'space-y-2 my-10') do
      concat(content_tag(:p, 'Pre-chat survey', class: 'text-lg font-bold text-gray-800'))
      concat(content_tag(:div, class: 'pl-6 space-y-4') do
        entity_form_elements&.each do |element|
          next unless respond_to?("render_custom_#{element[:type]}", true)
          next if element[:type] == 'select' && element[:options].blank?

          element[:field_name] = element[:name].parameterize.underscore
          concat(content_tag(:div, class: 'field') do
            send("render_custom_#{element[:type]}", form, element, lead)
          end)
        end
      end)
    end

    html
  end

  def input_classes
    INPUT_CSS_CLASSES
  end

  def label_classes
    LABEL_CSS_CLASSES
  end

  def text_area_classes
    TEXT_AREA_CSS_CLASSES
  end

  private

  def render_custom_label(form, element)
    concat(form.label "data[#{element[:field_name]}]", element[:name], class: label_classes)
  end

  def render_custom_input(form, element, lead)
    render_custom_label(form, element)
    concat(form.text_field "data[#{element[:field_name]}]", value: lead.data[element[:field_name]], class: input_classes)
  end

  def render_custom_checkbox(form, element, lead)
    value = lead.data[element[:field_name]]

    render_custom_label(form, element)
    concat(form.check_box "data[#{element[:field_name]}]", value: value, checked: value == '1', class: 'ml-2 form-checkbox rounded border-gray-300')
  end

  def render_custom_select(form, element, lead)
    choices = [''] + element[:options]

    render_custom_label(form, element)
    concat(form.select "data[#{element[:field_name]}]", options_for_select(choices, lead.data[element[:field_name]]), {}, class: 'form-select rounded-md border-gray-300 text-sm block')
  end

  def render_custom_textarea(form, element, lead)
    render_custom_label(form, element)
    concat(form.text_area "data[#{element[:field_name]}]", value: lead.data[element[:field_name]], class: text_area_classes)
  end
end
