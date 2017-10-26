class CustomFieldPropertiesController < AdminController
  load_and_authorize_resource

  include FormBuilderAttachments

  before_action :find_entity, :find_custom_field
  before_action :find_custom_field_property, only: [:edit, :update, :destroy]
  before_action :get_form_builder_attachments, only: [:edit, :update]
  before_action -> { check_user_permission('editable') }, except: [:index, :show]
  before_action -> { check_user_permission('readable') }, only: [:show, :index]

  def index
    @custom_field_properties = @custom_formable.custom_field_properties.accessible_by(current_ability).by_custom_field(@custom_field).most_recents.page(params[:page]).per(4)
  end

  def new
    @custom_field_property = @custom_formable.custom_field_properties.new(custom_field_id: @custom_field)
    @attachments = @custom_field_property.form_builder_attachments
    authorize! :new, @custom_field_property
  end

  def edit
    authorize! :edit, @custom_field_property
  end

  def create
    @custom_field_property = @custom_formable.custom_field_properties.new(custom_field_property_params)
    authorize! :create, @custom_field_property
    if @custom_field_property.save
      redirect_to polymorphic_path([@custom_formable, CustomFieldProperty], custom_field_id: @custom_field), notice: t('.successfully_created')
    else
      render :new
    end
  end

  def update
    authorize! :update, @custom_field_property
    if @custom_field_property.update_attributes(custom_field_property_params)
      add_more_attachments(@custom_field_property)
      redirect_to polymorphic_path([@custom_formable, CustomFieldProperty], custom_field_id: @custom_field), notice: t('.successfully_updated')
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @custom_field_property
    name = params[:file_name]
    index = params[:file_index].to_i
    if name.present? && index.present?
      delete_form_builder_attachment(@custom_field_property, name, index)
      redirect_to request.referer, notice: t('.delete_attachment_successfully')
    else
      @custom_field_property.destroy
      redirect_to polymorphic_path([@custom_formable, CustomFieldProperty], custom_field_id: @custom_field), notice: t('.successfully_deleted')
    end
  end

  private

  def custom_field_property_params
    properties_params.values.map{ |v| v.delete('') if (v.is_a?Array) && v.size > 1 } if properties_params.present?

    default_params = params.require(:custom_field_property).permit({}).merge(custom_field_id: params[:custom_field_id])
    default_params = default_params.merge(properties: properties_params) if properties_params.present?
    default_params = default_params.merge(form_builder_attachments_attributes: attachment_params) if action_name == 'create' && attachment_params.present?
    default_params
  end

  def get_form_builder_attachments
    @attachments = @custom_field_property.form_builder_attachments
  end

  def find_custom_field_property
    @custom_field_property = @custom_formable.custom_field_properties.find(params[:id])
  end

  def find_custom_field
    @custom_field = CustomField.find_by(entity_type: @custom_formable.class.name, id: params[:custom_field_id])
    raise ActionController::RoutingError.new('Not Found') if @custom_field.nil?
  end

  def find_entity
    if params[:client_id].present?
      @custom_formable = Client.accessible_by(current_ability).friendly.find(params[:client_id])
    elsif params[:family_id].present?
      @custom_formable = Family.find(params[:family_id])
    elsif params[:partner_id].present?
      @custom_formable = Partner.find(params[:partner_id])
    elsif params[:user_id].present?
      @custom_formable = User.find(params[:user_id])
    end
  end

  def check_user_permission(permission)
    unless current_user.admin? || current_user.strategic_overviewer?
      permission_set = current_user.custom_field_permissions.find_by(custom_field_id: @custom_field)[permission]
      redirect_to root_path, alert: t('unauthorized.default') unless permission_set
    end
  end
end
