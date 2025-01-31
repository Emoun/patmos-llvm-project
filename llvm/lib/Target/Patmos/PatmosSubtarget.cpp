//===- PatmosSubtarget.cpp - Patmos Subtarget Information ---------*- C++ -*-=//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the Patmos specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#include "Patmos.h"
#include "PatmosSubtarget.h"
#include "PatmosTargetMachine.h"
#include "MCTargetDesc/PatmosMCTargetDesc.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/ADT/StringExtras.h"
#include <math.h>

using namespace llvm;

#define DEBUG_TYPE "patmos-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "PatmosGenSubtargetInfo.inc"

/// StackCacheBlockSize - Block size of the stack cache in bytes (default: 4,
/// i.e., word-sized).
static cl::opt<unsigned> StackCacheBlockSize("mpatmos-stack-cache-block-size",
                           cl::init(32),
                           cl::desc("Block size of the stack cache in bytes."));

/// StackCacheSize - Total size of the stack cache in bytes (default: 4096,
/// i.e., 1K words).
static cl::opt<unsigned> StackCacheSize("mpatmos-stack-cache-size",
                           cl::init(2048),
                           cl::desc("Total size of the stack cache in bytes."));

/// MethodCacheSize - Total size of the method cache in bytes.
static cl::opt<unsigned> MethodCacheSize("mpatmos-method-cache-size",
                     cl::init(4096),
                     cl::desc("Total size of the instruction cache in bytes "
                              "(default 4096)"));

static cl::opt<unsigned> MinSubfunctionAlign("mpatmos-subfunction-align",
                   cl::init(16),
                   cl::desc("Alignment for functions and subfunctions (including "
                           " the preceding size-declaration word) in bytes "
                           "(default: 16 byte aligned)."));


static cl::opt<bool> BranchInsideCFLDelaySlots("mpatmos-nested-branches",
                     cl::init(false),
                     cl::desc("Enable scheduling of branch instructions "
                              "inside CFL delay slots."));

static cl::opt<bool> DisableVLIW("mpatmos-disable-vliw",
	             cl::init(true),
		     cl::desc("Schedule instructions only in first slot."));

static cl::opt<bool> PermissiveDualIssue("mpatmos-enable-permissive-dual-issue",
	             cl::init(false),
		     cl::desc("Allow loads, stores, and control flow instruction in second issue slot, "
		    		 "as long as only one of each is enabled simultaneously."));

static cl::opt<bool> DisableMIPreRA("mpatmos-disable-pre-ra-misched",
                     cl::init(true),
                     cl::Hidden,
                     cl::desc("Disable any pre-RA MI scheduler."));

static cl::opt<bool> DisablePostRA("mpatmos-disable-post-ra",
                     cl::init(false),
                     cl::Hidden,
                     cl::desc("Disable any post-RA scheduling."));

static cl::opt<bool> DisablePatmosPostRA("mpatmos-disable-post-ra-patmos",
                     cl::init(false),
                     cl::Hidden,
                     cl::desc("Use the standard LLVM post-RA scheduler instead "
                              "of the Patmos post-RA scheduler."));

static cl::opt<PatmosSubtarget::CFLType> PatmosCFLType("mpatmos-cfl",
                            cl::init(PatmosSubtarget::CFL_MIXED),
                            cl::desc("Type of generated control-flow instructions"),
                            cl::values(
                                clEnumValN(PatmosSubtarget::CFL_DELAYED,
                                           "delayed",
                                           "Only emit delayed branches and calls"),
                                clEnumValN(PatmosSubtarget::CFL_MIXED,
                                           "mixed",
                                           "Emit both delayed and non-delayed branches and calls"),
                                clEnumValN(PatmosSubtarget::CFL_NON_DELAYED,
                                           "non-delayed",
                                           "Emit only non-delayed branches and calls")
                                ));

