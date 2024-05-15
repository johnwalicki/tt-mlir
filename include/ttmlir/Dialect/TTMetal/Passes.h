// SPDX-FileCopyrightText: © 2024 Tenstorrent Inc.
//
// SPDX-License-Identifier: Apache-2.0

#ifndef TTMLIR_TTMLIR_DIALECT_TTMetal_TTMetalPASSES_H
#define TTMLIR_TTMLIR_DIALECT_TTMetal_TTMetalPASSES_H

#include "mlir/Pass/Pass.h"
#include "ttmlir/Dialect/TTMetal/IR/TTMetal.h"
#include "ttmlir/Dialect/TTMetal/IR/TTMetalOps.h"
#include <memory>

namespace mlir::tt::ttmetal {
#define GEN_PASS_DECL
#include "ttmlir/Dialect/TTMetal/Passes.h.inc"

#define GEN_PASS_REGISTRATION
#include "ttmlir/Dialect/TTMetal/Passes.h.inc"
} // namespace mlir::tt::ttmetal

#endif