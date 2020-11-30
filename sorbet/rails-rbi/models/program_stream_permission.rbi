# This is an autogenerated file for dynamic methods in ProgramStreamPermission
# Please rerun rake rails_rbi:models to regenerate.
# typed: strong

class ProgramStreamPermission::ActiveRecord_Relation < ActiveRecord::Relation
  include ProgramStreamPermission::ModelRelationShared
  extend T::Generic
  Elem = type_member(fixed: ProgramStreamPermission)
end

class ProgramStreamPermission::ActiveRecord_Associations_CollectionProxy < ActiveRecord::Associations::CollectionProxy
  include ProgramStreamPermission::ModelRelationShared
  extend T::Generic
  Elem = type_member(fixed: ProgramStreamPermission)
end

class ProgramStreamPermission < ActiveRecord::Base
  extend T::Sig
  extend T::Generic
  extend ProgramStreamPermission::ModelRelationShared
  include ProgramStreamPermission::InstanceMethods
  Elem = type_template(fixed: ProgramStreamPermission)
end

module ProgramStreamPermission::InstanceMethods
  extend T::Sig

  sig { returns(T.untyped) }
  def created_at(); end

  sig { params(value: T.untyped).void }
  def created_at=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def created_at?(*args); end

  sig { returns(T.nilable(T.untyped)) }
  def deleted_at(); end

  sig { params(value: T.nilable(T.untyped)).void }
  def deleted_at=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def deleted_at?(*args); end

  sig { returns(T.nilable(T::Boolean)) }
  def editable(); end

  sig { params(value: T.nilable(T::Boolean)).void }
  def editable=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def editable?(*args); end

  sig { returns(Integer) }
  def id(); end

  sig { params(value: Integer).void }
  def id=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def id?(*args); end

  sig { returns(T.nilable(Integer)) }
  def program_stream_id(); end

  sig { params(value: T.nilable(Integer)).void }
  def program_stream_id=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def program_stream_id?(*args); end

  sig { returns(T.nilable(T::Boolean)) }
  def readable(); end

  sig { params(value: T.nilable(T::Boolean)).void }
  def readable=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def readable?(*args); end

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

class ProgramStreamPermission
  extend T::Sig

  sig { returns(T.nilable(::ProgramStream)) }
  def program_stream(); end

  sig { params(value: T.nilable(::ProgramStream)).void }
  def program_stream=(value); end

  sig { returns(T.nilable(::User)) }
  def user(); end

  sig { params(value: T.nilable(::User)).void }
  def user=(value); end

end

module ProgramStreamPermission::ModelRelationShared
  extend T::Sig

  sig { returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def all(); end

  sig { params(block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def deleted_after_time(*args); end

  sig { params(args: T.untyped).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def deleted_before_time(*args); end

  sig { params(args: T.untyped).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def deleted_inside_time_window(*args); end

  sig { params(args: T.untyped).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def order_by_program_name(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def select(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def order(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def reorder(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def group(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def limit(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def offset(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def joins(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def where(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def rewhere(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def preload(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def eager_load(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def includes(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def from(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def lock(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def readonly(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def or(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def having(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def create_with(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def distinct(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def references(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def none(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def unscope(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ProgramStreamPermission::ActiveRecord_Relation) }
  def except(*args, &block); end

end
