require 'rails_helper'

describe 'partial' do
  let(:partial)     { "wallaby/resources/form/#{ field_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :datetime }
  let(:value)       { Time.new 2014, 2, 11, 23, 59, 59, '+00:00' }
  let(:metadata)    { Hash.new }

  before do
    expect(view).to receive :content_for
    render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata
  end

  it 'renders the datetime form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_datetime\">Datetime</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group date\" data-init='datetimepicker'>\n        <input value=\"2014-02-11 23:59:59 +0000\" class=\"form-control\" type=\"text\" name=\"all_postgres_type[datetime]\" id=\"all_postgres_type_datetime\" />\n        <span class=\"input-group-addon\"><i class=\"glyphicon glyphicon-calendar\"></i></span>\n      </div>\n    </div>\n  </div>\n  \n</div>\n\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_datetime\">Datetime</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-3\">\n      <div class=\"input-group date\" data-init='datetimepicker'>\n        <input class=\"form-control\" type=\"text\" name=\"all_postgres_type[datetime]\" id=\"all_postgres_type_datetime\" />\n        <span class=\"input-group-addon\"><i class=\"glyphicon glyphicon-calendar\"></i></span>\n      </div>\n    </div>\n  </div>\n  \n</div>\n\n"
    end
  end
end