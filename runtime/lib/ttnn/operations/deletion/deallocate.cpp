// SPDX-FileCopyrightText: (c) 2024 Tenstorrent AI ULC
//
// SPDX-License-Identifier: Apache-2.0
#include "deallocate.h"
#include "tt/runtime/detail/logger.h"
#include "tt/runtime/detail/ttnn.h"

namespace tt::runtime::ttnn::operations::deletion {
void run(const ::tt::target::ttnn::DeallocateOp *op, ProgramContext &context) {
  ProgramTensorPool &tensorPool = context.getTensorPool();
  ::ttnn::Tensor &tensor = tensorPool.at(op->in()->global_id());
  DEBUG_ASSERT(tensor.is_allocated());
  ::ttnn::deallocate(tensor, op->force());

  // The tensor should be deallocated after the deallocate call.
  // Still this assert may be hit in the future for multidevice/async ttnn
  // support. In that case, we will reevaluate the assert/dealloc behaviour and
  // adjust it accordingly.
  //
  DEBUG_ASSERT(!tensor.is_allocated());
  tensorPool.erase(op->in()->global_id());
}
} // namespace tt::runtime::ttnn::operations::deletion
