This is the stub README.txt for the "non-consing-variants" project.

There is only a single macro in non-consing-variants. It is `!`. By wrapping a normally-consing form in this macro, the non-consing variant of that form will be used. EG:

```
(! (sublis a b)) => (nsublis a b)
(! (remove a b)) => (delete a b)
```

I tend to exclusively use the safer consing versions throughout my code, and only switch to non-consing versions when profiling tells me there's a benefit to be had. The `!` macro gives me a quick toggle and makes it easy to find those places in my code. If I have a problem that I think is related to reusing a list mangled by a non-consing function, I can quickly

```
(defmacro ! (form)
  form)
```

and recompile to disable all of those optimizations and see if the issue goes away.

In addition to the `!` macro, there is a variable, `*non-consing-variants*` that is an alist to contain pairs of (consing . non-consing) symbols that don't follow the common FOO/NFOO naming pattern (which are handled automatically by the macro).
