require 'spec_helper'

module ImplicitVersion
  def method_missing(name, *args, &block)
    super unless args.empty?
    super unless block.nil?
    super unless name.to_s =~ /^v[\d\w_]+$/
    
    Version.new name.to_s.gsub(/^v/, '').gsub(/_/, '.')
  end
end

describe Version do
  include ImplicitVersion
  
  subject { v2_9 }
  
  its(:major)       { should == '2'   }
  its(:minor)       { should == '9'   }
  its(:revision)    { should be_nil   }
  its(:prerelease?) { should be_false }
  
  it 'should bump to 2.10' do
    subject.bump!.should == v2_10
  end
  
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
  
  it 'should prerelease-bump major to 3_0a' do
    subject.bump!(:major, true).should == v3_0a
  end
  
  it 'should prerelease-bump minor to 2.10a' do
    subject.bump!(:minor, true).should == v2_10a
  end
  
  it 'should prerelease-bump revision to 2.9.1a' do
    subject.bump!(:revision, true).should == v2_9_1a
  end
end

describe Version do
  include ImplicitVersion
  
  subject { v0_10_0 }
  
  its(:major)       { should == '0'   }
  its(:minor)       { should == '10'   }
  its(:revision)    { should == '0'   }
  its(:prerelease?) { should be_false }
  
  it 'should bump to 0.10.1' do
    subject.bump!.should == v0_10_1
  end
  
  it 'should major-bump to 1.0.0' do
    subject.bump!(:major).should == v1_0_0
  end
  
  it 'should minor-bump to 0.11.0' do
    subject.bump!(:minor).should == v0_11_0
  end
  
  it 'should revision-bump to 0.10.1' do
    subject.bump!(:revision).should == v0_10_1
  end
  
  it 'should prerelease-bump to 0.10.1a' do
    subject.bump!(:pre).should == v0_10_1a
  end
  
  it 'should prerelease-bump major to 1.0.0a' do
    subject.bump!(:major, true).should == v1_0_0a
  end
  
  it 'should prerelease-bump minor to 0.11.0a' do
    subject.bump!(:minor, true).should == v0_11_0a
  end
  
  it 'should prerelease-bump revision to 0.10.1a' do
    subject.bump!(:revision, true).should == v0_10_1a
  end
end


describe Version, 'with a prerelease revision' do
  include ImplicitVersion
  
  subject { v1_6_3a }
  
  its(:major)       { should == '1'  }
  its(:minor)       { should == '6'  }
  its(:revision)    { should == '3a' }
  its(:prerelease?) { should be_true }
  
  it 'should bump to 1.6.3' do
    subject.bump!.should == v1_6_3
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
  
  it 'should prerelease-bump major to 2.0.0a' do
    subject.bump!(:major, true).should == v2_0_0a
  end
  
  it 'should prerelease-bump minor to 1.7.0a' do
    subject.bump!(:minor, true).should == v1_7_0a
  end
  
  it 'should prerelease-bump revision to 1.6.4a' do
    subject.bump!(:revision, true).should == v1_6_4a
  end
end

describe Version, 'with a prerelease minor version' do
  include ImplicitVersion
  
  subject { v1_6a }
  
  its(:major)       { should == '1'  }
  its(:minor)       { should == '6a'  }
  its(:revision)    { should == nil }
  its(:prerelease?) { should be_true }
  
  it 'should bump to 1.6' do
    subject.bump!.should == v1_6
  end
  
  it 'should major-bump to 2.0' do
    subject.bump!(:major).should == v2_0
  end
  
  it 'should minor-bump to 1.6' do
    subject.bump!(:minor).should == v1_6
  end
  
  it 'should revision-bump to 1.6.1' do
    subject.bump!(:revision).should == v1_6_1
  end
  
  it 'should bump to 1.6b' do
    subject.bump!(:pre).should == v1_6b
  end
  
  it 'should prerelease-bump major to 2.0a' do
    subject.bump!(:major, true).should == v2_0a
  end
  
  it 'should prerelease-bump minor to 1.7a' do
    subject.bump!(:minor, true).should == v1_7a
  end
  
  it 'should prerelease-bump revision to 1.6.1a' do
    subject.bump!(:revision, true).should == v1_6_1a
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
