;;; FIXME ~/@/! in ido find file map
(defun ido-find-file-jump (dir)
  "Return a command that sends DIR to `ido-find-file'."
  `(lambda ()
     (interactive)
     (ido-set-current-directory ,dir)
     (setq ido-exit 'refresh)
     (exit-minibuffer)))
;;; Undo-close-buffer
(unless (featurep 'recentf) (require 'recentf))
(defun undo-last-killed-buffer ()
  (interactive)
  (let ((active-files (loop for buf in (buffer-list)
                            when (buffer-file-name buf) collect it)))
    (loop for file in recentf-list
          unless (member file active-files) return (find-file file))))

(define-key global-map (kbd "C-S-t") 'undo-last-killed-buffer)

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
