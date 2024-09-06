// SPDX-FileCopyrightText: (c) 2024 Tenstorrent AI ULC
//
// SPDX-License-Identifier: Apache-2.0

#ifndef TTMLIR_TARGET_TTMETAL_TTMETALTOFLATBUFFER_H
#define TTMLIR_TARGET_TTMETAL_TTMETALTOFLATBUFFER_H

#include "mlir/IR/Operation.h"
#include "mlir/Support/LogicalResult.h"

namespace mlir::tt::ttmetal {

// Translates a TTMetal operation to a flatbuffer and writes it to the given
// stream.
LogicalResult translateTTMetalToFlatbuffer(Operation *op,
                                           llvm::raw_ostream &os);
} // namespace mlir::tt::ttmetal

#endif