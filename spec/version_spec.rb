require 'spec_helper'

module ImplicitVersion
  def method_missing(name, *args, &block)
    super unless args.empty?
    super unless block.nil?
    super unless name.to_s =~ /^v[\d\w_]+$/
    
    name.to_s.gsub(/^v/, '').gsub(/_/, '.').to_version
  end
end

describe Version do
  include ImplicitVersion
  
  subject { v2_9 }
  
  its(:major)       { should == '2'   }
  its(:minor)       { should == '9'   }
  its(:revision)    { should be_nil   }
  its(:prerelease?) { should be_false }
  
  it 'should major-bump to 3.0' do
    subject.bump!(:major).should == v3_0
  end
  
  it 'should minor-bump to 2.10' do
    subject.bump!(:minor).should == v2_10
  end
  
  it 'should revision-bump to 2.9.1' do
    subject.bump!(:revision).should == v2_9_1
  end
  
  it 'should prerelease-bump to 2.10a' do
    subject.bump!(:pre).should == v2_10a
  end
end

describe Version, 'with a prerelease version' do
  include ImplicitVersion
  
  subject { v1_6_3a }
  
  its(:major)       { should == '1'  }
  its(:minor)       { should == '6'  }
  its(:revision)    { should == '3a' }
  its(:prerelease?) { should be_true }
  
  it 'should allow indexed access to components' do
    subject[0].should == '1'
    subject[1].should == '6'
    subject[2].should == '3a'
  end
  
  it 'should return nil for unset components' do
    subject[3].should == nil
    subject[4].should == nil
  end
  
  it 'should major-bump to 2.0.0' do
    subject.bump!(:major).should == v2_0_0
  end
  
  it 'should minor-bump to 1.7.0' do
    subject.bump!(:minor).should == v1_7_0
  end
  
  it 'should revision-bump to 1.6.3' do
    subject.bump!(:revision).should == v1_6_3
  end
  
  it 'should prerelease-bump to 1.6.3b' do
    subject.bump!(:pre).should == v1_6_3b
  end
end

describe Version do
  include ImplicitVersion
  
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
end
