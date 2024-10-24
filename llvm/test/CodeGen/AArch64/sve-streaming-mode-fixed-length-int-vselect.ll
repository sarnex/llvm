; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mattr=+sve -force-streaming-compatible  < %s | FileCheck %s
; RUN: llc -mattr=+sme -force-streaming-compatible  < %s | FileCheck %s
; RUN: llc -force-streaming-compatible < %s | FileCheck %s --check-prefix=NONEON-NOSVE

target triple = "aarch64-unknown-linux-gnu"

define <4 x i8> @select_v4i8(<4 x i8> %op1, <4 x i8> %op2, <4 x i1> %mask) {
; CHECK-LABEL: select_v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d2 killed $d2 def $z2
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    lsl z2.h, z2.h, #15
; CHECK-NEXT:    asr z2.h, z2.h, #15
; CHECK-NEXT:    and z2.h, z2.h, #0x1
; CHECK-NEXT:    cmpne p0.h, p0/z, z2.h, #0
; CHECK-NEXT:    sel z0.h, p0, z0.h, z1.h
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
;
; NONEON-NOSVE-LABEL: select_v4i8:
; NONEON-NOSVE:       // %bb.0:
; NONEON-NOSVE-NEXT:    shl v2.4h, v2.4h, #15
; NONEON-NOSVE-NEXT:    cmlt v2.4h, v2.4h, #0
; NONEON-NOSVE-NEXT:    bif v0.8b, v1.8b, v2.8b
; NONEON-NOSVE-NEXT:    ret
  %sel = select <4 x i1> %mask, <4 x i8> %op1, <4 x i8> %op2
  ret <4 x i8> %sel
}

define <8 x i8> @select_v8i8(<8 x i8> %op1, <8 x i8> %op2, <8 x i1> %mask) {
; CHECK-LABEL: select_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d2 killed $d2 def $z2
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    lsl z2.b, z2.b, #7
; CHECK-NEXT:    asr z2.b, z2.b, #7
; CHECK-NEXT:    and z2.b, z2.b, #0x1
; CHECK-NEXT:    cmpne p0.b, p0/z, z2.b, #0
; CHECK-NEXT:    sel z0.b, p0, z0.b, z1.b
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
;
; NONEON-NOSVE-LABEL: select_v8i8:
; NONEON-NOSVE:       // %bb.0:
; NONEON-NOSVE-NEXT:    shl v2.8b, v2.8b, #7
; NONEON-NOSVE-NEXT:    cmlt v2.8b, v2.8b, #0
; NONEON-NOSVE-NEXT:    bif v0.8b, v1.8b, v2.8b
; NONEON-NOSVE-NEXT:    ret
  %sel = select <8 x i1> %mask, <8 x i8> %op1, <8 x i8> %op2
  ret <8 x i8> %sel
}

define <16 x i8> @select_v16i8(<16 x i8> %op1, <16 x i8> %op2, <16 x i1> %mask) {
; CHECK-LABEL: select_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q2 killed $q2 def $z2
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    lsl z2.b, z2.b, #7
; CHECK-NEXT:    asr z2.b, z2.b, #7
; CHECK-NEXT:    and z2.b, z2.b, #0x1
; CHECK-NEXT:    cmpne p0.b, p0/z, z2.b, #0
; CHECK-NEXT:    sel z0.b, p0, z0.b, z1.b
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
;
; NONEON-NOSVE-LABEL: select_v16i8:
; NONEON-NOSVE:       // %bb.0:
; NONEON-NOSVE-NEXT:    shl v2.16b, v2.16b, #7
; NONEON-NOSVE-NEXT:    cmlt v2.16b, v2.16b, #0
; NONEON-NOSVE-NEXT:    bif v0.16b, v1.16b, v2.16b
; NONEON-NOSVE-NEXT:    ret
  %sel = select <16 x i1> %mask, <16 x i8> %op1, <16 x i8> %op2
  ret <16 x i8> %sel
}

