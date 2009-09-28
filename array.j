type Array(T,ndims) < Tensor(T,ndims)
    dims: buffer(size)
    data: buffer(T)
end

typealias Vector Tensor(T,1)
typealias Matrix Tensor(T,2)

function print(a:Array(T,1))
    for i=1:a.dims[1]
        print(a[i])
        _print("\n")
    end
end

function print(a:Array(T,2))
    for i=1:a.dims[1]
        for j=1:a.dims[2]
            print(a[i,j])
            _print(" ")
        end
        _print("\n")
    end
end

function make_array(m:int32)
    dims = new(buffer(int32), 1)
    dims[1] = m
    data = new(buffer(double), m)
    array = new(Array(double,1), dims, data)
    return array
end

function make_array(m:int32, n:int32)
    dims = new(buffer(int32), 2)
    dims[1] = m
    dims[2] = n
    data = new(buffer(double), m*n)
    array = new(Array(double,2), dims, data)
    return array
end

## One based indexing

function ref(a:Array, i:int32)
    return a.data[i] 
end

function ref(a:Array, I:Array)
    return [ a[i] | (i=I) ]
end

function ref(a:Array, i:int32, j:int32)
    m = a.dims[1]
    return a.data[(j-1)*m + i] 
end

function set(a:Array, i:int32, x)
    bufferset(a.data, unbox(i), x) 
    return x
end

function set(a:Array, i:int32, j:int32, x)
    m = a.dims[1]
    pos = (j-1)*m + i
    bufferset(a.data, unbox(pos), x)
    return x
end

function numel(a:Array)
    return a.data.length
end

function zeros(m:int32)
    a = make_array(m)
    return a
end

function zeros(m:int32, n:int32)
    a = make_array(m, n)
    return a
end

function ones(m:int32)
    return [ 1 | (i=1:m) ]
end

function ones(m:int32, n:int32)
    return [ 1 | (i=1:m), (j=1:n) ]
end

function `+`(x:Array(T,1), y:Array(T,1))
    n = numel(x)
    return [ x[i] + y[i] | (i=1:n) ]
end

function `+`(x:Array(T,2), y:Array(T,2))
    m = x.dims[1]
    n = x.dims[2]
    return [ x[i,j] + y[i,j] | (i=1:m), (j=1:n) ]
end
