(defvar flow-type-no-auto-start nil
  "Set flow server auto-start behaviour.
    Possible values:
    nil
      do nothing
    not nil
      add `--no-auto-start' to all relevant flow commands
    'process
      add `--no-auto-start' to all relevant flow commands, and on entry to a
      `js2-mode' / `react-mode' buffer call `flow-type/ensure-server-buffer'
      which runs `flow server' in a project specific comint buffer"
  )


(defvar flow-type-enable-eldoc-type-info t
  "When t, automatically display the type under the cursor using eldoc.
  When nil, types can be displayed manually with `flow-type/show-type-at-cursor'."
  )
