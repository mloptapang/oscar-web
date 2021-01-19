module FamiliesHelper
  def family_member_list(object)
    html_tags = []

    if params[:locale] == 'km'
      html_tags << "#{I18n.t('datagrid.columns.families.female_children_count')} : #{object.female_children_count.to_i}"
      html_tags << "#{I18n.t('datagrid.columns.families.male_children_count')} : #{object.male_children_count.to_i}"
      html_tags << "#{I18n.t('datagrid.columns.families.female_adult_count')} : #{object.female_adult_count.to_i}"
      html_tags << "#{I18n.t('datagrid.columns.families.male_adult_count')} : #{object.male_adult_count.to_i}"
    elsif params[:locale] == 'en'
      html_tags << "#{I18n.t('datagrid.columns.families.female')} #{'child'.pluralize(object.female_children_count.to_i)} : #{object.female_children_count.to_i}"
      html_tags << "#{I18n.t('datagrid.columns.families.male')} #{'child'.pluralize(object.male_children_count.to_i)} : #{object.male_children_count.to_i}"
      html_tags << "#{I18n.t('datagrid.columns.families.female')} #{'adult'.pluralize(object.female_adult_count.to_i)}  : #{object.female_adult_count.to_i}"
      html_tags << "#{I18n.t('datagrid.columns.families.male')} #{'adult'.pluralize(object.male_adult_count.to_i)} : #{object.male_adult_count.to_i}"
    end

    content_tag(:ul, class: 'family-members-list') do
      html_tags.each do |html_tag|
        concat content_tag(:li, html_tag)
      end
    end
  end

  def family_clients_list(object)
    content_tag(:ul, class: 'family-clients-list') do
      object.children.each do |child_id|
        client = Client.find_by(id: child_id)
        concat(content_tag(:li, link_to(entity_name(client), client_path(client)))) if client.present?
      end
    end
  end

  def family_workers_list(client_ids)
    content_tag(:ul, class: 'family-clients-list') do
      user_ids = Client.where(id: client_ids).joins(:case_worker_clients).map(&:user_ids).flatten.uniq
      User.where(id: user_ids).each do |user|
        concat(content_tag(:li, link_to(entity_name(user), user_path(user))))
      end
    end
  end

  def family_workers_count(client_ids)
    Client.where(id: client_ids).joins(:case_worker_clients).map(&:user_ids).flatten.uniq.size
  end

  def family_case_history(object)
    if object.case_history =~ /\A#{URI::regexp(['http', 'https'])}\z/
      link_to object.case_history, object.case_history, class: 'case-history', target: :_blank
    else
      object.case_history
    end
  end

  def additional_columns
    {
      date_of_custom_assessments: t('datagrid.columns.date_of_custom_assessments', assessment: t('families.show.assessment')),
      all_custom_csi_assessments: t('datagrid.columns.all_custom_csi_assessments', assessment: t('families.show.assessment')),
      assessment_completed_date: t('datagrid.columns.assessment_completed_date', assessment: t('families.show.assessment'))
    }
  end

  def columns_family_visibility(column)
    label_column = {
      name:                                     t('datagrid.columns.families.name'),
      id:                                       t('datagrid.columns.families.id'),
      code:                                     t('datagrid.columns.families.code'),
      family_type:                              t('datagrid.columns.families.family_type'),
      status:                                   t('datagrid.columns.families.status'),
      gender:                                   t('activerecord.attributes.family_member.gender'),
      date_of_birth:                            t('datagrid.columns.families.date_of_birth'),
      case_history:                             t('datagrid.columns.families.case_history'),
      address:                                  t('datagrid.columns.families.address'),
      significant_family_member_count:          t('datagrid.columns.families.significant_family_member_count'),
      male_children_count:                      t('datagrid.columns.families.male_children_count'),
      province_id:                              t('datagrid.columns.families.province'),
      district_id:                              t('datagrid.columns.families.district'),
      commune_id:                               t('datagrid.columns.families.commune'),
      village_id:                               t('datagrid.columns.families.village'),
      street:                                   t('datagrid.columns.families.street'),
      house:                                    t('datagrid.columns.families.house'),
      dependable_income:                        t('datagrid.columns.families.dependable_income'),
      male_adult_count:                         t('datagrid.columns.families.male_adult_count'),
      household_income:                         t('datagrid.columns.families.household_income'),
      contract_date:                            t('datagrid.columns.families.contract_date'),
      caregiver_information:                    t('datagrid.columns.families.caregiver_information'),
      changelog:                                t('datagrid.columns.families.changelog'),
      case_workers:                             t('datagrid.columns.families.case_workers'),
      manage:                                   t('datagrid.columns.families.manage'),
      **additional_columns
    }
    label_tag "#{column}_", label_column[column.to_sym]
  end

  def default_family_columns_visibility(column)
    label_column = {
      address_:                                  t('datagrid.columns.families.address'),
      province_id_:                              t('datagrid.columns.families.province'),
      district_id_:                              t('datagrid.columns.families.district'),
      commune_id_:                               t('datagrid.columns.families.commune'),
      village_id_:                               t('datagrid.columns.families.village'),
      street_:                                   t('datagrid.columns.families.street'),
      house_:                                    t('datagrid.columns.families.house'),
      caregiver_information_:                    t('datagrid.columns.families.caregiver_information'),
      case_history_:                             t('datagrid.columns.families.case_history'),
      clients_:                                  t('datagrid.columns.families.clients'),
      case_workers_:                             t('datagrid.columns.families.case_workers'),
      changelog_:                                t('datagrid.columns.families.changelogs'),
      code_:                                     t('datagrid.columns.families.code'),
      contract_date_:                            t('datagrid.columns.families.contract_date'),
      dependable_income_:                        t('datagrid.columns.families.dependable_income'),
      family_type_:                              t('datagrid.columns.families.family_type'),
      status_:                                   t('datagrid.columns.families.status'),
      gender_:                                   t('activerecord.attributes.family_member.gender'),
      date_of_birth_:                            t('datagrid.columns.families.date_of_birth'),
      female_adult_count_:                       t('datagrid.columns.families.female_adult_count'),
      female_children_count_:                    t('datagrid.columns.families.female_children_count'),
      household_income_:                         t('datagrid.columns.families.household_income'),
      id_:                                       t('datagrid.columns.families.id'),
      male_adult_count_:                         t('datagrid.columns.families.male_adult_count'),
      male_children_count_:                      t('datagrid.columns.families.male_children_count'),
      manage_:                                   t('datagrid.columns.families.manage'),
      member_count_:                             t('datagrid.columns.families.member_count'),
      name_:                                     t('datagrid.columns.families.name'),
      significant_family_member_count_:          t('datagrid.columns.families.significant_family_member_count'),
      **additional_columns
    }
    label_tag "#{column}_", label_column[column.to_sym]
  end

  def merged_address_family(object)
    current_address = []
    current_address << "#{I18n.t('datagrid.columns.families.house')} #{object.house}" if object.house.present?
    current_address << "#{I18n.t('datagrid.columns.families.street')} #{object.street}" if object.street.present?

    if I18n.locale.to_s == 'km'
      current_address << "#{I18n.t('datagrid.columns.families.village')} #{object.village.name_kh}" if object.village.present?
      current_address << "#{I18n.t('datagrid.columns.families.commune')} #{object.commune.name_kh}" if object.commune.present?
      current_address << object.district_name.split(' / ').first if object.district.present?
      current_address << object.province_name.split(' / ').first if object.province.present?
      current_address << 'កម្ពុជា' if Organization.current.short_name != 'brc'

    else
      current_address << "#{I18n.t('datagrid.columns.families.village')} #{object.village.name_en}" if object.village.present?
      current_address << "#{I18n.t('datagrid.columns.families.commune')} #{object.commune.name_en}" if object.commune.present?
      current_address << object.district_name.split(' / ').last if object.district.present?
      current_address << object.province_name.split(' / ').last if object.province.present?
      current_address << 'Cambodia' if Organization.current.short_name != 'brc'
    end

    current_address.join(', ')
  end

  def merged_address_community(object)
    current_address = []

    if I18n.locale.to_s == 'km'
      current_address << "#{I18n.t('datagrid.columns.families.village')} #{object.village.name_kh}" if object.village.present?
      current_address << "#{I18n.t('datagrid.columns.families.commune')} #{object.commune.name_kh}" if object.commune.present?
      current_address << object.district_name.split(' / ').first if object.district.present?
      current_address << object.province_name.split(' / ').first if object.province.present?
      current_address << 'កម្ពុជា' if Organization.current.short_name != 'brc'

    else
      current_address << "#{I18n.t('datagrid.columns.families.village')} #{object.village.name_en}" if object.village.present?
      current_address << "#{I18n.t('datagrid.columns.families.commune')} #{object.commune.name_en}" if object.commune.present?
      current_address << object.district_name.split(' / ').last if object.district.present?
      current_address << object.province_name.split(' / ').last if object.province.present?
      current_address << 'Cambodia' if Organization.current.short_name != 'brc'
    end

    current_address.join(', ')
  end

  def drop_down_relation
    if params[:locale] == 'km'
      FamilyMember::KM_RELATIONS
    elsif params[:locale] == 'my'
      FamilyMember::MY_RELATIONS
    else
      FamilyMember::EN_RELATIONS
    end
  end

  def family_type_translation(type)
    return if type.nil?
    type = type.downcase.gsub(/\(|\)/, '').gsub(/ \/ |-/, '_').gsub(' ', '_')
    I18n.t("default_family_fields.family_type_list.#{type}")
  end

  def selected_clients
    @family.id ? @clients.where("current_family_id = ?", @family.id).ids : @selected_children
  end

  def children_exist?
    @results && !@results.zero?
  end

  def name_km_en
    @family.name_en? ? "#{@family.name} - #{@family.name_en}" : "#{@family.name}"
  end

  def family_exit_circumstance_value
    @family.status == 'Accepted' ? 'Exited Family' : 'Rejected Referral'
  end

  def render_case_history_family(case_history, case_history_name)
    case case_history_name
    when 'enter_ngos'
      render 'family/enter_ngos/edit_form', family: @family, enter_ngo: case_history
    when 'exit_ngos'
      render 'family/exit_ngos/edit_form', family: @family, exit_ngo: case_history
    end
  end

  def family_case_history_links(case_history, case_history_name)
    case case_history_name
    when 'enrollments'
      link_to edit_family_enrollment_path(@family, case_history, program_stream_id: case_history.program_stream_id) do
        content_tag :div, class: 'btn btn-outline btn-success btn-xs' do
          fa_icon('pencil')
        end
      end
    when 'leave_programs'
      enrollment = @family.enrollments.find(case_history.enrollment_id)
      link_to edit_family_enrollment_leave_program_path(@family, enrollment, case_history) do
        content_tag :div, class: 'btn btn-outline btn-success btn-xs' do
          fa_icon('pencil')
        end
      end
    end
  end

  def family_translate_exit_reasons(reasons)
    reason_translations = I18n.backend.send(:translations)[:en][:family][:exit_ngos][:edit_form][:exit_reason_options]
    current_translations = I18n.t('family.exit_ngos.edit_form.exit_reason_options')
    reasons.map do |reason|
      current_translations[reason_translations.key(reason)]
    end.join(', ')
  end

  def family_order_case_worker(family)
    family.case_workers.distinct.sort
  end
  def name_km_en
    @family.name_en? ? "#{@family.name} - #{@family.name_en}" : "#{@family.name}"
  end

  def family_saved_search_column_visibility(field_key)
    default_setting(field_key, @default_columns) || params[field_key.to_sym].present? || (@visible_fields && @visible_fields[field_key]).present?
  end
end
