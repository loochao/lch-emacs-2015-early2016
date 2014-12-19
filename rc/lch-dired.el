;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; DIRED
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Charles LU
;;
;; Author:  Charles LU <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; Licence: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Settings for dired

;;; CODE
(message "=> lch-dired: loading...")

(require 'dired)
(require 'lch-key-util)
(require 'dired-extension-wux)
(require 'dired-extension)                             ;; Lazycat version
(require 'dired-tar)
(require 'dired+)
(require 'dired-details)

(setq dired-recursive-copies t)                        
(setq dired-recursive-copies 'always)                  ;; No ask when copying recursively.
(setq dired-recursive-deletes t)                       
(setq dired-recursive-deletes 'always)                 ;; No ask when delete recursively.

(setq dired-use-ls-dired nil)
(toggle-dired-find-file-reuse-dir 1)                   ;; From dired+
(setq dired-details-hidden-string "[ ... ] ")          
(setq dired-listing-switches "-aluh")                  ;; Parameters passed to ls
(setq directory-free-space-args "-Pkh")                ;; Options for space
(setq dired-omit-size-limit nil)                       ;; Number of file omitted

;;; Dired-lisps
;; Dired-x
;; dired-x is part of GNU Emacs
;; enable some really cool extensions like C-x C-j(dired-jump)
(require 'dired-x)
(define-key global-map (kbd "C-6") 'dired-jump)

;; Dired-single
(require 'dired-single)
(define-key global-map (kbd "C-<f9>") 'dired-single-magic-buffer)

;; Wdired
;; wdired is Part of GNU Emacs.
(require 'wdired)
(define-key dired-mode-map "w" 'wdired-change-to-wdired-mode)

;; Dired view
;; Jump to a file by typing that filename's first character.
(require 'dired-view)

;; Dired sort
(require 'dired-sort)
;; Directory ahead of files
(add-hook 'dired-after-readin-hook '(lambda ()
                                      (progn
                                        (require 'dired-extension)
                                        (dired-sort-method))))

(setq one-key-menu-dired-sort-alist
      '(
        (("a" . "All/Hidden") . dired-omit-mode)
        (("s" . "Size") . dired-sort-size)
        ;; (("x" . "Extension") . dired-sort-extension)        ;; Does not work with mac
        (("n" . "Name") . dired-sort-name)
        (("t" . "Modified Time") . dired-sort-time)
        (("u" . "Access Time") . dired-sort-utime)
        (("c" . "Create Time") . dired-sort-ctime)))

(defun one-key-menu-dired-sort ()
  "The `one-key' menu for DIRED-SORT."
  (interactive)
  (require 'one-key)
  (require 'dired-sort)
  (one-key-menu "DIRED-SORT" one-key-menu-dired-sort-alist nil))

;; Omit
(setq my-dired-omit-status t)                          ;; 设置默认忽略文件
(setq my-dired-omit-regexp "^\\.?#\\|^\\..*")          ;; 设置忽略文件的匹配正则表达式
(setq my-dired-omit-extensions '(".cache"))            ;; 设置忽略文件的扩展名列表

(add-hook 'dired-mode-hook '(lambda ()
                              (progn
                                (require 'dired-extension)
                                (dired-omit-method))))
;;; Dired-lisps
;;; Utils
(defun dired-open-mac ()
  (interactive)
  (let ((file-name (dired-get-file-for-visit)))
    (if (file-exists-p file-name)
	(call-process "/usr/bin/open" nil 0 nil file-name))))
(define-key dired-mode-map "o" 'dired-open-mac)

(defun dired-up-directory-single ()
  "Return up directory in single window.
When others visible window haven't current buffer, kill old buffer after `dired-up-directory'.
Otherwise, just `dired-up-directory'."
  (interactive)
  (let ((old-buffer (current-buffer))
        (current-window (selected-window)))
    (dired-up-directory)
    (catch 'found
      (walk-windows
       (lambda (w)
         (with-selected-window w
           (when (and (not (eq current-window (selected-window)))
                      (equal old-buffer (current-buffer)))
             (throw 'found "Found current dired buffer in others visible window.")))))
      (kill-buffer old-buffer))))
(define-key dired-mode-map "'" 'dired-up-directory-single)
(define-key dired-mode-map (kbd "C-6") 'dired-up-directory-single)

;;; Keymap
(lch-set-key
 '((";"              . dired-view-minor-mode-toggle)
   ("?"              . dired-get-size)
   ("f"              . dired-single-buffer)
   ("<return>"       . dired-single-buffer)
   ("<RET>"          . dired-single-buffer)
   ("<down-mouse-1>" . dired-single-buffer)

   ("E"              . emms-add-dired)

   ("/*"             . dired-mark-files-regexp)
   ("/m"             . dired-filter-regexp)
   ("/."             . dired-filter-extension)
   ("C-<f12>"        . dired-filter-extension)

   ("s"              . one-key-menu-dired-sort)
   ("v"              . dired-x-find-file)
   ("V"              . dired-view-file)
   ("j"              . dired-next-line)
   ("J"              . dired-goto-file)
   ("k"              . dired-previous-line)
   ("K"              . dired-do-kill-lines)

   ("r"              . wdired-change-to-wdired-mode)
   ("T"              . dired-tar-pack-unpack)
   )
 dired-mode-map)
;;; PROVIDE
(provide 'lch-dired)
(message "~~ lch-dired: done.")


;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
