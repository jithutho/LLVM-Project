; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,-slow-unaligned-mem-32 | FileCheck %s --check-prefix=FAST
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,+slow-unaligned-mem-32 | FileCheck %s --check-prefix=SLOW

define i256 @foo(<8 x i32> %a) {
; FAST-LABEL: foo:
; FAST:       # %bb.0:
; FAST-NEXT:    vmovups %ymm0, (%rdi)
; FAST-NEXT:    movq %rdi, %rax
; FAST-NEXT:    vzeroupper
; FAST-NEXT:    retq
;
; SLOW-LABEL: foo:
; SLOW:       # %bb.0:
; SLOW-NEXT:    vextractf128 $1, %ymm0, 16(%rdi)
; SLOW-NEXT:    vmovups %xmm0, (%rdi)
; SLOW-NEXT:    movq %rdi, %rax
; SLOW-NEXT:    vzeroupper
; SLOW-NEXT:    retq
  %r = bitcast <8 x i32> %a to i256
  ret i256 %r
}
