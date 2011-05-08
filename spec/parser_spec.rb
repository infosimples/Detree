require 'spec_helper'

describe Detree::Parser do
  
  it "must parse a single xml node" do
    node = Detree::Parser.xml("<a>sample</a>")
    node.name.should == 'a'
    node.text.should == 'sample'
    node.children.should be_empty
  end
  
  it "must parse nodes from html" do
    
    html_example = "<html><head><title>Sample Page</title></head><body>Sample Body<ul><li>Sample li 0</li><li>Sample li 1</li><li>Sample li 2</li></ul></body></html>"
    
    # html node
    html_node = Detree::Node.new(
      :text => "\t\tSample Page\n\tSample Body\n\t\t\tSample li 0\n\t\t\tSample li 1\n\t\t\tSample li 2",
      :name => "html")
    
    # head node
    head_node = html_node.new_child(:text => "\tSample Page", :name => "head")
    
    # title node
    title_node = head_node.new_child(:text => "Sample Page", :name => "head")
    
    # body node
    body_node = html_node.new_child(:text => "Sample Body\n\t\tSample li 0\n\t\tSample li 1\n\t\tSample li 2", :name => "body")
    
    # ul node
    ul_node = body_node.new_child(:text => "\tSample li 0\n\tSample li 1\n\tSample li 2", :name => "ul")
    
    # li nodes
    li_nodes = []
    3.times do |i|
      li_nodes.push ul_node.new_child(:text => "Sample li #{i}", :name => "li")
    end
    
    expected_node = html_node
    
    Detree::Parser.html(html_example).should == expected_node
    
  end
  
  it "must parse nodes from html except nodes with especified names" do
    
    html_example = "<html><head><title>Except</title></head><body>Sample Body</body></html>"
    
    # html node without head node
    html_node = Detree::Node.new(
      :text => "\tSample Body",
      :name => "html")
        
    # body node
    body_node = html_node.new_child(:text => "Sample Body", :name => "body")
    
    expected_node = html_node
        
    Detree::Parser.html(html_example, :except_nodes_names => ['head']).should == expected_node
    
  end
  
  it "must parse nodes from html except nodes with especified content" do
    
    html_example = "<html><head><title>Except</title></head><body>Sample Body</body></html>"
    
    # html node without head node
    html_node = Detree::Node.new(
      :text => "\tSample Body",
      :name => "html")
        
    # body node
    body_node = html_node.new_child(:text => "Sample Body", :name => "body")
    
    expected_node = html_node
        
    Detree::Parser.html(html_example, :except_nodes_content => /\Aexcept\Z/i).should == expected_node
    
  end
  
  xit "parses nodes with links from html" do
  end
  
  xit "should convert nodes to hash" do
  end
  
  xit "should not parse html with more than one root node" do
  end
  
end