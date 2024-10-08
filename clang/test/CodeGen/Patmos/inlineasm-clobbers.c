// RUN: %clang --target=patmos %s -S -emit-llvm -o - | FileCheck %s
// RUN: %clang --target=patmos %s -S -emit-llvm -o - -O0 | FileCheck %s
// RUN: %clang --target=patmos %s -S -emit-llvm -o - -O1 | FileCheck %s
// RUN: %clang --target=patmos %s -S -emit-llvm -o - -O2 | FileCheck %s
// END.
///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Test can provide clobber registers
//
///////////////////////////////////////////////////////////////////////////////////////////////////

// CHECK-LABEL: func
void func() { 
	asm volatile (  
		"asm body"
		: 
		:
		// For simplicity, we only use registers that don't have an alias
		:	"r1", "r2", "r3", "r4", "r5", "r6", "r7", "r8",
			"r9", "r10", "r11", "r12", "r13", "r14", "r15", "r16",
			"r17", "r18", "r19", "r20", "r21", "r22", "r23", "r24",
			"r25", "p1", "p2", "p3", "p4", "p5", "p6", "p7",
			"s7", "s8", "s9", "s10", "s11", "s12", "s13", "s14", "s15");
			
}

// CHECK: asm body
// CHECK: ~{r1},~{r2},~{r3},~{r4},~{r5},~{r6},~{r7},~{r8},~{r9},~{r10},~{r11},~{r12},~{r13},~{r14},~{r15},~{r16},~{r17},~{r18},~{r19},~{r20},~{r21},~{r22},~{r23},~{r24},~{r25},~{p1},~{p2},~{p3},~{p4},~{p5},~{p6},~{p7},~{s7},~{s8},~{s9},~{s10},~{s11},~{s12},~{s13},~{s14},~{s15}