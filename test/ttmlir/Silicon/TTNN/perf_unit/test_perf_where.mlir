// RUN: ttmlir-opt --ttir-to-ttnn-backend-pipeline="system-desc-path=%system_desc_path%" %s > %t.mlir
// RUN: FileCheck %s --input-file=%t.mlir
// RUN: ttmlir-translate --ttnn-to-flatbuffer %t.mlir > %t.ttnn
#any_device = #tt.operand_constraint<dram|l1|scalar|tile|any_device|any_device_tile>
#any_device_tile = #tt.operand_constraint<dram|l1|tile|any_device_tile>

func.func @test_where(%arg0: tensor<13x37xf32>, %arg1: tensor<13x37xf32>) -> tensor<13x37xf32> {
  %0 = tensor.empty() : tensor<13x37xbf16>
  %1 = "ttir.eq"(%arg0, %arg1, %0) <{operandSegmentSizes = array<i32: 2, 1>, operand_constraints = [#any_device_tile, #any_device_tile, #any_device_tile]}> : (tensor<13x37xf32>, tensor<13x37xf32>, tensor<13x37xbf16>) -> tensor<13x37xbf16>
  %2 = tensor.empty() : tensor<13x37xf32>
  %3 = "ttir.where"(%1, %arg0, %arg1, %2) <{operandSegmentSizes = array<i32: 3, 1>, operand_constraints = [#any_device_tile, #any_device_tile, #any_device_tile, #any_device_tile]}> : (tensor<13x37xbf16>, tensor<13x37xf32>, tensor<13x37xf32>, tensor<13x37xf32>) -> tensor<13x37xf32>
  // CHECK: %[[EMPTY:.*]] = "ttnn.empty"{{.*}}
  // CHECK: %[[VAL1:[0-9]+]] = "ttnn.eq"(%{{[0-9]+}}, %{{[0-9]+}}, %[[EMPTY]])
  // CHECK: %{{[0-9]+}} = "ttnn.where"(%[[VAL1]], %{{[0-9]+}}, %{{[0-9]+}}, %{{[0-9]+}})
  return %3 : tensor<13x37xf32>
}
