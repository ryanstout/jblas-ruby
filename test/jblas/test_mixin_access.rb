# Copyright (c) 2009-2010, Mikio L. Braun and contributors
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#
#     * Neither the name of the Technische Universität Berlin nor the
#       names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior
#       written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'test/unit'
require 'jblas'
require 'pp'

include JBLAS

class TestJblasMixinAccess < Test::Unit::TestCase
  def setup
    # Looks like this:
    #
    #   1  4  7  10
    #   2  5  8  11
    #   3  6  9  12
    @x = DoubleMatrix.new(3, 4, [1,2,3,4,5,6,7,8,9,10,11,12].to_java(:double))
  end

  def test_linear_access
    assert_equal 12, @x.length
    assert_equal 1.0, @x[0]
    assert_equal 2.0, @x[1]
    assert_equal 12.0, @x[11]
  end

  def test_two_dim_access
    assert_equal 3, @x.rows
    assert_equal 4, @x.columns
    assert_equal [3,4], @x.dims
    assert_equal 1.0, @x[0, 0]
    assert_equal 4.0, @x[0, 1]
    assert_equal 6.0, @x[2, 1]
  end

  def test_rows_and_columns
    assert_equal mat[[1,4,7,10]], @x.get_row(0)
    assert_equal mat[[2,5,8,11]], @x.get_row(1)
    assert_equal mat[[3,6,9,12]], @x.get_row(2)

    assert_equal mat[[1,4,7,10]], @x.row(0)
    assert_equal mat[[2,5,8,11]], @x.row(1)
    assert_equal mat[[3,6,9,12]], @x.row(2)

    assert_equal mat[1,2,3], @x.column(0)
    assert_equal mat[4,5,6], @x.column(1)
    assert_equal mat[7,8,9], @x.column(2)
  end

  def test_swap_columns_and_rows
    @x.swap_columns 0, 1
    assert_equal mat[[4,1,7,10],[5,2,8,11],[6,3,9,12]], @x
    @x.swap_columns 0, 1
    @x.swap_rows 0, 1
    assert_equal mat[[2,5,8,11],[1,4,7,10],[3,6,9,12]], @x
    @x.swap_rows 0, 1
  end

  def test_array_indices
    y = mat[0,1,2,3,4,5]
    assert_equal mat[1,3,5], y[[1, 3, 5]]

    y[[0, 1, 2, 3]] = mat[0, -1, -2, -3]
    assert_equal mat[0, -1, -2, -3, 4, 5], y

    x = mat[[1,2],[3,4],[5,6]]
    assert_equal mat[[1, 2], [5, 6]], x.get_rows(idx [0, 2])
    assert_equal mat[[1, 2], [1, 2]], x.get_rows(idx [0, 0])
  end

  def test_matrix_indices
    y = mat[0,1,2,3,4,5]
    assert_equal mat[1,3,5], y[mat[0, 1, 0, 1, 0, 1]]

    y[mat[1, 1, 1, 1, 0, 0]] = mat[0, -1, -2, -3]
    assert_equal mat[0, -1, -2, -3, 4, 5], y

    x = mat[[1,2],[3,4],[5,6]]
    assert_equal mat[[1, 2], [5, 6]], x.get_rows(mat[1, 0, 1])
    assert_equal mat[[1, 2]], x.get_rows(mat[1, 0, 0])
  end

  def test_row_and_column_ranges
    assert_equal mat[4,5], @x.get_row_range(0, 2, 1)
    assert_equal mat[4,7].t, @x.get_column_range(0, 1, 3)
    assert_equal mat[[8,11],[9,12]], @x.get_range(1, 3, 2, 4)
  end

  def test_range_range
    assert_equal mat[1,4,7].t, @x[0, 0...3]
    assert_equal mat[1,4,7,10].t, @x[0, 0..3]
  end

  def test_range_combinations
    assert_equal mat[[4.0, 7.0, 10.0],[5.0, 8.0, 11.0],[6.0, 9.0, 12.0]], @x[0..2, [1,2,3]]
  end
end