;;; FIXME ~/@/! in ido find file map
(defun ido-find-file-jump (dir)
  "Return a command that sends DIR to `ido-find-file'."
  `(lambda ()
     (interactive)
     (ido-set-current-directory ,dir)
     (setq ido-exit 'refresh)
     (exit-minibuffer)))

(defvar lch-ido-shortcuts
  '(("~/" "~")
    ("~/Downloads/" "!")
    ("/Volumes/DATA/" "@")))

(defun lch-ido-setup-hook ()
  (mapc
   (lambda (x)
     (define-key ido-file-dir-completion-map (cadr x) (car x)))
   lch-ido-shortcuts))

(add-hook 'ido-setup-hook 'lch-ido-setup-hook)
