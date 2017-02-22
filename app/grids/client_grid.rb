class ClientGrid
  include Datagrid

  attr_accessor :current_user, :qType
  scope do
    Client.includes({ cases: [:family, :partner] }, :referral_source, :user, :received_by, :followed_up_by, :province, :assessments, :birth_province).order('clients.status, clients.first_name')
  end

  filter(:name, :string, header: -> { I18n.t('datagrid.columns.clients.name') }) { |value, scope| scope.first_name_like(value) }

  filter(:gender, :enum, select: %w(Male Female), header: -> { I18n.t('datagrid.columns.clients.gender') }) do |value, scope|
    value == 'Male' ? scope.male : scope.female
  end

  filter(:slug, :string, header: -> { I18n.t('datagrid.columns.clients.id')})  { |value, scope| scope.slug_like(value) }

  filter(:code, :integer, header: -> { I18n.t('datagrid.columns.clients.code') }) { |value, scope| scope.start_with_code(value) }

  filter(:status, :enum, select: :status_options, header: -> { I18n.t('datagrid.columns.clients.status') })

  def status_options
    scope.status_like
  end

  filter(:case_type, :enum, select: :case_types, header: -> { I18n.t('datagrid.columns.cases.case_type') }) do |name, scope|
    case_ids = []
    Client.joins(:cases).where(cases: { exited: false }).each do |c|
      case_ids << c.cases.current.id
    end
    scope.joins(:cases).where(cases: { id: case_ids, case_type: name })
  end

  filter(:placement_date, :date, range: true, header: -> { I18n.t('datagrid.columns.clients.placement_start_date') }) do |values, scope|
    if values.first.present? && values.second.present?
      ids = scope.joins(:cases).where(cases: { start_date: values[0]..values[1] }).pluck(:id).uniq
      scope.where(id: ids)
    elsif values.first.present? && values.second.blank?
      ids = scope.joins(:cases).where('DATE(cases.start_date) >= ?', values.first).pluck(:id).uniq
      scope.where(id: ids)
    elsif values.second.present? && values.first.blank?
      ids = scope.joins(:cases).where('cases.start_date <= ?', values.second).pluck(:id).uniq
      scope.where(id: ids)
    end
  end

  # TODO: filter by placement date of both active and inactive cases
  # filter(:placement_case_type, :enum, select: %w(EC KC FC), header: -> { I18n.t('datagrid.columns.clients.placement_case_type') }) do |value, scope|
  #   ids = scope.joins(:cases).where(cases: { case_type: value }).pluck(:id).uniq
  #   scope.where(id: ids)
  # end

  def case_types
    Case.case_types
  end
  filter(:date_of_birth, :date, range: true, header: -> { I18n.t('datagrid.columns.clients.date_of_birth') })

  filter(:age, :float, range: true, header: -> { I18n.t('datagrid.columns.clients.age') }) do |value, scope|
    scope.age_between(value[0], value[1]) if value[0].present? && value[1].present?
  end

  filter(:has_date_of_birth, :enum, select: :has_or_has_no_dob, header: -> { I18n.t('datagrid.columns.clients.has_date_of_birth') }) do |value, scope|
    value == 'Yes' ? scope.where.not(date_of_birth: nil) : scope.where(date_of_birth: nil)
  end

  def has_or_has_no_dob
    [[I18n.t('datagrid.columns.clients.has_dob'), 'Yes'], [I18n.t('datagrid.columns.clients.no_dob'), 'No']]
  end

  filter(:birth_province_id, :enum, select: :province_with_birth_place, header: -> { I18n.t('datagrid.columns.clients.birth_province') })
  def province_with_birth_place
    Province.birth_places.map { |p| [p.name, p.id] }
  end

  filter(:province_id, :enum, select: :province_with_clients, header: -> { I18n.t('datagrid.columns.clients.current_province') })

  def province_with_clients
    Province.has_clients.map { |p| [p.name, p.id] }
  end

  filter(:initial_referral_date, :date, range: true, header: -> { I18n.t('datagrid.columns.clients.initial_referral_date') })

  filter(:referral_phone, :string, header: -> { I18n.t('datagrid.columns.clients.referral_phone') }) { |value, scope| scope.referral_phone_like(value) }

  filter(:received_by_id, :enum, select: :is_received_by_options, header: -> { I18n.t('datagrid.columns.clients.received_by') })

  def is_received_by_options
    current_user.present? ? scope.where(user_id: current_user.id).is_received_by : scope.is_received_by
  end

  filter(:referral_source_id, :enum, select: :referral_source_options, header: -> { I18n.t('datagrid.columns.clients.referral_source') })

  def referral_source_options
    current_user.present? ? scope.where(user_id: current_user.id).referral_source_is : scope.referral_source_is
  end

  filter(:followed_up_by_id, :enum, select: :is_followed_up_by_options, header: -> { I18n.t('datagrid.columns.clients.follow_up_by') })

  def is_followed_up_by_options
    current_user.present? ? scope.where(user_id: current_user.id).is_followed_up_by : scope.is_followed_up_by
  end

  filter(:follow_up_date, :date, range: true, header: -> { I18n.t('datagrid.columns.clients.follow_up_date') })

  def agencies_options
    Agency.joins(:clients).pluck(:name).uniq
  end

  filter(:agencies_name, :enum, multiple: true, select: :agencies_options, header: -> { I18n.t('datagrid.columns.clients.agency_names') }) do |name, scope|
    if agencies ||= Agency.name_like(name)
      scope.joins(:agencies).where(agencies: { id: agencies.ids })
    else
      scope.joins(:agencies).where(agencies: { id: nil })
    end
  end

  filter(:current_address, :string, header: -> { I18n.t('datagrid.columns.clients.current_address') }) { |value, scope| scope.current_address_like(value) }

  filter(:school_name, :string, header: -> { I18n.t('datagrid.columns.clients.school_name') }) { |value, scope| scope.school_name_like(value) }

  filter(:has_been_in_government_care, :xboolean, header: -> { I18n.t('datagrid.columns.clients.has_been_in_government_care') })

  filter(:grade, :integer, range: true, header: -> { I18n.t('datagrid.columns.clients.school_grade') })

  filter(:able_state, :enum, select: :able_states, header: -> { I18n.t('datagrid.columns.clients.able_state') })

  def able_states
    Client::ABLE_STATES
  end

  filter(:has_been_in_orphanage, :xboolean, header: -> { I18n.t('datagrid.columns.clients.has_been_in_orphanage') })

  filter(:relevant_referral_information, :string, header: -> { I18n.t('datagrid.columns.clients.relevant_referral_information') }) { |value, scope| scope.info_like(value) }

  filter(:user_id, :enum, select: :user_select_options, header: -> { I18n.t('datagrid.columns.clients.case_worker') })

  def user_select_options
    User.has_clients.map { |user| [user.name, user.id] }
  end

  filter(:donor, :enum, select: -> { Donor.pluck(:name, :id) }, header: -> { I18n.t('datagrid.columns.clients.donor') })

  filter(:state, :enum, select: %w(Accepted Rejected), header: -> { I18n.t('datagrid.columns.clients.state') }) do |value, scope|
    value == 'Accepted' ? scope.accepted : scope.rejected
  end

  filter(:family_id, :integer, header: -> { I18n.t('datagrid.columns.families.family_id') }) do |value, object|
    ids = []
    Case.active.most_recents.joins(:client).group_by(&:client_id).each do |key, c|
      ids << c.first.id
    end
    object.joins(:cases).where("cases.id IN (?)", ids).where("cases.family_id = ? ", value) if value.present?
  end

  def quantitative_type_options
    QuantitativeType.all.map{ |t| [t.name, t.id] }
  end

  filter(:quantitative_types, :enum, select: :quantitative_type_options, header: -> { I18n.t('datagrid.columns.clients.quantitative_types') }) do |value, scope|
    ids = Client.joins(:quantitative_cases).where(quantitative_cases: { quantitative_type_id: value.to_i }).pluck(:id).uniq
    scope.where(id: ids)
  end

  def quantitative_cases
    qType.present? ? QuantitativeType.find(qType.to_i).quantitative_cases.map{ |t| [t.value, t.id] } : QuantitativeCase.all.map{ |t| [t.value, t.id] }
  end

  filter(:quantitative_data, :enum, select: :quantitative_cases, header: -> { I18n.t('datagrid.columns.clients.quantitative_case_values') }) do |value, scope|
    ids = Client.joins(:quantitative_cases).where(quantitative_cases: { id: value.to_i }).pluck(:id).uniq
    scope.where(id: ids)
  end

  filter(:any_assessments, :enum, select: %w(Yes No), header: -> { I18n.t('datagrid.columns.clients.any_assessments') }) do |value, scope|
    if value == 'Yes'
      client_ids = Client.joins(:assessments).uniq.pluck(:id)
      scope.where(id: client_ids)
    else
      scope.without_assessments
    end
  end

  filter(:assessments_due_to, :enum, select: Assessment::DUE_STATES, header: -> { I18n.t('datagrid.columns.clients.assessments_due_to') }) do |value, scope|
    ids = []
    if value == Assessment::DUE_STATES[0]
      Client.all_active_types.each do |c|
        ids << c.id if c.next_assessment_date == Date.today
      end
    else
      Client.joins(:assessments).all_active_types.each do |c|
        ids << c.id if c.next_assessment_date < Date.today
      end
    end
    scope.where(id: ids)
  end

  filter(:all_domains, :dynamic, select: ['All CSI'], header: -> { I18n.t('datagrid.columns.clients.domains') }) do |(field, operation, value), scope|
    value = value.to_i
    assessment_id = []
    AssessmentDomain.all.group_by(&:assessment_id).each do |key, ad|
      arr = []
      a_id = []
      ad.each do |v|
        if operation == '='
          arr.push v.score == value.to_i ? true : false
        else
          arr.push eval("#{v.score}#{operation}#{value}") ? true : false
        end
        a_id.push v.assessment_id
      end
      if !arr.include?(false)
        assessment_id.push a_id[0]
      end
    end
    scope.joins(:assessments).where(assessments: { id: assessment_id })
  end

  def self.client_by_domain(operation, value, domain_id, scope)
    ids = Assessment.joins(:assessment_domains).where("score#{operation} ? AND domain_id= ?", value, domain_id).ids
    scope.joins(:assessments).where(assessments: { id: ids})
  end

  def self.get_domain(name)
    domain = Domain.find_by(name: name)
    domain.present?  ? Array.new([[domain.name, domain.id]]) : []
  end

  filter(:domain_1a, :dynamic, select: proc { get_domain('1A') }, header: -> { "#{ I18n.t('datagrid.columns.clients.domain')} 1A (Food Security)" }) do |(domain_id, operation, value), scope|
    value = value.to_i
    client_by_domain(operation, value, domain_id, scope)
  end

  filter(:domain_1b, :dynamic, select: proc { get_domain('1B') }, header: -> { "#{ I18n.t('datagrid.columns.clients.domain')} 1B (Nutrition and Growth)" }) do |(domain_id, operation, value), scope|
    value = value.to_i
    client_by_domain(operation, value, domain_id, scope)
  end

  filter(:domain_2a, :dynamic, select: proc { get_domain('2A') }, header: -> { "#{ I18n.t('datagrid.columns.clients.domain')} 2A (Shelter)" }) do |(domain_id, operation, value), scope|
    value = value.to_i
    client_by_domain(operation, value, domain_id, scope)
  end

  filter(:domain_2b, :dynamic, select: proc { get_domain('2B') }, header: -> { "#{ I18n.t('datagrid.columns.clients.domain')} 2B (Care)" }) do |(domain_id, operation, value), scope|
    value = value.to_i
    client_by_domain(operation, value, domain_id, scope)
  end

  filter(:domain_3a, :dynamic, select: proc { get_domain('3A') }, header: -> { "#{ I18n.t('datagrid.columns.clients.domain')} 3A (Protection from Abuse and Exploitation)" }) do |(domain_id, operation, value), scope|
    value = value.to_i
    client_by_domain(operation, value, domain_id, scope)
  end

  filter(:domain_3b, :dynamic, select: proc { get_domain('3B') }, header: -> { "#{ I18n.t('datagrid.columns.clients.domain')} 3B (Legal Protection)" }) do |(domain_id, operation, value), scope|
    value = value.to_i
    client_by_domain(operation, value, domain_id, scope)
  end

  filter(:domain_4a, :dynamic, select: proc { get_domain('4A') }, header: -> { "#{ I18n.t('datagrid.columns.clients.domain')} 4A (Wellness)" }) do |(domain_id, operation, value), scope|
    value = value.to_i
    client_by_domain(operation, value, domain_id, scope)
  end

  filter(:domain_4b, :dynamic, select: proc { get_domain('4B') }, header: -> { "#{ I18n.t('datagrid.columns.clients.domain')} 4B (Health Care Services)" }) do |(domain_id, operation, value), scope|
    value = value.to_i
    client_by_domain(operation, value, domain_id, scope)
  end

  filter(:domain_5a, :dynamic, select: proc { get_domain('5A') }, header: -> { "#{ I18n.t('datagrid.columns.clients.domain')} 5A (Emotional Health)" }) do |(domain_id, operation, value), scope|
    value = value.to_i
    client_by_domain(operation, value, domain_id, scope)
  end

  filter(:domain_5b, :dynamic, select: proc { get_domain('5B') }, header: -> { "#{ I18n.t('datagrid.columns.clients.domain')} 5B (Social Behaviour)" }) do |(domain_id, operation, value), scope|
    value = value.to_i
    client_by_domain(operation, value, domain_id, scope)
  end

  filter(:domain_6a, :dynamic, select: proc { get_domain('6A') }, header: -> { "#{ I18n.t('datagrid.columns.clients.domain')} 6A (Performance)" }) do |(domain_id, operation, value), scope|
    value = value.to_i
    client_by_domain(operation, value, domain_id, scope)
  end

  filter(:domain_6b, :dynamic, select: proc { get_domain('6B') }, header: -> { "#{ I18n.t('datagrid.columns.clients.domain')} 6B (Work and Education)" }) do |(domain_id, operation, value), scope|
    value = value.to_i
    client_by_domain(operation, value, domain_id, scope)
  end

  column(:slug, order:'clients.id', header: -> { I18n.t('datagrid.columns.clients.id') })

  column(:code, header: -> { I18n.t('datagrid.columns.clients.code') }) do |object|
    object.code ||= ''
  end

  column(:name, order: 'clients.first_name', header: -> { I18n.t('datagrid.columns.clients.name') }, html: true) do |object|
    name = object.name.blank? ? 'Unknown' : object.name
    link_to name, client_path(object)
  end

  column(:name, header: -> { I18n.t('datagrid.columns.clients.name') }, html: false) do |object|
    object.name
  end

  column(:gender, header: -> { I18n.t('datagrid.columns.clients.gender') }) do |object|
    object.gender.try(:titleize)
  end

  column(:status, header: -> { I18n.t('datagrid.columns.clients.status') }) do |object|
    format(object.status) do |value|
      status_style(value)
    end
  end

  column(:cases, header: -> { I18n.t('datagrid.columns.cases.case_type') }, order: false ) do |object|
    object.cases.current.case_type if object.cases.current.present?
  end

  column(:history_of_disability_and_or_illness, header: -> { I18n.t('datagrid.columns.clients.history_of_disability_and_or_illness') }) do |object|
    object.quantitative_cases.where(quantitative_type_id: QuantitativeType.name_like('History of disability and/or illness').ids).pluck(:value).join(', ')
  end

  column(:history_of_harm, header: -> { I18n.t('datagrid.columns.clients.history_of_harm') }) do |object|
    object.quantitative_cases.where(quantitative_type_id: QuantitativeType.name_like('History of Harm').ids).pluck(:value).join(', ')
  end

  column(:history_of_high_risk_behaviours, header: -> { I18n.t('datagrid.columns.clients.history_of_high_risk_behaviours') }) do |object|
    object.quantitative_cases.where(quantitative_type_id: QuantitativeType.name_like('History of high-risk behaviours').ids).pluck(:value).join(', ')
  end

  column(:reason_for_family_separation, header: -> { I18n.t('datagrid.columns.clients.reason_for_family_separation') }) do |object|
    object.quantitative_cases.where(quantitative_type_id: QuantitativeType.name_like('Reason for Family Separation').ids).pluck(:value).join(', ')
  end

  column(:follow_up_date, header: -> { I18n.t('datagrid.columns.clients.follow_up_date') })

  column(:received_by, html: true, header: -> { I18n.t('datagrid.columns.clients.received_by') }) do |object|
    render partial: 'clients/users', locals: { object: object.received_by } if object.received_by
  end

  column(:received_by, html: false, header: -> { I18n.t('datagrid.columns.clients.received_by') }) do |object|
    object.received_by.try(:name)
  end

  column(:followed_up_by, html: true, header: -> { I18n.t('datagrid.columns.clients.followed_up_by') }) do |object|
    render partial: 'clients/users', locals: { object: object.followed_up_by } if object.followed_up_by
  end

  column(:followed_up_by, html: false, header: -> { I18n.t('datagrid.columns.clients.followed_up_by') }) do |object|
    object.followed_up_by.try(:name)
  end

  column(:agency, order: false, header: -> { I18n.t('datagrid.columns.clients.agencies_involved') }) do |object|
    object.agencies.pluck(:name).join(', ')
  end

  column(:date_of_birth, header: -> { I18n.t('datagrid.columns.clients.date_of_birth') })

  column(:age, header: -> { I18n.t('datagrid.columns.clients.age') }, order: 'clients.date_of_birth desc') do |object|
    "#{object.age_as_years} #{'year'.pluralize(object.age_as_years)} #{object.age_extra_months} #{'month'.pluralize(object.age_extra_months)}" if object.date_of_birth.present?
  end

  column(:current_address, order: 'clients.current_address', header: -> { I18n.t('datagrid.columns.clients.current_address') })

  column(:school_name, header: -> { I18n.t('datagrid.columns.clients.school_name') })

  column(:grade, header: -> { I18n.t('datagrid.columns.clients.school_grade') })

  column(:has_been_in_orphanage, header: -> { I18n.t('datagrid.columns.clients.has_been_in_orphanage') }) do |object|
    object.has_been_in_orphanage ? 'Yes' : 'No'
  end

  column(:has_been_in_government_care, header: -> { I18n.t('datagrid.columns.clients.has_been_in_government_care') }) do |object|
    object.has_been_in_government_care ? 'Yes' : 'No'
  end

  column(:initial_referral_date, header: -> { I18n.t('datagrid.columns.clients.initial_referral_date') })

  column(:relevant_referral_information, header: -> { I18n.t('datagrid.columns.clients.relevant_referral_information') })

  column(:referral_phone, header: -> { I18n.t('datagrid.columns.clients.referral_phone') }) do |object|
    object.referral_phone.phony_formatted(normalize: :KH, format: :international) if object.referral_phone
  end

  column(:referral_source, order: 'referral_sources.name', header: -> { I18n.t('datagrid.columns.clients.referral_source') }) do |object|
    object.referral_source.try(:name)
  end

  column(:able_state, header: -> { I18n.t('datagrid.columns.clients.able_state') })

  column(:birth_province, header: -> { I18n.t('datagrid.columns.clients.birth_province') }) do |object|
    object.birth_province.try(:name)
  end

  column(:province, order: 'provinces.name', header: -> { I18n.t('datagrid.columns.clients.current_province') }) do |object|
    object.province.try(:name)
  end

  column(:state, header: -> { I18n.t('datagrid.columns.clients.state') }) do |object|
    object.state.titleize
  end

  column(:rejected_note, header: -> { I18n.t('datagrid.columns.clients.rejected_note') })

  column(:user, order: proc { |scope| scope.joins(:user).reorder('users.first_name') }, header: -> { I18n.t('datagrid.columns.clients.case_worker_or_staff') }) do |object|
    object.user.try(:name)
  end

  column(:donor, header: -> { I18n.t('datagrid.columns.clients.donor')}) do |object|
    object.donor_name
  end

  column(:case_start_date, order: false, header: -> { I18n.t('datagrid.columns.clients.placements.start_date') }) do |object|
    object.cases.current.try(:start_date)
  end

  column(:carer_names, order: false, header: -> { I18n.t('datagrid.columns.clients.placements.carer_names') }) do |object|
    object.cases.current.try(:carer_names)
  end

  column(:carer_address, order: false, header: -> { I18n.t('datagrid.columns.clients.placements.carer_address') }) do |object|
    object.cases.current.try(:carer_address)
  end

  column(:carer_phone_number, order: false, header: -> { I18n.t('datagrid.columns.clients.placements.carer_phone_number') }) do |object|
    object.cases.current.try(:carer_phone_number)
  end

  column(:support_amount, order: false, header: -> { I18n.t('datagrid.columns.clients.placements.support_amount') }) do |object|
    if object.cases.current
      format(object.cases.current.support_amount) do |amount|
        number_to_currency(amount)
      end
    end
  end

  column(:support_note, order: false, header: -> { I18n.t('datagrid.columns.clients.placements.support_note') }) do |object|
    object.cases.current.try(:support_note)
  end

  column(:family_preservation, order: false, header: -> { I18n.t('datagrid.columns.families.family_preservation') }) do |object|
    object.cases.current.family_preservation ? 'Yes' : 'No' if object.cases.current
  end

  column(:family_id, order: false, header: -> { I18n.t('datagrid.columns.families.family_id') }) do |object|
    if object.cases.current && object.cases.current.family
      object.cases.current.family.id
    end
  end

  column(:family, order: false, header: -> { I18n.t('datagrid.columns.clients.placements.family') }) do |object|
    if object.cases.current && object.cases.current.family
      object.cases.current.family.name
    end
  end

  column(:partner, order: false, header: -> { I18n.t('datagrid.columns.partners.partner') }) do |object|
    if object.cases.current && object.cases.current.partner
      object.cases.current.partner.name
    end
  end

  column(:any_assessments, class: 'text-center', header: -> { I18n.t('datagrid.columns.clients.assessments') }, html: true) do |object|
    render partial: 'clients/assessments', locals: { object: object }
  end

  column(:manage, html: true, class: 'text-center', header: -> { I18n.t('datagrid.columns.clients.manage') }) do |object|
    render partial: 'clients/actions', locals: { object: object }
  end

  column(:changelog, html: true, class: 'text-center', header: -> { I18n.t('datagrid.columns.clients.changelogs') }) do |object|
    link_to t('datagrid.columns.clients.view'), client_version_path(object)
  end
end
