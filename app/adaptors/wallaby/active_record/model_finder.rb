class Wallaby::ActiveRecord::ModelFinder < Wallaby::ModelFinder
  protected
  def all
    Rails.cache.fetch 'wallaby/model_finder' do
      ActiveRecord::Base.subclasses.reject do |model_class|
        model_class.abstract_class? ||
        /ActiveRecord::SchemaMigration|HABTM|#<Class/ =~ model_class.to_s
      end.sort_by &:to_s
    end
  end
end
