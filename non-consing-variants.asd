(asdf:defsystem non-consing-variants
  :description "A tiny utility library to make it easy to switch between consing
                and non-consing functions for optimization."
  :author "Gregory Martin Pfeil <greg@technomadic.org>"
  :license "MIT"
  :components ((:file "package")
               (:file "non-consing-variants" :depends-on ("package")))
  :in-order-to ((asdf:test-op (asdf:load-op non-consing-variants-tests)))
  :perform (asdf:test-op :after (op c)
                         (funcall (intern "RUN!" :fiveam)
                                  (intern "NON-CONSING-VARIANTS"
                                          :non-consing-variants-tests))))

(defmethod asdf:operation-done-p
    ((o asdf:test-op) (c (eql (asdf:find-system :non-consing-variants))))
  (values nil))

(asdf:defsystem non-consing-variants-tests
  :depends-on (non-consing-variants fiveam)
  :components ((:file "tests")))
