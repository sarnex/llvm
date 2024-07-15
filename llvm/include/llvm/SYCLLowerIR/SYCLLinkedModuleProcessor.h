#pragma once
#include "SpecConstants.h"
namespace llvm {
class PassRegistry;
class ModulePass;
ModulePass *
    createSYCLLinkedModuleProcessorPass(llvm::SpecConstantsPass::HandlingMode);
void initializeSYCLLinkedModuleProcessorPass(PassRegistry &);
} // namespace llvm
