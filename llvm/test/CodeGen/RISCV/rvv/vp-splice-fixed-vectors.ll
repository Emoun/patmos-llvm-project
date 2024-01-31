; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple riscv64 -mattr=+f,+d,+v -verify-machineinstrs -riscv-v-vector-bits-min=128 \
; RUN:   < %s | FileCheck %s

declare <2 x i64> @llvm.experimental.vp.splice.v2i64(<2 x i64>, <2 x i64>, i32, <2 x i1>, i32, i32)
declare <4 x i32> @llvm.experimental.vp.splice.v4i32(<4 x i32>, <4 x i32>, i32, <4 x i1>, i32, i32)
declare <8 x i16> @llvm.experimental.vp.splice.v8i16(<8 x i16>, <8 x i16>, i32, <8 x i1>, i32, i32)
declare <16 x i8> @llvm.experimental.vp.splice.v16i8(<16 x i8>, <16 x i8>, i32, <16 x i1>, i32, i32)

declare <2 x double> @llvm.experimental.vp.splice.v2f64(<2 x double>, <2 x double>, i32, <2 x i1>, i32, i32)
declare <4 x float> @llvm.experimental.vp.splice.v4f32(<4 x float>, <4 x float>, i32, <4 x i1>, i32, i32)

define <2 x i64> @test_vp_splice_v2i64(<2 x i64> %va, <2 x i64> %vb, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 5
; CHECK-NEXT:    vsetvli zero, a1, e64, m1, ta, ma
; CHECK-NEXT:    vslideup.vx v8, v9, a0
; CHECK-NEXT:    ret
  %head = insertelement <2 x i1> undef, i1 1, i32 0
  %allones = shufflevector <2 x i1> %head, <2 x i1> undef, <2 x i32> zeroinitializer

  %v = call <2 x i64> @llvm.experimental.vp.splice.v2i64(<2 x i64> %va, <2 x i64> %vb, i32 5, <2 x i1> %allones, i32 %evla, i32 %evlb)
  ret <2 x i64> %v
}

define <2 x i64> @test_vp_splice_v2i64_negative_offset(<2 x i64> %va, <2 x i64> %vb, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v2i64_negative_offset:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetivli zero, 5, e64, m1, ta, ma
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vsetvli zero, a1, e64, m1, ta, ma
; CHECK-NEXT:    vslideup.vi v8, v9, 5
; CHECK-NEXT:    ret
  %head = insertelement <2 x i1> undef, i1 1, i32 0
  %allones = shufflevector <2 x i1> %head, <2 x i1> undef, <2 x i32> zeroinitializer

  %v = call <2 x i64> @llvm.experimental.vp.splice.v2i64(<2 x i64> %va, <2 x i64> %vb, i32 -5, <2 x i1> %allones, i32 %evla, i32 %evlb)
  ret <2 x i64> %v
}

define <2 x i64> @test_vp_splice_v2i64_masked(<2 x i64> %va, <2 x i64> %vb, <2 x i1> %mask, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v2i64_masked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 5, v0.t
; CHECK-NEXT:    vsetvli zero, a1, e64, m1, ta, mu
; CHECK-NEXT:    vslideup.vx v8, v9, a0, v0.t
; CHECK-NEXT:    ret
  %v = call <2 x i64> @llvm.experimental.vp.splice.v2i64(<2 x i64> %va, <2 x i64> %vb, i32 5, <2 x i1> %mask, i32 %evla, i32 %evlb)
  ret <2 x i64> %v
}

define <4 x i32> @test_vp_splice_v4i32(<4 x i32> %va, <4 x i32> %vb, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 5
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, ma
; CHECK-NEXT:    vslideup.vx v8, v9, a0
; CHECK-NEXT:    ret
  %head = insertelement <4 x i1> undef, i1 1, i32 0
  %allones = shufflevector <4 x i1> %head, <4 x i1> undef, <4 x i32> zeroinitializer

  %v = call <4 x i32> @llvm.experimental.vp.splice.v4i32(<4 x i32> %va, <4 x i32> %vb, i32 5, <4 x i1> %allones, i32 %evla, i32 %evlb)
  ret <4 x i32> %v
}

define <4 x i32> @test_vp_splice_v4i32_negative_offset(<4 x i32> %va, <4 x i32> %vb, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v4i32_negative_offset:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetivli zero, 5, e32, m1, ta, ma
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, ma
; CHECK-NEXT:    vslideup.vi v8, v9, 5
; CHECK-NEXT:    ret
  %head = insertelement <4 x i1> undef, i1 1, i32 0
  %allones = shufflevector <4 x i1> %head, <4 x i1> undef, <4 x i32> zeroinitializer

  %v = call <4 x i32> @llvm.experimental.vp.splice.v4i32(<4 x i32> %va, <4 x i32> %vb, i32 -5, <4 x i1> %allones, i32 %evla, i32 %evlb)
  ret <4 x i32> %v
}

