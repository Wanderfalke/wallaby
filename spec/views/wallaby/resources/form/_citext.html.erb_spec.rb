require 'rails_helper'

partial_name = 'form/citext'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{ partial_name }.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, { } }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :citext }
  let(:value)       { '<b>this is a text for more than 20 characters</b>' }
  let(:metadata)    { Hash.new }

  before do
    expect(view).to receive :content_for
    render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata
  end

  it 'renders the citext form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_citext\">Citext</label>\n  <textarea class=\"form-control\" data-init=\"summernote\" name=\"all_postgres_type[citext]\" id=\"all_postgres_type_citext\">\n&lt;b&gt;this is a text for more than 20 characters&lt;/b&gt;</textarea>\n  \n</div>\n\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_citext\">Citext</label>\n  <textarea class=\"form-control\" data-init=\"summernote\" name=\"all_postgres_type[citext]\" id=\"all_postgres_type_citext\">\n</textarea>\n  \n</div>\n\n"
    end
  end
end
