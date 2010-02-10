require 'spec_helper'

describe Version do
  it 'should preserve equality' do
    v0_0.should       == v0_0
    v0_1_1.should     == v0_1_1
    v0_4_alpha.should == v0_4_alpha
    v1_0_2.should     == v1_0_2
    v1_0_2b.should    == v1_0_2b
    v1_01.should      == v1_01
    v1_10.should      == v1_10
    v2_0.should       == v2_0
    va.should         == vb
  end
  
  it 'should order correctly' do
    v0_0.should     < v0_0_0_0_0_1
    v0_0_0_1.should < v1
    v0_1a.should    < v0_1
    v0_01.should    < v0_10
    v0_9.should     < v0_10
  end
  
  def method_missing(name, *args, &block)
    super unless args.empty?
    super unless block.nil?
    super unless name.to_s =~ /^v[\d\w_]+$/
    
    name.to_s.gsub(/^v/, '').gsub(/_/, '.').to_version
  end
end
