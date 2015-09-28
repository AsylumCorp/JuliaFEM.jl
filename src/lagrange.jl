# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/JuliaFEM.jl/blob/master/LICENSE.md

# Lagrange (Continous Galerkin) finite elements

abstract CG <: Element

"""
Given polynomial P and coordinates of reference element, calculate
Lagrange basis functions
"""
function calculate_lagrange_basis(P, X)
    dim, nbasis = size(X)
    A = zeros(nbasis, nbasis)
    for i=1:nbasis
        A[i,:] = P(X[:, i])
    end
#   Logging.debug("Calculating inverse of A")
    invA = inv(A)'
    basis(xi) = invA*P(xi)
    basis
end

"""
Create new Lagrange element

Examples
--------
>>> @create_lagrange_element(Seg2, "2 node linear segment", X, P)
"""
macro create_lagrange_element(element_name, element_description, X, P)
#   Logging.debug("Creating element ", element_name, ": ", element_description, "\n")
    eltype = esc(element_name)
    quote
        global get_element_description
        global get_number_of_basis_functions, get_element_dimension
        dim = size($X, 1)
        nbasis = size($X, 2)
        h = calculate_lagrange_basis($P, $X)
        type $eltype <: CG
            connectivity :: Array{Int, 1}
            basis :: Basis
            fields :: Dict{Symbol, Array{Field, 1}}
        end
        function $eltype(connectivity, args...)
            $eltype(connectivity, Basis(h), Dict())
        end
        get_element_description(el::Type{$eltype}) = $element_description
        get_number_of_basis_functions(el::Type{$eltype}) = nbasis
        get_element_dimension(el::Type{$eltype}) = dim
    end
end

# 0d Lagrange element

#@create_element(Point1, CG, "1 node point element")

# 1d Lagrange elements

@create_lagrange_element(Seg2, "2 node linear line element",
    [-1.0 1.0], (xi) -> [1.0, xi[1]])

@create_lagrange_element(Seg3, "3 node quadratic line element",
    [-1.0 1.0 0.0], (xi) -> [1.0, xi[1], xi[1]^2])

# 2d Lagrange elements

@create_lagrange_element(Tri3, "3 node bilinear triangle element",
    [0.0 1.0 0.0
     0.0 0.0 1.0],
    (xi) -> [1.0, xi[1], xi[2]])

@create_lagrange_element(Quad4, "4 node bilinear quadrangle element",
    [-1.0  1.0 1.0 -1.0
     -1.0 -1.0 1.0  1.0],
    (xi) -> [1.0, xi[1], xi[2], xi[1]*xi[2]])

# 3d Lagrange elements

@create_lagrange_element(Tet10, "10 node quadratic tetrahedron",
    [0.0 1.0 0.0 0.0 0.5 0.5 0.0 0.0 0.5 0.0
     0.0 0.0 1.0 0.0 0.0 0.5 0.5 0.0 0.0 0.5
     0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.5 0.5 0.5],
    (xi) -> [    1.0,   xi[1],       xi[2],       xi[3],     xi[1]^2,
             xi[2]^2, xi[3]^2, xi[1]*xi[2], xi[2]*xi[3], xi[3]*xi[1]])
