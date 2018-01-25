require 'spec_helper'
require 'activerecord_flow/flow_type_generator'

RSpec.describe ActiverecordFlow::FlowTypeGenerator do
  context 'not an activerecord object' do
    it 'raises error' do
      flow_type_gen = ActiverecordFlow::FlowTypeGenerator.new(klass: Model)

      expect { flow_type_gen.convert }.to raise_error(
        'Not an ActiveRecord object'
      )
    end
  end

  context 'when it is an activerecord object' do
    it 'returns the flow type configuration' do
      flow_type_gen = ActiverecordFlow::FlowTypeGenerator.new(klass: User)

      flow_type_def = "type User = {
  id: number,
  username: ?string,
  password: ?string,
  created_at: Date,
  updated_at: Date,
};
"
      flow_type_gen.convert

      expect(flow_type_gen.render).to eq(flow_type_def)
    end
  end
end
