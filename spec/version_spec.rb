require 'rspec/its'

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
  
  its(:major)       { is_expected.to eq('2')  }
  its(:minor)       { is_expected.to eq('9')  }
  its(:revision)    { is_expected.to be_nil   }
  its(:prerelease?) { is_expected.to be_falsey }
  
  it 'is_expected.to bump to 2.10' do
    expect(subject.bump!).to eq(v2_10)
  end
  
  it 'is_expected.to major-bump to 3.0' do
    expect(subject.bump!(:major)).to eq(v3_0)
  end
  
  it 'is_expected.to minor-bump to 2.10' do
    expect(subject.bump!(:minor)).to eq(v2_10)
  end
  
  it 'is_expected.to revision-bump to 2.9.1' do
    expect(subject.bump!(:revision)).to eq(v2_9_1)
  end
  
  it 'is_expected.to prerelease-bump to 2.10a' do
    expect(subject.bump!(:pre)).to eq(v2_10a)
  end
  
  it 'is_expected.to prerelease-bump major to 3_0a' do
    expect(subject.bump!(:major, true)).to eq(v3_0a)
  end
  
  it 'is_expected.to prerelease-bump minor to 2.10a' do
    expect(subject.bump!(:minor, true)).to eq(v2_10a)
  end
  
  it 'is_expected.to prerelease-bump revision to 2.9.1a' do
    expect(subject.bump!(:revision, true)).to eq(v2_9_1a)
  end
end

describe Version do
  include ImplicitVersion
  
  subject { v0_10_0 }
  
  its(:major)       { is_expected.to eq('0')   }
  its(:minor)       { is_expected.to eq('10')   }
  its(:revision)    { is_expected.to eq('0')   }
  its(:prerelease?) { is_expected.to be_falsey }
  
  it 'is_expected.to bump to 0.10.1' do
    expect(subject.bump!).to eq(v0_10_1)
  end
  
  it 'is_expected.to major-bump to 1.0.0' do
    expect(subject.bump!(:major)).to eq(v1_0_0)
  end
  
  it 'is_expected.to minor-bump to 0.11.0' do
    expect(subject.bump!(:minor)).to eq(v0_11_0)
  end
  
  it 'is_expected.to revision-bump to 0.10.1' do
    expect(subject.bump!(:revision)).to eq(v0_10_1)
  end
  
  it 'is_expected.to prerelease-bump to 0.10.1a' do
    expect(subject.bump!(:pre)).to eq(v0_10_1a)
  end
  
  it 'is_expected.to prerelease-bump major to 1.0.0a' do
    expect(subject.bump!(:major, true)).to eq(v1_0_0a)
  end
  
  it 'is_expected.to prerelease-bump minor to 0.11.0a' do
    expect(subject.bump!(:minor, true)).to eq(v0_11_0a)
  end
  
  it 'is_expected.to prerelease-bump revision to 0.10.1a' do
    expect(subject.bump!(:revision, true)).to eq(v0_10_1a)
  end
end


describe Version, 'with a prerelease revision' do
  include ImplicitVersion
  
  subject { v1_6_3a }
  
  its(:major)       { is_expected.to eq('1')  }
  its(:minor)       { is_expected.to eq('6')  }
  its(:revision)    { is_expected.to eq('3a') }
  its(:prerelease?) { is_expected.to be_truthy }
  
  it 'is_expected.to bump to 1.6.3' do
    expect(subject.bump!).to eq(v1_6_3)
  end
  
  it 'is_expected.to major-bump to 2.0.0' do
    expect(subject.bump!(:major)).to eq(v2_0_0)
  end
  
  it 'is_expected.to minor-bump to 1.7.0' do
    expect(subject.bump!(:minor)).to eq(v1_7_0)
  end
  
  it 'is_expected.to revision-bump to 1.6.3' do
    expect(subject.bump!(:revision)).to eq(v1_6_3)
  end
  
  it 'is_expected.to prerelease-bump to 1.6.3b' do
    expect(subject.bump!(:pre)).to eq(v1_6_3b)
  end
  
  it 'is_expected.to prerelease-bump major to 2.0.0a' do
    expect(subject.bump!(:major, true)).to eq(v2_0_0a)
  end
  
  it 'is_expected.to prerelease-bump minor to 1.7.0a' do
    expect(subject.bump!(:minor, true)).to eq(v1_7_0a)
  end
  
  it 'is_expected.to prerelease-bump revision to 1.6.4a' do
    expect(subject.bump!(:revision, true)).to eq(v1_6_4a)
  end
end

describe Version, 'with a prerelease minor version' do
  include ImplicitVersion
  
  subject { v1_6a }
  
  its(:major)       { is_expected.to eq('1')  }
  its(:minor)       { is_expected.to eq('6a')  }
  its(:revision)    { is_expected.to eq(nil) }
  its(:prerelease?) { is_expected.to be_truthy }
  
  it 'is_expected.to bump to 1.6' do
    expect(subject.bump!).to eq(v1_6)
  end
  
  it 'is_expected.to major-bump to 2.0' do
    expect(subject.bump!(:major)).to eq(v2_0)
  end
  
  it 'is_expected.to minor-bump to 1.6' do
    expect(subject.bump!(:minor)).to eq(v1_6)
  end
  
  it 'is_expected.to revision-bump to 1.6.1' do
    expect(subject.bump!(:revision)).to eq(v1_6_1)
  end
  
  it 'is_expected.to bump to 1.6b' do
    expect(subject.bump!(:pre)).to eq(v1_6b)
  end
  
  it 'is_expected.to prerelease-bump major to 2.0a' do
    expect(subject.bump!(:major, true)).to eq(v2_0a)
  end
  
  it 'is_expected.to prerelease-bump minor to 1.7a' do
    expect(subject.bump!(:minor, true)).to eq(v1_7a)
  end
  
  it 'is_expected.to prerelease-bump revision to 1.6.1a' do
    expect(subject.bump!(:revision, true)).to eq(v1_6_1a)
  end
end

describe Version do
  include ImplicitVersion
  
  it 'is_expected.to preserve equality' do
    expect(v0_0).to       eq(v0_0)
    expect(v0_1_1).to     eq(v0_1_1)
    expect(v0_4_alpha).to eq(v0_4_alpha)
    expect(v1_0_2).to     eq(v1_0_2)
    expect(v1_0_2b).to    eq(v1_0_2b)
    expect(v1_01).to      eq(v1_01)
    expect(v1_10).to      eq(v1_10)
    expect(v2_0).to       eq(v2_0)
    expect(va).to         eq(vb)
  end
  
  it 'is_expected.to order correctly' do
    expect(v0_0).to be      < v0_0_0_0_0_1
    expect(v0_0_0_1).to be  < v1
    expect(v0_1a).to be     < v0_1
    expect(v0_01).to be     < v0_10
    expect(v0_9).to be      < v0_10
  end
end
