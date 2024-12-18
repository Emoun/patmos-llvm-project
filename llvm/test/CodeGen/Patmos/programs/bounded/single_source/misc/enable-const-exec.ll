; RUN: EXEC_ARGS="0=3 1=3"; \
; RUN: %test_execution
; END.
;//////////////////////////////////////////////////////////////////////////////////////////////////
;
; Unknown Error
; 
;//////////////////////////////////////////////////////////////////////////////////////////////////

; ModuleID = 'enable-const-exec.tmp'
source_filename = "/home/user/t-crest/llvm-project/clang/test/Driver/Patmos/enable-const-exec.c"
target datalayout = "E-S32-p:32:32:32-i8:8:8-i16:16:16-i32:32:32-i64:32:32-f64:32:32-a0:0:32-s0:32:32-v64:32:32-v128:32:32-n32"
target triple = "patmos"

@_0 = dso_local global i32 0, align 4

; Function Attrs: mustprogress nofree noinline norecurse nounwind willreturn memory(readwrite, argmem: none)
define dso_local range(i32 -2147483636, -2147483648) i32 @some_fn() local_unnamed_addr #0 {
entry:
  %0 = load volatile i32, ptr @_0, align 4, !tbaa !2
  %tobool.not = icmp eq i32 %0, 0
  br i1 %tobool.not, label %return, label %if.then

if.then:                                          ; preds = %entry
  %1 = load volatile i32, ptr @_0, align 4, !tbaa !2
  %add = add nsw i32 %1, 12
  br label %return

return:                                           ; preds = %entry, %if.then
  %retval.0 = phi i32 [ %add, %if.then ], [ 3, %entry ]
  ret i32 %retval.0
}

; Function Attrs: mustprogress nofree norecurse nounwind willreturn
define dso_local range(i32 -2147483636, -2147483648) i32 @main() local_unnamed_addr #1 {
entry:
  %call = tail call i32 @some_fn()
  ret i32 %call
}

attributes #0 = { mustprogress nofree noinline norecurse nounwind willreturn memory(readwrite, argmem: none) "no-trapping-math"="true" "sp-root" "stack-protector-buffer-size"="8" "target-cpu"="patmos" }
attributes #1 = { mustprogress nofree norecurse nounwind willreturn "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="patmos" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 19.1.3"}
!2 = !{!3, !3, i64 0}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