PatmosSubtarget::PatmosSubtarget(const Triple &TT,
                                 StringRef CPU,
                                 StringRef FS, const PatmosTargetMachine &TM, CodeGenOptLevel L) :
  PatmosGenSubtargetInfo(TT, CPU, CPU, FS), TSInfo(),InstrInfo(new PatmosInstrInfo(TM)),
  FrameLowering(new PatmosFrameLowering(TM,*this, TM.getDataLayout())),
  TLInfo(new PatmosTargetLowering(TM, *this)), OptLevel(L)
{
  auto CPUName = CPU;
  if (CPUName.empty()) CPUName = "generic";

  // Parse features string.
  ParseSubtargetFeatures(CPUName, CPUName, FS);

  InstrItins = getInstrItineraryForCPU(CPUName);
}

bool PatmosSubtarget::enablePostRAScheduler() const {
  return hasPostRAScheduler(OptLevel);
}

bool PatmosSubtarget::enableBundling() {
  return !DisableVLIW;
}

bool PatmosSubtarget::hasPostRAScheduler(CodeGenOptLevel OptLevel) const {

  // TargetPassConfig does not add the PostRA pass for -O0!
  if (OptLevel == CodeGenOptLevel::None) return false;

  // TODO there are also -disable-post-ra and -post-RA-scheduler flags,
  // which override the default postRA scheduler behavior, be basically ignore
  // them for now.
  return !DisablePostRA;
}

bool PatmosSubtarget::usePreRAMIScheduler(CodeGenOptLevel OptLevel) const {

  if (OptLevel == CodeGenOptLevel::None) return false;

  return !DisableMIPreRA;
}

bool PatmosSubtarget::usePatmosPostRAScheduler(CodeGenOptLevel OptLevel) const {
  return hasPostRAScheduler(OptLevel) && !DisablePatmosPostRA;
}

PatmosSubtarget::CFLType PatmosSubtarget::getCFLType() const {
  return PatmosCFLType;
}

unsigned PatmosSubtarget::getDelaySlotCycles(const MachineInstr &MI) const {
  if (MI.isBundle()) {
    const MachineBasicBlock *MBB = MI.getParent();
    auto I = MI.getIterator();
    auto E = MBB->instr_end();
    unsigned delay = 0;
    while ((++I != E) && I->isInsideBundle()) {
      delay = std::max(delay, getDelaySlotCycles(*I));
    }
    return delay;
  }
  else if (MI.isCall() || MI.isReturn() ||
           MI.getOpcode() == Patmos::BRCFu ||
           MI.getOpcode() == Patmos::BRCF ||
           MI.getOpcode() == Patmos::BRCFRu ||
           MI.getOpcode() == Patmos::BRCFR ||
           MI.getOpcode() == Patmos::BRCFTu ||
           MI.getOpcode() == Patmos::BRCFT)
  {
    return getCFLDelaySlotCycles(false);
  }
  else if (MI.isBranch()) {
    return getCFLDelaySlotCycles(true);
  } else {
    return 0;
  }
}


bool PatmosSubtarget::allowBranchInsideCFLDelaySots() const
{
  return BranchInsideCFLDelaySlots;
}

unsigned PatmosSubtarget::getIssueWidth(unsigned SchedClass) const {
  return InstrItins.getNumMicroOps(SchedClass);
}

bool PatmosSubtarget::canIssueInSlot(unsigned SchedClass, unsigned Slot) const {
  const InstrStage* IS = InstrItins.beginStage(SchedClass);
  auto FuncUnits = IS->getUnits();

  return llvm::canIssueInSlotForUnits(Slot, FuncUnits);
}

Align PatmosSubtarget::getMinSubfunctionAlignment() const {
  return Align(MinSubfunctionAlign);
}

unsigned PatmosSubtarget::getStackCacheSize() const {
  return StackCacheSize;
}

unsigned PatmosSubtarget::getStackCacheBlockSize() const {
  return StackCacheBlockSize;
}

unsigned PatmosSubtarget::getMethodCacheSize() const {
  return MethodCacheSize;
}

unsigned PatmosSubtarget::getAlignedStackFrameSize(unsigned frameSize) const {
  if (frameSize == 0) return 0;
  return ((frameSize - 1) / getStackCacheBlockSize() + 1) *
         getStackCacheBlockSize();
}

bool PatmosSubtarget::usePermissiveDualIssue() {
	return PermissiveDualIssue;
}
