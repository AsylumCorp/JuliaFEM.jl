# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/JuliaFEM.jl/blob/master/LICENSE.md

using JuliaFEM
using JuliaFEM.Preprocess
using JuliaFEM.Postprocess
using JuliaFEM.Abaqus
using JuliaFEM.Testing

# to turn on automatic file download, set
# ENV["ABAQUS_DOWNLOAD_URL"] = "http://<domain>:2080/v2016/books/eif"
# if don't want to download all stuff to current directory, set also
# ENV["ABAQUS_DOWNLOAD_DIR"] = "/tmp"

""" Run test, return true if simulation is succesfull, i.e. no errors raise
during parsing .inp file or execution of model. This doesn't mean that results
are meaningful; they must be checked in separately. Running model only verifies
that no catastrophic failures happen during file parsing. """
function abaqus_run_test(name)
    return_code = abaqus_run_model(name; fetch=true, verbose=true)
    return_code == 0 && return true
    return false
end

@testset "JuliaFEM-ABAQUS interface" begin
  @testset "1 Element Verification" begin
    @testset "1.2 Eigenvalue tests" begin
      @testset "1.2.1 Eigenvalue extraction for single unconstrained elements" begin
        @testset "Acoustic elements" begin
          @testset "AC1D2 elements." begin
#           abaqus_run_test("ec12afe1") || return
          end
        end
        @testset "Three-dimensional continuum elements" begin
          @testset "C3D10 elements." begin
#           abaqus_run_test("ec3asfe1") || return
          end
        end
      end
    end
    @testset "1.3 Simple load tests" begin
      @testset "1.3.1 Membrane loading of plane stress, plane strain, membrane, and shell elements" begin
        @testset "CPS4 elements." begin
#         abaqus_run_test("ecs4sfs1") || return
        end
      end
      @testset "1.3.3 Three-dimensional solid elements" begin
        @testset "C3D8 elements." begin
          abaqus_run_test("ec38sfs2") || return
          #= to check also results:
          xdmf = abaqus_open_results("ec38sfs2")
          side, opts = read_result(xdmf, "SECTION/side")
          @test isapprox(side["SOFM"], 3464.0)
          @test isapprox(side["SOF1"], 2000.0)
          @test isapprox(side["SOF2"], 2000.0)
          @test isapprox(side["SOF3"], 2000.0)
          @test isapprox(side["SOMM"], 2828.0)
          @test isapprox(side["SOM1"], 0.0)
          @test isapprox(side["SOM2"], 2000.0)
          @test isapprox(side["SOM3"], -2000.0)
          @test isapprox(side["SOAREA"], 2.000)
          @test isapprox(side["SOCF1"], 2/3)
          @test isapprox(side["SOCF2"], 2/3)
          @test isapprox(side["SOCF3"], 1/6)
          =#
        end
      end
    end
  end
end

