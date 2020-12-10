class Family < ActiveRecord::Base
  include EntityTypeCustomField
  include FamilyScope
  include Brc::Family

  TYPES = ['Birth Family (Both Parents)', 'Birth Family (Only Mother)',
    'Birth Family (Only Father)', 'Extended Family / Kinship Care',
    'Short Term / Emergency Foster Care', 'Long Term Foster Care',
    'Domestically Adopted', 'Child-Headed Household', 'No Family', 'Other']
  STATUSES = ['Active', 'Inactive', 'Referred']

  ID_POOR = ['No', 'Level 1', 'Level 2'].freeze

  acts_as_paranoid

  mount_uploaders :documents, FileUploader
  attr_accessor :community_ids, :case_management_record

  delegate :name, to: :province, prefix: true, allow_nil: true
  delegate :name, to: :district, prefix: true, allow_nil: true

  belongs_to :province, counter_cache: true
  belongs_to :district
  belongs_to :commune
  belongs_to :village
  belongs_to :user
  belongs_to :referral_source

  belongs_to :received_by,      class_name: 'User',      foreign_key: 'received_by_id'
  belongs_to :followed_up_by,   class_name: 'User',      foreign_key: 'followed_up_by_id'

  has_many :cases, dependent: :destroy
  has_many :clients, through: :cases

  has_many :donor_families, dependent: :destroy
  has_many :donors, through: :donor_families
  has_many :case_worker_families, dependent: :destroy
  has_many :case_workers, through: :case_worker_families, validate: false

  has_many :family_quantitative_cases, dependent: :destroy
  has_many :quantitative_cases, through: :family_quantitative_cases
  has_many :viewable_quantitative_cases, -> { joins(:quantitative_type).where('quantitative_types.visible_on LIKE ?', "%family%") }, through: :family_quantitative_cases, source: :quantitative_case

  has_many :custom_field_properties, as: :custom_formable, dependent: :destroy
  has_many :custom_fields, through: :custom_field_properties, as: :custom_formable
  has_many :enrollments, as: :programmable, dependent: :destroy
  has_many :program_streams, through: :enrollments, as: :programmable
  has_many :family_members, dependent: :destroy

  accepts_nested_attributes_for :family_members, reject_if: :all_blank, allow_destroy: true

  has_paper_trail

  before_validation :assign_family_type, if: [:new_record?, :brc?]
  before_validation :assign_status, unless: :status?

  validates :family_type, presence: true, inclusion: { in: TYPES }
  validates :code, uniqueness: { case_sensitive: false }, if: :code?
  validates :status, inclusion: { in: STATUSES }
  validates :received_by_id, :initial_referral_date, :case_worker_ids, :referral_source_category_id, presence: true, if: :case_management_record?
  validate :client_must_only_belong_to_a_family

  after_save :save_family_in_client

  def self.update_brc_aggregation_data
    Organization.switch_to 'brc'
    Family.find_each(&:save_aggregation_data)
  end

  def member_count
    brc? ? family_members.count : (male_adult_count.to_i + female_adult_count.to_i + male_children_count.to_i + female_children_count.to_i)
  end

  def monthly_average_income
    countable_member = family_members.select(&:monthly_income?)

    if countable_member.any?
      countable_member.map(&:monthly_income).sum / countable_member.count
    else
      'N/A'
    end
  end

  def emergency?
    family_type == 'Short Term / Emergency Foster Care'
  end

  def foster?
    family_type == 'Long Term Foster Care'
  end

  def kinship?
    family_type == 'Extended Family / Kinship Care'
  end

  def birth_family_both_parents?
    family_type == 'Birth Family (Both Parents)'
  end

  def exit_ngo?
    status == 'Exited'
  end

  def inactive?
    status == 'Inactive'
  end

  def is_case?
    emergency? || foster? || kinship?
  end

  def name=(name)
    write_attribute(:name, name.try(:strip))
  end

  def self.mapping_family_type_translation
    [I18n.backend.send(:translations)[:en][:default_family_fields][:family_type_list].values, I18n.t('default_family_fields.family_type_list').values].transpose
  end

  def current_clients
    Client.where(current_family_id: self.id)
  end

  def destroy
    if !deleted?
      with_transaction_returning_status do
        run_callbacks :destroy do
          if persisted?
            # Handle composite keys, otherwise we would just use
            # `self.class.primary_key.to_sym => self.id`.
            self.class
              .delete_all(Hash[[Array(self.class.primary_key), Array(id)].transpose])
          end

          @_trigger_destroy_callback = true

          stale_paranoid_value
          self
        end
      end
    else
      destroy_fully! if paranoid_configuration[:double_tap_destroys_fully]
    end
  end

  def case_management_record?
    @case_management_record == true
  end

  private

  def assign_status
    self.status = (case_management_record? ? 'Referred' : 'Active')
  end

  def assign_family_type
    self.family_type = 'Other'
  end

  def brc?
    Organization.brc?
  end

  def client_must_only_belong_to_a_family
    clients = Client.where.not(current_family_id: nil).where.not(current_family_id: self.id).ids
    existed_clients = children & clients
    existed_clients = Client.where(id: existed_clients).map(&:en_and_local_name) if existed_clients.present?
    error_message = "#{existed_clients.join(', ')} #{'has'.pluralize(existed_clients.count)} already existed in other family"
    errors.add(:children, error_message) if existed_clients.present?
  end

  def save_family_in_client
    Client.where(current_family_id: self.id).where.not(id: self.children).update_all(current_family_id: nil)
    self.children.each do |child|
      client = Client.find_by(id: child)
      next if client.nil?
      client.families << self
      client.current_family_id = self.id
      client.families.uniq
      client.save(validate: false)
    end
  end

  def stale_paranoid_value
    self.paranoid_value = self.class.delete_now_value
    clear_attribute_changes([self.class.paranoid_column])
  end
end
