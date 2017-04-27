class ClientCustomFormSqlBuilder
  def self.generate(rules)
    @sql_string = []
    @values = []
    @custom_form_rules = rules[:rules]
    condition = rules[:condition]

    get_sql if @custom_form_rules.present?
    @sql_string = @sql_string.join(" #{condition} ")

    @sql_string = "(#{@sql_string})" if @sql_string.present?

    {id: @sql_string, values: @values}
  end

  private

  def self.get_sql
    sql_string = 'clients.id IN (?)'
    custom_field_properties = CustomFieldProperty.where(custom_formable_type: 'Client')

    @custom_form_rules.each do |rule|
      field = rule[:field]
      value = rule[:value]
      type  = rule[:input]

      case rule[:operator]
      when 'equal'
        properties_result = custom_field_properties.where("properties -> '#{field}' ? '#{value}' ")
      when 'not_equal'
        properties_result = custom_field_properties.where.not("properties -> '#{field}' ? '#{value}' ")
      when 'less'
        properties_result = custom_field_properties.where("properties ->> '#{field}' < '#{value}' ")
      when 'less_or_equal'
        properties_result = custom_field_properties.where("properties ->> '#{field}' <= '#{value}' ")
      when 'greater'
        properties_result = custom_field_properties.where("properties ->> '#{field}' > '#{value}' ")
      when 'greater_or_equal'
        properties_result = custom_field_properties.where("properties ->> '#{field}' >= '#{value}' ")
      when 'contains'
        properties_result = custom_field_properties.where("properties ->> '#{field}' ILIKE '%#{value}%' ")
      when 'not_contains'
        properties_result = custom_field_properties.where("properties ->> '#{field}' NOT ILIKE '%#{value}%' ")
      when 'is_empty'
        properties_result = custom_field_properties.where("properties -> '#{field}' ? '' ")
      when 'between'
        properties_result = custom_field_properties.where("properties ->> '#{field}' BETWEEN '#{value.first}', '#{value.last}' ")
      end
      @sql_string << sql_string
      @values     << properties_result.pluck(:custom_formable_id).uniq
    end
  end
end
