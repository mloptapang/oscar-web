class ClientColumnsVisibility
  def initialize(grid, params)
    @grid   = grid
    @params = params
  end

  def columns_collection
    {
      live_with_: :live_with,
      exit_reasons_: :exit_reasons,
      exit_circumstance_: :exit_circumstance,
      other_info_of_exit_: :other_info_of_exit,
      exit_note_: :exit_note,
      presented_id_: :presented_id,
      id_number_: :id_number,
      whatsapp_: :whatsapp,
      other_phone_number_: :other_phone_number,
      v_score_: :v_score,
      brsc_branch_: :brsc_branch,
      current_island_: :current_island,
      current_street_: :current_street,
      current_po_box_: :current_po_box,
      current_city_: :current_city,
      current_settlement_: :current_settlement,
      current_resident_own_or_rent_: :current_resident_own_or_rent,
      current_household_type_: :current_household_type,
      island2_: :island2,
      street2_: :street2,
      po_box2_: :po_box2,
      city2_: :city2,
      settlement2_: :settlement2,
      resident_own_or_rent2_: :resident_own_or_rent2,
      household_type2_: :household_type2,
      what3words_: :what3words,
      # name_of_referee_: :name_of_referee,
      rated_for_id_poor_: :rated_for_id_poor,
      main_school_contact_: :main_school_contact,
      program_streams_: :program_streams,
      program_enrollment_date_: :program_enrollment_date,
      program_exit_date_: :program_exit_date,
      given_name_: :given_name,
      family_name_: :family_name,
      local_given_name_: :local_given_name,
      local_family_name_: :local_family_name,
      gender_: :gender,
      date_of_birth_: :date_of_birth,
      status_: :status,
      **Client::HOTLINE_FIELDS.map{ |field| ["#{field}_".to_sym, field.to_sym] }.to_h,
      birth_province_id_: :birth_province,
      initial_referral_date_: :initial_referral_date,
      # referral_phone_: :referral_phone,
      received_by_id_: :received_by,
      referral_source_id_: :referral_source,
      followed_up_by_id_: :followed_up_by,
      follow_up_date_: :follow_up_date,
      agencies_name_: :agency,
      donors_name_: :donor,
      province_id_: :province,
      current_address_: :current_address,
      house_number_: :house_number,
      street_number_: :street_number,
      district_: :district,
      subdistrict_: :subdistrict,
      state_: :state,
      township_: :township,
      suburb_: :suburb,
      description_house_landmark_: :description_house_landmark,
      directions_: :directions,
      street_line1_: :street_line1,
      street_line2_: :street_line2,
      postal_code_: :postal_code,
      plot_: :plot,
      road_: :road,
      school_name_: :school_name,
      school_grade_: :school_grade,
      has_been_in_orphanage_: :has_been_in_orphanage,
      has_been_in_government_care_: :has_been_in_government_care,
      relevant_referral_information_: :relevant_referral_information,
      user_ids_: :user,
      accepted_date_: :accepted_date,
      exit_date_: :exit_date,
      history_of_disability_and_or_illness_: :history_of_disability_and_or_illness,
      history_of_harm_: :history_of_harm,
      history_of_high_risk_behaviours_: :history_of_high_risk_behaviours,
      reason_for_family_separation_: :reason_for_family_separation,
      rejected_note_: :rejected_note,
      family_: :family,
      code_: :code,
      age_: :age,
      slug_: :slug,
      kid_id_: :kid_id,
      family_id_: :family_id,
      any_assessments_: :any_assessments,
      case_note_date_: :case_note_date,
      case_note_type_: :case_note_type,
      date_of_assessments_: :date_of_assessments,
      assessment_completed_date_: :assessment_completed_date,
      all_csi_assessments_: :all_csi_assessments,
      date_of_custom_assessments_: :date_of_custom_assessments,
      all_custom_csi_assessments_: :all_custom_csi_assessments,
      all_result_framework_assessments_: :all_result_framework_assessments,
      manage_: :manage,
      changelog_: :changelog,
      telephone_number_: :telephone_number,
      commune_: :commune,
      village_: :village,
      created_at_: :created_at,
      created_by_: :created_by,
      referred_to_: :referred_to,
      referred_from_: :referred_from,
      date_of_referral_: :date_of_referral,
      # time_in_care_: :time_in_care,
      time_in_ngo_: :time_in_ngo,
      time_in_cps_: :time_in_cps,
      referral_source_category_id_: :referral_source_category,
      type_of_service_: :type_of_service,
      referee_name_: :referee_name,
      referee_phone_: :referee_phone,
      referee_email_: :referee_email,
      **Call::FIELDS.map{ |field| ["#{field}_".to_sym, field.to_sym] }.to_h,
      call_count: :call_count,
      carer_name_: :carer_name,
      carer_phone_: :carer_phone,
      carer_email_: :carer_email,
      phone_owner_: :phone_owner,
      referee_relationship_to_client_: :referee_relationship_to_client,
      client_contact_phone_: :client_contact_phone,
      address_type_: :address_type,
      client_email_: :client_email
    }
  end

  def visible_columns
    @grid.column_names = []
    client_default_columns = Setting.first.try(:client_default_columns)
    params = @params.keys.select{ |k| k.match(/\_$/) }
    if params.present? && client_default_columns.present?
      defualt_columns = params - client_default_columns
    else
      if params.present?
        defualt_columns = params
      else
        defualt_columns = client_default_columns
      end
    end
    add_custom_builder_columns.each do |key, value|
      @grid.column_names << value if client_default(key, defualt_columns) || @params[key]
    end
  end

  private

  def domain_score_columns
    columns = columns_collection
    Domain.order_by_identity.each do |domain|
      identity = domain.identity
      field = domain.custom_domain ? "custom_#{domain.convert_identity}" : domain.convert_identity
      columns = columns.merge!("#{field}_": field.to_sym)
    end
    columns
  end

  def quantitative_type_columns
    columns = domain_score_columns
    QuantitativeType.joins(:quantitative_cases).uniq.each do |quantitative_type|
      field = quantitative_type.name
      columns = columns.merge!("#{field}_": field.to_sym)
    end
    columns
  end

  def add_custom_builder_columns
    columns = quantitative_type_columns
    if @params[:column_form_builder].present?
      @params[:column_form_builder].each do |column|
        field   = column['id']
        columns = columns.merge!("#{field}_": field.to_sym)
      end
    end
    columns
  end

  def client_default(column, setting_client_default_columns)
    return false if setting_client_default_columns.nil?
    setting_client_default_columns.include?(column.to_s) if @params.dig(:client_grid, :descending).present? || (@params[:client_advanced_search].present? && @params.dig(:client_grid, :descending).present?) || @params[:client_grid].nil? || @params[:client_advanced_search].nil?
  end
end
