# encoding: utf-8
require 'spec_helper'

describe LicitationProcessesHelper do
  describe '#accreditation_path_helper' do
    let(:resource) { double(:resource, :id => 1) }
    let(:purchase_process_accreditation) { double(:purchase_process_accreditation, :id => 2, :to_param => '2') }

    before do
      helper.stub(:resource => resource)
    end

    context 'when resource is not persisted' do
      before do
        resource.stub(:persisted? => false)
      end

      it 'should return nil' do
        expect(helper.accreditation_path_helper).to be_nil
      end
    end

    context 'when resource is persisted' do
      before do
        resource.stub(:persisted? => true)
      end

      context 'when resource has a purchase_process_accreditation' do
        before do
          resource.stub(:purchase_process_accreditation => purchase_process_accreditation)
        end

        it  'should return the link to edit the purchase_process_accreditation' do
          expect(helper.accreditation_path_helper).to eq '/purchase_process_accreditations/2/edit?licitation_process_id=1'
        end
      end

      context 'when resource have not a purchase_process_accreditation' do
        before do
          resource.stub(:purchase_process_accreditation => nil)
        end

        it  'should return the link to a new purchase_process_accreditation' do
          expect(helper.accreditation_path_helper).to eq '/purchase_process_accreditations/new?licitation_process_id=1'
        end
      end
    end
  end

  describe '#proposals_path' do
    let(:judgment_form) { double :judgment_form }
    let(:resource)      { double :resource }

    before do
      helper.stub(resource: resource)
      resource.stub(:judgment_form).and_return judgment_form
    end

    context 'when licitation process judged by item' do
      before { judgment_form.stub(:kind).and_return :item }

      it 'returns a path to creditors_purchase_process_item_creditor_proposals_path' do
        helper.should_receive(:send).with('creditors_purchase_process_item_creditor_proposals_path', licitation_process_id: resource)
        helper.proposals_path
      end
    end

    context 'when licitation process judged by lot' do
      before { judgment_form.stub(:kind).and_return :lot }

      it 'returns a path to creditors_purchase_process_lot_creditor_proposals_path' do
        helper.should_receive(:send).with('creditors_purchase_process_lot_creditor_proposals_path', licitation_process_id: resource)
        helper.proposals_path
      end
    end

    context 'when licitation process global judged' do
      before { judgment_form.stub(:kind).and_return :global }

      it 'returns a path to creditors_purchase_process_global_creditor_proposals_path' do
        helper.should_receive(:send).with('creditors_purchase_process_global_creditor_proposals_path', licitation_process_id: resource)
        helper.proposals_path
      end
    end
  end
end
