require 'decorator_helper'
require 'app/decorators/communication_source_decorator'

describe CommunicationSourceDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have description' do
      expect(described_class.header_attributes).to include :description
    end
  end
end
