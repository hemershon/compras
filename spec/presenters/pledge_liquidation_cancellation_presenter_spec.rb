require 'presenter_helper'
require 'app/presenters/pledge_liquidation_cancellation_presenter'

describe PledgeLiquidationCancellationPresenter do
  subject do
    described_class.new(pledge_liquidation_cancellation, nil, helpers)
  end

  let :pledge_liquidation_cancellation do
    double('PledgeLiquidationCancellation')
  end

  let :date do
    Date.new(2012, 12, 1)
  end

  let :helpers do
    double 'helpers'
  end

  it 'should return emission date' do
    helpers.stub(:l).with(date).and_return('01/12/2012')
    pledge_liquidation_cancellation.stub(:emission_date).and_return(date)

    subject.emission_date.should eq '01/12/2012'
  end

  it 'should return expiration_date' do
    helpers.stub(:l).with(date).and_return('01/12/2012')
    pledge_liquidation_cancellation.stub(:expiration_date).and_return(date)

    subject.expiration_date.should eq '01/12/2012'
  end

  it 'should return balance' do
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')
    pledge_liquidation_cancellation.stub(:balance).and_return(9.99)

    subject.balance.should eq '9,99'
  end

  it 'should return expiration_date' do
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')
    pledge_liquidation_cancellation.stub(:pledge_value).and_return(9.99)

    subject.pledge_value.should eq '9,99'
  end
end
