# This is an autogenerated file for dynamic methods in AdvancedSearch
# Please rerun rake rails_rbi:models to regenerate.
# typed: strong

class AdvancedSearch::ActiveRecord_Relation < ActiveRecord::Relation
  include AdvancedSearch::ModelRelationShared
  extend T::Generic
  Elem = type_member(fixed: AdvancedSearch)
end

class AdvancedSearch::ActiveRecord_Associations_CollectionProxy < ActiveRecord::Associations::CollectionProxy
  include AdvancedSearch::ModelRelationShared
  extend T::Generic
  Elem = type_member(fixed: AdvancedSearch)
end

class AdvancedSearch < ActiveRecord::Base
  extend T::Sig
  extend T::Generic
  extend AdvancedSearch::ModelRelationShared
  include AdvancedSearch::InstanceMethods
  Elem = type_template(fixed: AdvancedSearch)
end

module AdvancedSearch::InstanceMethods
  extend T::Sig

  sig { returns(T.untyped) }
  def created_at(); end

  sig { params(value: T.untyped).void }
  def created_at=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def created_at?(*args); end

  sig { returns(T.nilable(String)) }
  def custom_forms(); end

  sig { params(value: T.nilable(String)).void }
  def custom_forms=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def custom_forms?(*args); end

  sig { returns(T.nilable(String)) }
  def description(); end

  sig { params(value: T.nilable(String)).void }
  def description=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def description?(*args); end

  sig { returns(T.nilable(String)) }
  def enrollment_check(); end

  sig { params(value: T.nilable(String)).void }
  def enrollment_check=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def enrollment_check?(*args); end

  sig { returns(T.nilable(String)) }
  def exit_form_check(); end

  sig { params(value: T.nilable(String)).void }
  def exit_form_check=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def exit_form_check?(*args); end

  sig { returns(T.nilable(T.untyped)) }
  def field_visible(); end

  sig { params(value: T.nilable(T.untyped)).void }
  def field_visible=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def field_visible?(*args); end

  sig { returns(T.nilable(String)) }
  def hotline_check(); end

  sig { params(value: T.nilable(String)).void }
  def hotline_check=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def hotline_check?(*args); end

  sig { returns(Integer) }
  def id(); end

  sig { params(value: Integer).void }
  def id=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def id?(*args); end

  sig { returns(T.nilable(String)) }
  def name(); end

  sig { params(value: T.nilable(String)).void }
  def name=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def name?(*args); end

  sig { returns(T.nilable(String)) }
  def program_streams(); end

  sig { params(value: T.nilable(String)).void }
  def program_streams=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def program_streams?(*args); end

  sig { returns(T.nilable(String)) }
  def quantitative_check(); end

  sig { params(value: T.nilable(String)).void }
  def quantitative_check=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def quantitative_check?(*args); end

  sig { returns(T.nilable(T.untyped)) }
  def queries(); end

  sig { params(value: T.nilable(T.untyped)).void }
  def queries=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def queries?(*args); end

  sig { returns(T.nilable(String)) }
  def tracking_check(); end

  sig { params(value: T.nilable(String)).void }
  def tracking_check=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def tracking_check?(*args); end

  sig { returns(T.untyped) }
  def updated_at(); end

  sig { params(value: T.untyped).void }
  def updated_at=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def updated_at?(*args); end

  sig { returns(T.nilable(Integer)) }
  def user_id(); end

  sig { params(value: T.nilable(Integer)).void }
  def user_id=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def user_id?(*args); end

end

class AdvancedSearch
  extend T::Sig

  sig { returns(T.nilable(::User)) }
  def user(); end

  sig { params(value: T.nilable(::User)).void }
  def user=(value); end

  sig { returns(::PaperTrail::Version::ActiveRecord_Associations_CollectionProxy) }
  def versions(); end

  sig { params(value: T.any(T::Array[::PaperTrail::Version], ::PaperTrail::Version::ActiveRecord_Associations_CollectionProxy)).void }
  def versions=(value); end

end

module AdvancedSearch::ModelRelationShared
  extend T::Sig

  sig { returns(AdvancedSearch::ActiveRecord_Relation) }
  def all(); end

  sig { params(block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(AdvancedSearch::ActiveRecord_Relation) }
  def non_of(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def select(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def order(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def reorder(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def group(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def limit(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def offset(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def joins(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def where(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def rewhere(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def preload(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def eager_load(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def includes(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def from(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def lock(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def readonly(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def or(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def having(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def create_with(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def distinct(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def references(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def none(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def unscope(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(AdvancedSearch::ActiveRecord_Relation) }
  def except(*args, &block); end

end