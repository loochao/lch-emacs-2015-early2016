;;; HELM.EL
;;
;; Copyright (c) 2014 Charles Lu
;;
;; Author:  Charles Lu <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; License: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Settings for elisp packages.

(require 'helm-config)
(require 'helm-files)
(require 'helm-c-yasnippet)
(require 'helm-autoload-commands)
(require 'helm-descbinds)
(require 'helm-helm-commands)
(require 'helm-ls-git)

(require 'helm-swoop)
(autoload 'helm-swoop "helm-swoop" nil t)
(autoload 'helm-back-to-last-point "helm-swoop" nil t)
(push "When doing isearch, hand the word over to helm-swoop." lch-tips)
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)

(defun helm-dwim ()
  (interactive)
  (let ((helm-ff-transformer-show-only-basename nil))
    (helm-other-buffer
     '(
       helm-source-findutils
       helm-source-buffers-list
       helm-source-recentf
       helm-source-locate
       helm-source-autoload-commands
       helm-c-source-yasnippet
       helm-source-ls-git
       )
     "*helm search*")))

;; (helm-mode 1)
(define-key global-map (kbd "M-SPC") 'helm-dwim)
(define-key global-map (kbd "C-c y") 'helm-c-yas-complete)

(eval-after-load 'helm
  '(progn
	 (define-key helm-map (kbd "M-i")			'helm-previous-line)
	 (define-key helm-map (kbd "M-k")			'helm-next-line)
	 (define-key helm-map (kbd "M-n")			'helm-next-source)
         (define-key helm-map (kbd "M-SPC")			'helm-next-source)
	 (define-key helm-map (kbd "M-p")			'helm-previous-source)
	 (define-key helm-map (kbd "M-h")			'helm-next-page)
	 (define-key helm-map (kbd "M-y")			'helm-previous-page)
	 (define-key helm-map (kbd "<escape>")		        'helm-keyboard-quit)
	 (define-key helm-map (kbd "C-w")			'backward-kill-word)))

(push "Press M-SPC to do quicksilver in emacs." lch-tips)
(provide 'lch-helm)
