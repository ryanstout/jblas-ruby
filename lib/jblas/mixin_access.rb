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

class Numeric
  def to_jblas_index
    self
  end
end

module Enumerable
  def to_jblas_index
    to_a.to_java :int
  end
end

module JBLAS
  # Mixin for all kinds of element access.
  #
  # This mixin is collected into MatrixMixin.
  module MatrixAccessMixin
    # Get the entry at _i_, _j_
    def [](i, j=nil)
      if j
        get(i.to_jblas_index, j.to_jblas_index)
      else
        get(i.to_jblas_index)
      end
    end

    # Set the entry at _i_, _j_ to _v_.
    def []=(i, j, v=nil)
      if v
        put(i.to_jblas_index, j.to_jblas_index, v)
      else
        put(i.to_jblas_index, j)
      end
    end

    # <tt>column(i)</tt> returns the <em>i</em>th column. You can assign
    # to <tt>column(i)</tt>, for example <tt>a.column(i) = v</tt>,
    # if +v+ is a vector, or you can access the entries of the column via
    # <tt>a.column(i)[j] = 1.0</tt>
    def column(i)
      MatrixColumnProxy.new(self, i)
    end

    # Return a matrix whose columns are specified by +indices+. You
    # actually obtain a copy of those columns.
    #def columns(indices)
    #  cols = indices.map {|i| column_vector(i)}.to_java DoubleVector
    #  #cols = getColumnVectors(indices.to_java :int)
    #  DoubleMatrix.fromColumnVectors cols
    #end

    # <tt>row(i)</tt> returns the <em>i</em>th row. You can assign
    # to <tt>row(i)</tt>, for example <tt>a.row(i) = v</tt>,
    # if +v+ is a vector.
    def row_proxy(i)
      MatrixRowProxy.new(self, i)
    end

    # Return a matrix whose rows are specified by +indices+. You
    # actually obtain a copy of these rows.
    #def rows(indices)
    #  rows = indices.map {|i| row_vector(i)}.to_java DoubleVector
    #  DoubleMatrix.fromRowVectors rows
    #end
  end
end