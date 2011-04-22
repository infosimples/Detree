require 'spec_helper'

def valid_node
  node = Detree::Node.new(:text => 'Sample', :name => 'html')
  node.new_child :text => '', :name => 'head'
  node.new_child :text => 'Sample Body', :name => 'body'
  node
end

describe Detree::Node do
  
  it "must have text (can be empty)" do
    node = valid_node
    node.text = nil
    node.should_not be_valid
  end
  
  it "must have name" do
    node = valid_node
    node.name = ''
    node.should_not be_valid
  end
  
  it "must indent text" do
    node = valid_node
    node.text = "Sample\nIndent\n\tMore\n\t\tDouble"
    node.text_indented_by(1).should == "\tSample\n\tIndent\n\t\tMore\n\t\t\tDouble"
  end
  
  it "must compare if nodes are equal" do
    node1 = valid_node
    node2 = valid_node
    
    node1.should == node2
    
  end
  
end