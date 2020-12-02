# This is an autogenerated file for dynamic methods in QuantitativeCase
# Please rerun rake rails_rbi:models to regenerate.
# typed: strong

class QuantitativeCase::ActiveRecord_Relation < ActiveRecord::Relation
  include QuantitativeCase::ModelRelationShared
  extend T::Generic
  Elem = type_member(fixed: QuantitativeCase)
end

class QuantitativeCase::ActiveRecord_Associations_CollectionProxy < ActiveRecord::Associations::CollectionProxy
  include QuantitativeCase::ModelRelationShared
  extend T::Generic
  Elem = type_member(fixed: QuantitativeCase)
end

class QuantitativeCase < ActiveRecord::Base
  extend T::Sig
  extend T::Generic
  extend QuantitativeCase::ModelRelationShared
  include QuantitativeCase::InstanceMethods
  Elem = type_template(fixed: QuantitativeCase)
end

module QuantitativeCase::InstanceMethods
  extend T::Sig

  sig { returns(T.nilable(T.untyped)) }
  def created_at(); end

  sig { params(value: T.nilable(T.untyped)).void }
  def created_at=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def created_at?(*args); end

  sig { returns(Integer) }
  def id(); end

  sig { params(value: Integer).void }
  def id=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def id?(*args); end

  sig { returns(T.nilable(Integer)) }
  def quantitative_type_id(); end

  sig { params(value: T.nilable(Integer)).void }
  def quantitative_type_id=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def quantitative_type_id?(*args); end

  sig { returns(T.nilable(T.untyped)) }
  def updated_at(); end

  sig { params(value: T.nilable(T.untyped)).void }
  def updated_at=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def updated_at?(*args); end

  sig { returns(T.nilable(String)) }
  def value(); end

  sig { params(value: T.nilable(String)).void }
  def value=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def value?(*args); end

end

class QuantitativeCase
  extend T::Sig

  sig { returns(::ClientQuantitativeCase::ActiveRecord_Associations_CollectionProxy) }
  def client_quantitative_cases(); end

  sig { params(value: T.any(T::Array[::ClientQuantitativeCase], ::ClientQuantitativeCase::ActiveRecord_Associations_CollectionProxy)).void }
  def client_quantitative_cases=(value); end

  sig { returns(::Client::ActiveRecord_Associations_CollectionProxy) }
  def clients(); end

  sig { params(value: T.any(T::Array[::Client], ::Client::ActiveRecord_Associations_CollectionProxy)).void }
  def clients=(value); end

  sig { returns(T.nilable(::QuantitativeType)) }
  def quantitative_type(); end

  sig { params(value: T.nilable(::QuantitativeType)).void }
  def quantitative_type=(value); end

  sig { returns(::PaperTrail::Version::ActiveRecord_Associations_CollectionProxy) }
  def versions(); end

  sig { params(value: T.any(T::Array[::PaperTrail::Version], ::PaperTrail::Version::ActiveRecord_Associations_CollectionProxy)).void }
  def versions=(value); end

end

module QuantitativeCase::ModelRelationShared
  extend T::Sig

  sig { returns(QuantitativeCase::ActiveRecord_Relation) }
  def all(); end

  sig { params(block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(QuantitativeCase::ActiveRecord_Relation) }
  def quantitative_cases_by_type(*args); end

  sig { params(args: T.untyped).returns(QuantitativeCase::ActiveRecord_Relation) }
  def value_like(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def select(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def order(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def reorder(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def group(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def limit(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def offset(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def joins(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def where(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def rewhere(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def preload(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def eager_load(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def includes(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def from(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def lock(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def readonly(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def or(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def having(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def create_with(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def distinct(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def references(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def none(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def unscope(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(QuantitativeCase::ActiveRecord_Relation) }
  def except(*args, &block); end

end