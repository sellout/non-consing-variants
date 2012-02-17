(in-package #:non-consing-variants)

(defvar *non-consing-variants*
  '((append . nconc)
    (revappend . nreconc)
    (remove . delete)
    (remove-if . delete-if)
    (remove-if-not . delete-if-not)
    (remove-duplicates . delete-duplicates))
  "An alist of (consing . non-consing) symbol pairs. This should contain any
   pairs that don't match the FOO/NFOO pattern (that common pattern is handled
   by the ! macro directly). The pairs that exist in the CL package are already
   in the list, but you can push additional pairs, like
  (alexandria:mappend . mapcan).")

(defmacro ! (form)
  "If the enclosed form has a non-consing variant, use that as an optimization."
  (let* ((consing-symbol (car form))
         (non-consing-variant (cdr (assoc consing-symbol
                                          *non-consing-variants*))))
    (if non-consing-variant
        (if (fboundp non-consing-variant)
            (cons non-consing-variant (cdr form))
            (progn
              (warn "~a is not defined as a function." non-consing-variant)
              form))
        (let ((non-consing-symbol
               (find-symbol (concatenate 'string
                                         "N"
                                         (symbol-name consing-symbol))
                            (symbol-package consing-symbol))))
          (if (fboundp non-consing-symbol)
            (cons non-consing-symbol (cdr form))
            (progn
              (warn "No non-consing variant of ~a is known." consing-symbol)
              form))))))