define <4 x i32> @test_vp_splice_v4i32_masked(<4 x i32> %va, <4 x i32> %vb, <4 x i1> %mask, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v4i32_masked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 5, v0.t
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, mu
; CHECK-NEXT:    vslideup.vx v8, v9, a0, v0.t
; CHECK-NEXT:    ret
  %v = call <4 x i32> @llvm.experimental.vp.splice.v4i32(<4 x i32> %va, <4 x i32> %vb, i32 5, <4 x i1> %mask, i32 %evla, i32 %evlb)
  ret <4 x i32> %v
}

define <8 x i16> @test_vp_splice_v8i16(<8 x i16> %va, <8 x i16> %vb, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 5
; CHECK-NEXT:    vsetvli zero, a1, e16, m1, ta, ma
; CHECK-NEXT:    vslideup.vx v8, v9, a0
; CHECK-NEXT:    ret
  %head = insertelement <8 x i1> undef, i1 1, i32 0
  %allones = shufflevector <8 x i1> %head, <8 x i1> undef, <8 x i32> zeroinitializer

  %v = call <8 x i16> @llvm.experimental.vp.splice.v8i16(<8 x i16> %va, <8 x i16> %vb, i32 5, <8 x i1> %allones, i32 %evla, i32 %evlb)
  ret <8 x i16> %v
}

define <8 x i16> @test_vp_splice_v8i16_negative_offset(<8 x i16> %va, <8 x i16> %vb, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v8i16_negative_offset:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetivli zero, 5, e16, m1, ta, ma
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vsetvli zero, a1, e16, m1, ta, ma
; CHECK-NEXT:    vslideup.vi v8, v9, 5
; CHECK-NEXT:    ret
  %head = insertelement <8 x i1> undef, i1 1, i32 0
  %allones = shufflevector <8 x i1> %head, <8 x i1> undef, <8 x i32> zeroinitializer

  %v = call <8 x i16> @llvm.experimental.vp.splice.v8i16(<8 x i16> %va, <8 x i16> %vb, i32 -5, <8 x i1> %allones, i32 %evla, i32 %evlb)
  ret <8 x i16> %v
}

define <8 x i16> @test_vp_splice_v8i16_masked(<8 x i16> %va, <8 x i16> %vb, <8 x i1> %mask, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v8i16_masked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 5, v0.t
; CHECK-NEXT:    vsetvli zero, a1, e16, m1, ta, mu
; CHECK-NEXT:    vslideup.vx v8, v9, a0, v0.t
; CHECK-NEXT:    ret
  %v = call <8 x i16> @llvm.experimental.vp.splice.v8i16(<8 x i16> %va, <8 x i16> %vb, i32 5, <8 x i1> %mask, i32 %evla, i32 %evlb)
  ret <8 x i16> %v
}

define <16 x i8> @test_vp_splice_v16i8(<16 x i8> %va, <16 x i8> %vb, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetvli zero, a0, e8, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 5
; CHECK-NEXT:    vsetvli zero, a1, e8, m1, ta, ma
; CHECK-NEXT:    vslideup.vx v8, v9, a0
; CHECK-NEXT:    ret
  %head = insertelement <16 x i1> undef, i1 1, i32 0
  %allones = shufflevector <16 x i1> %head, <16 x i1> undef, <16 x i32> zeroinitializer

  %v = call <16 x i8> @llvm.experimental.vp.splice.v16i8(<16 x i8> %va, <16 x i8> %vb, i32 5, <16 x i1> %allones, i32 %evla, i32 %evlb)
  ret <16 x i8> %v
}

define <16 x i8> @test_vp_splice_v16i8_negative_offset(<16 x i8> %va, <16 x i8> %vb, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v16i8_negative_offset:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetivli zero, 5, e8, m1, ta, ma
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vsetvli zero, a1, e8, m1, ta, ma
; CHECK-NEXT:    vslideup.vi v8, v9, 5
; CHECK-NEXT:    ret
  %head = insertelement <16 x i1> undef, i1 1, i32 0
  %allones = shufflevector <16 x i1> %head, <16 x i1> undef, <16 x i32> zeroinitializer

  %v = call <16 x i8> @llvm.experimental.vp.splice.v16i8(<16 x i8> %va, <16 x i8> %vb, i32 -5, <16 x i1> %allones, i32 %evla, i32 %evlb)
  ret <16 x i8> %v
}

