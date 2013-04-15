require_relative '../learning'

describe Fibonacci do
  subject { Object.new.extend(Fibonacci) }

  describe 'the input' do
    it 'should give me the stuff' do
      subject.look_at_this([1,2,3]).take(3).force.should == [1,2,3]
    end

    it 'should give me unknown after the stuff' do
      subject.look_at_this([]).take(3).force.should == [:unknown,:unknown,:unknown]
    end
  end
end
describe 'the learning of ordinary fib' do
  subject { Object.new.extend(Fibonacci).rabbits([1,1,2],n) }

  context ('1') do
    let(:n) { 1 }
    it { should == 1 }
  end
  context ('2') do
    let(:n) { 2 }
    it { should == 1 }
  end
  context ('3') do
    let(:n) { 3 }
    it { should == 2 }
  end
  context ('4') do
    let(:n) { 4 }
    it { should == 3 }
  end
  context ('5') do
    let(:n) { 5 }
    it { should == 5 }
  end
  context ('6') do
    let(:n) { 6 }
    it { should == 8 }
  end
end

describe 'the learning of k = 3' do
  subject { Object.new.extend(Fibonacci).rabbits([1,1,4],n) }

  context ('4') do
    let(:n) { 4 }
    it { should == 7 }
  end
  context ('5') do
    let(:n) { 5 }
    it { should == 19 }
  end
end

describe 'the learning of k is approximately 3' do
  # 1, 1
  # then k = 2, so f(3) = 1 + (1 * 2) = 3
  # then k = 4, so f(4) = 3 + (1 * 4) = 7
  # and then unknown. We'll average k to 3 and predict 7 + (3 * 3) = 16
  subject { Object.new.extend(Fibonacci).rabbits([1,1,3,7],n) }

  context ('4') do
    let(:n) { 4 }
    it { should == 7 }
  end
  context ('5') do
    let(:n) { 5 }
    it { should == 16 }
  end
end

