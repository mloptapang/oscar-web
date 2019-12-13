module AdvancedSearches
  class EntityCustomFormSqlBuilder
    include FormBuilderHelper
    include ClientsHelper

    def initialize(selected_custom_form, rule, entity_type)
      @selected_custom_form = selected_custom_form
      field          = rule['field']
      @field         = field.split('__').last.gsub("'", "''").gsub('&qoute;', '"').gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;')
      @operator      = rule['operator']
      @value         = format_value(rule['value'])
      @type          = rule['type']
      @input_type    = rule['input']
      @entity_type   = entity_type
    end

    def get_sql
      custom_formable_type = @entity_type.titleize
      sql_string = "#{@entity_type.pluralize}.id IN (?)"
      properties_field = 'custom_field_properties.properties'
      custom_field_properties = CustomFieldProperty.where(custom_formable_type: custom_formable_type, custom_field_id: @selected_custom_form)

      type_format = ['select', 'radio-group', 'checkbox-group']
      if type_format.include?(@input_type)
        @value = @value.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;')
      end

      basic_rules  = $param_rules.present? && $param_rules[:basic_rules] ? $param_rules[:basic_rules] : $param_rules
      basic_rules  = basic_rules.is_a?(Hash) ? basic_rules : JSON.parse(basic_rules).with_indifferent_access
      results      = mapping_form_builder_param_value(basic_rules, 'formbuilder')

      query_string  = get_query_string(results, 'formbuilder', properties_field)

      properties_result = custom_field_properties.where(query_string.reject(&:blank?).join(" AND "))

      client_ids = properties_result.pluck(:custom_formable_id).uniq
      { id: sql_string, values: client_ids }

    end

    private

    def format_value(value)
      value.is_a?(Array) || value.is_a?(Fixnum) ? value : value.gsub("'", "''")
    end
  end
end
