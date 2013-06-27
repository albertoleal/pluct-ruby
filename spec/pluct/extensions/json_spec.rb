require File.join [Pluct.root, 'lib/pluct/extensions/json']

describe JSON do
  it 'returns false for invalid data' do
    ['', ' ', 'string'].each do |s|
      expect(JSON.is_json?(s)).to be_false
    end
  end

  it 'returns true for valid data' do  
    expect(JSON.is_json?('{"name" : "foo"}')).to be_true
  end
end