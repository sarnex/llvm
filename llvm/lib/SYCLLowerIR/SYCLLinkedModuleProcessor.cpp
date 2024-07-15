#include "llvm/SYCLLowerIR/SYCLLinkedModuleProcessor.h"

#include "llvm/Pass.h"

#define DEBUG_TYPE "sycl-linked-module-processor"
using namespace llvm;

namespace {
class SYCLLinkedModuleProcessor : public ModulePass {
public:
  static char ID; // Pass identification, replacement for typeid
  SYCLLinkedModuleProcessor(SpecConstantsPass::HandlingMode Mode)
      : ModulePass(ID), Mode(Mode) {
    initializeSYCLLinkedModuleProcessorPass(*PassRegistry::getPassRegistry());
  }

  // run the LowerESIMD pass on the specified module
  bool runOnModule(Module &M) override {
    ModuleAnalysisManager MAM;
    SpecConstantsPass SCP(Mode);
    auto PA = SCP.run(M, MAM);
    return !PA.areAllPreserved();
  }

private:
  SpecConstantsPass::HandlingMode Mode;
};
} // namespace
char SYCLLinkedModuleProcessor::ID = 0;
INITIALIZE_PASS(SYCLLinkedModuleProcessor, "SYCLLinkedModuleProcessor", "todo",
                false, false)
ModulePass *llvm::createSYCLLinkedModuleProcessorPass(
    SpecConstantsPass::HandlingMode Mode) {
  return new SYCLLinkedModuleProcessor(Mode);
}
