require 'spec_helper'

describe Idea do
  it { should validate_presence_of(:description)}
  it { should validate_presence_of(:price)}
  it { should validate_presence_of(:recipient)}

end