define <16 x i8> @test_vp_splice_v16i8_masked(<16 x i8> %va, <16 x i8> %vb, <16 x i1> %mask, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v16i8_masked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetvli zero, a0, e8, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 5, v0.t
; CHECK-NEXT:    vsetvli zero, a1, e8, m1, ta, mu
; CHECK-NEXT:    vslideup.vx v8, v9, a0, v0.t
; CHECK-NEXT:    ret
  %v = call <16 x i8> @llvm.experimental.vp.splice.v16i8(<16 x i8> %va, <16 x i8> %vb, i32 5, <16 x i1> %mask, i32 %evla, i32 %evlb)
  ret <16 x i8> %v
}

define <2 x double> @test_vp_splice_v2f64(<2 x double> %va, <2 x double> %vb, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 5
; CHECK-NEXT:    vsetvli zero, a1, e64, m1, ta, ma
; CHECK-NEXT:    vslideup.vx v8, v9, a0
; CHECK-NEXT:    ret
  %head = insertelement <2 x i1> undef, i1 1, i32 0
  %allones = shufflevector <2 x i1> %head, <2 x i1> undef, <2 x i32> zeroinitializer

  %v = call <2 x double> @llvm.experimental.vp.splice.v2f64(<2 x double> %va, <2 x double> %vb, i32 5, <2 x i1> %allones, i32 %evla, i32 %evlb)
  ret <2 x double> %v
}

define <2 x double> @test_vp_splice_v2f64_negative_offset(<2 x double> %va, <2 x double> %vb, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v2f64_negative_offset:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetivli zero, 5, e64, m1, ta, ma
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vsetvli zero, a1, e64, m1, ta, ma
; CHECK-NEXT:    vslideup.vi v8, v9, 5
; CHECK-NEXT:    ret
  %head = insertelement <2 x i1> undef, i1 1, i32 0
  %allones = shufflevector <2 x i1> %head, <2 x i1> undef, <2 x i32> zeroinitializer

  %v = call <2 x double> @llvm.experimental.vp.splice.v2f64(<2 x double> %va, <2 x double> %vb, i32 -5, <2 x i1> %allones, i32 %evla, i32 %evlb)
  ret <2 x double> %v
}

define <2 x double> @test_vp_splice_v2f64_masked(<2 x double> %va, <2 x double> %vb, <2 x i1> %mask, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v2f64_masked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 5, v0.t
; CHECK-NEXT:    vsetvli zero, a1, e64, m1, ta, mu
; CHECK-NEXT:    vslideup.vx v8, v9, a0, v0.t
; CHECK-NEXT:    ret
  %v = call <2 x double> @llvm.experimental.vp.splice.v2f64(<2 x double> %va, <2 x double> %vb, i32 5, <2 x i1> %mask, i32 %evla, i32 %evlb)
  ret <2 x double> %v
}

define <4 x float> @test_vp_splice_v4f32(<4 x float> %va, <4 x float> %vb, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 5
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, ma
; CHECK-NEXT:    vslideup.vx v8, v9, a0
; CHECK-NEXT:    ret
  %head = insertelement <4 x i1> undef, i1 1, i32 0
  %allones = shufflevector <4 x i1> %head, <4 x i1> undef, <4 x i32> zeroinitializer

  %v = call <4 x float> @llvm.experimental.vp.splice.v4f32(<4 x float> %va, <4 x float> %vb, i32 5, <4 x i1> %allones, i32 %evla, i32 %evlb)
  ret <4 x float> %v
}

define <4 x float> @test_vp_splice_v4f32_negative_offset(<4 x float> %va, <4 x float> %vb, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v4f32_negative_offset:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetivli zero, 5, e32, m1, ta, ma
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, ma
; CHECK-NEXT:    vslideup.vi v8, v9, 5
; CHECK-NEXT:    ret
  %head = insertelement <4 x i1> undef, i1 1, i32 0
  %allones = shufflevector <4 x i1> %head, <4 x i1> undef, <4 x i32> zeroinitializer

  %v = call <4 x float> @llvm.experimental.vp.splice.v4f32(<4 x float> %va, <4 x float> %vb, i32 -5, <4 x i1> %allones, i32 %evla, i32 %evlb)
  ret <4 x float> %v
}

define <4 x float> @test_vp_splice_v4f32_masked(<4 x float> %va, <4 x float> %vb, <4 x i1> %mask, i32 zeroext %evla, i32 zeroext %evlb) {
; CHECK-LABEL: test_vp_splice_v4f32_masked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, a0, -5
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 5, v0.t
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, mu
; CHECK-NEXT:    vslideup.vx v8, v9, a0, v0.t
; CHECK-NEXT:    ret
  %v = call <4 x float> @llvm.experimental.vp.splice.v4f32(<4 x float> %va, <4 x float> %vb, i32 5, <4 x i1> %mask, i32 %evla, i32 %evlb)
  ret <4 x float> %v
}