;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; CONFIGURATION
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author:  Chao LU <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; Licence: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Control file of which one to load

;;; CODE
(message "=> lch-conf: loading...")

(require 'lch-init)
(require 'lch-coding)
(require 'lch-ui)
;; (require 'lch-powerline-theme)
(require 'lch-util)
(require 'lch-elisp)
(require 'lch-helm)
(require 'lch-evil)
(require 'lch-hydra)        ;; hydra after evil since it called evil-leader
(require 'lch-ibuffer)
(require 'lch-auto-complete)
(require 'lch-dired)
(require 'lch-org)
(require 'lch-ox)
(if (and (not lch-win32-p) (executable-find "w3m")) (require 'lch-web))
(require 'lch-network)
(require 'lch-emms)
(require 'lch-bmk)
(require 'lch-binding)
(require 'lch-one-key)
(require 'lch-pgm)
(require 'lch-var)

;; System-related
(if lch-win32-p (require 'lch-w32))
(if lch-mac-p (require 'lch-mac))
(if (and lch-mac-p lch-aquamacs-p) (require 'lch-aquamacs))
;;; PROVIDE
(provide 'lch-conf)
(message "~~ lch-conf: done.")

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
