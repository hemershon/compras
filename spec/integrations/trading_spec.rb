# encoding: utf-8
require "spec_helper"

describe Trading do
  describe "validations" do
    it "doesn't allow the same licitation process to be used more than once" do 
      Trading.make!(:pregao_presencial)

      expect(subject).to validate_uniqueness_of :licitation_process_id
    end

    it "validates if year is present" do
      trading = Trading.make(:pregao_presencial,
                             :year => nil)

      trading.valid?

      expect(trading.errors.full_messages).to include "Ano não pode ficar em branco"
    end
  end
end