require_relative '../lib/aqueductron'

module Aqueductron
  describe Duct do
    describe 'this weird pipeline thing' do
      let(:input) { ["one","two","three"]}
      let(:new_builder) { Duct.new() }
      let(:builder) { new_builder }

      it 'can generate the pipeline dynamically' do
        make_a_pipeline = ->(e) { Duct.new().answer(Monoid.concat)}
        categorize = ->(e) { e.length }

        result = Duct.new().partition(categorize, make_a_pipeline).flow(input).value
        result.value(3).should == "onetwo"
        result.value(5).should == "three"

        result.keys.should == [3,5] #this test doesn't really belong here
      end
    end
  end
end
