require 'spec_helper'

descrive ValueAdjustment do
  let(:params) { [ sym, dt_in, opts = {} ] }
  subject { ValueAdjustment.new(*params) }
end