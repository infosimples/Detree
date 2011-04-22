module Detree
  
  class Node
    
    attr_accessor :text, :name, :children
    
    def initialize(args={})
      @text = args[:text] ? args[:text] : ''
      @name = args[:name] ? args[:name] : ''
      @children = args[:children] ? args[:children] : []
    end
    
    def new_child(*args)
      node = Node.new(*args)
      @children.push node
      node
    end
    
    def text_indented_by(value)
      if valid?
        return @text.split("\n").map{|line| "#{"\t"*value}#{line}"}.join("\n")
      end
    end
    
    def invalid?
      @text.nil? or @name.empty?
    end
    
    def valid?
      !invalid?
    end
    
    def ==(node)
      text_equal = node.text == text
      structure_equal = true
      
      node.children.size.times do |i|
        if node.children[i] != children[i]
          structure_equal = false
        end
      end
      
      text_equal and structure_equal
    end
    
  end
  
end