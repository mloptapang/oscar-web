class UserNotification
  include ProgramStreamHelper
  include CsiConcern

  attr_reader :all_count, :current_setting, :enable_default_assessment, :any_custom_assessment_enable, :assessments
  attr_accessor :upcoming_csi_assessments_count, :upcoming_custom_csi_assessments_count

  def initialize(user, clients)
    @current_setting = Setting.cache_first
    @user                                            = user
    @clients                                         = clients
    @assessments                                     = @user.assessment_either_overdue_or_due_today
    @user_custom_field                               = @user.user_custom_field_frequency_overdue_or_due_today if @user.admin? || @user.manager? || @user.hotline_officer?
    @partner_custom_field                            = @user.partner_custom_field_frequency_overdue_or_due_today
    @family_custom_field                             = @user.family_custom_field_frequency_overdue_or_due_today
    @client_forms_overdue_or_due_today               = @user.client_forms_overdue_or_due_today
    @case_notes_overdue_and_due_today                = @user.case_note_overdue_and_due_today
    @unsaved_referrals                               = get_referrals('new_referral')
    @repeat_referrals                                = get_referrals('existing_client')
    @unsaved_family_referrals                        = get_family_referrals('new_referral')
    @repeat_family_referrals                         = get_family_referrals('existing_family')
    @upcoming_csi_assessments_count                  = 0
    @upcoming_custom_csi_assessments_count           = 0
    upcoming_csi_assessments
    @all_count                                       = count
  end

  def upcoming_csi_assessments
    client_ids = []
    custom_client_ids = []
    clients = active_young_clients(@clients)
    if @user.deactivated_at.present? && clients.any?
      clients = clients.where('clients.created_at > ?', @user.activated_at)
    end

    default_clients = clients_have_recent_default_assessments(clients)
    custom_assessment_clients = clients_have_recent_custom_assessments(clients)

    upcoming_csi_assessments_count = default_clients.count
    upcoming_custom_csi_assessments_count = custom_assessment_clients.count

    { clients: default_clients, custom_clients: custom_assessment_clients }
  end

  def any_upcoming_csi_assessments?
    upcoming_csi_assessments_count >= 1
  end

  def any_upcoming_custom_csi_assessments?
    upcoming_custom_csi_assessments_count >= 1
  end

  def overdue_tasks_count
    if @user.deactivated_at.nil?
      @user.tasks.overdue_incomplete.exclude_exited_ngo_clients.where(client_id: @clients.ids).size
    else
      @user.tasks.where('tasks.created_at > ?', @user.activated_at).overdue_incomplete.exclude_exited_ngo_clients.where(client_id: @clients.ids).size
    end
  end

  def review_program_streams
    client_wrong_program_rules = []
    program_streams_by_user.each do |program_stream|
      rules = program_stream.rules
      client_ids = program_stream.client_enrollments.active.pluck(:client_id).uniq
      client_ids = client_ids & @clients.ids
      clients = Client.active_accepted_status.where(id: client_ids)

      clients_after_filter = AdvancedSearches::ClientAdvancedSearch.new(rules, clients).filter

      if clients_after_filter.any?
        clients_change = clients.where.not(id: clients_after_filter.ids).ids
        client_wrong_program_rules << [program_stream, clients_change] if clients_change.any?
      else
        client_wrong_program_rules << [program_stream, clients.ids] if clients.any?
      end
    end
    client_wrong_program_rules
  end

  def any_overdue_tasks?
    overdue_tasks_count >= 1
  end

  def due_today_tasks_count
    if @user.deactivated_at.nil?
      @user.tasks.today_incomplete.exclude_exited_ngo_clients.size
    else
      @user.tasks.where('tasks.created_at > ?', @user.activated_at).today_incomplete.exclude_exited_ngo_clients.size
    end
  end

  def any_due_today_tasks?
    due_today_tasks_count >= 1
  end

  def overdue_assessments_count
    @assessments[:overdue_count]
  end

  def any_overdue_assessments?
    overdue_assessments_count >= 1
  end

  def due_today_assessments_count
    @assessments[:due_today_count]
  end

  def any_due_today_assessments?
    due_today_assessments_count >= 1
  end

  def overdue_custom_assessments_count
    @assessments[:custom_overdue_count]
  end

  def any_overdue_custom_assessments?
    overdue_custom_assessments_count >= 1
  end

  def due_today_custom_assessments_count
    @assessments[:custom_due_today_count]
  end

  def any_due_today_custom_assessments?
    due_today_custom_assessments_count >= 1
  end

  def any_user_custom_field_frequency_overdue?
    user_custom_field_frequency_overdue_count >= 1
  end

  def any_user_custom_field_frequency_due_today?
    user_custom_field_frequency_due_today_count >= 1
  end

  def user_custom_field_frequency_due_today_count
    @user_custom_field[:entity_due_today].count
  end

  def user_custom_field_frequency_overdue_count
    @user_custom_field[:entity_overdue].count
  end

  def user_custom_field_frequency_due_today
    @user_custom_field[:entity_due_today]
  end

  def user_custom_field_frequency_overdue
    @user_custom_field[:entity_overdue]
  end

  def any_partner_custom_field_frequency_overdue?
    partner_custom_field_frequency_overdue_count >= 1 if partner_custom_field_frequency_overdue_count
  end

  def any_partner_custom_field_frequency_due_today?
    partner_custom_field_frequency_due_today_count >= 1 if partner_custom_field_frequency_due_today_count
  end

  def partner_custom_field_frequency_due_today_count
    @partner_custom_field[:entity_due_today].count if @partner_custom_field
  end

  def partner_custom_field_frequency_overdue_count
    @partner_custom_field[:entity_overdue].count if @partner_custom_field
  end

  def partner_custom_field_frequency_due_today
    @partner_custom_field[:entity_due_today] if @partner_custom_field
  end

  def partner_custom_field_frequency_overdue
    @partner_custom_field[:entity_overdue] if @partner_custom_field
  end

  def any_family_custom_field_frequency_overdue?
    family_custom_field_frequency_overdue_count >= 1
  end

  def any_family_custom_field_frequency_due_today?
    family_custom_field_frequency_due_today_count >= 1
  end

  def family_custom_field_frequency_due_today_count
    @family_custom_field[:entity_due_today].count
  end

  def family_custom_field_frequency_overdue_count
    @family_custom_field[:entity_overdue].count
  end

  def family_custom_field_frequency_due_today
    @family_custom_field[:entity_due_today]
  end

  def family_custom_field_frequency_overdue
    @family_custom_field[:entity_overdue]
  end

  def client_enrollment_tracking_frequency_due_today_count
    @client_forms_overdue_or_due_today[:today_forms].count
  end

  def client_enrollment_tracking_frequency_overdue_count
    @client_forms_overdue_or_due_today[:overdue_forms].count
  end

  def any_client_forms_due_today?
    client_enrollment_tracking_frequency_due_today_count >= 1
  end

  def any_client_forms_overdue?
    client_enrollment_tracking_frequency_overdue_count >= 1
  end

  def client_enrollment_tracking_frequency_due_today
    @client_forms_overdue_or_due_today[:today_forms]
  end

  def client_enrollment_tracking_frequency_overdue
    @client_forms_overdue_or_due_today[:overdue_forms]
  end

  def any_client_case_note_overdue?
    client_case_note_overdue_count >= 1
  end

  def client_case_note_overdue_count
    client_case_note_overdue.count
  end

  def client_case_note_overdue
    @case_notes_overdue_and_due_today[:client_overdue]
  end

  def any_client_case_note_due_today?
    client_case_note_due_today_count >= 1
  end

  def client_case_note_due_today_count
    client_case_note_due_today.count
  end

  def client_case_note_due_today
    @case_notes_overdue_and_due_today[:client_due_today]
  end

  def unsaved_referrals
    @unsaved_referrals
  end

  def unsaved_referrals_count
    @unsaved_referrals.count
  end

  def any_unsaved_referrals?
    unsaved_referrals_count >= 1
  end

  def repeat_referrals
    @repeat_referrals
  end

  def repeat_referrals_count
    @repeat_referrals.count
  end

  def any_repeat_referrals?
    repeat_referrals_count >= 1
  end

  def unsaved_family_referrals
    @unsaved_family_referrals
  end

  def unsaved_family_referrals_count
    @unsaved_family_referrals.count
  end

  def any_unsaved_family_referrals?
    unsaved_family_referrals_count >= 1
  end

  def repeat_family_referrals
    @repeat_family_referrals
  end

  def repeat_family_referrals_count
    @repeat_family_referrals.count
  end

  def any_repeat_family_referrals?
    repeat_family_referrals_count >= 1
  end

  def count
    count_notification = 0
    if @user.admin? || @user.manager?
      count_notification += 1 if any_user_custom_field_frequency_overdue?
      count_notification += 1 if any_user_custom_field_frequency_due_today?
      count_notification += 1 if any_unsaved_referrals? && @user.referral_notification
      count_notification += 1 if any_repeat_referrals? && @user.referral_notification
      count_notification += 1 if any_unsaved_family_referrals? && @user.referral_notification
      count_notification += 1 if any_repeat_family_referrals? && @user.referral_notification
    end
    if @user.admin? || @user.any_case_manager?
      count_notification += 1 if any_partner_custom_field_frequency_overdue?
      count_notification += 1 if any_partner_custom_field_frequency_due_today?
      count_notification += 1 if any_family_custom_field_frequency_overdue?
      count_notification += 1 if any_family_custom_field_frequency_due_today?
    end

    unless @user.strategic_overviewer?
      count_notification += 1 if any_due_today_tasks? || any_overdue_tasks?
      count_notification += 1 if any_client_forms_due_today? || any_client_forms_overdue?
      count_notification += 1 if current_setting.enable_default_assessment && (any_overdue_assessments? || any_due_today_assessments?)
      count_notification += 1 if current_setting.enable_custom_assessment? && (any_overdue_custom_assessments? || any_due_today_custom_assessments?)
      count_notification += 1 if any_upcoming_csi_assessments? && current_setting.enable_default_assessment
      count_notification += 1 if any_upcoming_custom_csi_assessments? && current_setting.enable_custom_assessment?
      count_notification += 1 if any_client_case_note_overdue?
      count_notification += 1 if any_client_case_note_due_today?
    end
    if @user.admin? || @user.manager? || @user.any_case_manager?
      count_notification += review_program_streams.size
    end
    count_notification
  end

  private

  def program_streams_by_user
    program_ids = ClientEnrollment.where(client_id: @clients.ids).active.pluck(:program_stream_id).uniq
    ProgramStream.where(id: program_ids).where.not(rules: '{}')
  end

  def get_referrals(referral_type)
    existing_client_referrals = []
    new_client_referrals = []

    if @user.deactivated_at.nil?
      referrals = Referral.received.unsaved
    else
      referrals = Referral.received.unsaved.where('created_at > ?', @user.activated_at)
    end

    referrals.each do |referral|
      referral_slug = referral.slug
      client = Client.find_by(slug: referral_slug) || Client.find_by(archived_slug: referral_slug)
      if client.present?
        existing_client_referrals << referral
        referral.update_column(:client_id, client.id) unless referral.client_id
      else
        new_client_referrals << referral
      end
    end

    referral_type == 'new_referral' ? new_client_referrals : existing_client_referrals
  end

  def get_family_referrals(referral_type)
    existing_family_referrals = []
    new_family_referrals = []

    if @user.deactivated_at.nil?
      referrals = FamilyReferral.received.unsaved
    else
      referrals = FamilyReferral.received.unsaved.where('created_at > ?', @user.activated_at)
    end

    referrals.each do |referral|
      referral_slug = referral.slug
      family = Family.find_by(slug: referral_slug)
      family.present? ? existing_family_referrals << referral : new_family_referrals << referral
    end
    referral_type == 'new_referral' ? new_family_referrals : existing_family_referrals
  end

end
