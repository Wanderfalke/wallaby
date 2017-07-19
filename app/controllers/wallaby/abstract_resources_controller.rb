module Wallaby
  # Generic CRUD controller
  class AbstractResourcesController < BaseController
    respond_to :html, :json
    self.responder = ResourcesResponder
    helper ResourcesHelper

    def self.resources_name
      return unless self < ::Wallaby::ResourcesController
      Map.resources_name_map name.gsub('Controller', EMPTY_STRING)
    end

    def self.model_class
      return unless self < ::Wallaby::ResourcesController
      Map.model_class_map name.gsub('Controller', EMPTY_STRING)
    end

    def index
      authorize! :index, current_model_class
      collection
    end

    def new
      authorize! :new, new_resource
    end

    def create
      authorize! :create, current_model_class
      @resource, _is_success =
        current_model_service.create params, current_ability
      respond_with resource, location: resources_index_path
    end

    def show
      authorize! :show, resource
    end

    def edit
      authorize! :edit, resource
    end

    def update
      authorize! :update, resource
      @resource, _is_success =
        current_model_service.update resource, params, current_ability
      respond_with resource, location: resources_show_path
    end

    def destroy
      authorize! :destroy, resource
      is_success = current_model_service.destroy resource, params
      respond_with \
        resource,
        location: -> { is_success ? resources_index_path : resources_show_path }
    end

    protected

    def _prefixes
      @_prefixes ||= PrefixesBuilder.new(
        super, controller_path, current_resources_name, params
      ).build
    end

    def lookup_context
      @_lookup_context ||= LookupContextWrapper.new super
    end

    def resources_index_path(name = current_resources_name)
      wallaby_engine.resources_path name
    end

    def resources_show_path(name = current_resources_name, id = resource_id)
      wallaby_engine.resource_path name, id
    end

    def current_model_service
      @current_model_service ||= Map.servicer_map current_model_class
    end

    def new_resource
      @resource ||= current_model_service.new params
    end

    begin # helper methods
      helper_method \
        :resource_id, :resource, :collection, :current_model_decorator

      def resource_id
        params[:id]
      end

      def collection
        @collection ||= begin
          page_number = params[:page]
          per_number  = params[:per] || 20

          query = current_model_service.collection params, current_ability
          query = query.page page_number if query.respond_to? :page
          query = query.per per_number if query.respond_to? :per
          query
        end
      end

      def resource
        @resource ||= current_model_service.find resource_id, params
      end

      def current_model_decorator
        @current_model_decorator ||= Map.model_decorator_map current_model_class
      end
    end
  end
end