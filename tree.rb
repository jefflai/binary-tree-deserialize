require_relative "node"
require "byebug"

class Tree
  attr_accessor :root

  def initialize(root = nil)
    @root = root
  end

  def in_order
    stack = []
    result = []

    node = @root
    until node.nil? do
      stack.push(node)
      node = node.left
    end

    while stack.any? do
      node = stack.pop
      result.push(node.value)

      unless node.right.nil?
        node = node.right
        until node.nil? do
          stack.push(node)
          node = node.left
        end
      end
    end
    result
  end

  def post_order
    stack = []
    result = []

    stack.push(@root)
    prev = nil

    while stack.any? do
      current = stack.last

      if prev.nil? || prev.left == current || prev.right == current

        if !current.left.nil?
          stack.push(current.left)
        elsif !current.right.nil?
          stack.push(current.right)
        else
          stack.pop
          result.push(current.value)
        end

      elsif current.left == prev

        if current.right.nil?
          stack.pop
          result.push(current.value)
        else
          stack.push(current.right)
        end

      elsif current.right == prev
        stack.pop
        result.push(current.value)
      end
      prev = current
    end

    result
  end

  def self.deserialize(in_order, post_order)
    tree = Tree.new
    unless in_order.nil? || post_order.nil? || in_order.empty? || post_order.empty?
      tree.root = build_tree(in_order, post_order)
    end
    tree
  end

  def self.build_tree(in_order, post_order)
    root_node = nil

    if in_order.length == 1 && post_order.length == 1
      root_node = Node.new(in_order.first)
    else
      root_value = post_order.last
      left = nil
      right = nil

      in_order_root_index = in_order.index(root_value)

      left_in_order = nil
      if in_order_root_index > 0
        left_in_order = in_order.slice(0..(in_order_root_index - 1))
      end

      right_in_order = nil
      if in_order_root_index < in_order.length - 1
        right_in_order = in_order.slice((in_order_root_index + 1)..(in_order.length - 1))
      end

      unless left_in_order.nil? || left_in_order.empty?
        left_post_order = post_order.select { |value| left_in_order.include?(value) }
        left = build_tree(left_in_order, left_post_order)
      end

      unless right_in_order.nil? || right_in_order.empty?
        right_post_order = post_order.select { |value| right_in_order.include?(value) }
        right = build_tree(right_in_order, right_post_order)
      end

      root_node = Node.new(root_value, left, right)
    end

    root_node
  end

  private_class_method :build_tree

end