define void @select_v32i8(ptr %a, ptr %b) {
; CHECK-LABEL: select_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q2, [x0]
; CHECK-NEXT:    ptrue p0.b, vl16
; CHECK-NEXT:    ldp q1, q3, [x1]
; CHECK-NEXT:    cmpeq p1.b, p0/z, z0.b, z1.b
; CHECK-NEXT:    cmpeq p0.b, p0/z, z2.b, z3.b
; CHECK-NEXT:    sel z0.b, p1, z0.b, z1.b
; CHECK-NEXT:    sel z1.b, p0, z2.b, z3.b
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
;
; NONEON-NOSVE-LABEL: select_v32i8:
; NONEON-NOSVE:       // %bb.0:
; NONEON-NOSVE-NEXT:    ldp q0, q2, [x0]
; NONEON-NOSVE-NEXT:    ldp q1, q3, [x1]
; NONEON-NOSVE-NEXT:    cmeq v4.16b, v0.16b, v1.16b
; NONEON-NOSVE-NEXT:    cmeq v5.16b, v2.16b, v3.16b
; NONEON-NOSVE-NEXT:    bif v0.16b, v1.16b, v4.16b
; NONEON-NOSVE-NEXT:    mov v1.16b, v5.16b
; NONEON-NOSVE-NEXT:    bsl v1.16b, v2.16b, v3.16b
; NONEON-NOSVE-NEXT:    stp q0, q1, [x0]
; NONEON-NOSVE-NEXT:    ret
  %op1 = load <32 x i8>, ptr %a
  %op2 = load <32 x i8>, ptr %b
  %mask = icmp eq <32 x i8> %op1, %op2
  %sel = select <32 x i1> %mask, <32 x i8> %op1, <32 x i8> %op2
  store <32 x i8> %sel, ptr %a
  ret void
}

define <2 x i16> @select_v2i16(<2 x i16> %op1, <2 x i16> %op2, <2 x i1> %mask) {
; CHECK-LABEL: select_v2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d2 killed $d2 def $z2
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    lsl z2.s, z2.s, #31
; CHECK-NEXT:    asr z2.s, z2.s, #31
; CHECK-NEXT:    and z2.s, z2.s, #0x1
; CHECK-NEXT:    cmpne p0.s, p0/z, z2.s, #0
; CHECK-NEXT:    sel z0.s, p0, z0.s, z1.s
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
;
; NONEON-NOSVE-LABEL: select_v2i16:
; NONEON-NOSVE:       // %bb.0:
; NONEON-NOSVE-NEXT:    shl v2.2s, v2.2s, #31
; NONEON-NOSVE-NEXT:    cmlt v2.2s, v2.2s, #0
; NONEON-NOSVE-NEXT:    bif v0.8b, v1.8b, v2.8b
; NONEON-NOSVE-NEXT:    ret
  %sel = select <2 x i1> %mask, <2 x i16> %op1, <2 x i16> %op2
  ret <2 x i16> %sel
}

define <4 x i16> @select_v4i16(<4 x i16> %op1, <4 x i16> %op2, <4 x i1> %mask) {
; CHECK-LABEL: select_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d2 killed $d2 def $z2
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    lsl z2.h, z2.h, #15
; CHECK-NEXT:    asr z2.h, z2.h, #15
; CHECK-NEXT:    and z2.h, z2.h, #0x1
; CHECK-NEXT:    cmpne p0.h, p0/z, z2.h, #0
; CHECK-NEXT:    sel z0.h, p0, z0.h, z1.h
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
;
; NONEON-NOSVE-LABEL: select_v4i16:
; NONEON-NOSVE:       // %bb.0:
; NONEON-NOSVE-NEXT:    shl v2.4h, v2.4h, #15
; NONEON-NOSVE-NEXT:    cmlt v2.4h, v2.4h, #0
; NONEON-NOSVE-NEXT:    bif v0.8b, v1.8b, v2.8b
; NONEON-NOSVE-NEXT:    ret
  %sel = select <4 x i1> %mask, <4 x i16> %op1, <4 x i16> %op2
  ret <4 x i16> %sel
}

