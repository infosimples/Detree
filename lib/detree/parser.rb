require 'nokogiri'
require 'sanitize'

module Detree
  
  class Parser
    
    def self.html(html_str, extra={})
      Parser.parse(Parser.html_filter(html_str), :html, extra)
    end
    
    def self.xml(xml_str, extra = {})
      Parser.parse(xml_str, :xml, extra)
    end
    
    private
    def self.parse(str, type, extra={})
      extra[:force_encoding] = nil? unless extra[:force_encoding]
      extra[:except_nodes_names] = [] unless extra[:except_nodes_names]
      
      html_str = Parser.prepare_string(html_str, extra[:force_encoding])
      
      doc = nil
      if type == :html
        doc = Nokogiri::HTML(str)
      elsif type == :xml
        doc = Nokogiri::XML(str)
      end
      
      if doc.nil?
        raise "it was not possible to parse the string from #{type}"
      end
      
      root_element = doc.elements.first
      
      root = Parser.parse_element(root_element, extra)
    end
    
    def self.parse_element(element, extra)
      link = element.attr(:href)
      link = extra[:parser_parent_link] if link.nil?
      extra[:parser_parent_link] = link
      
      text = ""
      name = element.name
      children = []
      
      element.children.each do |c|
        if Parser.can_parse_node?(c, extra)
          if c.kind_of? Nokogiri::XML::Text
            text += "#{c.text}\n"
          else
            node = Parser.parse_element(c, extra.clone)
            children.push node
            text += "#{node.text_indented_by(1)}\n"
          end
        end
      end
      
      Detree::Node.new(:text => text.split("\n").join("\n"), :name => name, :link => link, :children => children)
    end
    
    def self.prepare_string(str, force_encoding=nil)
      return nil if str.nil?
      
      output_encoding = 'UTF-8'
      
      str.force_encoding(force_encoding) if force_encoding
      str.encode!(output_encoding) if str.encoding.name != output_encoding
      str
    end
    
    #
    # Return true if the node can be parsed
    #
    def self.can_parse_node?(node, extra)
      except_name = extra[:except_nodes_names]
      except_content = extra[:except_nodes_content]
      !(  (except_name.include? node.name) or \
          (!except_content.nil? and except_content.match(node.text)) # check the content with a regex
       )
    end
    
    def self.html_filter(html)
      html.gsub("\n",' ').gsub(/<[\s]*br[\s]*[\/]{0,1}>/i,'').gsub(/[ ]{2,100}/, ' ').gsub(/<[\s]*\/a[\s]*>[\s]*<[\s]*a/i, '</a><a')
    end
    
  end
  
end