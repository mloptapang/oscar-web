# class Caller < ActiveRecord::Base
#   has_many :calls, dependent: :restrict_with_error

#   validates :answered_call, :called_before, presence: true
# end