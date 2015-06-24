;;; IBUFFER.EL
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Charles Lu
;;
;; Author:  Charles Lu <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; License: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Settings for ibuffer packages.
;; iBuffer is Part of GNU Emacs

(define-key global-map (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

(eval-after-load 'ibuffer
  '(progn
     ;; Use human readable Size column instead of original one
     (define-ibuffer-column size-h
       (:name "Size" :inline t)
       (cond
        ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
        ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
        (t (format "%8d" (buffer-size)))))
     ;; Explicitly require ibuffer-vc to get its column definitions, which
     ;; can't be autoloaded
     (require 'ibuffer-vc)

     (setq ibuffer-expert t
           ibuffer-show-empty-filter-groups nil
           ibuffer-display-summary nil)

     (setq ibuffer-saved-filter-groups
           (quote (("default"
                    ("Writing" (or
                                (mode . tex-mode)
                                (mode . plain-tex-mode)
                                (mode . latex-mode)
                                ;; (mode . rst-mode)
                                (mode . html-mode)
                                (mode . nxhtml-mode)
                                (mode . css-mode)
                                (mode . nxml-mode)))
                    ("Dired" (or (mode . dired-mode)
                                 (mode . sr-mode)
                                 ))
                    ("Code" (or (mode . emacs-lisp-mode)
                                (mode . cperl-mode)
                                (mode . c-mode)
                                (mode . java-mode)
                                (mode . idl-mode)
                                (mode . web-mode)
                                (mode . lisp-mode)
                                (mode . js2-mode)
                                (mode . c++-mode)
                                (mode . lua-mode)
                                (mode . cmake-mode)
                                (mode . ruby-mode)
                                (mode . scss-mode)
                                (mode . css-mode)
                                (mode . csharp-mode)
                                (mode . objc-mode)
                                (mode . sql-mode)
                                (mode . python-mode)
                                (mode . coffee-mode)
                                (mode . php-mode)
                                (mode . sh-mode)
                                (mode . json-mode)
                                (mode . scala-mode)
                                (mode . go-mode)
                                (mode . erlang-mode)
                                (name . "\\*Python.*\\*")
                                (name . "\\*haskell.*\\*")
                                ))
                    ("ERC" (or (mode . erc-mode)
                               (name . "ERC .*")))
                    ("Org" (or
                                (name . "^\\*Calendar\\*$")
                                (name . "^diary$")
                                (mode . org-mode)
                                (mode . org-agenda-mode)
                                ))
                    ("Emacs" (or
                              (name . "^\\*scratch\\*$")
                              (name . "^\\*Messages\\*$")))
                    ("Gnus" (or
                             (mode . message-mode)
                             (mode . bbdb-mode)
                             (mode . mail-mode)
                             (mode . gnus-group-mode)
                             (mode . gnus-summary-mode)
                             (mode . gnus-article-mode)
                             (name . "^\\.bbdb$")
                             (name . "^\\.newsrc-dribble")))))))
     (add-hook 'ibuffer-mode-hook (lambda ()
                                    (ibuffer-vc-set-filter-groups-by-vc-root)
                                    (unless (eq ibuffer-sorting-mode 'filename/process)
                                      (ibuffer-do-sort-by-filename/process))
                                    (ibuffer-switch-to-saved-filter-groups "default")
                                    ))
     ))

(defun ibuffer-ediff-marked-buffers (end)
  "Ediff marked buffers based on prefix.
Diffs prefix-1 marked buffer with prefix buffer."
  (interactive "p")
  (let ((marked-buffers (ibuffer-get-marked-buffers)))
    (ediff-buffers (nth (1- end) marked-buffers) (nth end marked-buffers))))

;; (define-key ibuffer-mode-map (kbd "<") 'ibuffer-ediff-marked-buffers)


;; Modify the default ibuffer-formats
(setq ibuffer-formats
      '((mark modified read-only vc-status-mini " "
              (name 18 18 :left :elide)
              " "
              (size-h 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " "
              (vc-status 16 16 :left)
              " "
              filename-and-process)))

(setq ibuffer-filter-group-name-face 'font-lock-doc-face)

;;; PROVIDE
(provide 'lch-ibuffer)
