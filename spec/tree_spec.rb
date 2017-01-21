require_relative "../tree"

describe Tree do

  describe "serialization methods" do

    context "when tree is empty" do
      let(:tree) { Tree.new }
      it "should return empty array result" do
        expect(tree.in_order).to eq([])
        expect(tree.post_order).to eq([])
      end
    end

    context "when tree contains single value" do
      let(:tree) do
        node = Node.new(5)
        Tree.new(node)
      end
      it "should return correct result" do
        expect(tree.in_order).to eq([5])
        expect(tree.post_order).to eq([5])
      end
    end

    context "when tree contains 3 balanced values" do
      #
      #        1
      #     /     \
      #    5        8
      #

      let(:tree) do
        left_node = Node.new(5)
        right_node = Node.new(8)
        root_node = Node.new(1, left_node, right_node)
        Tree.new(root_node)
      end
      it "should return correct result" do
        expect(tree.in_order).to eq([5, 1, 8])
        expect(tree.post_order).to eq([5, 8, 1])
      end
    end

    context "when tree contains complex unbalanced values" do
      #
      #       1
      #    /     \
      #   2        3
      #  /    \   /   \
      # 4     5   6    7
      #  \
      #    8
      #
      let(:tree) do
        root_node = Node.new(1)
        root_node.left = Node.new(2)
        root_node.left.left = Node.new(4)
        root_node.left.left.right = Node.new(8)
        root_node.left.right = Node.new(5)
        root_node.right = Node.new(3)
        root_node.right.left = Node.new(6)
        root_node.right.right = Node.new(7)
        Tree.new(root_node)
      end
      it "should return correct result" do
        expect(tree.in_order).to eq([4, 8, 2, 5, 1, 6, 3, 7])
        expect(tree.post_order).to eq([8, 4, 5, 2, 6, 7, 3, 1])
      end
    end

  end

  describe "deserialize" do
    subject { Tree.deserialize(in_order, post_order) }

    context "when input arrays are nil" do
      let(:in_order) { nil }
      let(:post_order) { nil }
      it "should return empty tree" do
        expect(subject.in_order).to eq([])
        expect(subject.post_order).to eq([])
      end
    end

    context "when input arrays are empty" do
      let(:in_order) { [] }
      let(:post_order) { [] }
      it "should return empty tree" do
        expect(subject.in_order).to eq([])
        expect(subject.post_order).to eq([])
      end
    end

    context "when valid in order and post order arrays for single value are provided" do
      let(:in_order) { [5] }
      let(:post_order) { [5] }
      it "should return correctly formatted binary tree" do
        expect(subject.in_order).to eq(in_order)
        expect(subject.post_order).to eq(post_order)
      end
    end

    context "when valid in order and post order arrays with only left child are provided" do
      #
      #      1
      #    /
      #   2
      #
      let(:in_order) { [2, 1] }
      let(:post_order) { [2, 1] }
      it "should return correctly formatted binary tree" do
        expect(subject.in_order).to eq(in_order)
        expect(subject.post_order).to eq(post_order)
      end
    end

    context "when valid in order and post order arrays with only right child are provided" do
      #
      #      1
      #       \
      #        2
      #
      let(:in_order) { [1, 2] }
      let(:post_order) { [2, 1] }
      it "should return correctly formatted binary tree" do
        expect(subject.in_order).to eq(in_order)
        expect(subject.post_order).to eq(post_order)
      end
    end

    context "when valid in order and post order arrays for simple tree are provided" do
      let(:in_order) { [5, 1, 8] }
      let(:post_order) { [5, 8, 1] }
      it "should return correctly formatted binary tree" do
        expect(subject.in_order).to eq(in_order)
        expect(subject.post_order).to eq(post_order)
      end
    end

    context "when complex valid in order and post order arrays are provided" do
      let(:in_order) { [4, 8, 2, 5, 1, 6, 3, 7] }
      let(:post_order) { [8, 4, 5, 2, 6, 7, 3, 1] }
      it "should return correctly formatted binary tree" do
        expect(subject.in_order).to eq(in_order)
        expect(subject.post_order).to eq(post_order)
      end
    end
  end

end