define <8 x i16> @select_v8i16(<8 x i16> %op1, <8 x i16> %op2, <8 x i1> %mask) {
; CHECK-LABEL: select_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d2 killed $d2 def $z2
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    uunpklo z2.h, z2.b
; CHECK-NEXT:    lsl z2.h, z2.h, #15
; CHECK-NEXT:    asr z2.h, z2.h, #15
; CHECK-NEXT:    and z2.h, z2.h, #0x1
; CHECK-NEXT:    cmpne p0.h, p0/z, z2.h, #0
; CHECK-NEXT:    sel z0.h, p0, z0.h, z1.h
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
;
; NONEON-NOSVE-LABEL: select_v8i16:
; NONEON-NOSVE:       // %bb.0:
; NONEON-NOSVE-NEXT:    ushll v2.8h, v2.8b, #0
; NONEON-NOSVE-NEXT:    shl v2.8h, v2.8h, #15
; NONEON-NOSVE-NEXT:    cmlt v2.8h, v2.8h, #0
; NONEON-NOSVE-NEXT:    bif v0.16b, v1.16b, v2.16b
; NONEON-NOSVE-NEXT:    ret
  %sel = select <8 x i1> %mask, <8 x i16> %op1, <8 x i16> %op2
  ret <8 x i16> %sel
}

define void @select_v16i16(ptr %a, ptr %b) {
; CHECK-LABEL: select_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q2, [x0]
; CHECK-NEXT:    ptrue p0.h, vl8
; CHECK-NEXT:    ldp q1, q3, [x1]
; CHECK-NEXT:    cmpeq p1.h, p0/z, z0.h, z1.h
; CHECK-NEXT:    cmpeq p0.h, p0/z, z2.h, z3.h
; CHECK-NEXT:    sel z0.h, p1, z0.h, z1.h
; CHECK-NEXT:    sel z1.h, p0, z2.h, z3.h
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
;
; NONEON-NOSVE-LABEL: select_v16i16:
; NONEON-NOSVE:       // %bb.0:
; NONEON-NOSVE-NEXT:    ldp q0, q2, [x0]
; NONEON-NOSVE-NEXT:    ldp q1, q3, [x1]
; NONEON-NOSVE-NEXT:    cmeq v4.8h, v0.8h, v1.8h
; NONEON-NOSVE-NEXT:    cmeq v5.8h, v2.8h, v3.8h
; NONEON-NOSVE-NEXT:    bif v0.16b, v1.16b, v4.16b
; NONEON-NOSVE-NEXT:    mov v1.16b, v5.16b
; NONEON-NOSVE-NEXT:    bsl v1.16b, v2.16b, v3.16b
; NONEON-NOSVE-NEXT:    stp q0, q1, [x0]
; NONEON-NOSVE-NEXT:    ret
  %op1 = load <16 x i16>, ptr %a
  %op2 = load <16 x i16>, ptr %b
  %mask = icmp eq <16 x i16> %op1, %op2
  %sel = select <16 x i1> %mask, <16 x i16> %op1, <16 x i16> %op2
  store <16 x i16> %sel, ptr %a
  ret void
}

