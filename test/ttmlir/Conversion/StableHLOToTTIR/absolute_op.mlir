// REQUIRES: stablehlo
// RUN: ttmlir-opt --stablehlo-to-ttir-pipeline %s | FileCheck %s
#any_device = #tt.operand_constraint<dram|l1|scalar|tile|any_device|any_device_tile>
module @jit_eltwise_abs attributes {} {
  func.func public @test_abs(%arg0: tensor<13x21x3xf32>) -> tensor<13x21x3xf32> {
    %0 = stablehlo.abs %arg0 : tensor<13x21x3xf32>
    // CHECK: %[[C:.*]] = tensor.empty[[C:.*]]
    // CHECK: %[[C:.*]] = "ttir.abs"[[C:.*]]
    return %0 : tensor<13x21x3xf32>
  }
}