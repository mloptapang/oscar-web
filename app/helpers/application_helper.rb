module ApplicationHelper
  Thredded::ApplicationHelper

  def asset_data_base64(path)
    if Rails.configuration.assets.compile
      asset = Rails.application.assets.find_asset(path)
    else
      asset = Rails.application.assets_manifest.assets[path]
    end
    throw "Could not find asset '#{path}'" if asset.nil?
    base64 = Base64.encode64(asset.to_s).gsub(/\s/, "")
    content_type = asset.try(:content_type) || "application/x-font-ttf"
    "data:#{content_type};base64,#{Rack::Utils.escape(base64)}"
  end

  def asset_exist?(path)
    if Rails.configuration.assets.compile
      Rails.application.precompiled_assets.include? path
    else
      Rails.application.assets_manifest.assets[path].present?
    end
  end

  def flash_alert
    notice = params[:notice] || flash[:notice]
    alert = params[:alert] || flash[:alert]
    if notice
      { 'message-type': 'notice', 'message': notice }
    elsif alert
      { 'message-type': 'alert', 'message': alert }
    else
      {}
    end
  end

  def show_family_CRD?
    @show_family_CRD ||= QuantitativeType.where('visible_on LIKE ?', "%family%").any?
  end

  def notification_client_exit(day)
    if day == 90
      t('.client_is_end_ec_today', count: @notification.ec_notification(day).count)
    else
      t('.client_is_about_to_end_ec', count: @notification.ec_notification(day).count, day_count: 90 - day)
    end
  end

  def authorized_body
    'unauthorized-background' unless user_signed_in?
  end

  def status_style(status)
    case status
    when 'Active' then color = 'label-primary'
    when 'Referred', 'Exited' then color = 'label-danger'
    when 'Accepted' then color = 'label-info'
    end

    content_tag(:span, class: ['label', color]) do
      status
    end
  end

  def unorderred_list(values)
    content_tag(:ul) do
      values.each do |value|
        concat(content_tag(:li, value))
      end
    end
  end

  def human_boolean(boolean)
    return (boolean ? 'បាទ/ចាស' : 'ទេ') if params[:locale] == 'km' || I18n.locale == :km
    boolean ? 'Yes' : 'No'
  end

  def current_url(new_params)
    url_for params: params.merge(new_params)
  end

  def remove_link(object, associated_objects = {}, btn_size = 'btn-xs', custom_assessment_setting_id = nil, tab_name = nil)
    btn_status = associated_objects.values.sum.zero? ? nil : 'disabled'
    if object.class.name.downcase == 'domain'
      link_to(domain_path(object, custom_assessment_setting_id: custom_assessment_setting_id, tab: tab_name || params[:tab]), method: 'delete',  data: { confirm: t('are_you_sure') }, class: "btn btn-outline btn-danger #{btn_size} #{btn_status}") do
        fa_icon('trash')
      end
    else
      link_to(object, method: 'delete',  data: { confirm: t('are_you_sure') }, class: "btn btn-outline btn-danger #{btn_size} #{btn_status}") do
        fa_icon('trash')
      end
    end
  end

  def is_active_controller(controller_name, class_name = nil)
    if params[:controller] =~ /#{controller_name}/i
      class_name == nil ? "active" : class_name
    else
      nil
    end
  end

  def clients_menu_active
    names = %w(clients tasks assessments case_notes cases government_reports leave_programs client_enrollments client_enrollment_trackings client_advanced_searches client_enrolled_programs client_enrolled_program_trackings leave_enrolled_programs)
    if names.include?(controller_name) && params[:family_id].nil?
      'active'
    elsif controller_name == 'custom_field_properties' && params[:client_id].present?
      'active'
    end
  end

  def families_menu_active
    names = %w(families cases)
    if names.include?(controller_name) && params[:client_id].nil?
      'active'
    elsif controller_name == 'custom_field_properties' && params[:family_id].present?
      'active'
    end
  end

  def users_menu_active
    if controller_name == 'users'
      'active'
    elsif controller_name == 'custom_field_properties' && params[:user_id].present?
      'active'
    end
  end

  def exit_circumstance_value
    @client.status == 'Accepted' ? 'Exited Client' : 'Rejected Referral'
  end

  def partners_menu_active
    if controller_name == 'partners'
      'active'
    elsif controller_name == 'custom_field_properties' && params[:partner_id].present?
      'active'
    end
  end

  def account_menu_active
    if :devise_controller? && params[:id].blank?
      'active' if action_name == 'edit' || action_name == 'update'
      ''
    end
  end

  def any_active_menu(names)
    'active' if names.include? controller_name
  end

  def active_menu(name, alter_name = '')
    controller_name == name || controller_name == alter_name ? 'active' : nil
  end

  def settings_menu_active(name, action_names)
    action = ['index' ,'update' ,'create'].include?(action_name) ? 'index' : action_name
    'active' if (controller_name == name && action_names == action)
  end

  def hidden_class(tasks, assessment_domain=false)
    'hidden' if tasks.blank? && !assessment_domain
  end

  def exit_modal_class(bool)
    bool ? 'exitFromCif' : 'exitFromCase'
  end

  def dynamic_third_party_cols(user)
    if user.admin? || user.strategic_overviewer?
      'col-xs-12'
    elsif user.any_case_manager?
      'col-xs-12'
    elsif user.case_worker?
      'col-sm-4'
    end
  end

  def error_notification(f)
    content_tag(:div, t('review_problem'), class: 'alert alert-danger') if f.error_notification.present?
  end

  def able_related_info(value)
    'able-related-info' if %w(illness disability).any? { |w| value.include?(w) }
  end

  def clients_controller?
    controller_name == 'clients'
  end

  def date_format(date)
    date.strftime('%d %B %Y') if date.present?
  end

  def date_time_format(date_time)
    return if date_time.nil?

    date_time.in_time_zone('Bangkok').strftime('%d %B %Y %I:%M%p')
  end

  def ability_to_write(object)
    'disabled' if cannot? :write, object
  end

  def ability_to_update(object)
    'disabled' if cannot? :update, object
  end

  def ability_to_delete(object)
    'disabled' if cannot? :delete, object
  end

  def required?(bool)
    'required' if bool
  end

  def strategic_overviewer?
    current_user.strategic_overviewer?
  end

  def entity_name(entity)
    entity.name
  end

  def progarm_stream_action
    ['show', 'report']
  end

  def error_message(controller_name, field_message = '')
    if %(client_enrollments leave_programs client_enrollment_trackings).include?(controller_name)
      content_tag(:span, t('cannot_be_blank'), class: 'help-block hidden', data: { email: I18n.t('client_enrollments.form.not_an_email') })
    else
      content_tag(:span, field_message, class: 'help-block')
    end
  end

  def government_forms_visible?
    selected_country == 'cambodia'
  end

  def program_stream_readable?(value)
    return true if current_user.admin? || current_user.strategic_overviewer?
    current_user.program_stream_permissions.find_by(program_stream_id: value).readable
  end

  def program_permission_editable?(value)
    return true if current_user.admin?
    return false if current_user.strategic_overviewer?
    current_user.program_stream_permissions.find_by(program_stream_id: value).editable
  end

  def custom_field_editable?(value)
    return true if current_user.admin?
    return false if current_user.strategic_overviewer?
    current_user.custom_field_permissions.find_by(custom_field_id: value).editable
  end

  def custom_field_readable?(value)
    return true if current_user.admin?
    return false if current_user.strategic_overviewer?
    current_user.custom_field_permissions.find_by(custom_field_id: value).readable
  end

  def action_search?
    Rails.application.routes.recognize_path(request.referrer)[:action] == 'search'
  end

  def convert_bracket(value, properties = {})
    value1 = value.gsub(/\[/, '&#91;').gsub(/\]/, '&#93;')
    value2 = value.gsub('[', '&amp;#91;').gsub(']', '&amp;#93;')
    properties[value1] ? value1 : value2
  end

  def default_setting(column, setting_default_columns)
    key_columns = params.keys.select{ |k| k.match(/\_$/) }
    return false if setting_default_columns.nil? || (key_columns.present? && key_columns.exclude?(column))
    return false unless params.dig(:client_grid, :descending).present? || (params[:client_advanced_search].present? && params.dig(:client_grid, :descending).present?) || params[:client_grid].nil? || params[:client_advanced_search].nil?
    return false unless params.dig(:family_grid, :descending).present? || (params[:family_advanced_search].present? && params.dig(:family_grid, :descending).present?) || params[:family_grid].nil? || params[:family_advanced_search].nil?
    return false unless params.dig(:partner_grid, :descending).present? || (params[:partner_advanced_search].present? && params.dig(:partner_grid, :descending).present?) || params[:partner_grid].nil? || params[:partner_advanced_search].nil?
    return false unless params.dig(:community_grid, :descending).present? || (params[:community_advanced_search].present? && params.dig(:community_grid, :descending).present?) || params[:community_grid].nil? || params[:community_advanced_search].nil?
    setting_default_columns.include?(column.to_s)
  end

  def tasks_notification_label
    if @notification.any_overdue_tasks? && @notification.any_due_today_tasks?
      "#{I18n.t('layouts.notification.overdue_tasks_count', count: @notification.overdue_tasks_count, tasks: t('tasks.task'))} #{I18n.t('layouts.notification.overdue_and_due_today_count', count: @notification.due_today_tasks_count, tasks: t('tasks.task'))} "
    elsif @notification.any_overdue_tasks?
      I18n.t('layouts.notification.overdue_tasks_count', count: @notification.overdue_tasks_count, tasks: t('tasks.task'))
    else
      I18n.t('layouts.notification.due_today_tasks_count', count: @notification.due_today_tasks_count, tasks: t('tasks.task'))
    end
  end

  def assessments_notification_label
    if @notification.any_overdue_assessments? && @notification.any_due_today_assessments?
      overdue_count = @notification.overdue_assessments_count
      due_today_count = @notification.due_today_assessments_count
      "#{I18n.t('layouts.notification.assessments_count', count: overdue_count)} #{Setting.cache_first.default_assessment} #{I18n.t('layouts.notification.overdue_assessments', count: overdue_count)} #{I18n.t('layouts.notification.overdue_and_due_today_count', count: due_today_count)}"
    elsif @notification.any_overdue_assessments?
      count = @notification.overdue_assessments_count
      "#{I18n.t('layouts.notification.assessments_count', count: count)} #{Setting.cache_first.default_assessment} #{I18n.t('layouts.notification.overdue_assessments', count: count)}"
    else
      count = @notification.due_today_assessments_count
      "#{I18n.t('layouts.notification.assessments_count', count: count)} #{Setting.cache_first.default_assessment} #{I18n.t('layouts.notification.due_today_assessments', count: count)}"
    end
  end

  def customized_assessments_notification_label
    if @notification.any_overdue_custom_assessments? && @notification.any_due_today_custom_assessments?
      overdue_count = @notification.overdue_custom_assessments_count
      due_today_count = @notification.due_today_custom_assessments_count
      "#{I18n.t('layouts.notification.assessments_count', count: overdue_count)} Custom Assessment #{I18n.t('layouts.notification.overdue_assessments', count: overdue_count)} #{I18n.t('layouts.notification.overdue_and_due_today_count', count: due_today_count)}"
    elsif @notification.any_overdue_custom_assessments?
      count = @notification.overdue_custom_assessments_count
      "#{I18n.t('layouts.notification.assessments_count', count: count)} Custom Assessment #{I18n.t('layouts.notification.overdue_assessments', count: count)}"
    else
      count = @notification.due_today_custom_assessments_count
      "#{I18n.t('layouts.notification.assessments_count', count: count)} Custom Assessment #{I18n.t('layouts.notification.due_today_assessments', count: count)}"
    end
  end

  def forms_notification_label
    if @notification.any_client_forms_overdue? && @notification.any_client_forms_due_today?
      "#{I18n.t('layouts.notification.due_today_forms_count', count: @notification.client_enrollment_tracking_frequency_overdue_count)} #{I18n.t('layouts.notification.overdue_and_due_today_count', count: @notification.client_enrollment_tracking_frequency_due_today_count)}"
    elsif  @notification.any_client_forms_overdue?
      I18n.t('layouts.notification.overdue_forms_count', count: @notification.client_enrollment_tracking_frequency_overdue_count)
    else
      I18n.t('layouts.notification.due_today_forms_count', count: @notification.client_enrollment_tracking_frequency_due_today_count)
    end
  end

  def whodunnit(type, id, event='create')
    user_id = PaperTrail::Version.find_by(event: event, item_type: type, item_id: id).try(:whodunnit)
    if user_id.blank? || (user_id.present? && user_id.include?('@rotati'))
      object = type.constantize.find(id)
      user_id = object.has_attribute?(:user_id) ? object&.user_id : object.try(:parent)&.user_id
      if user_id.nil?
        user_ids = object.try(:parent)&.users&.ids
        return User.where(id: user_ids).first.try(:name) || 'OSCaR Team'
      end
    end

    made_changed_by(user_id)
  end

  def made_changed_by(user_id)
    User.find_by(id: user_id).try(:name) || 'User not found'
  end

  def khmer_dob_to_age(date)
    return unless date.present?
    ((Date.today - date) / 365).to_i
  end

  def khmer_gender(gender)
    return unless gender.present?
    case gender
    when 'male' then 'ប្រុស'
    when 'female' then 'ស្រី'
    else
      'Unknown'
    end
  end

  def enable_all_csi_tools?
    enable_default_assessment? && enable_custom_assessment?
  end

  def enable_any_csi_tools?
    enable_default_assessment? || enable_custom_assessment?
  end

  def enable_default_assessment?
    Setting.cache_first.try(:enable_default_assessment)
  end

  def enable_custom_assessment?
    CustomAssessmentSetting.where(enable_custom_assessment: true).present?
  end

  def enable_any_csi_tools?
    enable_default_assessment? || enable_custom_assessment?
  end

  def country_langauge
    return 'Swahili' if current_organization.short_name == 'cccu'
    country = current_setting.try(:country_name)
    case country
    when 'cambodia' then 'Khmer'
    when 'myanmar' then 'Burmese'
    when 'thailand' then 'Thai'
    when 'lesotho' then 'English'
    end
  end

  def supported_languages_data
    {
      en: { label: t('.english'), flag_file_name: 'United-Kingdom.png' },
      km: { label: t('.khmer'), flag_file_name: 'Cambodia.png' },
      my: { label: t('.burmese'), flag_file_name: 'Myanamar-icon.png' }
    }
  end

  def referral_source_name(referral_source)
    if I18n.locale == :km
      referral_source.map{|ref| [ref.name, ref.id] }
    else
      referral_source.map do |ref|
        if ref.name_en.blank?
          [ref.name, ref.id]
        else
          [ref.name_en, ref.id]
        end
      end
    end
  end

  def ref_cat_name(referral_source_cat)
    ReferralSource.find_by(id: referral_source_cat).try(:name)
  end

  def select_ngos
    current_short_name = Apartment::Tenant.current
    if current_short_name == 'demo' || current_short_name == 'tutorials'
      Organization.test_ngos.exclude_current.order(:full_name).map{|org| [org.full_name, org.short_name] }
    elsif current_short_name == 'cif' || current_short_name == 'newsmile'
      Organization.exclude_current.visible_only_cif.where(demo: false).order(:full_name).map{|org| [org.full_name, org.short_name] }
    else
      Organization.exclude_current.oscar.order(:full_name).map{|org| [org.full_name, org.short_name] }
    end
  end

  def mapping_ngos(ngos)
    if controller_name == 'clients'
      ExternalSystem.all.each.map{ |external_system| ngos << [external_system.name, "external referral"] }
      ngos << ["I don't see the NGO I'm looking for...", "external referral"]
    elsif controller_name == 'family_referrals'
      ngos << ["MoSVY External System", "MoSVY External System"]
      ngos << ["I don't see the NGO I'm looking for...", "external referral", disabled: @referral&.referred_to != 'external referral']
    else
      ngos << ["MoSVY External System", "MoSVY External System", disabled: @referral&.referred_to != 'external referral']
      ngos << ["I don't see the NGO I'm looking for...", "external referral", disabled: @referral&.referred_to != 'external referral']
    end
    ngos
  end

  def initial_referral_date_picker_format(entity)
    "#{entity.initial_referral_date&.year}, #{entity.initial_referral_date&.month}, #{entity.initial_referral_date&.day}"
  end

  def advanced_search_url_dynamic
    routes = Rails.application.routes.url_helpers
    routes.public_send("advanced_search_#{params["controller"]}_path")
  end

  def has_service_delivery?
    !ServiceDelivery.count.zero?
  end

  def request_method
    (['clients', 'families'].include?(params[:controller]) && params[:action] == 'index') ?  'Post' : 'Get'
  end

  def age_in_hash(dob)
    now = Time.now.utc
    distance_of_time_in_words_hash(now, dob)
  end

end
