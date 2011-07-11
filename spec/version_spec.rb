require 'spec_helper'

describe Version do
  
  subject { Version.new(2.9) }
  
  its(:major)       { should == '2'   }
  its(:minor)       { should == '9'   }
  its(:revision)    { should be_nil   }
  its(:prerelease?) { should be_false }
  
  it 'should bump to 2.10' do
    subject.bump!.should == '2.10'
  end
  
  it 'should major-bump to 3.0' do
    subject.bump!(:major).should == '3.0'
  end
  
  it 'should minor-bump to 2.10' do
    subject.bump!(:minor).should == '2.10'
  end
  
  it 'should revision-bump to 2.9.1' do
    subject.bump!(:revision).should == '2.9.1'
  end
  
  it 'should prerelease-bump to 2.10a' do
    subject.bump!(:pre).should == '2.10a'
  end
  
  it 'should prerelease-bump major to 3_0a' do
    subject.bump!(:major, true).should == '3.0a'
  end
  
  it 'should prerelease-bump minor to 2.10a' do
    subject.bump!(:minor, true).should == '2.10a'
  end
  
  it 'should prerelease-bump revision to 2.9.1a' do
    subject.bump!(:revision, true).should == '2.9.1a'
  end
end

describe Version do
  
  subject { Version.new('0.10.0') }
  
  its(:major)       { should == '0'   }
  its(:minor)       { should == '10'   }
  its(:revision)    { should == '0'   }
  its(:prerelease?) { should be_false }
  
  it 'should bump to 0.10.1' do
    subject.bump!.should == '0.10.1'
  end
  
  it 'should major-bump to 1.0.0' do
    subject.bump!(:major).should == '1.0.0'
  end
  
  it 'should minor-bump to 0.11.0' do
    subject.bump!(:minor).should == '0.11.0'
  end
  
  it 'should revision-bump to 0.10.1' do
    subject.bump!(:revision).should == '0.10.1'
  end
  
  it 'should prerelease-bump to 0.10.1a' do
    subject.bump!(:pre).should == '0.10.1a'
  end
  
  it 'should prerelease-bump major to 1.0.0a' do
    subject.bump!(:major, true).should == '1.0.0a'
  end
  
  it 'should prerelease-bump minor to 0.11.0a' do
    subject.bump!(:minor, true).should == '0.11.0a'
  end
  
  it 'should prerelease-bump revision to 0.10.1a' do
    subject.bump!(:revision, true).should == '0.10.1a'
  end
end


describe Version, 'with a prerelease revision' do
  
  subject { Version.new('1.6.3a') }
  
  its(:major)       { should == '1'  }
  its(:minor)       { should == '6'  }
  its(:revision)    { should == '3a' }
  its(:prerelease?) { should be_true }
  
  it 'should bump to 1.6.3' do
    subject.bump!.should == '1.6.3'
  end
  
  it 'should major-bump to 2.0.0' do
    subject.bump!(:major).should == '2.0.0'
  end
  
  it 'should minor-bump to 1.7.0' do
    subject.bump!(:minor).should == '1.7.0'
  end
  
  it 'should revision-bump to 1.6.3' do
    subject.bump!(:revision).should == '1.6.3'
  end
  
  it 'should prerelease-bump to 1.6.3b' do
    subject.bump!(:pre).should == '1.6.3b'
  end
  
  it 'should prerelease-bump major to 2.0.0a' do
    subject.bump!(:major, true).should == '2.0.0a'
  end
  
  it 'should prerelease-bump minor to 1.7.0a' do
    subject.bump!(:minor, true).should == '1.7.0a'
  end
  
  it 'should prerelease-bump revision to 1.6.4a' do
    subject.bump!(:revision, true).should == '1.6.4a'
  end
end

describe Version, 'with a prerelease minor version' do
  
  subject { Version.new('1.6a') }
  
  its(:major)       { should == '1'  }
  its(:minor)       { should == '6a'  }
  its(:revision)    { should == nil }
  its(:prerelease?) { should be_true }
  
  it 'should bump to 1.6' do
    subject.bump!.should == '1.6'
  end
  
  it 'should major-bump to 2.0' do
    subject.bump!(:major).should == '2.0'
  end
  
  it 'should minor-bump to 1.6' do
    subject.bump!(:minor).should == '1.6'
  end
  
  it 'should revision-bump to 1.6.1' do
    subject.bump!(:revision).should == '1.6.1'
  end
  
  it 'should bump to 1.6b' do
    subject.bump!(:pre).should == '1.6b'
  end
  
  it 'should prerelease-bump major to 2.0a' do
    subject.bump!(:major, true).should == '2.0a'
  end
  
  it 'should prerelease-bump minor to 1.7a' do
    subject.bump!(:minor, true).should == '1.7a'
  end
  
  it 'should prerelease-bump revision to 1.6.1a' do
    subject.bump!(:revision, true).should == '1.6.1a'
  end
end

describe Version do
  
  it 'should preserve equality' do
    Version.new('0.0').should       == '0.0'
    Version.new('0.1.1').should     == '0.1.1'
    Version.new('0.4.alpha').should == '0.4.alpha'
    Version.new('1.0.2').should     == '1.0.2'
    Version.new('1.0.2b').should    == '1.0.2b'
    Version.new('1.01').should      == '1.01'
    Version.new('1.10').should      == '1.10'
    Version.new('2.0').should       == '2.0'
    Version.new('a').should         == 'b'
  end
  
  it 'should order correctly' do
    Version.new('0.0').should     < '0.0.0.0.0.1'
    Version.new('0.0.0.1').should < '1'
    Version.new('0.1a').should    < '0.1'
    Version.new('0.01').should    < '0.10'
    Version.new('0.9').should     < '0.10'
  end
end
