;;; vi-tilde-fringe-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (global-vi-tilde-fringe-mode vi-tilde-fringe-mode)
;;;;;;  "vi-tilde-fringe" "vi-tilde-fringe.el" (21721 54545 585696
;;;;;;  801000))
;;; Generated autoloads from vi-tilde-fringe.el

(autoload 'vi-tilde-fringe-mode "vi-tilde-fringe" "\
Buffer-local minor mode to display tildes in the fringe when the line is
empty.

\(fn &optional ARG)" t nil)

(defvar global-vi-tilde-fringe-mode nil "\
Non-nil if Global-Vi-Tilde-Fringe mode is enabled.
See the command `global-vi-tilde-fringe-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-vi-tilde-fringe-mode'.")

(custom-autoload 'global-vi-tilde-fringe-mode "vi-tilde-fringe" nil)

(autoload 'global-vi-tilde-fringe-mode "vi-tilde-fringe" "\
Toggle Vi-Tilde-Fringe mode in all buffers.
With prefix ARG, enable Global-Vi-Tilde-Fringe mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Vi-Tilde-Fringe mode is enabled in all buffers where
`vi-tilde-fringe-mode--turn-on' would do it.
See `vi-tilde-fringe-mode' for more information on Vi-Tilde-Fringe mode.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil nil ("vi-tilde-fringe-pkg.el") (21721 54545
;;;;;;  653148 185000))

;;;***

(provide 'vi-tilde-fringe-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; vi-tilde-fringe-autoloads.el ends here
