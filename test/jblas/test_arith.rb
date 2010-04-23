require 'test/unit'
require 'jblas'
require 'pp'

include JBLAS

class TestJblasArith < Test::Unit::TestCase
  def setup
    @x = DoubleMatrix.new(3, 3, [1,2,3,4,5,6,7,8,9].to_java(:double))
  end

  def test_arithmetics
    assert_equal mat[[-1,-4,-7],[-2,-5,-8],[-3,-6,-9]], -@x
    assert_equal mat[[3,12,21],[6,15,24],[9,18,27]], 3*@x
    assert_equal mat[[1.0,0.25,1.0/7.0],[0.5,0.2,0.125],[1.0/3,1.0/6,1.0/9]], 1.0/@x
    assert_equal mat[[0.5,2,3.5],[1,2.5,4],[1.5,3,4.5]], @x/2
    assert_equal mat[[1,16,49],[4,25,64],[9,36,81]], @x ** 2
    assert_equal mat[[1,2,3],[4,5,6],[7,8,9]], @x.t
    assert_equal 285.0, (@x.dot @x)

    assert_equal mat[2,6,12], mat[1,2,3].mul(mat[2,3,4])
    assert_equal mat[2,3,4], mat[4,12,20] / mat[2,4,5]
  end

  def test_compare
    assert_equal mat[[1,0,0],[1,0,0],[0,0,0]], @x < 3
    assert_equal mat[[0,0,0],[1,0,0],[1,0,0]], ((@x <= 3) & (@x > 1))
    assert_equal mat[[1,1,1],[0,1,1],[0,1,1]], ((@x <= 3) & (@x > 1)).not
    #assert_equal Array, @x.select {|z| z <= 5}.class
  end
end