define <2 x i32> @select_v2i32(<2 x i32> %op1, <2 x i32> %op2, <2 x i1> %mask) {
; CHECK-LABEL: select_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d2 killed $d2 def $z2
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    lsl z2.s, z2.s, #31
; CHECK-NEXT:    asr z2.s, z2.s, #31
; CHECK-NEXT:    and z2.s, z2.s, #0x1
; CHECK-NEXT:    cmpne p0.s, p0/z, z2.s, #0
; CHECK-NEXT:    sel z0.s, p0, z0.s, z1.s
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
;
; NONEON-NOSVE-LABEL: select_v2i32:
; NONEON-NOSVE:       // %bb.0:
; NONEON-NOSVE-NEXT:    shl v2.2s, v2.2s, #31
; NONEON-NOSVE-NEXT:    cmlt v2.2s, v2.2s, #0
; NONEON-NOSVE-NEXT:    bif v0.8b, v1.8b, v2.8b
; NONEON-NOSVE-NEXT:    ret
  %sel = select <2 x i1> %mask, <2 x i32> %op1, <2 x i32> %op2
  ret <2 x i32> %sel
}

define <4 x i32> @select_v4i32(<4 x i32> %op1, <4 x i32> %op2, <4 x i1> %mask) {
; CHECK-LABEL: select_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d2 killed $d2 def $z2
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    uunpklo z2.s, z2.h
; CHECK-NEXT:    lsl z2.s, z2.s, #31
; CHECK-NEXT:    asr z2.s, z2.s, #31
; CHECK-NEXT:    and z2.s, z2.s, #0x1
; CHECK-NEXT:    cmpne p0.s, p0/z, z2.s, #0
; CHECK-NEXT:    sel z0.s, p0, z0.s, z1.s
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
;
; NONEON-NOSVE-LABEL: select_v4i32:
; NONEON-NOSVE:       // %bb.0:
; NONEON-NOSVE-NEXT:    ushll v2.4s, v2.4h, #0
; NONEON-NOSVE-NEXT:    shl v2.4s, v2.4s, #31
; NONEON-NOSVE-NEXT:    cmlt v2.4s, v2.4s, #0
; NONEON-NOSVE-NEXT:    bif v0.16b, v1.16b, v2.16b
; NONEON-NOSVE-NEXT:    ret
  %sel = select <4 x i1> %mask, <4 x i32> %op1, <4 x i32> %op2
  ret <4 x i32> %sel
}

define void @select_v8i32(ptr %a, ptr %b) {
; CHECK-LABEL: select_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q2, [x0]
; CHECK-NEXT:    ptrue p0.s, vl4
; CHECK-NEXT:    ldp q1, q3, [x1]
; CHECK-NEXT:    cmpeq p1.s, p0/z, z0.s, z1.s
; CHECK-NEXT:    cmpeq p0.s, p0/z, z2.s, z3.s
; CHECK-NEXT:    sel z0.s, p1, z0.s, z1.s
; CHECK-NEXT:    sel z1.s, p0, z2.s, z3.s
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
;
; NONEON-NOSVE-LABEL: select_v8i32:
; NONEON-NOSVE:       // %bb.0:
; NONEON-NOSVE-NEXT:    ldp q0, q2, [x0]
; NONEON-NOSVE-NEXT:    ldp q1, q3, [x1]
; NONEON-NOSVE-NEXT:    cmeq v4.4s, v0.4s, v1.4s
; NONEON-NOSVE-NEXT:    cmeq v5.4s, v2.4s, v3.4s
; NONEON-NOSVE-NEXT:    bif v0.16b, v1.16b, v4.16b
; NONEON-NOSVE-NEXT:    mov v1.16b, v5.16b
; NONEON-NOSVE-NEXT:    bsl v1.16b, v2.16b, v3.16b
; NONEON-NOSVE-NEXT:    stp q0, q1, [x0]
; NONEON-NOSVE-NEXT:    ret
  %op1 = load <8 x i32>, ptr %a
  %op2 = load <8 x i32>, ptr %b
  %mask = icmp eq <8 x i32> %op1, %op2
  %sel = select <8 x i1> %mask, <8 x i32> %op1, <8 x i32> %op2
  store <8 x i32> %sel, ptr %a
  ret void
}

