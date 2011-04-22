require 'nokogiri'

module Detree
  
  class Parser
    
    def self.html(html_str, force_encoding=nil)
      html_str = Parser.prepare_string(html_str)
      
      doc = Nokogiri::HTML(html_str)
      root_element = doc.elements.first
      
      root = Parser.parse_element(root_element)
    end
    
    def self.xml(xml_str, force_encoding=nil)
      xml_str = Parser.prepare_string(xml_str)
      
      doc = Nokogiri::XML(xml_str)
      root_element = doc.elements.first
      
      root = Parser.parse_element(root_element)
    end
    
    private
    def self.parse_element(element)
      text = ""
      name = element.name
      children = []
      
      element.children.each do |c|
        if c.kind_of? Nokogiri::XML::Text
          text += "#{c.text}\n"
        else
          node = Parser.parse_element(c)
          children.push node
          text += "#{node.text_indented_by(1)}\n"
        end
      end
      
      Detree::Node.new(:text => text.split("\n").join("\n"), :name => name, :children => children)
    end
    
    def self.prepare_string(str, force_encoding=nil)
      output_encoding = 'UTF-8'
      
      str.force_encoding(force_encoding) if force_encoding
      str.encode!(output_encoding) if str.encoding.name != output_encoding
      str
    end
    
  end
  
end