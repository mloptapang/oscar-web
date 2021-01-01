class Goal < ActiveRecord::Base
  belongs_to :domain, counter_cache: true
  belongs_to :assessment_domain
  belongs_to :client
  belongs_to :care_plan

  has_many :tasks, dependent: :destroy

  has_paper_trail

  validates :description, presence: true

  accepts_nested_attributes_for :tasks, allow_destroy: true
end