define <1 x i64> @select_v1i64(<1 x i64> %op1, <1 x i64> %op2, <1 x i1> %mask) {
; CHECK-LABEL: select_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    and x8, x0, #0x1
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    mov z2.d, x8
; CHECK-NEXT:    cmpne p0.d, p0/z, z2.d, #0
; CHECK-NEXT:    sel z0.d, p0, z0.d, z1.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
;
; NONEON-NOSVE-LABEL: select_v1i64:
; NONEON-NOSVE:       // %bb.0:
; NONEON-NOSVE-NEXT:    tst w0, #0x1
; NONEON-NOSVE-NEXT:    csetm x8, ne
; NONEON-NOSVE-NEXT:    fmov d2, x8
; NONEON-NOSVE-NEXT:    bif v0.8b, v1.8b, v2.8b
; NONEON-NOSVE-NEXT:    ret
  %sel = select <1 x i1> %mask, <1 x i64> %op1, <1 x i64> %op2
  ret <1 x i64> %sel
}

define <2 x i64> @select_v2i64(<2 x i64> %op1, <2 x i64> %op2, <2 x i1> %mask) {
; CHECK-LABEL: select_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d2 killed $d2 def $z2
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    uunpklo z2.d, z2.s
; CHECK-NEXT:    lsl z2.d, z2.d, #63
; CHECK-NEXT:    asr z2.d, z2.d, #63
; CHECK-NEXT:    and z2.d, z2.d, #0x1
; CHECK-NEXT:    cmpne p0.d, p0/z, z2.d, #0
; CHECK-NEXT:    sel z0.d, p0, z0.d, z1.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
;
; NONEON-NOSVE-LABEL: select_v2i64:
; NONEON-NOSVE:       // %bb.0:
; NONEON-NOSVE-NEXT:    ushll v2.2d, v2.2s, #0
; NONEON-NOSVE-NEXT:    shl v2.2d, v2.2d, #63
; NONEON-NOSVE-NEXT:    cmlt v2.2d, v2.2d, #0
; NONEON-NOSVE-NEXT:    bif v0.16b, v1.16b, v2.16b
; NONEON-NOSVE-NEXT:    ret
  %sel = select <2 x i1> %mask, <2 x i64> %op1, <2 x i64> %op2
  ret <2 x i64> %sel
}

define void @select_v4i64(ptr %a, ptr %b) {
; CHECK-LABEL: select_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q2, [x0]
; CHECK-NEXT:    ptrue p0.d, vl2
; CHECK-NEXT:    ldp q1, q3, [x1]
; CHECK-NEXT:    cmpeq p1.d, p0/z, z0.d, z1.d
; CHECK-NEXT:    cmpeq p0.d, p0/z, z2.d, z3.d
; CHECK-NEXT:    sel z0.d, p1, z0.d, z1.d
; CHECK-NEXT:    sel z1.d, p0, z2.d, z3.d
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
;
; NONEON-NOSVE-LABEL: select_v4i64:
; NONEON-NOSVE:       // %bb.0:
; NONEON-NOSVE-NEXT:    ldp q0, q2, [x0]
; NONEON-NOSVE-NEXT:    ldp q1, q3, [x1]
; NONEON-NOSVE-NEXT:    cmeq v4.2d, v0.2d, v1.2d
; NONEON-NOSVE-NEXT:    cmeq v5.2d, v2.2d, v3.2d
; NONEON-NOSVE-NEXT:    bif v0.16b, v1.16b, v4.16b
; NONEON-NOSVE-NEXT:    mov v1.16b, v5.16b
; NONEON-NOSVE-NEXT:    bsl v1.16b, v2.16b, v3.16b
; NONEON-NOSVE-NEXT:    stp q0, q1, [x0]
; NONEON-NOSVE-NEXT:    ret
  %op1 = load <4 x i64>, ptr %a
  %op2 = load <4 x i64>, ptr %b
  %mask = icmp eq <4 x i64> %op1, %op2
  %sel = select <4 x i1> %mask, <4 x i64> %op1, <4 x i64> %op2
  store <4 x i64> %sel, ptr %a
  ret void
}
