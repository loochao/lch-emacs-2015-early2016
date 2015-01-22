;;; lch-evil.el --- Charles Lu evil configuration

;; Author: Charles Lu <loochao@gmail.com>>
;; Keywords:

;; This file is NOT part of GNU Emacs.

;; This is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 2, or (at your option) any later
;; version.

;; This file is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with Emacs; see the file COPYING, or type `C-h C-c'. If not,
;; write to the Free Software Foundation at this address:

;; Free Software Foundation
;; 51 Franklin Street, Fifth Floor
;; Boston, MA 02110-1301
;; USA
(require 'evil-leader)
(global-evil-leader-mode)

;; For some reason, this evil-set-toggle-key line has to before (require 'evil).
(evil-set-toggle-key "C-`")
(require 'evil)
(evil-mode 1)

;; Disable the annoying backward-one-char behavior of Vim
;; Use Emacs behavior instead.
(setq evil-move-cursor-back nil)

;; (autoload 'ace-jump-char-mode "evil-integration.el" t)
(define-key global-map (kbd "C-c v") 'evil-mode)
;; (global-evil-surround-mode 1)
;; (global-evil-matchit-mode 1)

;; Make horizontal movement cross lines
;; h/l wrap around to next lines
(setq evil-cross-lines t)
(setq evil-search-module 'evil-search)

(setq evil-default-state 'normal)

(add-hook 'evil-insert-state-exit-hook 'save-buffer)
;;; evil-leader
(defun lch-toggle-comment-on-line ()
  "comment or uncomment current line"
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position))
  (next-line)
  )

(setq evil-leader/leader ","
      evil-leader/in-all-states t)

(evil-leader/set-key "o" 'helm-swoop)         ;; Swoop works like occur.
(evil-leader/set-key "p" 'print-buffer)
(evil-leader/set-key "w" 'save-buffer)
(evil-leader/set-key "q" 'kill-buffer-and-window)
(evil-leader/set-key "h" 'dired-jump)
(evil-leader/set-key "v" 'split-window-right)
(evil-leader/set-key "1" 'delete-other-windows)
(evil-leader/set-key "e" 'find-file)
;; (evil-leader/set-key "," 'other-window)
(evil-leader/set-key ";" 'lch-toggle-comment-on-line)
(evil-leader/set-key "B" 'ibuffer)
;; (evil-leader/set-key "x" 'helm-M-x)
(evil-leader/set-key "e" 'eval-buffer)
(evil-leader/set-key "b" 'switch-to-buffer)
(evil-leader/set-key "d" 'helm-dash)
(evil-leader/set-key "k" 'kill-buffer)
(evil-leader/set-key "K" 'kill-current-buffer)
(evil-leader/set-key "t" 'transpose-lines)
(evil-leader/set-key "m" 'evil-motion-state)       ;; ESC back to normal state
(evil-leader/set-key "," 'ace-jump-mode)
(evil-leader/set-key "/" 'lch-switch-to-message)   ;; Defined in lch-util.el
;; (evil-leader/set-key "," 'evil-ace-jump-word-mode) ; ,, for Ace Jump (word)
;; (evil-leader/set-key "l" 'evil-ace-jump-line-mode) ; ,l for Ace Jump (line)
;; (evil-leader/set-key "x" 'evil-ace-jump-char-mode) ; ,x for Ace Jump (char)
(evil-leader/set-key "u" 'undo-tree-visualize)
(evil-leader/set-key "z" 'zap-to-char)

;;; State indicator
;; Cursor
(setq evil-emacs-state-cursor '("orange" box))
(setq evil-normal-state-cursor '("orange" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("cornsilk" box))
(setq evil-replace-state-cursor '("red" box))
(setq evil-operator-state-cursor '("red" hollow))

;; Tag
;; (setq evil-normal-state-tag (propertize "N" 'face '((:background "green" :foreground "black")))
;;       evil-emacs-state-tag (propertize "E" 'face '((:background "orange" :foreground "black")))
;;       evil-insert-state-tag (propertize "I" 'face '((:background "red")))
;;       evil-motion-state-tag (propertize "M" 'face '((:background "blue")))
;;       evil-visual-state-tag (propertize "V" 'face '((:background "grey80" :foreground "black")))
;;       evil-operator-state-tag (propertize "O" 'face '((:background "purple"))))

;;; Restore Emacs keys

;; (define-key evil-normal-state-map (kbd "SPC") 'evil-emacs-state)

(define-key evil-insert-state-map (kbd "C-e") 'end-of-line)
(define-key evil-normal-state-map (kbd "C-e") 'end-of-line)
(define-key evil-visual-state-map (kbd "C-e") 'end-of-line)
(define-key evil-motion-state-map (kbd "C-e") 'end-of-line)

(define-key evil-normal-state-map (kbd "C-f") 'evil-forward-char)
(define-key evil-insert-state-map (kbd "C-f") 'evil-forward-char)
(define-key evil-insert-state-map (kbd "C-f") 'evil-forward-char)

(define-key evil-normal-state-map (kbd "C-b") 'evil-backward-char)
(define-key evil-insert-state-map (kbd "C-b") 'evil-backward-char)
(define-key evil-visual-state-map (kbd "C-b") 'evil-backward-char)

(define-key evil-normal-state-map (kbd "C-d") 'delete-char)
(define-key evil-insert-state-map (kbd "C-d") 'delete-char)
(define-key evil-visual-state-map (kbd "C-d") 'delete-char)

;; Make C-g work like <esc>
;; (define-key evil-normal-state-map "\C-g" 'evil-normal-state)
;; (define-key evil-visual-state-map "\C-g" 'evil-normal-state)
;; (define-key evil-insert-state-map "\C-g" 'evil-normal-state)

(define-key evil-normal-state-map (kbd "C-n") 'next-line)
(define-key evil-insert-state-map (kbd "C-n") 'next-line)
(define-key evil-visual-state-map (kbd "C-n") 'next-line)

(define-key evil-normal-state-map (kbd "C-p") 'previous-line)
(define-key evil-insert-state-map (kbd "C-p") 'previous-line)
(define-key evil-visual-state-map (kbd "C-p") 'previous-line)

(define-key evil-normal-state-map (kbd "C-w") 'delete)
(define-key evil-insert-state-map (kbd "C-w") 'delete)
(define-key evil-visual-state-map (kbd "C-w") 'delete)

(define-key evil-normal-state-map (kbd "C-y") 'yank)
(define-key evil-insert-state-map (kbd "C-y") 'yank)
(define-key evil-visual-state-map (kbd "C-y") 'yank)

;; To unset this in evil-maps.el
;; (define-key evil-normal-state-map [remap yank-pop] 'evil-paste-pop)
(define-key evil-normal-state-map [remap yank-pop] nil)
(define-key evil-insert-state-map (kbd "M-y") 'yank-pop)
(define-key evil-normal-state-map (kbd "M-y") 'yank-pop)
(define-key evil-emacs-state-map (kbd "M-y") 'yank-pop)

(define-key evil-normal-state-map (kbd "C-w") 'kill-region)
(define-key evil-insert-state-map (kbd "C-w") 'kill-region)
(define-key evil-visual-state-map (kbd "C-w") 'kill-region)

(define-key evil-normal-state-map (kbd "C-k") 'kill-line)
(define-key evil-insert-state-map (kbd "C-k") 'kill-line)
(define-key evil-visual-state-map (kbd "C-k") 'kill-line)

(define-key evil-normal-state-map "\C-r" 'isearch-backward)
(define-key evil-insert-state-map "\C-r" 'isearch-backward)
(define-key evil-emacs-state-map "\C-r" 'isearch-backward)

;; (define-key evil-normal-state-map (kbd "Q") 'call-last-kbd-macro)
;; (define-key evil-visual-state-map (kbd "Q") 'call-last-kbd-macro)

;; Don't touch my TAB key
(defun evil-undefine ()
 (interactive)
 (let (evil-mode-map-alist)
   (call-interactively (key-binding (this-command-keys)))))

(define-key evil-normal-state-map (kbd "TAB") 'evil-undefine)

;; Page up and down
(defun evil-page-up ()
  (interactive)
  (previous-line 10)
  (evil-scroll-line-up 10))

(defun evil-page-down ()
  (interactive)
  (next-line 10)
  (evil-scroll-line-down 10))

(define-key evil-normal-state-map (kbd "DEL") 'backward-delete-char-untabify)
(define-key evil-normal-state-map (kbd "RET") 'newline-and-indent)

;; (define-key evil-normal-state-map (kbd "SPC") 'evil-ace-jump-char-mode)
(define-key evil-normal-state-map (kbd "SPC") 'scroll-up-command)
(define-key evil-normal-state-map (kbd "S-SPC") 'scroll-down-command)

(define-key evil-normal-state-map (kbd "C-v") 'scroll-up-command)
(define-key evil-normal-state-map (kbd "M-v") 'scroll-down-command)

(define-key evil-normal-state-map (kbd "<left>") 'hide-entry)
(define-key evil-normal-state-map (kbd "<right>") 'show-entry)

(define-key evil-emacs-state-map (kbd "C-t") 'transpose-chars)
(define-key evil-insert-state-map (kbd "C-t") 'transpose-chars)
(define-key evil-normal-state-map (kbd "C-t") 'transpose-chars)
(define-key evil-normal-state-map (kbd "gh") 'evil-window-top)
(define-key evil-normal-state-map (kbd "gl") 'evil-window-bottom)
(define-key evil-normal-state-map (kbd "gm") 'evil-window-middle)

;; evil-ex-map
(define-key evil-ex-map "e " 'ido-find-file)
(define-key evil-ex-map "b " 'ido-switch-buffer)
;; (require 'key-chord)
;; (key-chord-mode 1)
;; (key-chord-define-global "jk" 'evil-normal-state)

;; By default, a new buffer comes up in Normal state. This can be changed with the
;; function ‘evil-set-initial-state’.

(define-key evil-motion-state-map (kbd "ESC") 'evil-force-normal-state)
;; Esc quits
;; (define-key evil-normal-state-map [escape] 'keyboard-quit)
;; (define-key evil-visual-state-map [escape] 'keyboard-quit)

;; (define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
;; (define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
;; (define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
;; (define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
;; (define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;; Mode X should start in normal state, but mode Y should start in insert state
;(evil-set-initial-state mode-x 'normal)
;(evil-set-initial-state mode-y 'insert)

(loop for (mode . state) in '((inferior-emacs-lisp-mode . emacs)
                              (nrepl-mode . insert)
                              (pylookup-mode . emacs)
                              (comint-mode . normal)
                              (shell-mode . insert)
                              (matlab-mode . emacs)
                              (git-commit-mode . insert)
                              (git-rebase-mode . emacs)
                              (term-mode . emacs)
                              (help-mode . emacs)
                              (helm-grep-mode . emacs)
                              (grep-mode . emacs)
                              (bc-menu-mode . emacs)
                              (magit-branch-manager-mode . emacs)
                              (rdictcc-buffer-mode . emacs)
                              (dired-mode . emacs)
                              (moccur-grep-mode . emacs)
                              (wdired-mode . emacs))
      do (evil-set-initial-state mode state))


;; (add-hook 'evil-insert-state-exit-hook 'lch-clear-empty-lines)

(provide 'lch-evil)
