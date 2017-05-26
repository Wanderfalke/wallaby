module Wallaby
  class ActiveRecord
    # Model operator
    class ModelHandler < ::Wallaby::ModelHandler
      def collection(params, ability)
        query = querier.search params
        query = query.order params[:sort] if params[:sort].present?
        query.accessible_by ability
      end

      def new(params)
        @model_class.new permit params
      rescue ::ActionController::ParameterMissing
        @model_class.new {}
      end

      def find(id, _params)
        @model_class.find id
      rescue ::ActiveRecord::RecordNotFound
        raise ResourceNotFound
      end

      def create(params, ability)
        resource = @model_class.new
        resource.assign_attributes normalize permit(params)
        ensure_attributes_for ability, :create, resource
        resource.save if valid? resource
        [resource, resource.errors.blank?]
      rescue ::ActiveRecord::StatementInvalid => e
        resource.errors.add :base, e.message
        [resource, false]
      end

      def update(resource, params, ability)
        resource.assign_attributes normalize permit(params)
        ensure_attributes_for ability, :update, resource
        resource.save if valid? resource
        [resource, resource.errors.blank?]
      rescue ::ActiveRecord::StatementInvalid => e
        resource.errors.add :base, e.message
        [resource, false]
      end

      def destroy(resource, _params)
        resource.destroy
      end

      protected

      def permit(params)
        fields =
          permitter.simple_field_names << permitter.compound_hashed_fields
        params.require(param_key).permit(fields)
      end

      def normalize(params)
        normalizer.normalize params
      end

      def valid?(resource)
        validator.valid? resource
      end

      def ensure_attributes_for(ability, action, resource)
        return if ability.blank?
        restricted_conditions = ability.attributes_for action, resource
        resource.assign_attributes restricted_conditions
      end

      def param_key
        @model_class.model_name.param_key
      end

      def permitter
        @permitter ||= Permitter.new @model_decorator
      end

      def querier
        @querier ||= Querier.new @model_decorator
      end

      def normalizer
        @normalizer ||= Normalizer.new @model_decorator
      end

      def validator
        @validator ||= Validator.new @model_decorator
      end
    end
  end
end