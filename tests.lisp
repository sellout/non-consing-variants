(defpackage non-consing-variants-tests
  (:use #:cl #:fiveam #:non-consing-variants)
  (:shadowing-import-from #:non-consing-variants #:!)
  (:export #:non-consing-variants))

(in-package #:non-consing-variants-tests)

(def-suite non-consing-variants)

(in-suite non-consing-variants)

(test should-macroexpand
  (is (equal '(nconc a b)
             (macroexpand-1 '(! (append a b))))))

(test shouldnt-affect-result
  (is (equal (append '(1 2 3) '(4 5 6))
             (! (append '(1 2 3) '(4 5 6))))))

(test should-behave-as-non-consing
  (is (equal '(1 2 3 4 5 6)
             (let ((a '(1 2 3))
                   (b '(4 5 6)))
               (! (append a b))
               a))))

(test should-perform-default-transform
  (is (equal '(nset-exclusive-or a b)
             (macroexpand-1 '(! (set-exclusive-or a b))))))

(test should-warn-if-no-replacement
  (signals warning
    (macroexpand-1 '(! (cons 'a 'b)))))

(test should-warn-if-bad-pair
  (signals warning
    (push '(ldiff . abcdefg) *non-consing-variants*)
    (unwind-protect (macroexpand-1 '(! (ldiff 'a 'b)))
      (pop *non-consing-variants*))))

(test should-leave-intact-if-no-replacement
  (is (equal '(cons 'a 'b)
             (handler-bind ((warning #'muffle-warning))
               (macroexpand-1 '(! (cons 'a 'b)))))))

(test should-leave-intact-if-bad-pair
  (push '(ldiff . abcdefg) *non-consing-variants*)
  (unwind-protect
       (is (equal '(ldiff 'a 'b)
                  (handler-bind ((warning #'muffle-warning))
                    (macroexpand-1 '(! (ldiff 'a 'b))))))
    (pop *non-consing-variants*)))

